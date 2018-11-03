//
//  TimestampTranform.swift
//  Base
//
//  Created by Mark G on 10/26/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit
import ObjectMapper

open class TimestampTransform: DateFormatterTransform {
    
    static let reusableTimestampFormatter = DateFormatter(withFormat: "yyyy-MM-dd HH:mm:ss", locale: "en_US_POSIX")
    
    public init() {
        super.init(dateFormatter: TimestampTransform.reusableTimestampFormatter)
    }
}
