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
       // var data = Data()
        let bundle = Bundle(for: FakeResponse.self)
        let url = bundle.url(forResource: "Recipes", withExtension: "json")!
        return try!  Data(contentsOf: url)
        /*
        do {
            if let apiUrl = url {
        data = try Data(contentsOf: apiUrl)
            
            }
        } catch {
            print("Problem tests API.")
        }
        return data
        */
    }
    
    static var recipes: [Recipe] {
        let recipeResponse = try! JSONDecoder().decode(RecipeResponse.self, from: recipeCorrectData)
        return recipeResponse.recipes
    }
    
    static var recipeIncorrectData = "Erreur".data(using: .utf8) // delete
    /*
    static var recipe: RecipeEntity {
        let recipeEntityOne = RecipeEntity(context: context)
        recipeEntityOne.name = "Chicken"
        recipeEntityOne.imageUrl = "www.image.com"
        recipeEntityOne.url = "www.url.com"
        recipeEntityOne.person = 1.00
        recipeEntityOne.totalTime = 36.0
        recipeEntityOne.ingredients = try? JSONEncoder().encode(["Chicken","Salt"])
    }
    */
    
    
}
