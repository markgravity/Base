//
//  NSLayoutConstraint.swift
//  Moco360
//
//  Created by Mark G on 8/3/18.
//  Copyright © 2018 Mobiclix. All rights reserved.
//

import UIKit
import Device

public extension NSLayoutConstraint {
    @IBInspectable var iPhoneXConstant : CGFloat {
        get {
            return constant
        }
        
        set {
            if Device.size() == .screen5_8Inch
                || Device.size() == .screen6_1Inch
                || Device.size() == .screen6_5Inch {
                constant = newValue
            }
        }
    }
    
    @IBInspectable var iPhone5Constant : CGFloat {
        get {
            return constant
        }
        
        set {
            if Device.size() == .screen3_5Inch {
                constant = newValue
            }
        }
    }
    
    @IBInspectable var iPhonePlusConstant : CGFloat {
        get {
            return constant
        }
        
        set {
            if Device.size() == .screen4_7Inch {
                constant = newValue
            }
        }
    }
}
