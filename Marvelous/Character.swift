//
//  Character.swift
//  Marvelous
//
//  Created by Edouard Barbier on 28/04/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import UIKit

class Character: NSObject {
    
    fileprivate let _id: String
    fileprivate let _name: String
    fileprivate let _desc: String
    fileprivate let _thumbnailUrl: String
    fileprivate let _comics: [String: Any]
    fileprivate let _series: [String: Any]
    fileprivate let _stories: [String: Any]
    fileprivate let _urls: [String: Any]
    
    var id: String {
        return _id
    }
    
    var name: String {
        return _name
    }
    
    var desc: String {
        return _desc
    }
    
    var thumbnailUrl: String {
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
    
    init(id: String, name: String, desc: String, thumbnailUrl: String, comics: [String:Any], series: [String:Any], stories: [String:Any], urls: [String:Any]) {
        
        self._id = id
        self._name = name
        self._desc = desc
        self._thumbnailUrl = thumbnailUrl
        self._comics = comics
        self._series = series
        self._stories = stories
        self._urls = urls 
        
    }
    
    
}
