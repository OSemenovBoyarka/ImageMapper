//
//  Hyperlink+CoreDataProperties.swift
//  ImageMapper
//
//  Created by who knows? on 10/24/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Hyperlink {

    @NSManaged var centerX: Double
    @NSManaged var centerY: Double
    @NSManaged var image: NSData
    @NSManaged var size: Int16
    @NSManaged var document: Document?
    @NSManaged var hyperlinks: NSSet?
    @NSManaged var parent: Hyperlink?

}
