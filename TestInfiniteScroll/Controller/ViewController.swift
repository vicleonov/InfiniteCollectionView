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
    let collectionMultiplier = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionViewCell")

        collectionView.reloadData()
        
        collectionView.scrollToItem(at: IndexPath(row: bannerImages.count, section: 0), at: .left, animated: false)
    }

//    func scrollCentered(indexPath indexPath: IndexPath, animated: Bool) {
//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        var attr = layout.layoutAttributesForItem(at: indexPath)
//        var shift = (collectionView.frame.size.width - attr!.size.width) / 2
//        collectionView.contentOffset = CGPoint(x: (attr!.frame.origin.x - shift), y: 0)
//    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerImages.count * collectionMultiplier
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as? BannerCollectionViewCell
        
//        let imageUrl = URL(string: "https://picsum.photos/id/\(indexPath.row)/900/1000")
//        let placeholderImgage = #imageLiteral(resourceName: "Placeholder")
        
        
        let originCount = Float(bannerImages.count)
        let index = Int(Float(indexPath.item).truncatingRemainder(dividingBy: originCount))
        bannerCell?.imageView.image = bannerImages[index]
//        bannerCell?.imageView.kf.setImage(wit h: imageUrl, placeholder: placeholderImgage)
//        bannerCell?.cellWidth.constant = collectionView.bounds.height / 1.3
        
        return bannerCell ?? UICollectionViewCell()

    }
    
}

extension ViewController: UICollectionViewDelegate {

    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = collectionView.frame.width*0.8
        let cellHeight =  collectionView.frame.height - layout.sectionInset.top*2
        return CGSize(width: cellWidth, height: cellHeight)
    }

//    - (void)collectionView:(UICollectionView *)collectionView didUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
//    {
//        // As we are not using the default scrollable feature from the UIScrollView,
//        // we can scroll ourself to the center of the focused cell
//        if (context.nextFocusedIndexPath && !collectionView.scrollEnabled) {
//
//          [collectionView scrollToItemAtIndexPath:context.nextFocusedIndexPath
//                                 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
//                                         animated:YES];
//        }

}
