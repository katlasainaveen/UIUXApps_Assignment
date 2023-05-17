//
//  DetailsCollectionView.swift
//  UIUXApps_Assignment
//
//  Created by Sai Naveen Katla on 5/17/23.
//

import UIKit
import SDWebImage

class DetailsCollectionView: UICollectionViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var sourceButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var instructionsTitle: UILabel!
    @IBOutlet weak var ytButton: UIImageView!
    @IBOutlet weak var instructions: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var data: MealLookUp = .init()
    var ingredientsToMeasures: [(String, String)] = []
    
    func setUpUI(with data: MealLookUp) {
        self.data = data
        self.ingredientsToMeasures = data.mapIngredientsToMeasures()
        
        mainImage.layer.cornerRadius = 21
        mainImage.contentMode = .scaleToFill
        name.numberOfLines = 0
        instructions.numberOfLines = 0
        
        mainImage.sd_setImage(with: URL(string: data.strMealThumb ?? String()))
        name.text = data.strMeal
        name.font = FontHelper.bold
        instructionsTitle.font = FontHelper.bold
        instructions.text = data.strInstructions
        instructions.font = FontHelper.normal
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "IngredientsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        if let _ = data.strSource {
            sourceButton.imageView?.tintColor = .black
            sourceButton.addTarget(self, action: #selector(sourceClicked), for: .touchUpInside)
            sourceButton.isHidden = false
        }
        else {
            sourceButton.isHidden = true
        }
        
        if let _ = data.strYoutube {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ytClicked(tapGestureRecognizer:)))
            ytButton.isUserInteractionEnabled = true
            ytButton.addGestureRecognizer(tapGesture)
            ytButton.isHidden = false
        }
        else {
            ytButton.isHidden = true
        }
        
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    @objc func sourceClicked() {
        if let url = URL(string: data.strSource ?? String()) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func ytClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        if let url = URL(string: data.strYoutube ?? String()) {
            UIApplication.shared.open(url)
        }
    }
    
    static func getCellSize(with data: MealLookUp) -> CGSize {
        var height: CGFloat = 250 // image height
        height += (4*21) // padding
        height += FontHelper.heightForView(text: "Instructions:", font: FontHelper.bold, width: UIScreen.main.bounds.width - 60)
        height += FontHelper.heightForView(text: data.strInstructions ?? String(), font: FontHelper.normal, width: UIScreen.main.bounds.width - 60)
        height += FontHelper.heightForView(text: data.strMeal ?? String(), font: FontHelper.bold, width: UIScreen.main.bounds.width - 60)
        
        for i in data.mapIngredientsToMeasures() {
            height += IngredientsCollectionViewCell.getCellSize(with: i.0, text2: i.1).height
        }
        
        return .init(width: UIScreen.main.bounds.width, height: height + 30 + 10)
    }

}

//MARK:- CollectionView Funcs
extension DetailsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredientsToMeasures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: IngredientsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! IngredientsCollectionViewCell
        let texts = ingredientsToMeasures[indexPath.row]
        cell.setUpUI(text1: texts.0, text2: texts.1)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let texts = ingredientsToMeasures[indexPath.row]
        
        return IngredientsCollectionViewCell.getCellSize(with: texts.0, text2: texts.1)
    }
    
}
