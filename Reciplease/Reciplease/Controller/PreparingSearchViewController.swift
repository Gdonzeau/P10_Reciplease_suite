//
//  PreparingSearchViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 12/07/2021.
//

import UIKit
import CoreData

class PreparingSearchViewController: UIViewController {
    // Pour le test
    let recipeCoreDataManager = RecipeCoreDataManager()
    var entitiesPresent = [EntityTest]()
    // fin du test
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
        paraTest = "Привет"
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
        // Test
        /*
         On charge le nombre d'entitiesTest en mémoire.
         On affiche leur nombre. S'il est supérieur à zéro, on affiche les données (nom et nombre de personnes)
         On crée une nouvelle EntityTest avec pour nom "Name"+ un nombre aléatoire
         et pour nombre de personnes le nombre d'EntitiesTest déjà enregistrées.
         */
        // On charge les entités
        var entitiesLoaded = loadEntities()
        print("Nous avons \(entitiesLoaded.count) entités chargées.")
        entitiesLoaded = []
        print("Nous avons à présent \(entitiesLoaded.count) entités chargées.")
        // Puis on crée une nouvelle entité...
        let entityCreated = createEntity() // D'où viennent les optionels ?
        print("Nous avons créé l'entité \(String(describing: entityCreated.name)) avec \(entityCreated.invited).")
        // Nous la convertissons
        let entityUsable = convertCoreDataEntityToUsableEntity(entityToConvert: entityCreated)
      //  print("Nous avons l'entité Usable \(entityUsable.name) avec \(entityUsable.invited)")
        // ... que l'on convertit (même si elle l'est déjà sous le nom de entityCreated)
        //let entityToSave = convertUsableEntityToCoreDataEntity(entityToConvert: entityUsable)
        saveEntity(entityToSave: entityUsable)
        // Fin du Test
        
        paraTest = "Salut"
        ingredientName.attributedPlaceholder = NSAttributedString(string: "Lemon, Cheese, Sausages,...",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        self.ingredientTableView.rowHeight = 40.0
    }
    // Méthodes pour les tests
    private func convertUsableEntityToCoreDataEntity(entityToConvert:EntityUsable) -> EntityTest {
        let entityCoreData = EntityTest(context: AppDelegate.viewContext)
        entityCoreData.name = entityToConvert.name
        entityCoreData.invited = entityToConvert.invited
        return entityCoreData
    }
    private func convertCoreDataEntityToUsableEntity(entityToConvert:EntityTest) -> EntityUsable {
        if let name = entityToConvert.name {
        let entityUsable = EntityUsable(name: name, invited: entityToConvert.invited)
            return entityUsable
        }
        return EntityUsable(name: "", invited: 0.00) // En cas d'échec on revoie une entité nulle.
    }
    private func loadEntities() -> [EntityTest] {
        let request: NSFetchRequest<EntityTest> = EntityTest.fetchRequest()
        var entitiesTest = [EntityTest]()
        if let entitiesReceived = try? AppDelegate.viewContext.fetch(request) {
            print("Le tableau contient \(entitiesReceived.count) entité(s)")
            for object in entitiesReceived {
                let newEntity = EntityTest(context: AppDelegate.viewContext)
                newEntity.name = object.name
                newEntity.invited = object.invited
                entitiesTest.append(newEntity)
            }
        }
            print("Il y a actuellement \(entitiesTest.count) entités déjà enregistrée(s)")
            
            if entitiesTest.count > 0 {
                entitiesPresent = [] // On remet à zéro
                for object in entitiesTest {
                    print("Entité \(String(describing: object.name)) avec \(object.invited) personnes")
                    entitiesPresent.append(object)
                    // On se retrouve avec un tableau d'entités.
                }
                print("Reste : \(entitiesTest.count)")
            }
        return entitiesTest
    }
    
    private func deleteEntity() {
        
    }
    private func saveEntity(entityToSave: EntityUsable) {
        let entityCoreData = EntityTest(context: AppDelegate.viewContext)
        entityCoreData.name = entityToSave.name
        entityCoreData.invited = entityToSave.invited
        try? AppDelegate.viewContext.save() // On essaie de svg
    }
    
    private func createEntity() -> EntityTest {
        let newEntity = EntityTest(context: AppDelegate.viewContext)
        let randomNumber = Int.random(in: 1 ... 100)
        newEntity.name = "Name" + String(randomNumber)
        newEntity.invited = Float.random(in: 1 ... 100)
        return newEntity
    }
    // Fin des méthodes pour les tests
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
        ingredientTableView.reloadData()
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
