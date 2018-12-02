//
//  ApiRequest.swift
//  Base
//
//  Created by Mark G on 10/25/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

public class ApiRequest<T:Responsable> {
    public typealias Completion = (_ info:T?, _ error:Error?)->()
    public typealias VoidCompletion = (_ error:Error?)->()
    public typealias Handler = (_ isVoid: Bool, _ completion:@escaping Completion)-> (DataRequest?)
    
    fileprivate var handler: Handler!
    
    fileprivate var observable: Observable<T>!
    fileprivate var voidObservable: Observable<Void>!
    
    private init() {}
    
    public convenience init(handler: @escaping Handler) {
        self.init()
        self.handler = handler
        
        self.observable = Observable.create { observer in
            let dataRequest = handler (false) { info, error in
                guard error == nil else {
                    observer.onError(error!)
                    return
                }
                
                observer.onNext(info!)
                observer.onCompleted()
            }
            
            return Disposables.create {
                dataRequest?.cancel()
            }
        }
        
        self.voidObservable = Observable.create { observer in
            let dataRequest = handler (true) { info, error in
                guard error == nil else {
                    observer.onError(error!)
                    return
                }
                
                observer.onNext(())
                observer.onCompleted()
            }
            
            return Disposables.create {
                dataRequest?.cancel()
            }
        }
    }
    
    public func asObservable()-> Observable<T> {
        return observable
    }
    
    public func asVoidObservable()-> Observable<Void> {
        return voidObservable
    }
    
    public func response(_ completion: Completion? = nil) {
        _ = handler(false, { info, error in
            completion?(info, error)
        })
    }
    
    public func voidResponse(_ completion: VoidCompletion? = nil) {
        _ = handler(true, { info, error in
            completion?(error)
        })
    }
}
