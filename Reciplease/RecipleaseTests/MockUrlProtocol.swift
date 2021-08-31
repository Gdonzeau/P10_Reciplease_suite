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
        
    }
}
