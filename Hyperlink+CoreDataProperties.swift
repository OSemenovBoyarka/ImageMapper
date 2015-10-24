//
//  Hyperlink+CoreDataProperties.swift
//  ImageMapper
//
//  Created by Alexander Semenov on 10/22/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Hyperlink {

    @NSManaged var image: NSData
    @NSManaged var centerX: Double
    @NSManaged var centerY: Double
    @NSManaged var size: Int16
    @NSManaged var document: NSManagedObject?
    @NSManaged var hyperlinks: NSSet?
    @NSManaged var parent: Hyperlink?

}
