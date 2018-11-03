//
//  Parametable.swift
//  safety
//
//  Created by Mark G on 5/25/18.
//  Copyright © 2018 MarkG. All rights reserved.
//

import UIKit
import ObjectMapper

public protocol Parametable: Mappable {
    init()
    
    func validate()-> ErrorBag?
    func rules(validator: Validator)
    func messages()-> [ValidationAttribute:String]?
}

public extension Parametable {
    init() {
        self.init(JSON: [:])!
    }
    
    public func validate()-> ErrorBag? {
        let validator = Validator()
        validator.customMessages = messages()
        rules(validator: validator)
        return validator.errorBag.hasError ? validator.errorBag : nil
    }
    
    public func rules(validator: Validator) {
        
    }
    
    public func messages()-> [ValidationAttribute:String]? {
        return nil
    }
}
