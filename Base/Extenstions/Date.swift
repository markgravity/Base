//
//  Date+Utils.swift
//  VADriver
//
//  Created by Mark G on 9/15/17.
//  Copyright © 2017 Tomlar. All rights reserved.
//

import UIKit

public extension Date {
    public init?(iso8601 string:String){
        self.init()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.init(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let date = formatter.date(from: string) else {
            return nil
        }
        
        
        self = date
    }
    
    public init?(timestamp string:String){
        self.init()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = formatter.date(from: string) else {
            return nil
        }
        
        self = date
    }
    
    public func format(_ format:String)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}
