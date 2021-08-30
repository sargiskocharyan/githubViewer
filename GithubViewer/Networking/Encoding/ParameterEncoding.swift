//
//  ParameterEncoding.swift
//
//  Created by Sargis Kocharyan on 30.08.21.
//

import Foundation

public typealias Parameters = [String:Any]

public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
    func encodeParamArray (urlRequest: inout URLRequest, with parametersArray: [Parameters]) throws
}

public enum ParameterEncoding {
    
    case urlEncoding
    case jsonEncoding
    case jsonEncodingEncrypted
    case urlAndJsonEncoding
    case bodyUrlEncoding
    case bodyJsonArrayEncoding
    
    public func encode(urlRequest: inout URLRequest,
                       bodyParameters: Parameters?,
                       urlParameters: Parameters?,
                       encrypted:Bool, bodyArrayParameters: [Parameters]?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                
            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
            case .jsonEncodingEncrypted:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters,
                    let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
            case .bodyUrlEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try BodyURLParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
            case .bodyJsonArrayEncoding:
                guard let bodyArrayParameters = bodyArrayParameters else { return }
                try JSONParameterEncoder().encodeParamArray(urlRequest: &urlRequest, with: bodyArrayParameters)
            }
        }catch {
            throw error
        }
    }
}


public enum NetworkError : String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
