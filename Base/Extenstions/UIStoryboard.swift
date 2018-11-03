//
//  UIStoryboard+Utils.swift
//  VADriver
//
//  Created by Mark G on 9/26/17.
//  Copyright © 2017 Tomlar. All rights reserved.
//

import UIKit

public extension UIStoryboard {
    public func instantiateViewController<T>( withType type:T.Type)-> T{
        let name = "\(T.self)".replacingOccurrences(of: ".Type", with: "")
        return instantiateViewController(withIdentifier:  name) as! T
    }
    
    public func instantiateViewController<T>( withNavigationOf type:T.Type)-> UINavigationController{
        var name =  "\(T.self)".replacingOccurrences(of: ".Type", with: "")
        name = name.replacingOccurrences(of: "Controller", with: "NavigationController")
        return instantiateViewController(withIdentifier:  name) as! UINavigationController
    }
}
