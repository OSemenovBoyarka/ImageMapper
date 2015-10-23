//
//  DetailViewController.swift
//  ImageMapper
//
//  Created by Alexander Semenov on 10/22/15.
//
//

import UIKit

class HyperLinkViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    var link: Hyperlink? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
//        if let detail = self.link {
//            if let label = self.detailDescriptionLabel {
//                label.text = detail.valueForKey("")!.description
//            }
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

