//
//  UINib.swift
//  iOSBaseProject
//
//  Created by Mark G on 10/13/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit

public extension UINib {
    public convenience init<T>(withType: T.Type, bundle: Bundle?){
        let name = "\(T.self)"
        var bundle = bundle
        if bundle == nil {
            bundle = Bundle(for: T.self as! AnyClass)
        }
        
        self.init(nibName: name, bundle: bundle)
    }
}
