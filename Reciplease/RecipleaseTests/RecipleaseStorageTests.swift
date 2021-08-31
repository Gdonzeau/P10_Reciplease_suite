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
    override func setUp() {
        let persistentStoreDescription = NSPersistentStoreDescription()
            persistentStoreDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: RecipeCoreDataManager.modelName)
        
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { (_, error) in
            if let error = error as? NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        persistentContainer = container
    }
}
