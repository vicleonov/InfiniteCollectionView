//
//  ViewController.swift
//  TestInfiniteScroll
//
//  Created by Виктор Леонов on 29.01.2020.
//  Copyright © 2020 Viktor Leonov. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let bannersNumber = 9
    let bannerImages = [#imageLiteral(resourceName: "Image11"), #imageLiteral(resourceName: "Image12"), #imageLiteral(resourceName: "Image7"), #imageLiteral(resourceName: "Image10"), #imageLiteral(resourceName: "Image8"), #imageLiteral(resourceName: "Image6"), #imageLiteral(resourceName: "Image4"), #imageLiteral(resourceName: "Image5")]
    
    //https://picsum.photos/id/237/200/300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionViewCell")
        
        collectionView.reloadData()
    }


}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannersNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as? BannerCollectionViewCell
        
        let imageUrl = URL(string: "https://picsum.photos/id/\(indexPath.row)/900/1000")
        let placeholderImgage = #imageLiteral(resourceName: "Placeholder")
        bannerCell?.imageView.kf.setImage(with: imageUrl, placeholder: placeholderImgage)
        bannerCell?.cellWidth.constant = collectionView.bounds.height / 1.3
        
        return bannerCell ?? UICollectionViewCell()

    }
    
}

