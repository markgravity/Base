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
    public var passable: Bool
    public var retryable: Bool
    public var token: String?
    
    public init(passable: Bool, retryable: Bool, token: String?) {
        self.passable = passable
        self.retryable = retryable
        self.token = token
    }
}

public protocol Apiable {
    associatedtype ObjectType: Responsable
    associatedtype ListType: ResponsableList
    
    // Base Url
    static var baseUrl: String { get }
    
    
    // Create an api that return an object
    static func createApi(baseUrl: String?, endPoint: String, method: HTTPMethod, parameters: Parametable?, token:String?)
        -> ApiRequest<ObjectType>
    
    // Create an api that return a list
    static func createApiList(baseUrl: String?, endPoint: String, method: HTTPMethod, parameters: Parametable?, token:String?)-> ApiListRequest<ListType>
    
    // Called before completion, delimiter that shoud we call the completion function
    static func middleware(response: Response<[String:Any]>)-> MiddlewareResult
    
    // Transform response object from api to desire format
    static func transform(response: Response<Data>)-> Response<[String:Any]>

    // Transform request parameters
    static func modify(configure: RequestConfigure)
        -> RequestConfigure
}


public extension Apiable {
    static func createApi(baseUrl: String? = nil, endPoint: String, method: HTTPMethod, parameters: Parametable? = nil, token:String? = nil)-> ApiRequest<ObjectType> {
        var handler: ApiRequest<ObjectType>.Handler!

        // Validation
        let errorBag = parameters?.validate()
        guard errorBag == nil else {
            handler = {
                $1(nil, errorBag?.first)
                return nil
            }
            return ApiRequest<ObjectType>(handler: handler)
        }


        // Request handler
        handler = { isVoid, completion in
            // Create request parameters & transform it
            var configure = RequestConfigure(baseUrl: baseUrl ?? self.baseUrl,
                                                      endPoint: endPoint,
                                                      method: method,
                                                      headers: nil,
                                                      token: token,
                                                      parameters: parameters)
            configure = self.modify(configure: configure)

            var request = Request(configure: configure, middlewareClosure:
            {
                return self.middleware(response: $0)
            }, transformClosure: {
                return self.transform(response: $0)
            })


            // Request to server
            request.response {
                let error = $0.error

                // Check error
                guard error == nil else {
                    completion(nil, error!)
                    return
                }

                guard $0.data == nil
                    && isVoid else {

                        // Response must not nil
                        guard let data = $0.data else {
                            completion(nil, NSError(code: .apiWrongStructure, description: "Data is not found"))
                            return
                        }

                        // Data have to be mapped
                        guard let info = ObjectType(JSON:data) else {
                            completion(nil, NSError(code: .apiWrongStructure, description: "Wrong data structure"))
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

        return ApiRequest<ObjectType>(handler: handler)
    }
    
    static func createApiList(baseUrl: String? = nil, endPoint: String, method: HTTPMethod, parameters: Parametable? = nil, token:String? = nil)-> ApiListRequest<ListType> {
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
            var configure = RequestConfigure(baseUrl: baseUrl ?? self.baseUrl,
                                                      endPoint: endPoint,
                                                      method: method,
                                                      headers: nil,
                                                      token: token,
                                                      parameters: parameters)
            configure = self.modify(configure: configure)
            
            var request = Request(configure: configure, middlewareClosure: {
                return self.middleware(response: $0)
            }, transformClosure: {
                return self.transform(response: $0)
            })
            
            request.response(completion: {
                let error = $0.error
                
                guard error == nil else {
                    completion(nil, error!)
                    return
                }
                
                
                guard let data = $0.data else {
                    completion(nil, NSError(code: .apiWrongStructure, description: "Data is not found"))
                    return
                }
                
                let info = ListType(JSON:data)
                completion(info!, nil)
            })
            
            return request
        }
        
        return ApiListRequest<ListType>(handler: handler)
    }
    
//    static func middleware(response: Response<[String:Any]>)-> MiddlewareResult {
//        return MiddlewareResult(passable: true, retryable: true, token: nil)
//    }
}
