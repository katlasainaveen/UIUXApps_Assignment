//
//  IngredientsCollectionViewCell.swift
//  UIUXApps_Assignment
//
//  Created by Sai Naveen Katla on 5/17/23.
//

import UIKit

class IngredientsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setUpUI(text1: String, text2: String) {
        bgView.layer.borderColor = UIColor.separator.cgColor
        bgView.layer.borderWidth = 0.5
        
        label1.font = FontHelper.light
        label1.text = text1
        label2.font = FontHelper.light
        label2.text = text2
    }
    
    static func getCellSize(with text1: String, text2: String) -> CGSize {
        let height: CGFloat = FontHelper.heightForView(text: text1 + text2, font: FontHelper.light, width: UIScreen.main.bounds.width - 21 - 12 - 60)
        return .init(width: UIScreen.main.bounds.width - 60, height: height + 24)
    }

}
