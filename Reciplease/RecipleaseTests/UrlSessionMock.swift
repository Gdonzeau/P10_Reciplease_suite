//
//  UrlSessionMock.swift
//  RecipleaseTests
//
//  Created by Guillaume Donzeau on 25/08/2021.
//

import Foundation
import Alamofire

class UrlSessionMock: Session {
    
    var data: Data?
    var error: Error?
    var result = Result<Data,AFError>.self
    
    init(data: Data, error: Error) {
        self.data = data
        self.error = error
    }
    
    //override func
}
