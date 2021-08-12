//
//  RecipeCoreDataManager.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 10/08/2021.
//

import Foundation
import UIKit
import CoreData

class RecipeCoreDataManager {
    private let viewContext: NSManagedObjectContext
    static let shared = RecipeCoreDataManager()
    init(persistentContainer: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
        self.viewContext = persistentContainer.viewContext
    }
    // EntityTest
    func loadEntities() throws -> [EntityTest] {
        let request: NSFetchRequest<EntityTest> = EntityTest.fetchRequest()
        var entitiesTest = [EntityTest]()
        if let entitiesReceived = try? AppDelegate.viewContext.fetch(request) {
            for object in entitiesReceived {
                let newEntity = EntityTest(context: AppDelegate.viewContext)
                newEntity.name = object.name
                newEntity.invited = object.invited
                entitiesTest.append(newEntity)
            }
        }
        return entitiesTest
    }
    func saveEntities() {
        
    }
    
    /*
     func loadRecipes() -> [RecipeStored] {
     
     let request: NSFetchRequest<RecipeStored> = RecipeStored.fetchRequest()
     
     do {
     let storedRecipes = try viewContext.fetch(request)
     return storedRecipes
     } catch {
     return []
     }
     }
     */
    func loadRecipes() throws -> [Recipe] {
        let request: NSFetchRequest<RecipeStored> = RecipeStored.fetchRequest()
        let recipesEntities:[RecipeStored]
        
        //let request: NSFetchRequest<RecipeEntity>
        
        do {
            recipesEntities = try viewContext.fetch(request)
            print("Nous avons \(recipesEntities.count)")
            
        } catch let myError {
            throw myError
        }
        /*
         let convertedArray = recipesEntities.map { (recipeEntity) -> Recipe in
         return Recipe(from: recipeEntity)
         }
         return convertedArray
         */
        return recipesEntities.map { Recipe(from: $0) }
        
    }
    
    //func saveRecipe(recipeToSave: Recipe) {
    func saveRecipe(recipeToSave: Recipe) { // Comme loadRecipes
        //let recipe = convertFromUsableToCoreData(recipeToConvert: recipeToSave)
        /* Partie à faire en amont dans le contrôleur
         */
        print(recipeToSave.name)
        let recipe = convertFromUsableToCoreData(recipeToConvert: recipeToSave)
        /*
         //let recipe = RecipeStored()
         recipe.imageUrl = recipeToSave.imageURL
         recipe.ingredients = recipeToSave.ingredientsNeeded
         recipe.name = recipeToSave.name
         recipe.totalTime = recipeToSave.duration
         recipe.person = Float(Int(recipeToSave.numberOfPeople))
         recipe.url = recipeToSave.url
         */
        //print(recipe.name)
        do {
            try viewContext.save()
        } catch { // À traiter plus tard
            print("Oh non une erreur.")
        }
    }
    
    func deleteRecipe(recipeToDelete: Recipe) {
        let recipeToDeleteConverted = convertFromUsableToCoreData(recipeToConvert: recipeToDelete)
        viewContext.delete(recipeToDeleteConverted)
        try? viewContext.save()
    }
    // On ne touche pas... Et on n'utilise pas
    func deleteAll() {
        let request: NSFetchRequest<RecipeStored> = RecipeStored.fetchRequest()
        do {
            let response = try viewContext.fetch(request)
            
            for recipe in response {
                viewContext.delete(recipe)
            }
            try? viewContext.save()
            
        } catch {
            print("Error while deleting")
            return
        }
    }
    
    private func convertFromUsableToCoreData(recipeToConvert: Recipe) -> RecipeStored {
        let recipeConverted = RecipeStored(context: AppDelegate.viewContext)
        
        let name = recipeToConvert.name
        
        recipeConverted.name = name
        recipeConverted.imageUrl = recipeToConvert.imageURL
        recipeConverted.url = recipeToConvert.url
        recipeConverted.person = recipeToConvert.numberOfPeople
        recipeConverted.totalTime = recipeToConvert.duration
        recipeConverted.ingredients = recipeToConvert.ingredientsNeeded
        return recipeConverted
    }
    
}
