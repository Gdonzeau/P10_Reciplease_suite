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
        var data = Data()
        let bundle = Bundle(for: FakeResponseAPI.self)
        let url = bundle.url(forResource: "Recipes", withExtension: "json")
        do {
            if let apiUrl = url {
        data = try Data(contentsOf: apiUrl)
            
            }
        } catch {
            print("Problem tests API.")
        }
        return data
    }
    
    var recipeIncorrectData = "Erreur".data(using: .utf8)
}
