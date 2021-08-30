//
//  GithubSearchViewModel.swift
//  GithubViewer
//
//  Created by Sargis Kocharyan on 31.08.21.
//

import Foundation

class GithubSearchViewModel {
    
    private var networkManager: GithubNetworkManager
    
    var dataSource: [RepoItemModel] = []
    
    init(networkManager: GithubNetworkManager) {
        self.networkManager = networkManager
    }
    
    func searchForRepo(keyword: String, completion: @escaping ()->())  {
        networkManager.search(keyword: keyword) { [weak self] responseModel, error in
            self?.dataSource = responseModel?.items ?? []
            completion()
        }
    }
}
