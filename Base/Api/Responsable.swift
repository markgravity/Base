//
//  Responsable.swift
//  Base
//
//  Created by Mark G on 10/25/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import ObjectMapper

public protocol Responsable: Mappable {
    static var endPoint: String { get }
}

public extension Responsable {
    init() {
        self.init(JSON: [:])!
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.toJSONString() == rhs.toJSONString()
    }
}
