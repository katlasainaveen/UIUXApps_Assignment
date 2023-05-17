//
//  DetailsViewController.swift
//  UIUXApps_Assignment
//
//  Created by Sai Naveen Katla on 5/17/23.
//

import UIKit
import Lottie

class DetailsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var countryOrginLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var removePlayer: Bool = false
    
    private var loader: LottieAnimationView = {
        let loader = LottieAnimationView()
        loader.frame = .init(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 100, width: 200, height: 200)
        loader.animation = .named("loading")
        loader.animationSpeed = 2
        loader.contentMode = .scaleAspectFit
        loader.loopMode = .loop
        
        return loader
    }()
    
    var data: MealLookUp = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLottieView()
        setUpUI()
    }

    private func setUpUI() {
        backButton.imageView?.tintColor = .black
        backButton.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "DetailsCollectionView", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        countryOrginLabel.font = FontHelper.light_small
    }
    
    func setUpLottieView() {
        loader.play()
        self.view.addSubview(loader)
        loader.isHidden = false
        collectionView.isHidden = true
    }
    
    @objc func backClicked() {
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK:- CollectionView Funcs
extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DetailsCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DetailsCollectionView
        cell.setUpUI(with: data)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return DetailsCollectionView.getCellSize(with: data)
    }
    
}

//MARK:- IDSendingDelegate
extension DetailsViewController: IDSendingDelegate {
    
    func openDetailsFor(id: String) {
        TheAPIHub.shared.getMealDetails(with: id) { [weak self] result in
            switch result {
            case .success(let data):
                if let data = data?.meals?.first {
                    self?.data = data
                    
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                        self?.loader.isHidden = true
                        self?.collectionView.isHidden = false
                        self?.countryOrginLabel.text = (data.strCategory ?? String()) + " | " + (data.strArea ?? String())
                    }
                }
                
            case .failure(_):
                DispatchQueue.main.async {
                    self?.loader.isHidden = false
                    self?.collectionView.isHidden = true
                }
            }
        }
    }
    
}
