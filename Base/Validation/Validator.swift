//
//  Validator.swift
//  iOSBaseProject
//
//  Created by Mark G on 8/12/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit

infix operator <~

public func <~ <T> (left:T, right:Validator){
    right.validate(value: left)
}

public class Validator {
    fileprivate var currentRules = [ValidationRule]()
    fileprivate var currentName : String!
    
    fileprivate static var defaultMessages : [ValidationMessage]?
    var customMessages : [ValidationAttribute : String]?
    
    var errorBag = ErrorBag()
    
    init(){
        if Validator.defaultMessages == nil {
            loadDefaultMessages()
        }
    }
    
    public subscript(name: String, rules: ValidationRule...)-> Validator {
        currentRules = rules
        currentName = name
        
        
        return self
    }
    
    func validate<T>(value:T){
        for rule in currentRules {
            
            var error : Error?
            switch rule {
            case .required:
                error = validateRequiredRule(value: value)
                
            case .min(let min):
                error = validateMinRule(value: value, min: min)
                
            case .max(let max):
                error = validateMaxRule(value: value, max: max)
                
            case .confirmed(let other):
                error = validateConfirmedRule(value: value, otherValue: other as! T)
            }
            
            
            
            guard error != nil else { continue }
            errorBag.add(name:currentName, error: error!)
        }
    }
    
    fileprivate func loadDefaultMessages(){
        Validator.defaultMessages = [ValidationMessage]()
        let defaultPath = Bundle(for: type(of: self)).url(forResource: "Validation", withExtension: "plist")
        guard var defaultValMessages = NSDictionary.init(contentsOf: defaultPath!) as? [String:Any] else {
            
            return
        }
        
        if let customDefaultValPath = BaseConfigure.ValidationURL,
            let customDefaultValMessages = NSDictionary.init(contentsOf: customDefaultValPath) as? [String:Any]{
            defaultValMessages.merge(with: customDefaultValMessages)
        }
        
        for (key,value) in defaultValMessages {
            let rule = ValidationRule.init(rawValue: key)!
            
            if let message = value as? String {
                Validator.defaultMessages?.append(ValidationMessage.init(rule: rule, message: message))
            } else if let dict = value as? [String:Any] {
                
                var messages = [ValidationValueType:String]()
                for (dictK, dictV) in dict {
                    let valueType = ValidationValueType.init(rawValue: dictK)!
                    messages[valueType] = (dictV as! String)
                }
                
                Validator.defaultMessages?.append(ValidationMessage.init(rule: rule, messages: messages))
            }
        }
    }
    
    fileprivate func validateRequiredRule<T>(value:T)-> Error?{
        let message = messageForRule(.required, valueType: getValueType(value: value))
        let error = NSError(code: .validation, description: message)
        
        guard isEmpty(value: value) else {
            return nil
        }
        
        return error
    }
    
    fileprivate func validateMinRule<T>(value:T, min:CGFloat)-> Error? {
        guard !isEmpty(value: value) else { return nil }
        
        let valueType = getValueType(value: value)
        let message = messageForRule(.min(min), valueType: valueType)
        var errorInfo = NSError(code: .validation, description: message)
        
        var hasError = true
        switch valueType {
        case .string:
            hasError = (value as! String).count < Int(min)
            
        case .numeric:
            
            var numeric: CGFloat!
            if value is Int {
                numeric = CGFloat(value as! Int)
            } else if value is Double {
                numeric = CGFloat(value as! Double)
            } else if value is Float {
                numeric = CGFloat(value as! Float)
            }
            
            hasError = numeric < min
            
        case .array:
            hasError = (value as! Array<Any>).count < Int(min)
        default:
            break
        }
    
        guard !hasError else {
            return errorInfo
        }
        
        return nil
    }
    
    fileprivate func validateMaxRule<T>(value:T, max:CGFloat)-> Error? {
        guard !isEmpty(value: value) else { return nil }
        
        let valueType = getValueType(value: value)
        let message = messageForRule(.max(max), valueType: valueType)
        let errorInfo = NSError(code: .validation, description: message)
        
        var hasError = true
        
        switch valueType {
        case .string:
            hasError = (value as! String).count > Int(max)
            
        case .numeric:
            
            var numeric: CGFloat!
            if value is Int {
                numeric = CGFloat(value as! Int)
            } else if value is Double {
                numeric = CGFloat(value as! Double)
            } else if value is Float {
                numeric = CGFloat(value as! Float)
            }
            
            hasError = numeric > max
            
        case .array:
            hasError = (value as! Array<Any>).count > Int(max)
        default:
            break
        }
        
        guard !hasError else {
            return errorInfo
        }
        
        return nil
    }
    
    fileprivate func validateConfirmedRule<T>(value:T, otherValue:T)-> Error? {
        let valueType = getValueType(value: value)
        let message = messageForRule(.confirmed(otherValue), valueType: valueType)
        let error = NSError(code: .validation, description: message)
        
        var hasError = true
        switch valueType {
        case .string:
            hasError = (value as! String) != (otherValue as! String)
            
        case .numeric:
            
            var numeric: CGFloat!
            var otherNumeric: CGFloat!
            
            if value is Int {
                numeric = CGFloat(value as! Int)
                otherNumeric = CGFloat(otherValue as! Int)
            } else if value is Double {
                numeric = CGFloat(value as! Double)
                otherNumeric = CGFloat(otherValue as! Double)
            } else if value is Float {
                numeric = CGFloat(value as! Float)
                otherNumeric = CGFloat(otherValue as! Float)
            }
            
            hasError = numeric == otherNumeric
            
        default:
            break
        }
        
        guard !hasError else {
            return error
        }
        
        return nil
    }
    
    fileprivate func messageForRule(_ rule:ValidationRule, valueType: ValidationValueType)-> String{
        
        if let message = customMessages?
            .first(where: { $0.key.name == currentName && $0.key.rule == rule })
            .map({ $0.value }){
            return message
        }
        
        let message = Validator.defaultMessages!.first(where: { $0.rule == rule})!
            .messages[valueType]!
        
        switch rule {
        case .required:
            return String.init(format: message, currentName)
            
        case .min(let min):
            return String.init(format: message, currentName, valueType == .string ? "\(Int(min))" : "\(min)")
            
        case .max(let max):
            return String.init(format: message, currentName, valueType == .string ? "\(Int(max))" : "\(max)")
            
        case .confirmed(_):
            return String.init(format: message, currentName)
        }
    }
    
    fileprivate func isEmpty<T>(value:T)-> Bool {
        if let string = value as? String {
            return string.count == 0
        }  else if let array = value as? Array<Any> {
            return array.count == 0
        }
        
        return "\(value)" == "nil"
    }
    
    fileprivate func getValueType<T>(value:T)-> ValidationValueType{
        let typeString = "\(T.self)"
        if typeString.contains("<String>") {
            return .string
        } else if typeString.contains("<Array") {
            return .array
        } else if typeString.contains("<Double>")
            || typeString.contains("<Int>")
            || typeString.contains("<Float>") {
            return .numeric
        }
        
        print(value, "\(T.self)", value is Int)
        return .other
    }
}
