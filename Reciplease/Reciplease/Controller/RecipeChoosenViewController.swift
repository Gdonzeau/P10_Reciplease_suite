//
//  RecipeChoosenViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 14/07/2021.
//

import UIKit
import SafariServices

class RecipeChoosenViewController: UIViewController {
    
    var recipeName = String()
    var ingredientList = String()
    var recipe: Recipe?
    var recipesStored = [Recipe]()
    
    let recipeCoreDataManager = RecipeCoreDataManager.shared
    
    @IBOutlet weak var blogNameLabel: UILabel!
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var ingredientsList: UITextView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var favoriteOrNot: UIButton!
    @IBOutlet weak var newImageRecipe: UIView!
    
    private var stackViewInfo = StackViewInfo()
    
    @IBAction func changeFavoriteStatus(_ sender: UIButton) {
        do {
        try saveOrDelete()
        } catch {
            print("Error CoreData")
            let error = AppError.coreDataError
            if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
            }
        }
    }
    
    @IBAction func getDirectionsButtonAction(_ sender: UIButton) {
        openUrl()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        setupView()
        setConstraints()
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
            let error = AppError.noImage
            if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
            }
        }
        if let imageUrlUnwrapped = URL(string: urlImage) {
            imageRecipe.load(url: imageUrlUnwrapped)
        } else {
            let error = AppError.noImage
            if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
            }
            imageRecipe.image = UIImage(named: "imageDefault") // No image, so Default image
        }
    }
    private func setupView() {
        print("Go")
        isRecipeNotFavorite(answer: isRecipeNotAlreadyRegistred())
        favoriteOrNot.contentVerticalAlignment = .fill
        favoriteOrNot.contentHorizontalAlignment = .fill
        favoriteOrNot.tintColor = .red
        
        stackViewInfo.duration = recipe?.duration
        stackViewInfo.persons = recipe?.numberOfPeople
        stackViewInfo.translatesAutoresizingMaskIntoConstraints = false
        
        imageRecipe.addSubview(stackViewInfo)
    }
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackViewInfo.topAnchor.constraint(equalToSystemSpacingBelow: imageRecipe.topAnchor, multiplier: 1.5),
            imageRecipe.trailingAnchor.constraint(equalToSystemSpacingAfter: stackViewInfo.trailingAnchor, multiplier: 1.5)
        ])
    }
    
    private func saveOrDelete() throws {
        guard let recipeHere = recipe else {
            return
        }
        if isRecipeNotAlreadyRegistred() == true {
            favoriteOrNot.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            do {
            try recipeCoreDataManager.saveRecipe(recipe: recipeHere)
            } catch {
                print("Error while saving")
                let error = AppError.errorSaving
                if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                    allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                }
            }
        } else {
            favoriteOrNot.setImage(UIImage(systemName: "heart"), for: .normal)
            do {
            try recipeCoreDataManager.deleteRecipe(recipeToDelete: recipeHere)
            } catch {
                print("Error while deleting")
                let error = AppError.errorDelete
                if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                    allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                }
            }
        }
    }
    private func openUrl() {
        guard let recipeHere = recipe else {
            return
        }
        
        if let urlString = recipeHere.url, let url = URL(string: urlString) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            present(vc, animated: true)
        } else {
            let error = AppError.noUrl
            if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
            }
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
