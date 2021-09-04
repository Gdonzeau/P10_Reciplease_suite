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
        //recipeCoreDataManager = RecipeCoreDataManager(persistentContainer: TestCoreDataStack().persistentContainer)
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
       // } catch {
            
          //  XCTFail("Error saving recipes \(error.localizedDescription)")
       // }
        do {
            loadedRecipes = try recipeCoreDataManager.loadRecipes()
        } catch {
            XCTFail("Error loading recipes \(error.localizedDescription)")
        }
        XCTAssertFalse(loadedRecipes.isEmpty)
        // loadedrecipe.first
        // name equal ...
    }
    
    func testToDebugPersistentContainer() {
        
    }
    
    func testDeleteRecipe() {
        // save 2 3 recettes
        // laod
        // delete 
    }
    
    func testToTry() {
        
        let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
            expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
                return true
            }
        
        //let recipeCoreDataTest = RecipeCoreDataManager(persistentContainer: context)
        
        //let expectation = XCTestExpectation(description: "recipe loading success")
        
        
        let recipes:[Recipe] = try! recipeCoreDataManager.loadRecipes()
        print(recipes.count)
        XCTAssert(recipes.count == 0)
        /*
        let recipeEntityOne = RecipeEntity(context: context)
        recipeEntityOne.name = "Chicken"
        recipeEntityOne.imageUrl = "www.image.com"
        recipeEntityOne.url = "www.url.com"
        recipeEntityOne.person = 1.00
        recipeEntityOne.totalTime = 36.0
        recipeEntityOne.ingredients = try? JSONEncoder().encode(["Chicken","Salt"])
        
        try? AppDelegate.viewContext.save()
        */
        //let recipeOne = recipe(from: recipeEntityOne)
        /*
        let recipeEntityTwo = RecipeEntity()
        recipeEntityTwo.name = "Salad Lemon"
        let recipeTwo = Recipe(from: recipeEntityTwo)
        
        let recipeEntityThree = RecipeEntity()
        recipeEntityThree.name = "Ice Cream"
        let recipeThree = Recipe(from: recipeEntityThree)
        */
        
        
        //recipeCoreDataManager.saveRecipe(recipe: recipeOne)
        //recipeCoreDataManager.saveRecipe(recipe: recipeTwo)
        //recipeCoreDataManager.saveRecipe(recipe: recipeThree)
    }
    
    func testHowMany() {
        recipeCoreDataManager = RecipeCoreDataManager(persistentContainer: TestCoreDataStack().persistentContainer)
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
    
}

