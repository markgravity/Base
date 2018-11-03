//
//  HasVModel.swift
//  Moco360
//
//  Created by Mark G on 7/18/18.
//  Copyright © 2018 Mobiclix. All rights reserved.
//

import UIKit
import RxSwift

public protocol HasViewModel : HasDisposeBag {
    associatedtype ViewModelType : ViewModel

    var viewModel : ViewModelType! { get set }
    
    func setup()
    func binds()
}

public extension HasViewModel {
    func setup() {}
}
