//
//  HyperlinkView.swift
//  ImageMapper
//
//  Created by Alexander Semenov on 10/24/15.
//
//

import Foundation
import UIKit

class HyperlinkView: UIView {
    
    weak var hyperLink: Hyperlink?
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect);
        self.layer.borderColor = UIColor.redColor().CGColor
        self.layer.borderWidth = 2
    }
    
    

}
