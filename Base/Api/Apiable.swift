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

public protocol Apiable {
    associatedtype ResponsableType: Responsable
    typealias Completion = (_ response:[String:Any]?, _ error:Error?)->()
    
    static func createApi(baseUrl: String, endPoint: String, method: HTTPMethod, parameter: Parametable?, token:String?)
        -> ApiRequest<ResponsableType>
    
    static func createApiList(baseUrl: String, endPoint: String, method: HTTPMethod, parameter: Parametable?, token:String?)-> ApiListRequest<ResponsableType>
    
    static func shouldProccess(response:[String:Any]?, error: Error?)-> (process:Bool, retry:Bool, token: String?)
    
    static func createRequest(baseUrl:String, endPoint:String, method:HTTPMethod, parameters:[String:Any]?, token:String?)
        -> DataRequest
    
    static func transformResponseObject(_ responseObject:AFDataResponse<Any>)-> (response:[String:Any]?, error:Error?)
}

public extension Apiable {
    static func createApi(baseUrl: String, endPoint: String, method: HTTPMethod, parameter: Parametable? = nil, token:String? = nil)-> ApiRequest<ResponsableType> {
        var handler: ApiRequest<ResponsableType>.Handler!
        
        // Validation
        let errorBag = parameter?.validate()
        guard errorBag == nil else {
            handler = {
                $1(nil, errorBag?.first)
                return nil
            }
            return ApiRequest<ResponsableType>.init(handler: handler)
        }
        
        
        // Request handler
        handler = { isVoid, completion in
            let dataRequest = createRequest(baseUrl: baseUrl, endPoint: endPoint, method: method, parameters: parameter?.toJSON(), token: token)
            let responseJSONHandler : ((_ response:[String:Any]?, _ error:Error?) -> Void) = { response, error  in
                guard error == nil else {
                    completion(nil, error!)
                    return
                }
                
                let wrongStructureError = NSError(code: .apiWrongStructure, description: "Wrong response structure".localized())
                guard response == nil
                    && isVoid else {
                        
                        // Response must not nil
                        guard let response = response else {
                            completion(nil, wrongStructureError)
                            return
                        }
                        
                        // Prefer get data inside `response`
                        var data = response
                        if let tmp = response["data"] as? [String:Any] {
                            data = tmp
                        }
                        
                        // Data have to be mapped
                        guard let info = ResponsableType.init(JSON:data) else {
                            completion(nil, wrongStructureError)
                            return
                        }
                        
                        // Success
                        completion(info, nil)
                        return
                }
                
                completion(nil, nil)
                return
            }
            
            dataRequest.responseJSON { (responseObject) in
                
                DispatchQueue.global().async {
                    let (response, error) = transformResponseObject(responseObject)
                    let (process, retry, token) = shouldProccess(response: response, error: error)
                    guard process else {
                        if retry {
                            let dataRequest = createRequest(baseUrl: baseUrl, endPoint: endPoint, method: method, parameters: parameter?.toJSON(), token: token)
                            dataRequest.responseJSON { (responseObject) in
                                let (response, error) = transformResponseObject(responseObject)
                                let (process, _, _) = shouldProccess(response: response, error: error)
                                guard process else { return }
                                
                                
                                DispatchQueue.main.async {
                                    responseJSONHandler(response, error)
                                }
                            }
                        }
                        
                        return
                    }
                    
                    DispatchQueue.main.async {
                        responseJSONHandler(response, error)
                    }
                }
                
            }
            
            return dataRequest
        }
        
        return ApiRequest<ResponsableType>.init(handler: handler)
    }
    
    static func createApiList(baseUrl: String, endPoint: String, method: HTTPMethod, parameter: Parametable? = nil, token:String? = nil)-> ApiListRequest<ResponsableType> {
        var handler: ApiListRequest<ResponsableType>.Handler!
        
        // Validation
        let errorBag = parameter?.validate()
        guard errorBag == nil else {
            handler = {
                $0(nil, errorBag?.first)
                return nil
            }
            return ApiListRequest<ResponsableType>.init(handler: handler)
        }
        
        
        // Request handler
        handler = { completion in
            let dataRequest = createRequest(baseUrl: baseUrl, endPoint: endPoint, method: method, parameters: parameter?.toJSON(), token: token)
            let responseJSONHandler : ((_ response:[String:Any]?, _ error:Error?) -> Void) = { response, error  in
                guard error == nil else {
                    completion(nil, error!)
                    return
                }
                
                
                guard response != nil else {
                    let error = NSError(code: .apiWrongStructure, description: "Wrong response structure".localized())
                    completion(nil, error)
                    return
                }
                
                let info = ResponseList<ResponsableType>.init(JSON:response!)
                completion(info!, nil)
            }
            
            dataRequest.responseJSON { (responseObject) in
                DispatchQueue.global().async {
                    let (response, error) = transformResponseObject(responseObject)
                    let (process, retry, token) = shouldProccess(response: response, error: error)
                    guard process else {
                        if retry {
                            let dataRequest = createRequest(baseUrl: baseUrl, endPoint: endPoint, method: method, parameters: parameter?.toJSON(), token: token)
                            dataRequest.responseJSON { (responseObject) in
                                let (response, error) = transformResponseObject(responseObject)
                                let (process, _, _) = shouldProccess(response: response, error: error)
                                guard process else { return }
                                
                                
                                DispatchQueue.main.async {
                                    responseJSONHandler(response, error)
                                }
                            }
                        }
                        
                        return
                    }
                    
                    DispatchQueue.main.async {
                        responseJSONHandler(response, error)
                    }
                }
                
            }
            
            return dataRequest
        }
        
        return ApiListRequest<ResponsableType>.init(handler: handler)
    }
    
    static func shouldProccess(response:[String:Any]?, error: Error?)-> (process:Bool, retry:Bool, token: String?) {
        return (process:true, retry:false, token:nil)
    }
}
