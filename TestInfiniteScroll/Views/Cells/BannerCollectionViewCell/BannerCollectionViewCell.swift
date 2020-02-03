//
//  BannerCollectionViewCell.swift
//  TestInfiniteScroll
//
//  Created by Виктор Леонов on 30.01.2020.
//  Copyright © 2020 Viktor Leonov. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        self.layer.cornerRadius = 8
    }
    
    
}
