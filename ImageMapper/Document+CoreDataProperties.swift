//
//  Document+CoreDataProperties.swift
//  ImageMapper
//
//  Created by Alexander Semenov on 10/24/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Document {

    @NSManaged var image: NSData!
    @NSManaged var hyperlinks: NSSet?

}
