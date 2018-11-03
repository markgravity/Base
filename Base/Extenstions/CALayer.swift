//
//  CALayer+Exts.swift
//  tinhte-unofficial-swift
//
//  Created by Mark G on 1/26/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit

public extension CALayer {
    public func addShadow() {

        self.masksToBounds = false
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    public func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    private func addShadowWithRoundedCorners() {
        shadowPath = UIBezierPath(roundedRect: bounds,
                                  cornerRadius: cornerRadius).cgPath
    }
}
