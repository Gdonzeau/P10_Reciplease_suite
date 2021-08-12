//
//  ViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 05/07/2021.
//
/*
import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var recipesStored = [Recipe]()
    let recipeCoreDataManager = RecipeCoreDataManager()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        //recipeEntity.deleteAll()
        do {
        recipesStored = try recipeCoreDataManager.loadRecipes()
        print("Nombre de recettes en mémoire : \(recipesStored.count)")
        } catch let myError {
            print(myError)
            print("Je n'ai pas réussi à charger les recettes.")
        }
        
        //let entityForTrain = try? recipeCoreDataManager.loadEntities()
        if let entityReceived = try? recipeCoreDataManager.loadEntities() {
        print(entityReceived.count)
        }
        
    }

 
}

*/
