//
//  DocumentsListViewController.swift
//  ImageMapper
//
//  Created by who knows? on 10/22/15.
//
//

import UIKit
import CoreData

class DocumentsListViewController: UITableViewController {

    var detailViewController: HyperLinkViewController? = nil
    var documentManager = DocumentManager.sharedManager
    var documents:[UIManagedDocument]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "createNewDocument:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? HyperLinkViewController
        }

        // This will remove extra separators from tableview
        self.tableView.tableFooterView = UIView()
        self.loadDocuments()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    func loadDocuments(){
        self.documents = self.documentManager.listDocuments();
        self.tableView.reloadData()
    }
    
    //MARK: - Document management
    func createNewDocument(sender: AnyObject) {
        //TODO add filename editing and open newly created file
        self.showImagePicker("Select image for new document", message: nil, sender: sender)
    }
    
 

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            //TODO open newly created document
            //create new document uses image conversion, so we need to perform it in background
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let handler = {(success: Bool) -> Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.loadDocuments()
                    }
                }
                
                self.documentManager.createNewDocumentNamed("New Document", rootImage: originalImage,completionHandler: handler)
            }
        }
    }
    
    
    func deleteDocument(document: UIManagedDocument){
        do {
            try NSFileManager.defaultManager().removeItemAtURL(document.fileURL)
        } catch {
            print("Can't delete file - \(error)")
        }
        self.loadDocuments()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! HyperLinkViewController
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                
                let managedDocument = self.documents?[indexPath.row]
                if managedDocument?.documentState == .Closed{
                    managedDocument!.openWithCompletionHandler({ (sucess: Bool) -> Void in
                         controller.document = Document.getFromContext(managedDocument!.managedObjectContext)
                    })
                } else {
                     controller.document = Document.getFromContext(managedDocument!.managedObjectContext)
                }
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let docCount = self.documents?.count {
            return docCount
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let managedDocument = self.documents![indexPath.row]
            if (managedDocument.documentState == .Closed){
                self.deleteDocument(managedDocument)
            } else {
                managedDocument.closeWithCompletionHandler({ (sucess:Bool) -> Void in
                    self.deleteDocument(managedDocument)
                })
            }
        }
    }

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.documents?[indexPath.row]
        cell.textLabel!.text = object?.fileURL.lastPathComponent
    }
}

