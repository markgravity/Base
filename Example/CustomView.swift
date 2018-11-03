//
//  CustomView.swift
//  Example
//
//  Created by Mark G on 10/26/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit
import Base

class CustomView: UIView, Popupable {
    @IBOutlet weak var label: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    
    func setup() {
        
    }
    
    
    static func show(title: String) {
        let view = initialView()
        view.label.text = title
        
        view.show()
    }
}
