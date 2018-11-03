//
//  ValidationMessage.swift
//  iOSBaseProject
//
//  Created by Mark G on 8/12/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit

public struct ValidationMessage {
    public var rule : ValidationRule
    public var messages : [ValidationValueType : String]
    
    public init(rule: ValidationRule, message: String) {
        self.rule = rule
        self.messages = [
            .other : message
        ]
    }
    
    public init(rule: ValidationRule, messages: [ValidationValueType : String]) {
        self.rule = rule
        self.messages = messages
    }
    
}
