//
//  FormDataParametable.swift
//  Base
//
//  Created by Mark G on 6/1/19.
//  Copyright © 2019 Mark G. All rights reserved.
//

import UIKit

public protocol FormDataParametable: Parametable {
    func toData() -> [String:Data]
}

public extension FormDataParametable {
    func toData() -> [String:Data] {
        let JSON = toJSON()
        var data = [String:Data]();
        for (key, value) in JSON {
            // string
            if let string = value as? String {
                data[key] = string.data(using: .utf8)!
            }
            
            // integer
            else if let int = value as? Int {
                data[key] = "\(int)".data(using: .utf8)!
            }
            
            // double
            else if let double = value as? Double {
                data[key] = "\(double)".data(using: .utf8)!
            }
            
            // float
            else if let float = value as? Float {
                data[key] = "\(float)".data(using: .utf8)!
            }
            
                
            // data
            else if let dt = value as? Data {
                data[key] = dt
            }
        }
        
        return data;
    }
}
