//
//  RestfulApiable.swift
//  AFDateHelper
//
//  Created by Mark G on 9/29/19.
//

import UIKit

public protocol RestfulApiable: Apiable {

    // Info
    static func info(id: Int, parameters: Parametable?, token:String?)-> ApiRequest<ObjectType>
    
    // Create
    static func create(parameters: Parametable?, token:String?)-> ApiRequest<ObjectType>
    
    // Update
    static func update(id: Int, parameters: Parametable?, token:String?)-> ApiRequest<ObjectType>
    
    // List
    static func list(parameters: Parametable?, token: String?)-> ApiListRequest<ListType>
}

public extension RestfulApiable {
    
    // Info
    static func info(id: Int, parameters: Parametable? = nil, token:String? = nil)-> ApiRequest<ObjectType> {
        return createApi(baseUrl: baseUrl, endPoint: "\(ObjectType.endPoint)/\(id)", method: .get, parameters: parameters, token: token)
    }

    // Create
    static func create(parameters: Parametable? = nil, token:String? = nil)-> ApiRequest<ObjectType> {
        return createApi(baseUrl: baseUrl, endPoint: ObjectType.endPoint, method: .get, parameters: parameters, token: token)
    }

    // Update
    static func update(id: Int, parameters: Parametable? = nil, token:String? = nil)-> ApiRequest<ObjectType> {
        return createApi(baseUrl: baseUrl, endPoint: "\(ObjectType.endPoint)/\(id)", method: .get, parameters: parameters, token: token)
    }
    
    
    // List
    static func list(parameters: Parametable? = nil, token: String? = nil)-> ApiListRequest<ListType> {
        return createApiList(baseUrl: baseUrl, endPoint: ObjectType.endPoint, method: .get, parameters: parameters, token: token)
    }
}
