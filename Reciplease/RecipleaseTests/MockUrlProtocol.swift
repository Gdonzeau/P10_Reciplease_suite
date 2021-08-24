//
//  MockUrlProtocol.swift
//  RecipleaseTests
//
//  Created by Guillaume Donzeau on 22/08/2021.
//
import XCTest
import Foundation

final class MockUrlProtocol: URLProtocol {
    
    static var error: Error?
    static var data: Data?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockUrlProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        guard let data = MockUrlProtocol.data else {
            XCTFail("Missing datas")
            return
        }
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
        
    }
    
    override func stopLoading() {
        //activeTask?.cancel()
    }
    
}

extension MockUrlProtocol: URLSessionDataDelegate {
    
    enum ResponseType {
        case error(Error)
        case success(HTTPURLResponse)
    }
    
    static var responseType: ResponseType!
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        switch MockUrlProtocol.responseType {
        case .error(let error)?:
            client?.urlProtocol(self, didFailWithError: error)
        case .success(let response)?:
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        default:
            break
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
}

extension MockUrlProtocol {
    
    enum MockError: Error {
        case none
    }
    
    static func responseWithFailure() {
        MockUrlProtocol.responseType = MockUrlProtocol.ResponseType.error(MockError.none)
    }
    
    static func responseWithStatusCode(code: Int) {
        MockUrlProtocol.responseType = MockUrlProtocol.ResponseType.success(HTTPURLResponse(url: URL(string: "http://any.com")!, statusCode: code, httpVersion: nil, headerFields: nil)!)
    }
}

