//
//  Hyperlink.swift
//  ImageMapper
//
//  Created by Alexander Semenov on 10/24/15.
//
//

import Foundation
import CoreData

class Hyperlink: NSManagedObject {
    static let entityName = "Hyperlink"

    static func createInConext(context:NSManagedObjectContext) -> Document {
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context) as! Document
    }
}
