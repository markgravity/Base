//
//  ResponseList.swift
//  safety
//
//  Created by Mark G on 12/20/17.
//  Copyright © 2017 MarkG. All rights reserved.
//

import UIKit
import ObjectMapper

public protocol ResponsableList: Mappable {
    associatedtype ItemType: Responsable
    var items: [ItemType] { get set }
}

public struct ResponseList<T:Responsable>: ResponsableList {
    public typealias ItemType = T
    public var items: [T] = [T]()
    public init?(map: Map) {}
    
    public mutating func mapping(map: Map) {
        items  <- map["data"]
    }
    
    
}
