//
//  Error.swift
//  Base
//
//  Created by Mark G on 10/25/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit

public typealias ErrorCode = Int

public extension ErrorCode {
    static let validation   = 10001
    static let unknown      = 10002
    static let empty        = 10003
}

public extension NSError {
    static let empty = NSError(code: .empty, description: "")
    convenience init(code: ErrorCode, description: String) {
        self.init(domain: Bundle.main.bundleIdentifier!, code: code, userInfo: [
            NSLocalizedDescriptionKey : description
            ])
    }
}
