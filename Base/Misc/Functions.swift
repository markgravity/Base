//
//  Functions.swift
//  Base
//
//  Created by Mark G on 11/27/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

public typealias Handler = (()->())

public func showProgressHUD() {
    let data = ActivityData.init(type: .circleStrokeSpin)
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(data, nil)
}

public func dismissProgressHUD() {
    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
}

public func alert(error: Error, title: String? = nil, handler: Handler? = nil) {
    let error = error as NSError
    alert(title: title, message: error.localizedDescription, handler: handler)
}

public func alert(title: String? = nil, message: String, handler: Handler? = nil) {
    guard let closure = BaseConfigure.AlertClosure else {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { _ in
            handler?()
        }
        alert.addAction(action)
        
        UIApplication.shared.keyWindow?.visibleViewController?.present(alert, animated: true, completion: nil)
        return
    }
    
    closure(title, message, handler)
}

