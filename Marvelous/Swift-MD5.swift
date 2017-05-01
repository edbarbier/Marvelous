//
//  Swift-MD5.swift
//  Marvelous
//
//  Created by Edouard Barbier on 30/04/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import Foundation

extension String {
    func md5() -> String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        var hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deinitialize()
        result.deallocate(capacity: digestLen)
        
        
        return String(format: hash as String)
    }
}
