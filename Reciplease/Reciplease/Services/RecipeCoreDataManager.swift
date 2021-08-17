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
    
    func loadRecipes() throws -> [Recipe] { // throws retiré, mais à remettre
        //let request: NSFetchRequest<RecipeStored> = RecipeStored.fetchRequest()
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        let essai = RecipeEntity()
       // let essai2 = essai.ingredients
        /*
        var recipes = [Recipe]()
        guard let recipesReceived = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        for object in recipesReceived {
           // if let name = object.name { // Ici peut-être quelque chose ?
                let newRecipe = Recipe(from: object)
                recipes.append(newRecipe)
            //}
        }
        return recipes
        //let request: NSFetchRequest<RecipeEntity>
        */
        //var recipesStored: [RecipeStored]
        var recipesStored: [RecipeEntity]
        do {
            recipesStored = try viewContext.fetch(request)
            //print("Nous avons \(recipesStored.count)")
            print("Nous avons \(recipesStored.count)")
            
        } catch { throw error }

        /*
         let convertedArray = recipesEntities.map { (recipeEntity) -> Recipe in
         return Recipe(from: recipeEntity)
         }
         return convertedArray
         */
        return recipesStored.map { Recipe(from: $0) }
        
    }
    
    func saveRecipe(name: String, person: Float, totalTime: Float, url: String, imageUrl: String, ingredients: [String]) {
        print("Saving")
        let recipeToSave = RecipeEntity(context: AppDelegate.viewContext)
        recipeToSave.name = name
        recipeToSave.person = person
        recipeToSave.totalTime = totalTime
        recipeToSave.url = url
        recipeToSave.imageUrl = imageUrl
        
        // saving an array [String] to a Core Data (Binary Data) type
        // user is an instance of the User entity class
        do {
            recipeToSave.ingredients = try NSKeyedArchiver.archivedData(withRootObject: ingredients, requiringSecureCoding: true)
        } catch {
          print("failed to archive array with error: \(error)")
        }
        //recipeToSave.ingredients = ingredients
        try? AppDelegate.viewContext.save()
        
        /*
        let recipeToSave = RecipeStored(context: AppDelegate.viewContext)
        recipeToSave.name = name
        recipeToSave.person = person
        recipeToSave.totalTime = totalTime
        recipeToSave.url = url
        recipeToSave.imageUrl = imageUrl
        recipeToSave.ingredients = ingredients
        try? AppDelegate.viewContext.save()
 */
    }
    
    func deleteRecipe(recipeToDelete: Recipe) {
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
    func deleteAll() {
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
    
    private func convertFromUsableToCoreData(recipeToConvert: Recipe) -> RecipeEntity {
        let recipeConverted = RecipeEntity(context: AppDelegate.viewContext)
        
        //let name = recipeToConvert.name
        
        recipeConverted.name = recipeToConvert.name
        recipeConverted.imageUrl = recipeToConvert.imageURL
        recipeConverted.url = recipeToConvert.url
        recipeConverted.person = recipeToConvert.numberOfPeople
        recipeConverted.totalTime = recipeToConvert.duration
        
        do {
            recipeConverted.ingredients = try NSKeyedArchiver.archivedData(withRootObject: recipeToConvert.ingredientsNeeded, requiringSecureCoding: true)
        } catch {
          print("failed to archive array with error: \(error)")
        }
        //let hobbies = recipeToConvert.ingredientsNeeded {
        /*
          do {
            if let hobbiesArr = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: recipeToConvert.ingredientsNeeded) as? [String] {
              dump(hobbiesArr)
            }
          } catch {
            print("could not unarchive array: \(error)")
          }
        */
        //}
        
        //recipeConverted.ingredients = recipeToConvert.ingredientsNeeded
        return recipeConverted
    }
    /*
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
    */
}
