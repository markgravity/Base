//
//  HasDisposeBag.swift
//  Moco360
//
//  Created by Mark G on 7/23/18.
//  Copyright © 2018 Mobiclix. All rights reserved.
//

import UIKit
import RxSwift

public protocol HasDisposeBag {
    var disposeBag : DisposeBag { get set }
}
