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
    static let shared = RecipeCoreDataManager()
    init(persistentContainer: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
        self.viewContext = persistentContainer.viewContext
    }
    static var all:[RecipeStored] {
        let request: NSFetchRequest<RecipeStored> = RecipeStored.fetchRequest()
        guard let recipes = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return recipes
    }
    static func loadRecipes() -> [Recipe] { // throws retiré, mais à remettre
        let request: NSFetchRequest<RecipeStored> = RecipeStored.fetchRequest()
        var recipesEntities = [Recipe]()
        guard let recipesReceived = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        for object in recipesReceived {
           // if let name = object.name {
                let newRecipe = Recipe(from: object)
                recipesEntities.append(newRecipe)
            //}
        }
        return recipesEntities
        //let request: NSFetchRequest<RecipeEntity>
        /*
        do {
            recipesEntities = try viewContext.fetch(request)
            print("Nous avons \(recipesEntities.count)")
            
        } catch let myError {
            throw myError
        }
 */
        /*
         let convertedArray = recipesEntities.map { (recipeEntity) -> Recipe in
         return Recipe(from: recipeEntity)
         }
         return convertedArray
         */
        //return recipesEntities.map { Recipe(from: $0) }
        
    }
    
    static func saveRecipe(name: String, person: Float, totalTime: Float, url: String, imageUrl: String, ingredients: [String]) {
        print("Saving")
        let recipeToSave = RecipeStored(context: AppDelegate.viewContext)
        recipeToSave.name = name
        recipeToSave.person = person
        recipeToSave.totalTime = totalTime
        recipeToSave.url = url
        recipeToSave.imageUrl = imageUrl
        recipeToSave.ingredients = ingredients
        try? AppDelegate.viewContext.save()
    }
    
    static func deleteRecipe(recipeToDelete: Recipe) {
        let request: NSFetchRequest<RecipeStored> = RecipeStored.fetchRequest()
        let recipeCoreDataToDelete = convertFromUsableToCoreData(recipeToConvert: recipeToDelete)
        do {
            let response = try AppDelegate.viewContext.fetch(request)
            for recipe in response {
                //if recipe.name == entityToDeleteConverted.name && recipe.invited == entityToDeleteConverted.invited {
                if recipeCoreDataToDelete == recipe {
                //viewContext.delete(recipe)
                AppDelegate.viewContext.delete(recipe)
                    try? AppDelegate.viewContext.save()
                }
            }
        } catch {
            print("Error while deleting")
            return
        }
        //AppDelegate.viewContext.delete(entityToDeleteConverted)
        //try? viewContext.save()
    }
    // On ne touche pas... Et on n'utilise pas
    static func deleteAll() {
        let request: NSFetchRequest<RecipeStored> = RecipeStored.fetchRequest()
        do {
            let response = try AppDelegate.viewContext.fetch(request)
            
            for recipe in response {
                AppDelegate.viewContext.delete(recipe)
            }
            try? AppDelegate.viewContext.save()
            
        } catch {
            print("Error while deleting")
            return
        }
    }
    
    static private func convertFromUsableToCoreData(recipeToConvert: Recipe) -> RecipeStored {
        let recipeConverted = RecipeStored(context: AppDelegate.viewContext)
        
        //let name = recipeToConvert.name
        
        recipeConverted.name = recipeToConvert.name
        recipeConverted.imageUrl = recipeToConvert.imageURL
        recipeConverted.url = recipeToConvert.url
        recipeConverted.person = recipeToConvert.numberOfPeople
        recipeConverted.totalTime = recipeToConvert.duration
        recipeConverted.ingredients = recipeToConvert.ingredientsNeeded
        return recipeConverted
    }
    
}
