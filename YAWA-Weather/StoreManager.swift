//
//  StoreManager.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 15/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import CoreData

class StoreManager: NSObject {

	static let sharedInstance = StoreManager()
	
	func executeRequestWithPredicate(predicate: NSPredicate?, entityName: String) -> [NSManagedObject]? {
		
		let request = NSFetchRequest()
		let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedObjectContext!)
		
		request.entity = entity
		request.predicate = predicate
		
        do {
            let results =  try managedObjectContext?.executeFetchRequest(request) as? [NSManagedObject]
            return results
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
		
		return nil
	}
	// MARK: - Core Data stack
	
	lazy var applicationDocumentsDirectory: NSURL = {
		let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		return urls[urls.count-1] as NSURL
		}()
	
	lazy var managedObjectModel: NSManagedObjectModel = {
		let modelURL = NSBundle.mainBundle().URLForResource("mercuryModel", withExtension: "momd")!
		return NSManagedObjectModel(contentsOfURL: modelURL)!
		}()
	
    var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        get {
            do {
                let coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
                let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("mercuryDataBase")
                try coordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: .None)
                return coordinator
            } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
            }
            return nil
        }
    }
    
	lazy var managedObjectContext: NSManagedObjectContext? = {
		// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
		let coordinator = self.persistentStoreCoordinator
		if coordinator == nil {
			return nil
		}
		var managedObjectContext = NSManagedObjectContext()
		managedObjectContext.persistentStoreCoordinator = coordinator
		return managedObjectContext
		}()
	
	// MARK: - Core Data Saving support
	
	func saveContext () {
		if let moc = self.managedObjectContext {
			if moc.hasChanges {

                do {
                    try moc.save()
                }catch let error as NSError {
                    NSLog("Unresolved error \(error), \(error.userInfo)")
                    fatalError()
                }
			}
		}
	}

}
