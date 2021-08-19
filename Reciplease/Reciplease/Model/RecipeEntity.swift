//
//  RecipeEntity.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 16/08/2021.
//

import Foundation
import CoreData

extension RecipeEntity {
    
    //@NSManaged public var ingredients: Data?
    @NSManaged public var ingredient: String
    
    var ingredientArray : [String] {
        get {
            let data = Data(ingredient.utf8)
            return (try? JSONDecoder().decode([String].self, from: data)) ?? []
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue), let string = String(data: data, encoding: .utf8) else {
                ingredient = ""
                return
            }
            ingredient = string
        }
    }
    
}
