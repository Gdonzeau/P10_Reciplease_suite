//
//  UrlSessionMock.swift
//  RecipleaseTests
//
//  Created by Guillaume Donzeau on 25/08/2021.
//

import Foundation
import Alamofire

class UrlSessionMock: Session {
    var result: Result<Data?,AFError>
    var data: Data?
    var error: Error?
    init(result: Result<Data?,AFError>) {
        super.init()
        self.result = result
    }
}
