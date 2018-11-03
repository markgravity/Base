//
//  ViewController.swift
//  Example
//
//  Created by Mark G on 10/25/18.
//  Copyright © 2018 Mark G. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import RxSwift
import Base
import RxCocoa

class Book: Responsable {
    required init?(map: Map) {
        
    }
    
    static var endPoint: String = ""
    var id: Int?
    
    func mapping(map: Map) {
        id <- map["id"]
    }
}
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

