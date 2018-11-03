//
//  IdTransform.swift
//  S3Innovate
//
//  Created by Mark G on 9/6/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit
import ObjectMapper

class NumericTransform<T:Numeric>: TransformType {
    typealias Object = T
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Object? {
        if let int = value as? Object {
            return int
        }
        
        if let string = value as? String {
             let typeString = "\(T.self)"
            if typeString.contains("Double") {
                return Double(string) as? T
            } else if typeString.contains("Int") {
                return Int(string) as? T
            } else if typeString.contains("Float") {
                return Float(string) as? T
            }
            
        }
        
        return nil
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        guard let int = value else {
            return nil
        }
        
        return "\(int)"
    }

}
