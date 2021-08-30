//
//  Router.swift
//
//  Created by sargis on 03/02/20.
//  Copyright © 2020 Sargis Kocharyan. All rights reserved.
//

import UIKit

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 120
        do {
            let request = try self.buildRequest(from: route)
            NetworkLogger.log(request: request)
            
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    func uploadImageRequest(_ route: EndPoint, boundary: String, isBase64Encoded: Bool, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 120
        let request = self.buildUploadImageRequest(from: route, boundary: boundary, isBase64Encoded: isBase64Encoded)
        NetworkLogger.log(request: request)
        task = session.dataTask(with: request)  { data, response, error in
            if error != nil {
                completion(data, response, error)
            } else {
                completion(data, response, nil)
            }
        }
        self.task?.resume()
    }

    fileprivate func configureFormDataBody(_ bodyParameters: Parameters?, _ boundary: String) -> Data {
        let body = NSMutableData()
        for parameter in bodyParameters! {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition:form-data; name=\"\(parameter.key)\"; filename=\"image.jpg\"\r\n")
            body.appendString("Content-Type: image/jpg\r\n\r\n")
            body.append(parameter.value as! Data)
            body.appendString("\r\n")
        }
        body.appendString("--\(boundary)--\r\n")
        return body as Data
    }
    
    fileprivate func configureFormDataBodyWithBase64(_ bodyParameters: Parameters?, _ boundary: String) -> Data {
        let body = NSMutableData()
        for parameter in bodyParameters! {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(parameter.key)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: text\r\n\r\n".data(using: .utf8)!)
            body.append((parameter.value as! UIImage).pngData()!.base64EncodedString().data(using: .utf8)!)
            body.appendString("\r\n")
        }
        body.appendString("--\(boundary)--\r\n")
        return body as Data
    }
    
    fileprivate func buildUploadImageRequest(from route: EndPoint, boundary: String, isBase64Encoded: Bool) -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 60.0)
        request.httpMethod = route.httpMethod.rawValue
        switch route.task {
        case .request:
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        case .requestParameters(let bodyParameters, _, _):
            request.httpBody = isBase64Encoded ? configureFormDataBodyWithBase64(bodyParameters, boundary) : configureFormDataBody(bodyParameters, boundary)
        case .requestParametersAndHeaders(let bodyParameters, _, _, let additionalHeaders):
            request.httpBody = isBase64Encoded ? configureFormDataBodyWithBase64(bodyParameters, boundary) : configureFormDataBody(bodyParameters, boundary)
            addAdditionalHeaders(additionalHeaders, request: &request)
        case .requestParametersArrayAndHeaders(bodyParameters: let bodyParameters, bodyEncoding: _, additionHeaders: let additionHeaders):
            request.httpBody = isBase64Encoded ? configureFormDataBodyWithBase64(bodyParameters?.first, boundary) : configureFormDataBody(bodyParameters?.first, boundary)
            addAdditionalHeaders(additionHeaders, request: &request)
        }
        return request
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 60.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            case .requestParametersArrayAndHeaders(let bodyParameters,
                                                   let bodyEncoding,
                                                   let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: nil,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: nil,
                                             request: &request, bodyArrayParameters: bodyParameters)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest,
                                         encrypted: Bool = false, bodyArrayParameters: [Parameters]? = nil) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters, encrypted:encrypted, bodyArrayParameters: bodyArrayParameters )
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: .utf8)
        append(data!)
    }
}
