//
//  ValidationRule.swift
//  iOSBaseProject
//
//  Created by Mark G on 8/12/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit

public enum ValidationRule: RawRepresentable, Hashable {
    public var hashValue: Int {
        switch self {
        case .required:
            return 0
            
        case .min:
            return 1
            
        case .max:
            return 2
            
        case .confirmed:
            return 3
        }
        
        
    }
    
    public var rawValue: String {
        switch self {
        case .required:
            return "required"
            
        case .min:
            return "min"
        case .max:
            return "max"
            
        case .confirmed:
            return "confirmed"
        }
    }
    
    public init?(rawValue: String) {
        switch rawValue {
        case "required":
            self = .required
        case "min":
            self = .min(0)
            
        case "max":
            self = .max(0)
            
        case "confirmed":
            self = .confirmed("")
            
        default:
            return nil
        }
    }
    
    
    
    case required
    case min(CGFloat)
    case max(CGFloat)
    case confirmed(Any)
}
