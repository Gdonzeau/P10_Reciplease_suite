//
//  RecipeCoreDataManager.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 10/08/2021.
//

//import Foundation
import UIKit
import CoreData

class RecipeCoreDataManager {
    private let viewContext: NSManagedObjectContext
    public static let modelName = "Storage Recipes"
    
    static let shared = RecipeCoreDataManager()
    
    init(persistentContainer: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
        self.viewContext = persistentContainer.viewContext
    }

    func loadRecipes() throws -> [Recipe] {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        var recipesStored: [RecipeEntity]
        do {
            recipesStored = try viewContext.fetch(request)
        } catch { throw error }
        
        return recipesStored.map { Recipe(from: $0) }
    }
    
    func saveRecipe(recipe: Recipe) throws { // ajouter throws
        let recipeToSave = RecipeEntity(context: viewContext)
        recipeToSave.name = recipe.name
        recipeToSave.person = recipe.numberOfPeople
        recipeToSave.totalTime = recipe.duration
        recipeToSave.url = recipe.url
        recipeToSave.imageUrl = recipe.imageURL
        recipeToSave.ingredients = try? JSONEncoder().encode(recipe.ingredientsNeeded)
        
        do {
            try viewContext.save()
       // } catch {  throw error }
        } catch { print("Error \(error)") ; throw error }
    }
    
    func deleteRecipe(recipeToDelete: Recipe) throws { // ajout throws
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            let response = try viewContext.fetch(request)
            for recipe in response {
                if recipeToDelete == recipe { // Equatable adapted to compare different types
                    viewContext.delete(recipe)
                }
            }
            try viewContext.save()
        } catch { print("Error while deleting : \(error)") ; throw error } // Pas sûr
    }
}
