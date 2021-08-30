//
//  Constants.swift
//  GithubViewer
//
//  Created by Sargis Kocharyan on 30.08.21.
//

import Foundation

var EnvironmentBaseURL : String {
    switch NetworkManager.environment {
    case .production: return "https://api.github.com"
    case .qa: return "https://developer.github.com/v3"
   
    }
}

struct GithubURLs {
    static let SearchRepo = "/search/repositories"
   
}
