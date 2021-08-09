//
//  PreparingSearchViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 12/07/2021.
//

import UIKit

class PreparingSearchViewController: ViewController{
    var ingredientsUsed = ""
    var ingredientsList = [String]()
    var parameters: Parameters = .search
    
    var paraTest = "Bonjour" {
        didSet {
            searchButton.setTitle(paraTest, for: .normal)
        }
    }
    
    @IBOutlet weak var ingredientName: UITextField!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    
    @IBAction func addIngredientButton(_ sender: UIButton) {
        ingredientName.resignFirstResponder()
        addIngredient()
        paraTest = "Priviet"
    }
    @IBAction func searchRecipesButton(_ sender: UIButton) {
        gettingIngredients()
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        disMissKeyboardMethod()
    }
    @IBAction func clearIngredients(_ sender: UIButton) {
        deleteIngredientTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paraTest = "Salut"
        ingredientName.attributedPlaceholder = NSAttributedString(string: "Lemon, Cheese, Sausages,...",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        self.ingredientTableView.rowHeight = 40.0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ingredientTableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToReceiptList" {
            let recipeListVC = segue.destination as! RecipeListViewController
            recipeListVC.ingredientsUsed = ingredientsUsed
            recipeListVC.parameters = parameters
        }
    }
    private func deleteIngredientTableView() {
        ingredientsUsed = ""
        for _ in 0 ..< ingredientsList.count {
            ingredientsList.remove(at: 0)
        }
        ingredientTableView.reloadData()
    }
    private func addIngredient() {
        guard var ingredientAdded = ingredientName.text else {
            return
        }
        ingredientAdded = "- " + ingredientAdded
        ingredientsList.append(ingredientAdded) // Adding new ingredient
        ingredientName.text = ""
        viewWillAppear(true)
    }
    
    private func gettingIngredients() {
            guard ingredientsList.count > 0 else {
            let error = APIErrors.nothingIsWritten
            if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
            allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
            }
            return
        }
        for index in 0 ..< ingredientsList.count {
            ingredientsUsed += ingredientsList[index]
        }
        self.performSegue(withIdentifier: "segueToReceiptList", sender: nil)
    }
    
    private func disMissKeyboardMethod() {
        ingredientName.resignFirstResponder()
    }

    private func allErrors(errorMessage: String, errorTitle: String) {
        let alertVC = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
}

extension PreparingSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return IngredientService.shared.ingredients.count
        return ingredientsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.text = ingredientsList[indexPath.row]
        
        return cell
    }
}
extension PreparingSearchViewController: UITextFieldDelegate { // To dismiss keyboard when returnKey
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientName.resignFirstResponder()
        ingredientName.text = ""
        return true
    }
}
extension PreparingSearchViewController: UITableViewDelegate { // To delete cells one by one
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("On efface : \(indexPath.row)")
            ingredientsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            ingredientsUsed = ""
            for ingredient in ingredientsList {
                ingredientsUsed += ingredient
            }
        }
    }
}
