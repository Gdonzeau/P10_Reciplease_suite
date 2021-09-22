//
//  RecipleaseStorageTests.swift
//  RecipleaseTests
//
//  Created by Guillaume Donzeau on 31/08/2021.
//

import XCTest
import CoreData
@testable import Reciplease


class RecipleaseStorageTests: XCTestCase {
    var recipeCoreDataManager: RecipeCoreDataManager!
    
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
        try? recipeCoreDataManager.saveRecipe(recipe: recipe)
        XCTAssertTrue(recipe.name == "Lemon Icey")
        
        do {
            loadedRecipes = try recipeCoreDataManager.loadRecipes()
        } catch {
            XCTFail("Error loading recipes \(error.localizedDescription)")
        }
        XCTAssertFalse(loadedRecipes.isEmpty)
        XCTAssertTrue(loadedRecipes.first?.name == "Lemon Icey")
    }
    
    func testWhenDeletingOneRecipeFromFiveThenFourLeft() {
        var loadedRecipes: [Recipe] = []
        // Saving recipes from Recipes.json
        for index in 0 ..< 5 {
            let recipe = FakeResponse.recipes[index]
            try? recipeCoreDataManager.saveRecipe(recipe: recipe)
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
        
        try? recipeCoreDataManager.deleteRecipe(recipeToDelete: loadedRecipes[4])
        
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
}

