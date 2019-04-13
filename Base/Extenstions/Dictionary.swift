//
//  Dictionary.swift
//  iOSBaseProject
//
//  Created by Mark G on 8/12/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit

public extension Dictionary {
    
    mutating func merge(with dictionary: [Dictionary.Key : Dictionary.Value]) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
    func merged(with dictionary: [Dictionary.Key : Dictionary.Value]) -> [Dictionary.Key : Dictionary.Value] {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}
