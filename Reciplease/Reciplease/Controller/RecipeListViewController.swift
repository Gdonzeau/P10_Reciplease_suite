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
    //var emptyImage: UIImage
    
    //var emptyViewtitle: String {
}

enum ViewState {
    case loading
    case error
    case empty
    case showDate
   // case error2(Error)
   // case show(Recipe)
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
                imageView.isHidden = false
                imageView.image = UIImage(named: "noRecipe")
            case .showDate:
                receipesTableView.isHidden = false
                receipesTableView.reloadData()
                
          //  case .error2(let error where error.):
            //    allErrors(errorMessage: error.title, errorTitle: <#T##String#>)
            }
        }
    }
    
    private func resetViewState() {
        activityIndicator.stopAnimating()
        receipesTableView.isHidden = true
        imageView.isHidden = true
    }
    
    private let recipeCoreDataManager = RecipeCoreDataManager()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var receipesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        getRecipes()
    }
    
    private func setupView() {
        title = recipeMode.title
        activityIndicator.hidesWhenStopped = true // possible de le faire storyboard
        imageView.isHidden = true
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
                self?.viewState = .showDate
            case .failure(let error):
                print("Error loading recipes from API \(error.localizedDescription)")
                self?.viewState = .error
                // on peux remove
                //let error = APIErrors.invalidStatusCode
               // if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                //    self?.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
               // }
            }
        }
    }
    
    private func getRecipesFromDatabase() {
        do {
            recipes = try recipeCoreDataManager.loadRecipes()
            if recipes.isEmpty {
                viewState = .empty
            } else {
                viewState = .showDate
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
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
        //cell.information2.recipe = recipes[indexPath.row]
        return cell
        
    }
}

extension RecipeListViewController: UITableViewDelegate { // To delete cells one by one
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let sotry ...indexPath
        //detailViewController
        //detailVC.recipe = recipes[indexPath.row]
       // navgation.push
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // nouvelle facon
        guard recipeMode == .database else { return nil }
        //TODO cree l action deleteAction
        
        return nil
    }
}

