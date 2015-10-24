//
//  CoreDataStack.swift
//  ImageMapper
//
//  Created by Alexander Semenov on 10/24/15.
//
//

import Foundation
import CoreData
import UIKit



class DocumentManager {

    let kDocFileExtension = "imagemap"
    static let sharedManager = DocumentManager()

    lazy var appDocumentsDir: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.mobilechallenge.ImageMapper" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count - 1]
    }()

    func createNewDocumentNamed(name: String, rootImage: UIImage, completionHandler: ((Bool) -> Void)?) -> UIManagedDocument {
        let fileName = NSUUID().UUIDString
        let url = self.appDocumentsDir.URLByAppendingPathComponent("\(fileName).\(self.kDocFileExtension)")
        let document = UIManagedDocument(fileURL: url)
        let context:NSManagedObjectContext = document.managedObjectContext

        let rootEntity = Document.createInConext(context)
        rootEntity.image = UIImagePNGRepresentation(rootImage)!
    
        document.saveToURL(url, forSaveOperation: .ForCreating, completionHandler: completionHandler)
        return document;
    }
    
    func listDocuments() -> [UIManagedDocument]{
        let fileManager = NSFileManager.defaultManager();

        do {
            let files = try fileManager.contentsOfDirectoryAtURL(self.appDocumentsDir, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles)
            let documentFiles = files.filter(){
                $0.pathExtension == kDocFileExtension
            }
            let documents: [UIManagedDocument] = documentFiles.map(){
                UIManagedDocument(fileURL:$0)
            }
            print("Found \(documents.count) documents")
            return documents;
        } catch {
            print("Failed to load contents of documents dir")
            return []
        }
      
        
    }

}