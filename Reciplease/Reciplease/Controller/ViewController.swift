//
//  ViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 05/07/2021.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
   
    
    var recipesStored = [RecipeStored]()
    
    
    let recipeCoreDataManager = RecipeCoreDataManager()
 
    //var recipeFromCoreData = RecipeEntity(context: AppDelegate.viewContext)
    //var basicRecipe = Recipe(from: RecipeStored()) //Recette de base, vide
    override func viewDidLoad() {
        super.viewDidLoad()
        //recipeEntity.deleteAll()
        recipesStored = recipeCoreDataManager.loadRecipes()
        print("Nombre de recettes en mémoire : \(recipesStored.count)")
        
    }

 
}

