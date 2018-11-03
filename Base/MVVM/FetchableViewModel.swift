//
//  FetchableViewModel.swift
//  Base
//
//  Created by Mark G on 10/26/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public protocol FetchableViewModel {
    associatedtype ItemType
    
    var items: BehaviorRelay<[ItemType]> { get set }
    func fetch()-> Observable<Void>
}
