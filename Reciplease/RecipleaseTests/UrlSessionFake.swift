//
//  UrlSessionFake.swift
//  RecipleaseTests
//
//  Created by Guillaume Donzeau on 24/08/2021.
//

import Foundation

class UrlSessionFake: URLSession {
    var data: Data?
    var error: Error?
    var response : URLResponse?
    
    init(data: Data?, error: Error?, response: URLResponse?) {
        self.data = data
        self.error = error
        self.response = response
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake(completionHandler: completionHandler, data: data, response: response)
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake(completionHandler: completionHandler, data: data, response: response)
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }
}

class URLSessionDataTaskFake: URLSessionDataTask {
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var data:Data?
    var urlResponse: URLResponse?
    var responseError: Error?
    
    init(completionHandler: ((Data?, URLResponse?, Error?) -> Void)?, data:Data?, response: URLResponse?) {
        self.completionHandler = completionHandler
        self.data = data
        self.urlResponse = response
    }
    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }
    override func cancel() {}
}
