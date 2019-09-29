//
//  ApiSequence.swift
//  Base
//
//  Created by Mark G on 8/23/19.
//  Copyright © 2019 Mark G. All rights reserved.
//

class ApiSequence: NSObject {
    typealias Clouse = (()->())
    var forwardData: [Any]?
    var closure: Clouse!
    
//    convenience init(closure: @escaping Clouse) {
//        self.init()
//        self.closure = closure
//    }
//    
//    func then(sequence: ApiSequence, shouldForwardData: Bool = false) {
//        return ApiSequence {
//            
//        }
//    }
}
