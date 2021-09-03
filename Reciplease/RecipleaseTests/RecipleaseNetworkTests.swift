//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by Guillaume Donzeau on 05/07/2021.
//

import XCTest
import Alamofire
@testable import Reciplease

class RecipleaseNetworkTests: XCTestCase {
    
    var recipeService: RecipesServices!
    
    override func setUp() {
        let urlSessionConfigTest = URLSessionConfiguration.default
        urlSessionConfigTest.protocolClasses = [MockUrlProtocol.self]
        let sessionTest = Session(configuration: urlSessionConfigTest)
        recipeService = RecipesServices(session: sessionTest)
    }
    override func tearDown() {
        MockUrlProtocol.data = nil
        MockUrlProtocol.error = nil
    }
    func testSuccess() {
        let expectation = XCTestExpectation(description: "recipe success")
        MockUrlProtocol.data = FakeResponse.recipeCorrectData
        recipeService.getRecipes(ingredients: "Lemon") { (result) in
            guard case .success(let recipeResponse) = result else {
                XCTFail("Missing datas")
                return
            }
            XCTAssertNotNil(recipeResponse)
            let recipe = try? XCTUnwrap(recipeResponse.recipes.first)
            XCTAssertEqual(recipe?.name, "Lemon Icey") // XCTAssertEqual
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testError() {
        let expectation = XCTestExpectation(description: "recipe error")
       // MockUrlProtocol.data = FakeResponse.recipeIncorrectData
        MockUrlProtocol.error = AFError.explicitlyCancelled
        
        recipeService.getRecipes(ingredients: "Lemon") { (result) in
            guard case .failure(let error) = result else {
                XCTFail("Datas correctly returned")
                return
            }
            
            XCTAssertNotNil(error)
            /*
            let error = try? XCTUnwrap(recipeResponse.asAFError)
            XCTAssertTrue(error?.errorDescription == "Response could not be decoded because of error:\nThe data couldn’t be read because it isn’t in the correct format.")
            */
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
}
