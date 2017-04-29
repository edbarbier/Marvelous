//
//  MarvelAPI.swift
//  Marvelous
//
//  Created by Edouard Barbier on 28/04/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import UIKit
import Foundation

enum MarvelAPIError: Error {
    case invalidJSONData
}

enum EndPoint: String {
    case characters = "characters"
}

enum OrderBy: String {
    case name = "name"
}

struct MarvelAPI {

    private static let baseURL = "https://gateway.marvel.com:443/v1/public/"
    private static let apiKey = "468cfa39e994bdbd4398928bb0c9eccc"
    
    static func marvelApiURL(endpoint: EndPoint, orderBy: OrderBy, limit: Int?) -> URL {
        
        var urlString = String()
        
        if limit != nil {
            
            urlString = "\(baseURL)\(endpoint)?orderBy=\(orderBy)&limit=\(limit!)&apikey=\(apiKey)"

        } else {
            
            urlString = "\(baseURL)\(endpoint)?orderBy=\(orderBy)&apikey=\(apiKey)"
        }
        
        return URL(string: urlString)!
    }
    
    //Construct Array of Character based on JSON
    static func characters(fromJSON data: Data) -> CharactersResult {
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
            
            guard
            let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let jsonCharacters = jsonDictionary["results"] as? [[String: Any]] else {
            
              return .failure(MarvelAPIError.invalidJSONData)
            }
            
            print(jsonCharacters)
            
            var characters = [Character]()
            
            for jsonCharacter in jsonCharacters {
                
                if let character = character(fromJSON: jsonCharacter) {
                    characters.append(character)
                }
            }
            
            if characters.isEmpty && !jsonCharacters.isEmpty {
                
                return .failure(MarvelAPIError.invalidJSONData)
            } else {
                
                return .success(characters)
            }
            
        } catch let error {
            return .failure(error)
        }
        
    }
    
    //Creating Character object based on JSON
    static func character(fromJSON json: [String:Any]) -> Character? {
        
        guard
            let id = json[KEY_ID] as? String,
            let name = json[KEY_NAME] as? String,
            let desc = json[KEY_DESC] as? String,
            let thumbnailUrl = json[KEY_THUMBNAILURL] as? String,
            let comics = json[KEY_COMICS] as? [String:Any],
            let series = json[KEY_SERIES] as? [String:Any],
            let stories = json[KEY_STORIES] as? [String:Any],
            let urls = json[KEY_URLS] as? [String:Any]
        
        else {
            print("Invalid object")
            return nil
        }
        
        return Character(id: id, name: name, desc: desc, thumbnailUrl: thumbnailUrl, comics: comics, series: series, stories: stories, urls: urls)
    }
    
}
