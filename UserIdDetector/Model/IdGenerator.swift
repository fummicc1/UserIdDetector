//
//  IdGenerator.swift
//  SampleForUserId
//
//  Created by Fumiya Tanaka on 2019/02/16.
//  Copyright © 2019 Fumiya Tanaka. All rights reserved.
//

import Foundation

class IdGenerator {
    
    static func setId(length: Int) -> String {
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var id = ""
        
        for _ in 0..<length {
            let _value = Int.random(in: 0..<base.count)
            id.append(base[base.index(base.startIndex, offsetBy: _value)])
        }
        
        return id
        
    }
    
}
