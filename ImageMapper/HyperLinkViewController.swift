//
//  DetailViewController.swift
//  ImageMapper
//
//  Created by who knows? on 10/22/15.
//
//

import UIKit
import CoreData

class HyperLinkViewController: UIViewController {


    @IBOutlet weak var rootImage: UIImageView!
    var pendingHypelink: Hyperlink?
    
    var hyperLinkViews: [HyperlinkView] = []
    
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
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        for linkView in self.hyperLinkViews {
            linkView.editing = editing
        }
    }
    
    var hyperLink: Hyperlink? {
        didSet {
            if let context = hyperLink?.managedObjectContext{
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

        self.rootImage!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTapMainImage:"))
        
    }
    
    func setViewsContent() {
        //if we haven't imageview set- should
        if let imageView = self.rootImage {
            //TODO remove code duplication
            if let document = self.document {
                imageView.image = UIImage(data: document.image)
                imageView.layoutIfNeeded()
                imageView.sizeToFit()
                for hyperLink in document.hyperlinks! {
                    self.addLinkView(hyperLink as! Hyperlink)
                }
                return
            } else if let hyperLink = self.hyperLink{
                imageView.image = UIImage(data: hyperLink.image)
                imageView.layoutIfNeeded()
                imageView.sizeToFit()
                for hyperLink in hyperLink.hyperlinks! {
                    self.addLinkView(hyperLink as! Hyperlink)
                }
                return
            }
            //no image - no fun :)
            //TODO pop back in that case
            self.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    func addLinkView(link: Hyperlink){
        //view will position itself
        let view = HyperlinkView.viewWithLink(link)
        view.editing = self.editing
        self.rootImage.addSubview(view)
        self.hyperLinkViews.append(view)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTapHyperLink:"))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "moveViewWithGestureRecognizer:"))
    }
    
    // MARK - gestures recognition
    
    func moveViewWithGestureRecognizer(recognizer: UIPanGestureRecognizer){
        if !self.editing {
            return
        }
        let linkView = recognizer.view as! HyperlinkView
        
        
        let touchLocation = recognizer.locationInView(self.rootImage)
        let rootSize = self.rootImage.frame.size
        linkView.hyperLink!.centerX = Double(touchLocation.x/rootSize.width)
        linkView.hyperLink!.centerY = Double(touchLocation.y/rootSize.height)

        linkView.center = touchLocation;
    }
    
    func handleTapMainImage(recognizer: UITapGestureRecognizer){
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
    
    func handleTapHyperLink(recognizer: UITapGestureRecognizer){
        // pop remove dialog if in edit mode
        if self.editing {
            //TODO add undo support
            let alert = UIAlertController(title: "Delete link", message: "You can't recover your link, delete it?", preferredStyle: .ActionSheet)
            alert.addAction(UIAlertAction(title: "Delete hyperlink", style: .Destructive, handler: { _ in
                    let linkView = recognizer.view as! HyperlinkView
                    let hyperLink = linkView.hyperLink!
                    self.document?.mutableSetValueForKey("hyperlinks").removeObject(hyperLink)
                    self.managedContext?.deleteObject(hyperLink)
                    linkView.removeFromSuperview();
                    self.hyperLinkViews.removeAtIndex(self.hyperLinkViews.indexOf(linkView)!)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            alert.popoverPresentationController?.sourceView = recognizer.view
            return
        }
        
        let linkView = recognizer.view as! HyperlinkView
        let hyperLinkController = self.storyboard?.instantiateViewControllerWithIdentifier("HyperLinkViewController") as! HyperLinkViewController
        hyperLinkController.hyperLink = linkView.hyperLink
        self.navigationController?.pushViewController(hyperLinkController, animated: true)
        
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
        self.addLinkView(hyperLink)
        
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            //create new hyperlink uses image conversion, so we need to perform it in background
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                hyperLink.image = UIImageJPEGRepresentation(originalImage, 1.0)!
            }
        } else {
            //normally this should never happen, but handle error just in case
            self.managedContext?.deleteObject(hyperLink);
        }
    }
   
}

