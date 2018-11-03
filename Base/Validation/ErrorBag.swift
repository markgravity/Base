//
//  ErrorBagInfo.swift
//  Moco360
//
//  Created by Mark G on 7/19/18.
//  Copyright © 2018 Mobiclix. All rights reserved.
//

import UIKit

public struct ErrorBag {
    public var errors = [(name:String, errors:[Error])]()
    public var first : Error {
        return errors.first!.errors.first!
    }
    
    public var hasError : Bool {
        return errors.count > 0
    }
    
    public mutating func add(name:String, error:Error){
        var newErrors = [Error]()
        if let group = self.errors.first(where: { $0.name == name }) {
            newErrors.append(contentsOf: group.errors)
        }
        newErrors.append(error)
        
        errors.append((name:name, errors: newErrors))
    }
}
