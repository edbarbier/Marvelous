//
//  ChacaterManager.swift
//  Marvelous
//
//  Created by Edouard Barbier on 28/04/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import UIKit

enum CharactersResult {
    case success([Character])
    case failure(Error)
}

class CharacterManager {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
        
    }()
    
    func processCharactersRequest(data: Data?, error: Error?) -> CharactersResult {
        
        guard let jsonData = data else {
            return .failure(error!)
        }
        return MarvelAPI.characters(fromJSON: jsonData)
    }
    
    func getCharacters(completion: @escaping (CharactersResult) -> Void) {
        
        let url = MarvelAPI.marvelApiURL(endpoint: .characters, orderBy: .name, limit: 50)
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            print("Response received from API: \(response)")
            
            let result = self.processCharactersRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        })
        task.resume()
        
    }
    
    
    
    
    
}
