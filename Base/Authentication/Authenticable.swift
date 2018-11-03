//
//  User.swift
//  iOSBaseProject
//
//  Created by Mark G on 8/11/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit
import ObjectMapper

public protocol Authenticatable {
    var id: Int? { get set }
    var apiToken: String? { get set }
}
