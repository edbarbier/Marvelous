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
    
    //TODO: HIDE KEYS IN GITIGNORE FILE - not done on purpose here to let interviewer run the app. 
    private static let apiKey = "ae4fd56952df9c1455d573b2d4f3b93e"
    private static let privateKey = "b12605d9e7e21ecf3c3b00238633dd06efbd9037"
    
    static func marvelApiURL(endpoint: EndPoint, orderBy: OrderBy, limit: Int?) -> URL {
        
        var urlString = String()
        
        let ts = NSDate().timeIntervalSince1970.description
        
        
        let hash = "\(ts)\(privateKey)\(apiKey)".md5()
        
        if limit != nil {
            
            urlString = "\(baseURL)\(endpoint)?orderBy=\(orderBy)&limit=\(limit!)&ts=\(ts)&apikey=\(apiKey)&hash=\(hash!)"

        } else {
            
            urlString = "\(baseURL)\(endpoint)?orderBy=\(orderBy)&ts=\(ts)&apikey=\(apiKey)&hash=\(hash)"
        }
               
        return URL(string: urlString)!
    }
    
    //Construct Array of Characters based on JSON
    static func characters(fromJSON data: Data) -> CharactersResult {
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
            
            //print("JSON Object received from API = \(jsonObject)")
            
            guard
            let jsonDictionary = jsonObject as? [AnyHashable:Any], let jsonData = jsonDictionary["data"] as? [AnyHashable:Any],
                let jsonCharacters = jsonData["results"] as? [[String: Any]] else {
            
              return .failure(MarvelAPIError.invalidJSONData)
            }
            
            var characters = [Character]()
            
            for jsonCharacter in jsonCharacters {
                
                if let character = character2(fromJSON: jsonCharacter) {
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
            let thumbnailUrl = json[KEY_THUMBNAILURL] as? [String:Any],
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
    
    static func character2(fromJSON json: [String:Any]) -> Character? {
        
        var characterId = String()
        var characterDict = Dictionary<String,Any>()
        
        if let id = json[KEY_ID] as? String { characterId = id }
        if let name = json[KEY_NAME] as? String { characterDict[KEY_NAME] = name }
        if let desc = json[KEY_DESC] as? String { characterDict[KEY_DESC] = desc }
        if let thumbnail = json[KEY_THUMBNAILURL] as? [String:Any] { characterDict[KEY_THUMBNAILURL] = thumbnail }
        if let comics = json[KEY_COMICS] as? [String:Any] { characterDict[KEY_COMICS] = comics }
        if let series = json[KEY_SERIES] as? [String:Any] { characterDict[KEY_SERIES] = series }
        if let stories = json[KEY_STORIES] as? [String:Any] { characterDict[KEY_STORIES] = stories }
        if let urls = json[KEY_URLS] as? [String:Any] { characterDict[KEY_URLS] = urls }
        
        //TODO: Add the rest of the data 
        
        let char = Character(id: characterId, dict: characterDict)
                
        return char
    }
    
}
