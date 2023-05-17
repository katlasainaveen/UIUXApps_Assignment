//
//  ViewController.swift
//  UIUXApps_Assignment
//
//  Created by Sai Naveen Katla on 5/17/23.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var loader: LottieAnimationView = {
        let loader = LottieAnimationView()
        loader.frame = .init(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 100, width: 200, height: 200)
        loader.animation = .named("loading")
        loader.animationSpeed = 2
        loader.contentMode = .scaleAspectFit
        loader.loopMode = .loop
        
        return loader
    }()
    
    private var data: [Meal] = []
    
    var detailsDelegate: IDSendingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
        setUpLottieView()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        titleLabel.font = FontHelper.bold
        titleLabel.numberOfLines = 0
        
        makeAPICall()
    }
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true
        titleLabel.isHidden = true
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    func setUpLottieView() {
        loader.play()
        self.view.addSubview(loader)
        loader.isHidden = false
    }

}

//MARK:- API Call
extension ViewController {
    
    func makeAPICall() {
        TheAPIHub.shared.getAllMeals { [weak self] result in
            switch result {
            case .success(let data):
                let data_ = data?.meals?.compactMap({ m -> Meal? in
                    guard let id = m.idMeal,
                          let name = m.strMeal,
                          let image = m.strMealThumb else {
                        return nil
                    }
                    
                    return Meal(strMeal: name, strMealThumb: image, idMeal: id)
                })
                
                if let data_ = data_ {
                    DispatchQueue.main.async {
                        self?.data = data_.sorted(by: { m1, m2 in
                            m1.strMeal ?? String() < m2.strMeal ?? String()
                        })
                        self?.collectionView.reloadData()
                        
                        self?.loader.isHidden = true
                        self?.collectionView.isHidden = false
                        self?.titleLabel.isHidden = false
                    }
                }
                
            case .failure(_):
                DispatchQueue.main.async {
                    self?.loader.isHidden = false
                    self?.collectionView.isHidden = true
                    self?.titleLabel.isHidden = true
                }
            }
        }
    }
    
}

//MARK:- CollectionView Funcs
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let details = data[indexPath.row]
        
        cell.setUpView(imgURL: details.strMealThumb!, name: details.strMeal!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CollectionViewCell.getCellSize(name: data[indexPath.row].strMeal!)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedID = data[indexPath.row].idMeal
        
        let detailsScreen = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
        self.detailsDelegate = detailsScreen
        self.navigationController?.pushViewController(detailsScreen, animated: true)
        
        self.detailsDelegate?.openDetailsFor(id: selectedID!)
    }
    
}

//MARK:- IDSendingDelegate
protocol IDSendingDelegate {
    func openDetailsFor(id: String)
}
