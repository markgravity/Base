//
//  ApiListRequest.swift
//  Base
//
//  Created by Mark G on 10/25/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

public class ApiListRequest<T:Responsable> {
    public typealias Completion = (_ list:ResponseList<T>?, _ error:Error?)->()
    public typealias Handler = (_ completion:@escaping Completion)-> (DataRequest?)
    
    fileprivate var handler: Handler!
    fileprivate var observable: Observable<ResponseList<T>>!
    
    private init() {}
    
    public convenience init(handler: @escaping Handler) {
        self.init()
        self.handler = handler
        
        self.observable = Observable.create { observer in
            let dataRequest = handler { info, error in
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
    }
    
    public func asObservable()-> Observable<ResponseList<T>> {
        return observable
    }
    
    public func response(_ completion: Completion? = nil) {
        _ = handler { list, error in
            completion?(list, error)
        }
    }
}
