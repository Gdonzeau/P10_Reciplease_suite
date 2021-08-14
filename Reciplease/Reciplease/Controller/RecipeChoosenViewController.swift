//
//  RecipeChoosenViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 14/07/2021.
//

import UIKit
//import CoreData
//import WebKit

class RecipeChoosenViewController: UIViewController {
    
    var recipeName = String()
    var ingredientList = String()
    var recipesFromCoreData = RecipeStored(context: AppDelegate.viewContext)
    var recipeChoosen = Recipe(from: RecipeStored(context: AppDelegate.viewContext))
    var recipeEntity = RecipeStored(context: AppDelegate.viewContext)
    
    var recipesStored = [Recipe]()
    
    let recipeCoreDataManager = RecipeCoreDataManager()
    
    @IBOutlet weak var blogNameLabel: UILabel!
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var ingredientsList: UITextView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var favoriteOrNot: UIButton!
    @IBOutlet weak var newImageRecipe: UIView!
    @IBOutlet weak var infoView: InfoView!
    
    @IBAction func favoriteOrNotChange(_ sender: UIButton) {
        saveOrDelete()
    }
    
    @IBAction func getDirectionsButtonAction(_ sender: UIButton) {
        openUrl()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isRecipeNotFavorite(answer: isRecipeNotAlreadyRegistred())
        favoriteOrNot.contentVerticalAlignment = .fill
        favoriteOrNot.contentHorizontalAlignment = .fill
        // Pourquoi y avait-il ces lignes ci-dessous ?
        /*
        do {
        recipesStored = try recipeCoreDataManager.loadRecipes() // On charge les données du CoreData
        } catch {
            print("Erreur de chargement")
        }
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareInformations()
        blogNameLabel.text = recipeName
        ingredientsList.text = ingredientList
        var urlImage = ""
        // Remplacer par des if pour des valeurs par défaut ?
        if let imageUrl = recipeChoosen.imageURL {
            urlImage = imageUrl
        } else {
            let error = APIErrors.noImage
            if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
            }
        }
        if let imageUrlUnwrapped = URL(string: urlImage) {
            imageRecipe.load(url: imageUrlUnwrapped)
        } else {
            let error = APIErrors.noImage
            if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
            }
            imageRecipe.image = UIImage(named: "imageDefault") // No image, so Default image
        }
        
    }
    private func saveOrDelete() {
        if isRecipeNotAlreadyRegistred() == true {
            favoriteOrNot.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            if let recipeUrl = recipeChoosen.url, let recipeImageUrl = recipeChoosen.imageURL {
            recipeCoreDataManager.saveRecipe(name: recipeChoosen.name, person: recipeChoosen.numberOfPeople, totalTime: recipeChoosen.duration, url: recipeUrl, imageUrl: recipeImageUrl, ingredients: recipeChoosen.ingredientsNeeded)
            }
            //savingRecipe(recipeToSave: recipeChoosen)
            /*
            let recipeEntity = RecipeStored(context: AppDelegate.viewContext)
            recipeEntity.name = recipeChoosen.name
            
            recipeEntity.imageUrl = recipeChoosen.imageURL
            recipeEntity.url = recipeChoosen.url
            recipeEntity.person = recipeChoosen.numberOfPeople
            recipeEntity.totalTime = recipeChoosen.duration
            recipeEntity.ingredients = recipeChoosen.ingredientsNeeded
            */
            /*
            do {
                try? AppDelegate.viewContext.save()
            } //catch { // À traiter plus tard
            //  print("Oh une erreur.")
            // }
            */
            
            
        } else {
            favoriteOrNot.setImage(UIImage(systemName: "heart"), for: .normal)
            recipeCoreDataManager.deleteRecipe(recipeToDelete: recipeChoosen)
            //deleteRecipeFromCoreData()
        }
    }
    private func openUrl() {
        if let url = recipeChoosen.url {
            guard let urlAdress = URL(string: url) else {
                return
            }
            UIApplication.shared.open(urlAdress)
        } else {
            let error = APIErrors.noUrl
            if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
            }
            print("no url") // Ajouter un message d'erreur
        }
    }
    
    private func prepareInformations() {
        recipeName = recipeChoosen.name
        presentIngredients()
    }
    
    private func presentIngredients() {
        for index in 0 ..< recipeChoosen.ingredientsNeeded.count {
            ingredientList += "- "
            ingredientList += recipeChoosen.ingredientsNeeded[index]
            ingredientList += "\n"
        }
    }
    
    private func createRecipeObject(object:RecipeStored) -> Recipe {
        let recipe = Recipe(from: object)
        return recipe
    }
    
    private func isRecipeNotAlreadyRegistred()-> Bool {
        //if recipesFromCoreData.loadRecipes().count == 0 { // If there is no recipe in favorite
        // if RecipeStored.all.count == 0 {
        if recipesStored.count == 0 {
            return true
        }
        //for object in recipesFromCoreData.loadRecipes() {
        //for object in RecipeStored.all {
        for object in recipesStored {
            if object == recipeChoosen { // is the recipe on the View already favorit ?
                return false
            }
        }
        return true
    }
    /*
    private func savingRecipe(recipeToSave: Recipe) {
        recipeCoreDataManager.saveRecipe(recipeToSave: recipeToSave)
        //let recipeEntity = RecipeStored(context: AppDelegate.viewContext) //Appel du CoreDate RecipeService
        //let recipe = convertFromUsableToCoreData(recipeToSave: recipeToSave)
        /*
        recipeEntity.name = recipeToSave.name
        
        recipeEntity.imageUrl = recipeToSave.imageURL
        recipeEntity.url = recipeToSave.url
        recipeEntity.person = recipeToSave.numberOfPeople
        recipeEntity.totalTime = recipeToSave.duration
        recipeEntity.ingredients = recipeToSave.ingredientsNeeded
        
        do {
            try? AppDelegate.viewContext.save()
        } //catch { // À traiter plus tard
        //  print("Oh une erreur.")
        // }
        //recipeEntity.saveRecipe()
 */
    }
    */
    /*
    private func convertFromUsableToCoreData(recipeToSave: Recipe) -> RecipeStored {
        let recipeToStore = RecipeStored(context: AppDelegate.viewContext)
        recipeToStore.name = recipeToSave.name
        recipeToStore.imageUrl = recipeToSave.imageURL
        recipeToStore.url = recipeToSave.url
        recipeToStore.person = recipeToSave.numberOfPeople
        recipeToStore.totalTime = recipeToSave.duration
        recipeToStore.ingredients = recipeToSave.ingredientsNeeded
        return recipeToStore
    }
    */
    /*
    private func deleteRecipeFromCoreData() {
        // for object in recipesFromCoreData.loadRecipes() {
        //for object in RecipeStored.all {
        for object in recipesStored {
            if object == recipeChoosen {
                print("Trouvé, on efface")
                recipeCoreDataManager.deleteRecipe(recipeToDelete: object)
                try? AppDelegate.viewContext.save()
                return
            } else {
                print("Absent de la base de données") // At each step where it is not the  right recipe
            }
        }
    }
    */
    private func isRecipeNotFavorite(answer : Bool) {
        if answer == false {
            favoriteOrNot.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteOrNot.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    private func allErrors(errorMessage: String, errorTitle: String) {
        let alertVC = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
    
}
extension UIImageView { // Publishing the image
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            guard let image = UIImage(data:data) else {
                return
            }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
