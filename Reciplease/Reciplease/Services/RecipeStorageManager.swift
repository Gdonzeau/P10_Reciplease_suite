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
    
    func loadRecipes() throws -> [Recipe] {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        var recipesStored: [RecipeEntity]
        do {
            recipesStored = try viewContext.fetch(request)
            
        } catch { throw error }
        /*
         let convertedArray = recipesEntities.map { (recipeEntity) -> Recipe in
         return Recipe(from: recipeEntity)
         }
         return convertedArray
         */
        return recipesStored.map { Recipe(from: $0) }
        
    }
    
    func saveRecipe(recipe: Recipe) {
        self.howMany()
        //print("Saving")
        let recipeToSave = RecipeEntity(context: AppDelegate.viewContext)
        //print("Model to save created.")
        recipeToSave.name = recipe.name
        //print("Name is \(String(describing: recipeToSave.name))")
        recipeToSave.person = recipe.numberOfPeople
        //print("Nb of pers. is \(String(describing: recipeToSave.person))")
        recipeToSave.totalTime = recipe.duration
        //print("Time is \(String(describing: recipeToSave.totalTime))")
        recipeToSave.url = recipe.url
        //print("Url is \(String(describing: recipeToSave.url))")
        recipeToSave.imageUrl = recipe.imageURL
        //print("Image's url is \(String(describing: recipeToSave.imageUrl))")
        recipeToSave.ingredients = try? JSONEncoder().encode(recipe.ingredientsNeeded)
        
        try? AppDelegate.viewContext.save()
    }
    
    func deleteRecipe(recipeToDelete: Recipe) {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            let response = try AppDelegate.viewContext.fetch(request)
            for recipe in response {
                if recipeToDelete == recipe { // Equatable adapted to compare different types
                    //print("\(String(describing: recipeToDelete.name)) est pareil que \(String(describing: recipe.name))")
                    AppDelegate.viewContext.delete(recipe)
                } else {
                    //print("\(String(describing: recipeToDelete.name)) est différent de \(String(describing: recipe.name))")
                }
            }
            try? AppDelegate.viewContext.save()
        } catch {
            print("Error while deleting")
            return
        }
    }
    
    // MARK: - Just while programming
    
    /// Will erase all entities in memory
    func deleteAll() {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            let response = try AppDelegate.viewContext.fetch(request)
            //print("Nous avons \(response.count) entités en mémoire")
            for recipe in response {
                AppDelegate.viewContext.delete(recipe)
            }
            try? AppDelegate.viewContext.save()
            
        } catch {
            print("Error while deleting")
            return
        }
    }
    /// Will return how many entities are in memory at this moment
    func howMany() {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            let response = try AppDelegate.viewContext.fetch(request)
            print("Nous avons \(response.count) entités en mémoire")
            
        } catch {
            print("Error while reading")
            return
        }
    }
}
