//
//  CollectionViewCell.swift
//  UIUXApps_Assignment
//
//  Created by Sai Naveen Katla on 5/17/23.
//

import UIKit
import SDWebImage

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var mealName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mealImage.contentMode = .scaleAspectFill
        mealImage.layer.cornerRadius = 25
        mealName.numberOfLines = 0
        
        bgView.layer.borderColor = UIColor.separator.withAlphaComponent(0.1).cgColor
        bgView.layer.borderWidth = 0.3
    }
    
    func setUpView(imgURL: String, name: String) {
        mealName.text = name
        mealName.font = FontHelper.normal
        mealImage.sd_setImage(with: URL(string: imgURL))
    }
    
    static func getCellSize(name: String) -> CGSize {
        let imageHeight: CGFloat = 50
        let labelHeight: CGFloat = FontHelper.heightForView(text: name, font: FontHelper.normal, width: UIScreen.main.bounds.width - 50 - 16 - 60)
        return .init(width: UIScreen.main.bounds.width, height: imageHeight > labelHeight ? imageHeight + 30 : labelHeight + 30)
    }

}
