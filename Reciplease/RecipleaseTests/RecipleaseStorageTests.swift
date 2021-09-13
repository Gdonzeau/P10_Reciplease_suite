//
//  RecipleaseStorageTests.swift
//  RecipleaseTests
//
//  Created by Guillaume Donzeau on 31/08/2021.
//

import XCTest
import CoreData
@testable import Reciplease

/*
class TestCoreDataStack: NSObject {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: "Reciplease")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
}
*/

class RecipleaseStorageTests: XCTestCase {
    var recipeCoreDataManager: RecipeCoreDataManager!
    //var recipe: Recipe?
    override func setUp() {
        super.setUp()
       
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        persistentStoreDescription.shouldAddStoreAsynchronously = true
        
        let persistentContainer = NSPersistentContainer(name: "Reciplease", managedObjectModel: managedObjectModel)
        
        persistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
        persistentContainer.loadPersistentStores { (description, error) in
            precondition(description.type == NSInMemoryStoreType, "Store description is not type NSInMemoryStoreType")
            
            if let error = error as NSError? {
                fatalError("Persistent container creation error: \(error), \(error.userInfo)")
            }
        }
        recipeCoreDataManager = RecipeCoreDataManager(persistentContainer: persistentContainer)
    }
    
    override func tearDown() {
        recipeCoreDataManager = nil
        super.tearDown()
    }
    
    func testLoadRecipes() {
        var loadedRecipes: [Recipe] = []

        let recipe = FakeResponse.recipes.first!
        //do {
            //try
                recipeCoreDataManager.saveRecipe(recipe: recipe)
        XCTAssertTrue(recipe.name == "Lemon Icey")
       // } catch {
            
          //  XCTFail("Error saving recipes \(error.localizedDescription)")
       // }
        do {
            loadedRecipes = try recipeCoreDataManager.loadRecipes()
        } catch {
            XCTFail("Error loading recipes \(error.localizedDescription)")
        }
        XCTAssertFalse(loadedRecipes.isEmpty)
        XCTAssertTrue(loadedRecipes.first?.name == "Lemon Icey")
        // loadedrecipe.first
        // name equal ...
    }
    
    func testWhenDeletingOneRecipeFromFiveThenFourLeft() {
        var loadedRecipes: [Recipe] = []
        // Saving recipes from Recipes.json
        for index in 0 ..< 5 {
            let recipe = FakeResponse.recipes[index]
            recipeCoreDataManager.saveRecipe(recipe: recipe)
        }
        // Loading recipes
        XCTAssertTrue(loadedRecipes.count == 0)
        do {
            loadedRecipes = try recipeCoreDataManager.loadRecipes()
        } catch {
            XCTFail("Error loading recipes \(error.localizedDescription)")
        }
        
        XCTAssertTrue(loadedRecipes.count == 5)
        XCTAssertTrue(loadedRecipes[0].name == "Baking with Dorie: Lemon-Lemon Lemon Cream Recipe")
        
        XCTAssertTrue(loadedRecipes[1].name == "Lemon Salt Lemon Cupcakes")
        
        XCTAssertTrue(loadedRecipes[2].name == "Lemon Icey")
        
        XCTAssertTrue(loadedRecipes[3].name == "Lemon Bars")
        
        XCTAssertTrue(loadedRecipes[4].name == "Lemon Cookies")
        
        recipeCoreDataManager.deleteRecipe(recipeToDelete: loadedRecipes[4])
        
        do {
            loadedRecipes = try recipeCoreDataManager.loadRecipes()
        } catch {
            XCTFail("Error loading recipes \(error.localizedDescription)")
        }

        XCTAssertTrue(loadedRecipes.count == 4)
        
        XCTAssertTrue(loadedRecipes[0].name == "Baking with Dorie: Lemon-Lemon Lemon Cream Recipe")
        
        XCTAssertTrue(loadedRecipes[1].name == "Lemon Salt Lemon Cupcakes")
        
        XCTAssertTrue(loadedRecipes[2].name == "Lemon Icey")
        
        XCTAssertTrue(loadedRecipes[3].name == "Lemon Bars")
    }
    /*
    func testDeleteAll() {
        //When
        var loadedRecipes: [Recipe] = []
        // Saving recipes from Recipes.json
        for index in 0 ..< 5 {
            let recipe = FakeResponse.recipes[index]
            recipeCoreDataManager.saveRecipe(recipe: recipe)
        }
        // Loading recipes
        XCTAssertTrue(loadedRecipes.count == 0)
        do {
            loadedRecipes = try recipeCoreDataManager.loadRecipes()
        } catch {
            XCTFail("Error loading recipes \(error.localizedDescription)")
        }
        
        XCTAssertTrue(loadedRecipes.count == 5)
        
        XCTAssertTrue(loadedRecipes[0].name == "Baking with Dorie: Lemon-Lemon Lemon Cream Recipe")

        XCTAssertTrue(loadedRecipes[1].name == "Lemon Salt Lemon Cupcakes")

        XCTAssertTrue(loadedRecipes[2].name == "Lemon Icey")

        XCTAssertTrue(loadedRecipes[3].name == "Lemon Bars")

        XCTAssertTrue(loadedRecipes[4].name == "Lemon Cookies")
        // Then
        //recipeCoreDataManager.deleteAll()
        
        do {
            loadedRecipes = try recipeCoreDataManager.loadRecipes()
        } catch {
            XCTFail("Error loading recipes \(error.localizedDescription)")
        }
        
        XCTAssertTrue(loadedRecipes.count == 0)
        
    }
    
    func testHowMany() {
        recipeCoreDataManager.howMany()
        let recipe = FakeResponse.recipes.first!
        recipeCoreDataManager.saveRecipe(recipe: recipe)
        recipeCoreDataManager.howMany()
        //let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        /*
        let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        
        /*
            expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
                return true
            }
 */
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        var response: [RecipeEntity]
        do {
            response = try context.fetch(request)
            //let response = try AppDelegate.viewContext.fetch(request)
            print("Nous avons ici \(response.count) entités en mémoire")
            
        } catch {
            
            print("Error while reading")
            return
        }
        waitForExpectations(timeout: 2.0) { error in
                XCTAssertNil(error, "Save did not occur")
            }
        */
    }
    */
}

