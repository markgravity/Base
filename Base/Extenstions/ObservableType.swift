//
//  ObservableType.swift
//  Base
//
//  Created by Mark G on 11/27/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension ObservableType {
    func showProgressHUD()-> Observable<Element> {
        
        return self
            .do(onNext: { _ in
                Base.showProgressHUD()
            })
    }
    
    func dismissProgressHUD()-> Observable<Element> {

        return self
            .do(onNext: { _ in
                Base.dismissProgressHUD()
            }, onError: { _ in
                Base.dismissProgressHUD()
            })
    }
    
    func asVoidObservable()-> Observable<Void> {
        return self.map { _ in ()}
    }
    
    func catchErrorThenAlert(_ handler: Handler? = nil)-> Observable<Element> {
        return self.catchError {
            Base.dismissProgressHUD()
            alert(error: $0, handler: handler)
            
            return Observable.empty()
        }
    }
    
    func skipError()-> Observable<Element> {
        return self.catchError { _ in
            Base.dismissProgressHUD()
            
            return Observable.empty()
        }
    }
    
//    func call<T>(api observable: Observable<T>)-> Observable<T> {
//
//    }
    
    func alsoBind(to relay: RxCocoa.BehaviorRelay<Self.Element>) -> Observable<Element> {
        
        return self
            .do(onNext: {
                relay.accept($0)
            })
    }
}
