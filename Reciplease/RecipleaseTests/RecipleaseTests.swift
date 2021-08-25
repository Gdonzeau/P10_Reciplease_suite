//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by Guillaume Donzeau on 05/07/2021.
//

import XCTest
import Alamofire
@testable import Reciplease

class RecipleaseTests: XCTestCase {
    var recipes: [Recipe] = []
    
    func testGet_If_() {
        //Given
        
        let sessionFake = UrlSessionMock()
        let ingredientsUsed = "Lemon"
        let recipeService = RecipesServices(session: sessionFake)
        //var session = Session(session: <#T##URLSession#>, delegate: <#T##SessionDelegate#>, rootQueue: <#T##DispatchQueue#>)
        
        // When
        recipeService.getRecipes(ingredients: ingredientsUsed) { [weak self] (result) in
            switch result {
            case .success(let recipeResponse) where recipeResponse.recipes.isEmpty:
                print("no result show empty")
                self?.viewState = .empty
            case .success(let recipeResponse):
                self?.recipes = recipeResponse.recipes
                self?.viewState = .showData
            case .failure(let error):
                print("Error loading recipes from API \(error.localizedDescription)")
                self?.viewState = .error
            // on peux remove
            //let error = APIErrors.invalidStatusCode
            // if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
            //    self?.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
            // }
            }
        }
        // Then
    }
    
    func testGetApiAlamoFireIf_() {
        let urlSession = MockUrlProtocol()
        
    }
}
/*
final class AuthenticationAPITest: XCTestCase {
    
    private var sut: AuthenticationAPIBis!
    
    override func setUp() {
        super.setUp()
        let manager: Session = {
        //let manager: SessionManager = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockUrlProtocol.self]
                return configuration
            }()
            return Session(configuration: configuration)
            //return SessionManager(configuration: configuration)
        }()
        sut = AuthenticationAPIBis(manager: manager)
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
    }
    
    func testStatusCode200ReturnsStatusCode200() {
        // given
        MockUrlProtocol.responseWithStatusCode(code: 200)
        
        let expectation = XCTestExpectation(description: "Performs a request")
        let ingredients = "carrots"
        // when
        
        sut.getRecipes(ingredients: ingredients) { [weak self] (result) in        //sut.login(username: "username", password: "password") { (result) in
            //XCTAssertEqual(result)
            //XCTAssertEqual(result.response?.statusCode, 200)
            print(result)
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 3)
    }
}
*/
