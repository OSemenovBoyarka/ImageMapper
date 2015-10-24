//
//  Document.swift
//  ImageMapper
//
//  Created by who knows? on 10/24/15.
//
//

import Foundation
import CoreData
import UIKit

class Document: NSManagedObject {
    static let entityName = "Document"
    
    static func createInConext(context:NSManagedObjectContext) -> Document {
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context) as! Document
    }
    
    //each conext (each document) should have only one of this entity
    static func getFromContext(context:NSManagedObjectContext) -> Document? {
        let request = NSFetchRequest(entityName: entityName)
        do {
            return try context.executeFetchRequest(request)[0] as? Document
        } catch {
            print("Can't fetch documents root node \(error)")
            return nil
        }
    }
}
