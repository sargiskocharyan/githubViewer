//
//  RepoItemModel.swift
//  GithubViewer
//
//  Created by Sargis Kocharyan on 31.08.21.
//

import Foundation

struct RepoItemModel: Codable {
    var id: Double?
    var name: String?
    var fullName: String?
    var isPrivate: Bool
    var htmlUrl: String?
    var description: String?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, url
        case fullName = "full_name"
        case isPrivate = "private"
        case htmlUrl = "html_url"
        case description = "description"
    }
}
