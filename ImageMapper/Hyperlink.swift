//
//  Hyperlink.swift
//  ImageMapper
//
//  Created by who knows? on 10/24/15.
//
//

import Foundation
import CoreData

class Hyperlink: NSManagedObject {
    static let entityName = "Hyperlink"

    static func createInConext(context:NSManagedObjectContext) -> Hyperlink {
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context) as! Hyperlink
    }
}
