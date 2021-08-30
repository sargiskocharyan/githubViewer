//
//  Endpoints.swift
//  GithubViewer
//
//  Created by Sargis Kocharyan on 30.08.21.
//

import Foundation


public enum GithubApi {
    
    case searchRepo(name: String)
}

extension GithubApi: EndPointType {
    
    var baseURL: URL {
        guard let url = URL(string: EnvironmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        
        case .searchRepo(_):
            return GithubURLs.SearchRepo
        }
    }
    
    var httpMethod: HTTPMethod {
        
        switch self {
        case .searchRepo(_):
            return .get
        
        }
    }
    
    var task: HTTPTask {
        let endPointManager = EndPointManager()
        switch self {
   
        case .searchRepo(let keyword):
            let parameters:Parameters = ["q": keyword, "page": 1, "per_page": 30 ]
            let headers:HTTPHeaders = endPointManager.createHeaders(token:  nil)
            
            return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: parameters, additionHeaders: headers)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
}



