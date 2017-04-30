//
//  Character.swift
//  Marvelous
//
//  Created by Edouard Barbier on 28/04/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import UIKit

class Character: NSObject {
    
    fileprivate var _id: String!
    fileprivate var _name: String!
    fileprivate var _desc: String!
    fileprivate var _thumbnailUrl: [String:Any]!
    fileprivate var _comics: [String: Any]!
    fileprivate var _series: [String: Any]!
    fileprivate var _stories: [String: Any]!
    fileprivate var _urls: [String: Any]!
    
    var id: String {
        return _id
    }
    
    var name: String {
        return _name
    }
    
    var desc: String {
        return _desc
    }
    
    var thumbnailUrl: [String:Any] {
        return _thumbnailUrl
    }
    
    var comics: [String: Any] {
        return _comics
    }
    
    var series: [String: Any] {
        return _series
    }
    
    var stories: [String: Any] {
        return _stories
    }
    
    var urls: [String: Any] {
        return _urls
    }
    
    init(id: String, name: String, desc: String, thumbnailUrl: [String:Any], comics: [String:Any], series: [String:Any], stories: [String:Any], urls: [String:Any]) {
        
        self._id = id
        self._name = name
        self._desc = desc
        self._thumbnailUrl = thumbnailUrl
        self._comics = comics
        self._series = series
        self._stories = stories
        self._urls = urls 
        
    }
    
    init(id: String, dict: [String:Any]) {
        
        self._id = id
        
        if let name = dict[KEY_NAME] as? String {
            
            self._name = name
        }
        
        if let desc = dict[KEY_DESC] as? String {
            self._desc = desc
        }
        
        if let thumbDict = dict[KEY_THUMBNAILURL] as? [String:Any] {
            self._thumbnailUrl = thumbDict
        }
        
        if let comics = dict[KEY_COMICS] as? [String:Any] {
            self._comics = comics
        }
        
        if let series = dict[KEY_SERIES] as? [String:Any] {
            self._series = series
        }
        
        if let stories = dict[KEY_STORIES] as? [String:Any] {
            self._stories = stories
        }
        
        if let urls = dict[KEY_URLS] as? [String:Any] {
            self._urls = urls
        }
        
    }
    
    
}
