//
//  Enum.swift
//  Base
//
//  Created by Mark G on 10/26/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit

public protocol GroupComparable: Equatable {
    func `in`(_ list: Self...) -> Bool
    func notIn(_ list: Self...) -> Bool
}

public extension GroupComparable {
    func `in`(_ list: Self...) -> Bool {
        return list.contains(self)
    }
    
    func notIn(_ list: Self...) -> Bool {
        return !list.contains(self)
    }
}
