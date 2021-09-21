//
//  FakeResponseAPI.swift
//  RecipleaseTests
//
//  Created by Guillaume Donzeau on 24/08/2021.
//

import Foundation
@testable import Reciplease

class FakeResponse {
    class RecipeError: Error {}
    var error = RecipeError()
    
    static var recipeCorrectData: Data {
        let bundle = Bundle(for: FakeResponse.self)
        let url = bundle.url(forResource: "Recipes", withExtension: "json")!
        return try!  Data(contentsOf: url)
    }
    
    static var recipes: [Recipe] {
        let recipeResponse = try! JSONDecoder().decode(RecipeResponse.self, from: recipeCorrectData)
        return recipeResponse.recipes
    }
    
    static var recipeIncorrectData = "Erreur".data(using: .utf8) // delete
}
