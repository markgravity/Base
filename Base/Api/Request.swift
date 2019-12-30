//
//  Request.swift
//  Base
//
//  Created by Mark G on 8/1/19.
//  Copyright © 2019 Mark G. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public typealias HTTPHeaders = [String: String]

// Response Result
public struct Response<DataType> {
    public var data: DataType?
    public var error: Error?
    public var request: Request!

    public init(request: Request, data: DataType?, error: Error?) {
        self.data = data
        self.error = error
        self.request = request
    }
    
    public func empty<AnotherDataType>()-> Response<AnotherDataType> {
        return Response<AnotherDataType>(request: request, data: nil, error: error)
    }
    
    public func error<AnotherDataType>(_ error: Error)-> Response<AnotherDataType> {
        return Response<AnotherDataType>(request: request, data: nil, error: error)
    }
    
    public func data<AnotherDataType>(_ data: AnotherDataType)-> Response<AnotherDataType> {
        return Response<AnotherDataType>(request: request, data: data, error: nil)
    }
}

// Request Parameters
public enum RequestEncoding {
    case json, url
    
    
}
public struct RequestConfigure {
    public var baseUrl: String
    public var endPoint: String
    public var method: HTTPMethod
    public var headers: HTTPHeaders?
    public var token: String?
    public var parameters: Parametable?
    public var encoding: ParameterEncoding = JSONEncoding.default
    public var url: String {
        guard endPoint.count > 0 else {
            return baseUrl
        }
        
        return "\(baseUrl)/\(endPoint)"
    }
}

public typealias ApiMiddlewareClosure = (_ response: Response<[String:Any]>)-> MiddlewareResult
public typealias ApiTransformResponseClosure = (_ response: Response<Data>)-> Response<[String:Any]>

public struct Request {
    fileprivate var dataRequest: DataRequest? = nil
    public var configure: RequestConfigure
    var middlewareClosure: ApiMiddlewareClosure
    var transformClosure: ApiTransformResponseClosure
    
    // Initilize
    init(configure: RequestConfigure, middlewareClosure: @escaping ApiMiddlewareClosure, transformClosure: @escaping ApiTransformResponseClosure) {
        self.configure = configure
        self.middlewareClosure = middlewareClosure
        self.transformClosure = transformClosure
    }
    
    mutating func response(retry: Bool = true, completion : @escaping ((_ response: Response<[String:Any]>) -> Void)) {
        
        
        // Create json request
        dataRequest = request(configure.url,
                method: configure.method,
                parameters: configure.method == .get ? nil : configure.parameters?.toJSON(),
                encoding: configure.encoding,
                headers: configure.headers)
        
        var `self` = self
        dataRequest?.responseData { responseObject in
            
            // Get response
            let data = responseObject.data
            let error = responseObject.error
            
            DispatchQueue.main.async {
                let tmpResponse = Response(request: self, data: data, error: error)
                var response = self.transformClosure(tmpResponse)
                
                // Checking middleware
                let middlewareResult = self.middlewareClosure(response)
                guard middlewareResult.passable else {
                    if retry {
                        self.response(retry: false, completion: completion)
                    }
                    
                    return
                }
                completion(response)
            }
            
            
        }
    }
    
    func cancel() {
        dataRequest?.cancel()
    }
}
