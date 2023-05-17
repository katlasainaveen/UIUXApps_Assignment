//
//  Fonts.swift
//  UIUXApps_Assignment
//
//  Created by Sai Naveen Katla on 5/17/23.
//

import UIKit

final class FontHelper {
    
    static let bold = UIFont(name: "HelveticaNeue-Bold", size: 20)!
    static let normal = UIFont(name: "HelveticaNeue", size: 16)!
    static let light = UIFont(name: "HelveticaNeue-Light", size: 16)!
    static let light_small = UIFont(name: "HelveticaNeue-Light", size: 12)!
    
    static func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
    
}
