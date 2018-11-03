//
//  Translatable.swift
//  Base
//
//  Created by Mark G on 10/30/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit

public protocol Translatable {
    func localized(_ args: String...)-> String
}
