//
//  Apiable.swift
//  safety
//
//  Created by Mark G on 5/24/18.
//  Copyright © 2018 MarkG. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RxSwift
import ObjectMapper

public struct MiddlewareResult {
    var isPassed: Bool
    var canRetry: Bool
    var token: String?
}

public protocol Apiable {
    associatedtype ResponsableType: Responsable
    typealias Completion = (_ response:Response?, _ error:Error?)->()
    typealias Response = [String:Any]
    
    // Base Url
    static var baseUrl: String { get }
    
    
    // Create an api that return an object
    static func createApi(baseUrl: String?, endPoint: String, method: HTTPMethod, parameters: Parametable?, token:String?)
        -> ApiRequest<ResponsableType>
    
    // Create an api that return a list
    static func createApiList<ListType: ResponsableList>(baseUrl: String?, endPoint: String, method: HTTPMethod, parameters: Parametable?, token:String?)-> ApiListRequest<ListType>
    
    // Called before completion, delimiter that shoud we call the completion function
    static func middleware(result: ResponseResult)-> MiddlewareResult
    
    // Transform response object from api to desire format
    static func transform(result: ResponseResult)-> ResponseResult
    
    // Transform request parameters
    static func transform(requestParameters parameters: RequestParameters)
        -> RequestParameters
}


public extension Apiable {
    static func createApi(baseUrl: String? = nil, endPoint: String, method: HTTPMethod, parameters: Parametable? = nil, token:String? = nil)-> ApiRequest<ResponsableType> {
        var handler: ApiRequest<ResponsableType>.Handler!
        
        // Validation
        let errorBag = parameters?.validate()
        guard errorBag == nil else {
            handler = {
                $1(nil, errorBag?.first)
                return nil
            }
            return ApiRequest<ResponsableType>.init(handler: handler)
        }
        
        
        // Request handler
        handler = { isVoid, completion in
            
            // Create request parameters & transform it
            var requestParameters = RequestParameters(baseUrl: baseUrl ?? self.baseUrl,
                                                      endPoint: endPoint,
                                                      method: method,
                                                      headers: nil,
                                                      token: token,
                                                      parameters: parameters)
            requestParameters = self.transform(requestParameters: requestParameters)
            
            var request = Request(requestParameters: requestParameters, middleware: { result in
                return self.middleware(result: result)
            }, transform: { result in
                return self.transform(result: result)
            })
            
            
            // Request to server
            request.response { result in
                let error = result.error
                let response = result.response
                
                // Check error
                guard error == nil else {
                    completion(nil, error!)
                    return
                }
                
                guard response == nil
                    && isVoid else {
                        
                        // Response must not nil
                        guard let response = response else {
                            completion(nil, Request.Error.WrongStructure)
                            return
                        }
                        
                        // Prefer get data inside `response`
                        var data = response
                        if let tmp = response["data"] as? [String:Any] {
                            data = tmp
                        }
                        
                        // Data have to be mapped
                        guard let info = ResponsableType.init(JSON:data) else {
                            completion(nil, Request.Error.WrongStructure)
                            return
                        }
                        
                        // Success
                        completion(info, nil)
                        return
                }
                
                completion(nil, nil)
                return
                
                
            }
            
            return request
        }
        
        return ApiRequest<ResponsableType>(handler: handler)
    }
    
    static func createApiList<ListType: ResponsableList>(baseUrl: String? = nil, endPoint: String, method: HTTPMethod, parameters: Parametable? = nil, token:String? = nil)-> ApiListRequest<ListType> {
        var handler: ApiListRequest<ListType>.Handler!
        
        // Validation
        let errorBag = parameters?.validate()
        guard errorBag == nil else {
            handler = {
                $0(nil, errorBag?.first)
                return nil
            }
            return ApiListRequest<ListType>(handler: handler)
        }
        
        
        // Request handler
        handler = { completion in
            // Create request parameters & transform it
            var requestParameters = RequestParameters(baseUrl: baseUrl ?? self.baseUrl,
                                                      endPoint: endPoint,
                                                      method: method,
                                                      headers: nil,
                                                      token: token,
                                                      parameters: parameters)
            requestParameters = self.transform(requestParameters: requestParameters)
            
            var request = Request(requestParameters: requestParameters, middleware: { result in
                return self.middleware(result: result)
            }, transform: { result in
                return self.transform(result: result)
            })
            
            request.response(completion: { result in
                let error = result.error
                let response = result.response
                
                guard error == nil else {
                    completion(nil, error!)
                    return
                }
                
                
                guard response != nil else {
                    completion(nil, Request.Error.WrongStructure)
                    return
                }
                
                let info = ListType(JSON:response!)
                completion(info!, nil)
            })
            
            return request
        }
        
        return ApiListRequest<ListType>(handler: handler)
    }
    
    static func middleware(result: ResponseResult)-> MiddlewareResult {
        return MiddlewareResult(isPassed: true, canRetry: false, token: nil)
    }
}
