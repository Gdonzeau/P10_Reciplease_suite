//
//  RecipeChoosenViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 14/07/2021.
//

import UIKit

class RecipeChoosenViewController: UIViewController {
    
    var recipeName = String()
    var ingredientList = String()
    var recipe: Recipe?
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
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareInformations()
        blogNameLabel.text = recipeName
        ingredientsList.text = ingredientList
        var urlImage = ""
        guard let recipeHere = recipe else {
            return
        }
        if let imageUrl = recipeHere.imageURL {
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
    func setupView() {
        isRecipeNotFavorite(answer: isRecipeNotAlreadyRegistred())
        favoriteOrNot.contentVerticalAlignment = .fill
        favoriteOrNot.contentHorizontalAlignment = .fill
    }
    private func saveOrDelete() {
        guard let recipeHere = recipe else {
            return
        }
        if isRecipeNotAlreadyRegistred() == true {
            favoriteOrNot.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                print("Let's save.")
                recipeCoreDataManager.saveRecipe(recipe: recipeHere)
        } else {
            favoriteOrNot.setImage(UIImage(systemName: "heart"), for: .normal)
            print("Let's delete.")
            recipeCoreDataManager.deleteRecipe(recipeToDelete: recipeHere)
        }
    }
    private func openUrl() {
        guard let recipeHere = recipe else {
            return
        }
        if let url = recipeHere.url {
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
        guard let recipeHere = recipe else {
            return
        }
        recipeName = recipeHere.name
        presentIngredients()
    }
    
    private func presentIngredients() {
        guard let recipeHere = recipe else {
            return
        }
        for index in 0 ..< recipeHere.ingredientsNeeded.count {
            ingredientList += "- "
            ingredientList += recipeHere.ingredientsNeeded[index]
            ingredientList += "\n"
        }
    }
    
    private func createRecipeObject(object:RecipeEntity) -> Recipe {
        let recipe = Recipe(from: object)
        return recipe
    }
    
    private func isRecipeNotAlreadyRegistred()-> Bool {
        guard let recipeHere = recipe else {
            return true
        }
        if let recipes = try? recipeCoreDataManager.loadRecipes() {
            recipesStored = recipes
        }
        if recipesStored.count == 0 {
            return true
        }
        if recipesStored.contains(recipeHere) {
            return false
        }
        
        return true
    }
    
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
