//
//  FakeResponseAPI.swift
//  RecipleaseTests
//
//  Created by Guillaume Donzeau on 24/08/2021.
//

import Foundation

class FakeResponseAPI {
    class RecipeError: Error {}
    var error = RecipeError()
    
    var recipeCorrectData: Data {
        let bundle = Bundle(for: FakeResponseAPI.self)
        let url = bundle.url(forResource: "Recipes", withExtension: "json")
        do {
            if let apiUrl = url {
        let data = try Data(contentsOf: apiUrl)
            return data
            }
        } catch {
            print("Problem tests API.")
        }
    }
    
    var recipeIncorrectData = "Erreur".data(using: .utf8)
}
