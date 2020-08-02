//
//  a.swift
//  Base
//
//  Created by Mark G on 11/27/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension ObservableType where Element:ResponsableList {
    func alsoBind(to items: BehaviorRelay<[Self.Element.ItemType]>, isReset: Bool = false) -> Observable<Element> {
        
        return self
            .do(onNext: {
                var newItems = items.value
                if isReset {
                    newItems.removeAll()
                }
                
                newItems.append(contentsOf: $0.items)
                items.accept(newItems)
            })
    }
}
