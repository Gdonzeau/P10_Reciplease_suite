//
//  ReceipeListViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 12/07/2021.
//

import UIKit
import CoreData // Sorti des commentaires pour test

class RecipeListViewController: UIViewController {
    
    var ingredientsUsed = ""
    var parameters: Parameters = .favorites // By default
    var favoriteRecipes = [Recipe]() // To store recipes from Core Data
    var downloadedRecipes = [Recipe]()
    let recipeCoreDataManager = RecipeCoreDataManager()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var receipesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isHidden = true
        toggleActivityIndicator(shown: true)
        self.receipesTableView.rowHeight = 120.0
        whichImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.isHidden = true
        if parameters == .search {
            searchForRecipes(ingredients: ingredientsUsed)
        } else {
            // On charge les données depuis le CoreData
            do {
            let result = try recipeCoreDataManager.loadRecipes()
            print(result.count)
            //recipesStored = result
            favoriteRecipes = result
            
            toggleActivityIndicator(shown: false)
            
            //if recipesStored.count == 0 {
            if favoriteRecipes.count == 0 {
                imageView.isHidden = false
            }
 
            } catch {
                print("Erreur de chargement")
            }
        }
        receipesTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromCellToChoosenRecipe",
           let recipeChoosenVC = segue.destination as? RecipeChoosenViewController,
           let index = receipesTableView.indexPathForSelectedRow?.row {
            if parameters == .search {
                recipeChoosenVC.recipeChoosen = downloadedRecipes[index]
            } else {
                //recipeChoosenVC.recipeChoosen = recipesStored[index]
                recipeChoosenVC.recipeChoosen = favoriteRecipes[index]
            }
        }
    }
    private func whichImage() {
        if parameters == .search {
            imageView.image = UIImage(named: "noRecipe")
        } else {
            imageView.image = UIImage(named: "noFavorit")
        }
    }
    private func searchForRecipes(ingredients: String) { // Receiving recipes from API
        RecipesServices.shared.getRecipes(ingredients: ingredients) { (result) in
            switch result {
            case .success(let recipes) :
                self.toggleActivityIndicator(shown: false)
                self.savingAnswer(recipes:recipes)
                self.receipesTableView.reloadData()
                
            case .failure(let error) :
                print("KO")
                print(error.errorDescription as Any)
                let error = APIErrors.invalidStatusCode
                if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                    self.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                }
            }
        }
    }
    private func savingAnswer(recipes:(RecipeResponse)) { // Storing recipes received from API
        downloadedRecipes = [Recipe]() // initializing
        downloadedRecipes = recipes.recipes //{
        
        toggleActivityIndicator(shown: false)
    }
    
    private func convertFromCoreDataToUsable(recipe:RecipeStored)-> Recipe {
        let recette = Recipe(from: recipe)
        return recette
    }
 
    
    /*
    private func convertFromUsableToCoreData(recipeToSave: Recipe) -> RecipeStored {
        let recipeCoreData = RecipeStored(context: AppDelegate.viewContext)
        recipeCoreData.name = recipeToSave.name
        recipeCoreData.imageUrl = recipeToSave.imageURL
        recipeCoreData.url = recipeToSave.url
        recipeCoreData.person = recipeToSave.numberOfPeople
        recipeCoreData.totalTime = recipeToSave.duration
        recipeCoreData.ingredients = recipeToSave.ingredientsNeeded
        return recipeCoreData
    }
 */
    
    private func allErrors(errorMessage: String, errorTitle: String) {
        let alertVC = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        receipesTableView.isHidden = shown
        activityIndicator.isHidden = !shown
    }
}

extension RecipeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch parameters {
        case .search:
            if downloadedRecipes.count == 0 {
                imageView.isHidden = false
            } else {
                imageView.isHidden = true
            }
            return downloadedRecipes.count
        default:
            //print("Nombre de favoris : \(recipesStored.count)")
            print("Nombre de favoris : \(favoriteRecipes.count)")
            if favoriteRecipes.count == 0 {
            //if recipesStored.count == 0 {
                imageView.isHidden = false
            } else {
                imageView.isHidden = true
            }
            return favoriteRecipes.count
            //return recipesStored.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        var recipe = Recipe(from: RecipeStored(context: AppDelegate.viewContext)) // ???
        //var recipe = Recipe(from: RecipeStored(context: recipeCoreDataManager.shared.))
        if parameters == .search {
            recipe = downloadedRecipes[indexPath.row]
        } else {
            recipe = favoriteRecipes[indexPath.row]
            //recipe = recipesStored[indexPath.row]
        }
        
        let name = recipe.name
        var timeToPrepare = ""
        if recipe.duration > 0 {
            timeToPrepare = String(Int(recipe.duration))
        } else {
            timeToPrepare = "-"
        }
        let image = UIImageView()
        let person = recipe.numberOfPeople
        
        // Mettre des if au lieu des guard pour éviter le return et proposer une alternative par défaut
        guard let imageUrl = recipe.imageURL else { // There is a picture
            // Create a Default image
            cell.backgroundColor = UIColor.blue
            print("problème d'image")
            return UITableViewCell() // À améliorer...
        }
        guard let URLUnwrapped = URL(string: imageUrl) else {
            let error = APIErrors.noUrl
            if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
            }
            print("Lien internet mauvais")
            return UITableViewCell()
        }
        image.load(url: URLUnwrapped)
        cell.configure(timeToPrepare: timeToPrepare, name: name, person: person)
        cell.backgroundView = image
        cell.backgroundView?.contentMode = .scaleAspectFill
        return cell
    }
}

extension RecipeListViewController: UITableViewDelegate { // To delete cells one by one
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("On efface : \(indexPath.row)")
            if parameters == .search {
                downloadedRecipes.remove(at: indexPath.row)
            } else {
                do {
                    let recipes = try recipeCoreDataManager.loadRecipes()
                    
                    for object in recipes {
                        if object == favoriteRecipes[indexPath.row] {
                        //if object == recipesStored[indexPath.row] {
                            recipeCoreDataManager.deleteRecipe(recipeToDelete: object)
                        }
                    }
                } catch {
                    print("Je n'arriv pas à charger.")
                }
            }
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
}
