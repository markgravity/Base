//
//  Extension.swift
//  Base
//
//  Created by Mark G on 10/30/18.
//  Copyright © 2018 Mark G. All rights reserved.
///Users/markg/Dropbox/Projects/Base/Base.podspec

import UIKit

extension String: Translatable {
    public func localized(_ args: String...)-> String {
        return self
    }
}
