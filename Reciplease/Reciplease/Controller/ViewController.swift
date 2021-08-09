//
//  ViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 05/07/2021.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var recipeEntity = RecipeStored(context: AppDelegate.viewContext)
    
    var recipesStored = [RecipeStored]()
 
    //var recipeFromCoreData = RecipeEntity(context: AppDelegate.viewContext)
    //var basicRecipe = Recipe(from: RecipeStored()) //Recette de base, vide
    override func viewDidLoad() {
        super.viewDidLoad()
        recipesStored = recipeEntity.loadRecipes()
        print("Nombre de recettes en mémoire : \(recipesStored.count)")
        /*
        let recipeEntity = RecipeStored(context: AppDelegate.viewContext)
        let recipesStored = recipeEntity.loadRecipes()
        test2(recipesStored:recipesStored)
        //print("Nombre de favoris : \(RecipeStored.all.count)")
        print("Nombre de favoris : \(recipesStored.count)")
        //recipeFromCoreData.deleteAll()
        */
    }
    
    func test2(recipesStored:[RecipeStored]) {
        //if recipeFromCoreData.loadRecipes().count > 0 {
        if recipesStored.count > 0 { 
        //if RecipeStored.all.count > 0 {
            //let recipeEntity = recipeFromCoreData.loadRecipes()[0]
            //let recipeEntity = RecipeStored.all[0]
            let recipeEntity = recipesStored[0]
            let recipe = Recipe(from: recipeEntity)
            print (recipe.name)
        }
    }
 
}

