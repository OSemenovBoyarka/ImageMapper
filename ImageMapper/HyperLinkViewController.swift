//
//  DetailViewController.swift
//  ImageMapper
//
//  Created by Alexander Semenov on 10/22/15.
//
//

import UIKit
import CoreData

class HyperLinkViewController: UIViewController {


    @IBOutlet weak var rootImage: UIImageView!
    var pendingHypelink: Hyperlink?

    var managedContext: NSManagedObjectContext?
    var document: Document? {
        didSet {
            if let context = document?.managedObjectContext{
                self.managedContext = context
            } else {
                self.managedContext = nil
            }
            // Update the view.
            self.setViewsContent()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewsContent()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()

        self.rootImage!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hadleTapMainImage:"))
        
    }
    
    func setViewsContent() {
        //if we haven't imageview set- should
        if let imageView = self.rootImage {
            if let document = self.document {
                imageView.image = UIImage(data: document.image)
                return
            }
            //no image - no fun :)
            //TODO pop back in that case
            self.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // MARK - gestures recognition
    func hadleTapMainImage(recognizer: UITapGestureRecognizer){
//        if we are not in editing mode - nothing to do here
        if !self.editing {
            return
        }
        let touchLocation = recognizer.locationInView(self.rootImage)
        
        // creating hyperlink
        pendingHypelink = Hyperlink.createInConext(self.managedContext!)
      
        let rootSize = self.rootImage.frame.size
        pendingHypelink!.centerX = Double(touchLocation.x/rootSize.width)
        pendingHypelink!.centerY = Double(touchLocation.y/rootSize.height)
        
        showImagePicker("Select a target image for new hyperlink", message: nil, sender: self.rootImage)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        if let hyperLink = self.pendingHypelink {
            self.managedContext?.deleteObject(hyperLink);
        }

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        let hyperLink = self.pendingHypelink!
        self.pendingHypelink = nil
        self.document?.mutableSetValueForKey("hyperlinks").addObject(hyperLink)
        
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            //create new hyperlink uses image conversion, so we need to perform it in background
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                hyperLink.image = UIImageJPEGRepresentation(originalImage, 1.0)
            }
        } else {
            //normally this should never happen, but handle error just in case
            self.managedContext?.deleteObject(hyperLink);
        }
    }

   
}

