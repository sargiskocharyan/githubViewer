//
//  RepoSearchResponseModel.swift
//  GithubViewer
//
//  Created by Sargis Kocharyan on 31.08.21.
//

import Foundation

struct RepoSearchResponseModel: Codable {
    var totalCount: Double?
    var incompleteResults: Bool
    var items: [RepoItemModel]?
     
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

