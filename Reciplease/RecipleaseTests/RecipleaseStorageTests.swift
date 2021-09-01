//
//  RecipleaseStorageTests.swift
//  RecipleaseTests
//
//  Created by Guillaume Donzeau on 31/08/2021.
//

import XCTest
import CoreData
@testable import Reciplease


class TestCoreDataStack: NSObject {
    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: "Storage Recipes")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
}

class RecipleaseStorageTests: XCTestCase {
    let recipeCoreDataManager = RecipeCoreDataManager()
    var recipe: Recipe?
    
    override func setUp() {
        
        let persistentStoreDescription = NSPersistentStoreDescription()
            persistentStoreDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: RecipeCoreDataManager.modelName)
        
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        RecipeCoreDataManager.init(persistentContainer: container)
        //persistentContainer = container
    }
    
    func testToTry() {
        
        let recipeEntityOne:RecipeEntity
        //recipeEntityOne.name = "Chicken"
        recipeEntityOne.name = "Chicken"
        recipeEntityOne.imageUrl = "www.image.com"
        recipeEntityOne.url = "www.url.com"
        recipeEntityOne.person = 1.00
        recipeEntityOne.totalTime = 36.0
        recipeEntityOne.ingredients = (["Chicken","Salt"])
        //recipeEntityOne.name = "ChickenCesar"
        let recipeOne = recipe(from: recipeEntityOne)
        
        let recipeEntityTwo = RecipeEntity()
        recipeEntityTwo.name = "Salad Lemon"
        let recipeTwo = Recipe(from: recipeEntityTwo)
        
        let recipeEntityThree = RecipeEntity()
        recipeEntityThree.name = "Ice Cream"
        let recipeThree = Recipe(from: recipeEntityThree)
        
        let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
            expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
                return true
            }
        let recipes:[Recipe] = try! recipeCoreDataManager.loadRecipes()
        XCTAssert(recipes.count == 0)
        recipeCoreDataManager.saveRecipe(recipe: recipeOne)
        recipeCoreDataManager.saveRecipe(recipe: recipeTwo)
        recipeCoreDataManager.saveRecipe(recipe: recipeThree)
    }
    
}

