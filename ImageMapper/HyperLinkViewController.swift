//
//  DetailViewController.swift
//  ImageMapper
//
//  Created by Alexander Semenov on 10/22/15.
//
//

import UIKit

class HyperLinkViewController: UIViewController {


    @IBOutlet weak var rootImage: UIImageView!

    var document: Document? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
}

