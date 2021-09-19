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
    
    private var stackViewInfo: StackViewInfo = {
        let view = StackViewInfo()
        view.codeInfoPersonView.person = "3"
        return view
    }()
    //private var codeInfoView = InfoTimeView()
    @IBAction func favoriteOrNotChange(_ sender: UIButton) {
        saveOrDelete()
    }
    
    @IBAction func getDirectionsButtonAction(_ sender: UIButton) {
        openUrl()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
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
        print("Go")
        isRecipeNotFavorite(answer: isRecipeNotAlreadyRegistred())
        favoriteOrNot.contentVerticalAlignment = .fill
        favoriteOrNot.contentHorizontalAlignment = .fill
        favoriteOrNot.tintColor = .red
        
        //codeInfoView.recipe = recipe
        
        stackViewInfo.translatesAutoresizingMaskIntoConstraints = false
        stackViewInfo = StackViewInfo(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
        //stackViewInfo.layer.zPosition = .greatestFiniteMagnitude
        imageRecipe.addSubview(stackViewInfo)
        //imageRecipe.bringSubviewToFront(codeInfoView)
        prepareInfo()
        
        
        //customView = MyCustomView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        //self.view.addSubview(customView)
    }
    private func saveOrDelete() {
        guard let recipeHere = recipe else {
            return
        }
        if isRecipeNotAlreadyRegistred() == true {
            favoriteOrNot.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            recipeCoreDataManager.saveRecipe(recipe: recipeHere)
        } else {
            favoriteOrNot.setImage(UIImage(systemName: "heart"), for: .normal)
            recipeCoreDataManager.deleteRecipe(recipeToDelete: recipeHere)
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
            //vc.modalPresentationStyle = .popover
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            present(vc, animated: true)
        }
        
    }
    private func prepareInfo() {
        guard let timePreparation = recipe?.duration else {
            return
        }
        guard let person = recipe?.numberOfPeople else {
            return
        }
        // Right format for time
        let timeToPrepare = String(timePreparation)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        //if interval >= 60 {
        formatter.allowedUnits = [.hour, .minute]
        
        guard let timeForPrepare = Double(timeToPrepare) else {
            return
        }
        guard let time = formatter.string(from: Double(timeForPrepare)*60) else {
            return
        }
        
        if time == "0min" {
            stackViewInfo.codeInfoTimeView.isHidden = true
        } else {
            stackViewInfo.codeInfoTimeView.isHidden = false
        }
        if person == 0 {
            stackViewInfo.codeInfoPersonView.isHidden = true
        } else {
            stackViewInfo.codeInfoPersonView.isHidden = false
        }
        stackViewInfo.codeInfoTimeView.title.text = " : \(time) "
        stackViewInfo.codeInfoPersonView.title.text = " : \(String(Int(person))) pers. "
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
