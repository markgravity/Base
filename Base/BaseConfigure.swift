//
//  Base.swift
//  iOSBaseProject
//
//  Created by Mark G on 8/11/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit

public class BaseConfigure: NSObject {
    public static var ApiBaseUrl = ""
    public static var ValidationMessages : [String:Any]?
    public static var ValidationURL : URL?
    public static var PopupVerticalMargin : CGFloat = 20
    public static var AlertClosure : ((_ title: String?, _ message: String, _ handler: Handler?)-> ())?
}
