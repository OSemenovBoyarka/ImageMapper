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
    
    static func viewWithLink(link: Hyperlink) -> HyperlinkView{
        let view = NSBundle.mainBundle().loadNibNamed("HyperlinkView", owner: self, options: nil)[0] as! HyperlinkView
        view.hyperLink = link
        view.autoresizingMask = UIViewAutoresizing.None
        return view;
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        let size = CGFloat(hyperLink!.size);
        self.frame = CGRectMake(0, 0, size, size)
    }
    
    override func drawRect(rect: CGRect) {
        self.layer.borderColor =  UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7).CGColor
        self.layer.borderWidth = 1
        
        if let superSize = self.superview?.frame.size{
            let x = hyperLink!.centerX * Double(superSize.width)
            let y = hyperLink!.centerY * Double(superSize.height)
            self.center = CGPoint(x: x,y: y)
        }
    }
}
