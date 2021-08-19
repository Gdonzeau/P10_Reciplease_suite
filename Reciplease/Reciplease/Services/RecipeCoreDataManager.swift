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
    
    func saveRecipe(recipe: Recipe) {
        self.howMany()
        print("Saving")
        let recipeToSave = RecipeEntity(context: AppDelegate.viewContext)
        print("Model to save created.")
        recipeToSave.name = recipe.name
        print("Name is \(String(describing: recipeToSave.name))")
        recipeToSave.person = recipe.numberOfPeople
        print("Nb of pers. is \(String(describing: recipeToSave.person))")
        recipeToSave.totalTime = recipe.duration
        print("Time is \(String(describing: recipeToSave.totalTime))")
        recipeToSave.url = recipe.url
        print("Url is \(String(describing: recipeToSave.url))")
        recipeToSave.imageUrl = recipe.imageURL
        print("Image's url is \(String(describing: recipeToSave.imageUrl))")
        
        // saving an array [String] to a Core Data (Binary Data) type
        do {
            recipeToSave.ingredients = try NSKeyedArchiver.archivedData(withRootObject: recipe.ingredientsNeeded, requiringSecureCoding: true)
            print("Ingredients are \(String(describing: recipeToSave.ingredients))")
        } catch {
          print("failed to archive array with error: \(error)")
        }
        try? AppDelegate.viewContext.save()
    }
    
    func deleteRecipe(recipeToDelete: Recipe) {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        let recipeCoreDataToDelete = convertFromUsableToCoreData(recipeToConvert: recipeToDelete)
        do {
            let response = try AppDelegate.viewContext.fetch(request)
            for recipe in response {
                if recipeCoreDataToDelete.name == recipe.name {
                    print("\(String(describing: recipeCoreDataToDelete.name)) est pareil que \(String(describing: recipe.name))")
                AppDelegate.viewContext.delete(recipe)
                } else {
                    print("\(String(describing: recipeCoreDataToDelete.name)) est différent de \(String(describing: recipe.name))")
                }
            }
            try? AppDelegate.viewContext.save()
        } catch {
            print("Error while deleting")
            return
        }
    }
    // On ne touche pas... Et on n'utilise pas
    func deleteAll() {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            let response = try AppDelegate.viewContext.fetch(request)
            print("Nous avons \(response.count) entités en mémoire")
            for recipe in response {
                AppDelegate.viewContext.delete(recipe)
            }
            try? AppDelegate.viewContext.save()
            
        } catch {
            print("Error while deleting")
            return
        }
    }
    
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
    
    private func convertFromUsableToCoreData(recipeToConvert: Recipe) -> RecipeEntity {
        let recipeConverted = RecipeEntity(context: AppDelegate.viewContext)
        
        recipeConverted.name = recipeToConvert.name
        recipeConverted.imageUrl = recipeToConvert.imageURL
        recipeConverted.url = recipeToConvert.url
        recipeConverted.person = recipeToConvert.numberOfPeople
        recipeConverted.totalTime = recipeToConvert.duration
        /*
        do {
            recipeConverted.ingredients = try NSKeyedArchiver.archivedData(withRootObject: recipeToConvert.ingredientsNeeded, requiringSecureCoding: true)
        } catch {
          print("failed to archive array with error: \(error)")
        }
        */
        let jsonData = try? JSONSerialization.data(withJSONObject: recipeToConvert.ingredientsNeeded, options: JSONSerialization.WritingOptions.prettyPrinted)
        recipeConverted.ingredients = jsonData
        /*
        let data = JSONSerialization.dataWithJSONObject(recipeToConvert.ingredientsNeeded, options: nil, error: nil)
        recipeConverted.ingredients = data
        recipeConverted.ingredients = Data?(recipeToConvert.ingredientsNeeded.utf8)
        do {
            if let ingredients = try JSONDecoder().decode(Data, from: recipeToConvert.ingredientsNeeded) {
                recipeConverted.ingredients = ingredients
            }
        } catch {
            print("failed to archive array with error: \(error)")
        }
        */
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
        
        return recipeConverted
    }
}
