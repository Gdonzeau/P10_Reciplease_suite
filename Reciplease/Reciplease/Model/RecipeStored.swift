//
//  RecipeRegistred.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 17/07/2021.
//

import Foundation
import CoreData

class RecipeStored: NSManagedObject { // Le storage Service
    
    func loadRecipes() -> [RecipeStored] { // Ajouter throws
        
        let request: NSFetchRequest<RecipeStored> = RecipeStored.fetchRequest()
        var answer = [RecipeStored]()
        do {
            print("Loading")
            let response = try AppDelegate.viewContext.fetch(request) // response = total des données du CoreData
            for index in 0 ..< response.count { // En profiter pour tester l'état des réponses ?
                if response[index].name != nil {
                answer.append(response[index])
                }
            }
            return answer // Peut-être pas nécessaire. Juste retourner response ?
            //return response
        } catch {
            let error = APIErrors.noData // Peut-être pas API... mais juste Error
            print(error)
            //return error
            return [RecipeStored]()
        }
    }
    //func saveRecipe(recipeToSave: Recipe) {
        func saveRecipe() {
            /* Partie à faire en amont dans le contrôleur
        self.imageUrl = recipeToSave.imageURL
        self.ingredients = recipeToSave.ingredientsNeeded
        self.name = recipeToSave.name
        self.totalTime = recipeToSave.duration
        self.person = Float(Int(recipeToSave.numberOfPeople))
        self.url = recipeToSave.url
        */
            do {
        try AppDelegate.viewContext.save()
            } catch { // À traiter plus tard
                print("Oh non une erreur.")
            }
    }
    func deleteRecipe(recipeToDelete: RecipeStored) {
        /* À faire aussi en amont, dans le contrôleur
        let request: NSFetchRequest<RecipeStored> = RecipeStored.fetchRequest()
        do {
            let response = try AppDelegate.viewContext.fetch(request)
        } catch {
            print("Error while deleting")
            return
        }
        let recipe  = RecipeStored(context: AppDelegate.viewContext)
        
        recipe.imageUrl = recipeToDelete.imageURL
        recipe.ingredients = recipeToDelete.ingredientsNeeded
        recipe.name = recipeToDelete.name
        recipe.totalTime = recipeToDelete.duration
        recipe.person = Float(Int(recipeToDelete.numberOfPeople))
        recipe.url = recipeToDelete.url
        */
        AppDelegate.viewContext.delete(recipeToDelete)
        try? AppDelegate.viewContext.save()
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
}
/*
 
 init(persistentContainer: (UIApplication.shared.delegate as! AppDelegate).persistentContainer
 ViewContext = persistentContainer de ViewContext
 
 LoadRecipes -> tableau de recettes
 SaveRecipes
 DeleteRecipe
 
 
 */
