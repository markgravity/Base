//
//  ValidationExtenstion.swift
//  iOSBaseProject
//
//  Created by Mark G on 8/12/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit

extension String {
    var required: ValidationAttribute {
        return ValidationAttribute.init(rule: .required, name: self)
    }
}
