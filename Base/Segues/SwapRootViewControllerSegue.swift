//
//  SwapRootViewControllerSegue.swift
//  iOSBaseProject
//
//  Created by Mark G on 9/19/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit

class SwapRootViewControllerSegue: UIStoryboardSegue {
    public override func perform() {
        let destination = self.destination
        let window = UIApplication.shared.keyWindow!
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            
            window.rootViewController = destination
        }, completion: nil)
        
    }
}
