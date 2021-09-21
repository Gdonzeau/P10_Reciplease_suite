//
//  ReceipeListViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 12/07/2021.
//

import UIKit

enum RecipeListMode {
    case api
    case database
    
    var title: String {
        switch self {
        case .api:
            return "Search"
        case .database:
            return "Favorites"
        }
    }
    
    var emptyImage: UIImage {
        var image = UIImage()
        switch self {
        case .api:
            if let imageReturned = UIImage(named: "noRecipe") {
                image = imageReturned
            }
        case .database:
            if let imageReturned = UIImage(named: "noFavorit") {
                image = imageReturned
            }
        }
        return image
    }
    
    var subtitle: String {
        switch self {
        case .api:
            return "No Recipe"
        case .database:
            return "No Favorite"
        }
    }
}
enum ViewState {
    case loading
    case error
    case empty
    case showData
}

class RecipeListViewController: UIViewController {
    
    var recipes: [Recipe] = []
    
    var recipeMode: RecipeListMode = .database
    
    var ingredientsUsed: String = ""
    
    var viewState: ViewState = .loading {
        didSet {
            resetViewState()
            switch viewState {
            case .loading:
                activityIndicator.startAnimating()
            case .error:
                allErrors(errorMessage: "Error", errorTitle: "subtitle")
            case .empty:
                //stack view image / title / subtitle
                subtitle.isHidden = false
                imageView.isHidden = false
            case .showData:
                receipesTableView.isHidden = false
                receipesTableView.reloadData()
            }
        }
    }
    
    private func resetViewState() {
        activityIndicator.stopAnimating()
        receipesTableView.isHidden = true
        subtitle.isHidden = true
        imageView.isHidden = true
    }
    
    private let recipeCoreDataManager = RecipeCoreDataManager.shared
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var receipesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        setupView()
        //options()
        getRecipes()
    }
    func options() {
        receipesTableView.delegate = self
        receipesTableView.dataSource = self
    }
    private func setupView() {
        title = recipeMode.title
        imageView.image = recipeMode.emptyImage
        subtitle.text = recipeMode.subtitle
        activityIndicator.hidesWhenStopped = true
        imageView.isHidden = true
        subtitle.isHidden = true
        toggleActivityIndicator(shown: true)
        self.receipesTableView.rowHeight = 120.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if recipeMode == .database {
            getRecipes()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromCellToChoosenRecipe",
           let recipeChoosenVC = segue.destination as? RecipeChoosenViewController,
           let index = receipesTableView.indexPathForSelectedRow?.row {
            recipeChoosenVC.recipe = recipes[index]
        }
    }
    
    private func getRecipes() {
        switch recipeMode {
        case .api:
            getRecipesFromApi()
        case .database:
            getRecipesFromDatabase()
        }
    }
    
    private func getRecipesFromApi() {
        viewState = .loading
        RecipesServices.shared.getRecipes(ingredients: ingredientsUsed) { [weak self] (result) in
            switch result {
            case .success(let recipeResponse) where recipeResponse.recipes.isEmpty:
                print("no result show empty")
                self?.viewState = .empty
            case .success(let recipeResponse):
                self?.recipes = recipeResponse.recipes
                self?.viewState = .showData
            case .failure(let error):
                print("Error loading recipes from API \(error.localizedDescription)")
                self?.viewState = .error
            }
        }
    }
    
    private func getRecipesFromDatabase() {
        do {
            recipes = try recipeCoreDataManager.loadRecipes()
            if recipes.isEmpty {
                viewState = .empty
            } else {
                viewState = .showData
            }
        } catch let error {
            print("Error loading recipes from database \(error.localizedDescription)")
            viewState = .error
        }
    }
    
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
    
    // func numberOfSection not necessary as 1 by default
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        cell.recipe = recipes[indexPath.row]
        return cell
        
    }
}

extension RecipeListViewController: UITableViewDelegate { // To delete cells one by one
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) throws -> UISwipeActionsConfiguration? { // Swipe action
        guard recipeMode == .database else {
            return nil
        }
        
        let deleteAction = UIContextualAction(
            style: .destructive, title: "Delete") { _, _, completionHandler in
            let recipeToDelete = self.recipes[indexPath.row]
            
            do {
                try self.recipeCoreDataManager.deleteRecipe(recipeToDelete: recipeToDelete)
                DispatchQueue.main.async {
                    self.getRecipesFromDatabase()
                }
                completionHandler(true)
            } catch {
                print("Error while deleting")
                completionHandler(false)
                let error = AppError.errorDelete
                if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                    self.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                }
            }
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

