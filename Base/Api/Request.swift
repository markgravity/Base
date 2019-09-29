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
public typealias Response = [String:Any]
public typealias HTTPHeaders = [String: String]

// Response Result
public struct ResponseResult {
    public var response: Response?
    public var error: Error?
}

// Request Parameters
public struct RequestParameters {
    public var baseUrl: String
    public var endPoint: String
    public var method: HTTPMethod
    public var headers: HTTPHeaders?
    public var token: String?
    public var parameters: Parametable?
    
    public var url: String {
        return "\(baseUrl)/\(endPoint)"
    }
}

public typealias Middleware = (_ result: ResponseResult)-> MiddlewareResult
public typealias TransformResponseResult = (_ result: ResponseResult)-> ResponseResult

public struct Request {
    fileprivate var dataRequest: DataRequest? = nil
    var requestParameters: RequestParameters
    var middleware: Middleware
    var transform: TransformResponseResult
    
    // Initilize
    init(requestParameters: RequestParameters, middleware: @escaping Middleware, transform: @escaping TransformResponseResult) {
        self.requestParameters = requestParameters
        self.middleware = middleware
        self.transform = transform
    }
    
    mutating func response(retry: Bool = true, completion : @escaping ((_ result: ResponseResult) -> Void)) {
        
        
        // Create json request
        dataRequest = request(requestParameters.url,
                method: requestParameters.method,
                parameters: requestParameters.parameters?.toJSON(),
                encoding: JSONEncoding.default,
                headers: requestParameters.headers)
        
        var `self` = self
        dataRequest?.responseJSON { responseObject in
            
            // Get response
            var response: Response? = nil
            if let data = responseObject.data {
                response = try? JSON(data: data).dictionaryObject
            }
            
            let result = ResponseResult(response: response, error: responseObject.error)
            
            DispatchQueue.global().async {
                let result = self.transform(result)
                let middlewareResult = self.middleware(result)
                guard middlewareResult.isPassed else {
                    if middlewareResult.canRetry {
                        self.response(retry: false, completion: completion)
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            
        }
    }
    
    func cancel() {
        dataRequest?.cancel()
    }
}

// Errors
extension Request {
    struct Error {
        static let WrongStructure = NSError(code: .apiWrongStructure, description: "Wrong response structure".localized())
    }
}
