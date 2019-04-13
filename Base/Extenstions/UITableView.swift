//
//  UITableView+Utils.swift
//  VADriver
//
//  Created by markg on 9/28/17.
//  Copyright © 2017 Tomlar. All rights reserved.
//

import UIKit
import RxSwift

public extension UITableView {
    @IBInspectable var cellReuseIdentifier: String? {
        set {
            guard let value = newValue else { return }
            let nib = UINib(nibName: value, bundle: nil)
            register(nib, forCellReuseIdentifier: value)
        }
        
        get {
            fatalError("cellReuseIdentifier.get() method has not been implemented")
        }
    }
    
    func dequeueReusableCell<T>(withType type:T.Type) -> T? {
        let name = "\(T.self)"
        return dequeueReusableCell(withIdentifier: name) as? T
    }
    
    func dequeueReusableCell<T>(withType type:T.Type) -> T? where T: HasDisposeBag {
        let name = "\(T.self)"
        var cell = dequeueReusableCell(withIdentifier: name) as? T
        cell?.disposeBag = DisposeBag()
        
        return cell
    }
    
    func dequeueReusableCell<T>(withType type:T.Type, for indexPath:IndexPath) -> T? {
        
        let name = "\(T.self)"
        return dequeueReusableCell(withIdentifier: name, for: indexPath) as? T
    }
    
    func dequeueReusableCell<T>(withType type:T.Type, for indexPath:IndexPath) -> T? where T: HasDisposeBag {
        
        let name = "\(T.self)"
        var cell = dequeueReusableCell(withIdentifier: name, for: indexPath) as? T
        cell?.disposeBag = DisposeBag()
        return cell
    }
}
