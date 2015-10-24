//
//  UIViewController+ImagePicker.swift
//  ImageMapper
//
//  Created by Alexander Semenov on 10/24/15.
//
//

import Foundation
import UIKit



extension UIViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    func showImagePicker(title: String?, message: String?, sender: AnyObject){
        
        //TODO add filename editing and open newly created file
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet )
        
        actionSheet.addAction(UIAlertAction(title: "Take photo", style: UIAlertActionStyle.Default, handler: { (action) in
            //TODO check camera permissions
            self.showImagePickerWithSource(.Camera, sender: sender)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Use photo library", style: UIAlertActionStyle.Default, handler: { (action) in
            self.showImagePickerWithSource(.PhotoLibrary, sender: sender)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        actionSheet.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        actionSheet.popoverPresentationController?.sourceView = sender as? UIView
        
    }
    
    private func showImagePickerWithSource(source: UIImagePickerControllerSourceType, sender: AnyObject){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        self.presentViewController(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        picker.popoverPresentationController?.sourceView = sender as? UIView
    }
    
  }