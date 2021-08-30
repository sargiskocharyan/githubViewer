//
//  EndPoint.swift
//
//  Created by sargis on 03/02/20.
//  Copyright © 2020 Sargis Kocharyan. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

class EndPointManager {
    
    func createHeaders(token: String?) -> HTTPHeaders {
        var headers:HTTPHeaders = [String: String]()
        
        headers["Accept"] = "application/vnd.github.v3+json"
      //  headers["Content-Type"] = "application/json"
        
        return headers
    }
   
}
