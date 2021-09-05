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
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Reciplease")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //static let shared = RecipeCoreDataManager(persistentContainer: persistentContainer)
    static let shared = RecipeCoreDataManager()
    
    
    init(persistentContainer: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
    //init(persistentContainer: NSPersistentContainer) { // = persistentContainer) {
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
    
    func saveRecipe(recipe: Recipe) { // ajouter throws
        self.howMany()
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
        } catch {
                print("Error \(error)")
            }
        //try? AppDelegate.viewContext.save()
    }
    
    func deleteRecipe(recipeToDelete: Recipe) { // ajout throws
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            let response = try viewContext.fetch(request)
            for recipe in response {
                if recipeToDelete == recipe { // Equatable adapted to compare different types
                    //print("\(String(describing: recipeToDelete.name)) est pareil que \(String(describing: recipe.name))")
                    viewContext.delete(recipe)
                } else {
                    //print("\(String(describing: recipeToDelete.name)) est différent de \(String(describing: recipe.name))")
                }
            }
            try? viewContext.save()
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
            let response = try viewContext.fetch(request)
            //print("Nous avons \(response.count) entités en mémoire")
            for recipe in response {
                viewContext.delete(recipe)
            }
            try? viewContext.save()
            
        } catch {
            print("Error while deleting")
            return
        }
    }
    /// Will return how many entities are in memory at this moment
    func howMany() {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            let response = try viewContext.fetch(request)
            print("Nous avons \(response.count) entités en mémoire")
            
        } catch {
            print("Error while reading")
            return
        }
    }
}
