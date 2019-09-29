//
//  EnumTransform.swift
//  S3Innovate
//
//  Created by Mark G on 9/8/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit
import ObjectMapper

class EnumTransform<ObjectType: RawRepresentable, JSONType>: TransformType {
    typealias Object = ObjectType
    typealias JSON = JSONType
    
    func transformFromJSON(_ value: Any?) -> Object? {
        
        guard let value = value as? ObjectType.RawValue else {
            return nil
        }
        
        return Object.init(rawValue: value)
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        
        return value?.rawValue as? JSON
    }
    
}
