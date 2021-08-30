//
//  GithubNetworkManager.swift
//  GithubViewer
//
//  Created by Sargis Kocharyan on 31.08.21.
//

import Foundation

class GithubNetworkManager: NetworkManager {
    
    let router = Router<GithubApi>()
    
    func search(keyword: String, completion: @escaping ( RepoSearchResponseModel?, String?)->()) {
        router.request(.searchRepo(name: keyword)) { data, response, error in
            if error != nil {
                completion(nil,  error?.localizedDescription)
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion( nil, nil)
                        return
                    }
                    do {
                        let responseObject = try JSONDecoder().decode(RepoSearchResponseModel.self, from: responseData)
                        completion( responseObject, nil)
                        
                    } catch {
                        completion(nil, nil)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
}
