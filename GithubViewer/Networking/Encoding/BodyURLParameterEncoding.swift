//
//  BodyURLParameterEncoding.swift
//
//  Created by Sargis Kocharyan on 30.08.21.
//

import Foundation

public struct BodyURLParameterEncoder: ParameterEncoder {
    public func encodeParamArray(urlRequest: inout URLRequest, with parametersArray: [Parameters]) throws {
        var bodyString = ""
        for parameters in parametersArray {
            for (key,value)in parameters {
                let item = "\(key)=\(value)&"
                bodyString += item
            }
        }
        let bodyStr = String(bodyString.dropLast())
        let bodyData = bodyStr.data(using: .utf8)
        urlRequest.httpBody = bodyData
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
    
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        
        var bodyString = ""
        for (key,value)in parameters {
            let item = "\(key)=\(value)&"
            bodyString += item
        }
        
        let bodyStr = String(bodyString.dropLast())
        let bodyData = bodyStr.data(using: .utf8)
        urlRequest.httpBody = bodyData
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
