//
//  Array.swift
//  Base
//
//  Created by Mark G on 10/26/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit

public extension Array {
    public func modify(at index:Int, _ element:((_ e:Element)->Element))-> Array {
        let e = element(self[index])
        var a = self
        a[index] = e
        
        return a
    }
}
