//
//  RecipeStorageManagerTest.swift
//  RecipleaseTests
//
//  Created by Guillaume Donzeau on 27/08/2021.
//

import Foundation
import CoreData


class TestCoreDataStack: CoreDataStack {
  override init() {
    super.init()

    // 1
    let persistentStoreDescription = NSPersistentStoreDescription()
    persistentStoreDescription.type = NSInMemoryStoreType

    // 2
    let container = NSPersistentContainer(
      name: CoreDataStack.modelName,
      managedObjectModel: CoreDataStack.model)

    // 3
    container.persistentStoreDescriptions = [persistentStoreDescription]

    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }

    // 4
    storeContainer = container
  }
}
