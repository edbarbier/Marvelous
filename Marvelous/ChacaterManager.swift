//
//  ChacaterManager.swift
//  Marvelous
//
//  Created by Edouard Barbier on 28/04/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import UIKit

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum CharactersResult {
    case success([Character])
    case failure(Error)
}

enum ImageError: Error {
    case imageCreationError
}

class CharacterManager {
    
    var characters: [Character]!
    
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
    
    func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
                
                // Couldn't create an image
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(ImageError.imageCreationError)
                }
        }
                
        return .success(image)
    }
    
    func fetchImage(for character: Character, completion: @escaping (ImageResult) -> Void) {
        
//        let imageUrlString = "\(character.thumbnailUrl["path"]!).\(character.thumbnailUrl["extension"]!)"
//        let imageUrl = URL(string: imageUrlString)
//        print("Fetching image for url = \(imageUrl!)")
        
        let imgUrl = URL(string: self.getCharacterImgUrl(from: character))
        
        let request = URLRequest(url: imgUrl!)
            
        let task = session.dataTask(with: request) {
            
            (data, response, error) -> Void in
        
            let result = self.processImageRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    func getCharacters(completion: @escaping (CharactersResult) -> Void) {
        
        let url = MarvelAPI.marvelApiURL(endpoint: .characters, orderBy: .name, limit: 100)
        
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
    
    //FROM JSON FILE to work around MARVEL DEVELOPER Site being down.
    
    func getCharactersFromJSONFile(completion: @escaping (CharactersResult) -> Void) {
        
        do {
            
            let path = Bundle.main.path(forResource: "marvel", ofType: "json")!
            
            let data = try (NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe))

            let result = self.processCharactersRequest(data: data as Data, error: nil)
            
            OperationQueue.main.addOperation {
                completion(result)
            }
            
        } catch let err {
            
            print(err.localizedDescription)
            
        }
    }
    
    func getCharacterImgUrl(from character: Character) -> String {
        
        var url = String()
        
        if let thumbnail = character.thumbnailUrl as [String:Any]? {
            
            guard
                let path = thumbnail["path"] as? String,
                let ext = thumbnail["extension"] as? String
                else {
                  
                    return "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg"
            }
            url = "\(path).\(ext)"

        } else {
            
            return "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg"
        }

        return url
    }
    
    
    
    
    
}
