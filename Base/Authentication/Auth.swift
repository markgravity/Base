//
//  VAAuth.swift
//  ValetAngels-swift
//
//  Created by Mark G on 11/29/17.
//  Copyright © 2017 Tomlar. All rights reserved.
//

import UIKit

public protocol AuthInterface {
    associatedtype UserModel: Responsable & Authenticatable
    
    var user: UserModel? { get set }
    var apiToken: String { get }
    var isAuthenticated: Bool { get }
    
    mutating func attemptLogin()-> Bool
    mutating func login(user:UserModel)
    mutating func update(user:UserModel)
    mutating func logout()
}


public extension AuthInterface {
    var apiToken : String {
        return user?.apiToken ?? ""
    }
    
    var isAuthenticated : Bool {
        return user != nil
    }
    
    fileprivate func getUser()-> Self.UserModel? {
        guard let data = UserDefaults.standard.object(forKey: "authenticated_user"),
            let user = Self.UserModel.init(JSON: data as! [String : Any]) else {
                return nil
        }
        
        return user
    }
    
    mutating func attemptLogin()-> Bool{
        guard let user = getUser() else {
            return false
        }
        
        self.user = user
        return true
    }
    
    mutating func login(user:Self.UserModel){
        self.user = user
        UserDefaults.standard.set(self.user!.toJSON(), forKey: "authenticated_user")
        UserDefaults.standard.synchronize()
    }
    
    mutating func update(user:Self.UserModel){
        let token = apiToken
        let refreshToken = self.user?.refreshToken
        self.user = user
        self.user!.apiToken = token
        self.user!.refreshToken = refreshToken
        
        UserDefaults.standard.set(user.toJSON(), forKey: "authenticated_user")
        UserDefaults.standard.synchronize()
    }
    
    mutating func logout(){
        self.user = nil
        UserDefaults.standard.removeObject(forKey: "authenticated_user")
        UserDefaults.standard.synchronize()
    }
}
