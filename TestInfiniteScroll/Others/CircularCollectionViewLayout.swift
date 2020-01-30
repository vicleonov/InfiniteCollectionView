//
//  CircularFlowLayout.swift
//  TestInfiniteScroll
//
//  Created by Виктор Леонов on 29.01.2020.
//  Copyright © 2020 Viktor Leonov. All rights reserved.
//

import UIKit

class CircularCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        let minLineSpacing = self.minimumLineSpacing
        let contentOffset = self.collectionView?.contentOffset ?? CGPoint()
        let contentSize = super.collectionViewContentSize
        
        let rightContentEdge =  contentSize.width + minLineSpacing
        let leftContentEdge = CGFloat(0.0)
        let topContentEdge = CGFloat(0.0)
        let bottomContentEdge = contentSize.height + minLineSpacing
        
        // Changing collectionView offset after reaching its content edges
        switch self.scrollDirection {
        case .vertical:
            if contentOffset.y <= topContentEdge {
                self.collectionView?.contentOffset.y = bottomContentEdge
            } else if contentOffset.y > bottomContentEdge {
                self.collectionView?.contentOffset.y = topContentEdge
            }
        case .horizontal:
            if contentOffset.x <= leftContentEdge {
                self.collectionView?.contentOffset.x = rightContentEdge
            } else if contentOffset.x > rightContentEdge {
                self.collectionView?.contentOffset.x = leftContentEdge
            }
        @unknown default: fatalError("Correct prepare method for CircularCollectionViewLayout")
        }
        
        super.prepare()
    }
    
    override var collectionViewContentSize: CGSize {
        let minLineSpacing = self.minimumLineSpacing
        let contentSize = super.collectionViewContentSize
        let collectionViewSize = self.collectionView?.bounds.size ?? CGSize()
        
        // Adding collectionView's height/width to the contentSize to allow changing offset unnoticeably without any screen artifacts
        switch self.scrollDirection {
        case .vertical: return CGSize(width: contentSize.width, height: contentSize.height + collectionViewSize.height + minLineSpacing)
        case .horizontal: return CGSize(width: contentSize.width + collectionViewSize.width + minLineSpacing, height: contentSize.height)
        @unknown default: fatalError("Correct collectionViewContentSize method for CircularCollectionViewLayout")
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let contentSize = super.collectionViewContentSize
        let collectionViewSize = self.collectionView?.bounds.size ?? CGSize()

        switch self.scrollDirection {
        case .vertical:
            if (newBounds.origin.y <= collectionViewSize.height) || (newBounds.origin.y >= contentSize.height - collectionViewSize.height) {
                return true
            }
        case .horizontal:
            if (newBounds.origin.x <= collectionViewSize.width) || (newBounds.origin.x >= contentSize.width - collectionViewSize.width) {
                return true
            }
        @unknown default: fatalError("Correct shouldInvalidateLayout method for CircularCollectionViewLayout")
        }
    
        return super.shouldInvalidateLayout(forBoundsChange: newBounds)
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let minLineSpacing = self.minimumLineSpacing
        let contentSize = super.collectionViewContentSize
        
        var layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
        
        switch self.scrollDirection {
        case .vertical:
            let newRect = CGRect(x: rect.origin.x, y: rect.origin.y - contentSize.height, width: rect.width, height: rect.height)
            if let wrappingAttributes = super.layoutAttributesForElements(in: newRect) {
                wrappingAttributes.forEach{ $0.center.y += contentSize.height + minLineSpacing }
                layoutAttributes += wrappingAttributes
            }
        case .horizontal:
            let newRect = CGRect(x: rect.origin.x - contentSize.width, y: rect.origin.y, width: rect.width, height: rect.height)
            if let wrappingAttributes = super.layoutAttributesForElements(in: newRect){
                wrappingAttributes.forEach{ $0.center.x += contentSize.width + minLineSpacing }
                layoutAttributes += wrappingAttributes
            }
        @unknown default: fatalError("Correct generateLayoutAttributes method for CircularCollectionViewLayout")
        }
        
        return layoutAttributes
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let collectionViewSize = self.collectionView?.bounds.size ?? CGSize()
        
        let layoutAttributes = super.layoutAttributesForItem(at: indexPath)
        layoutAttributes?.center.x += collectionViewSize.width
        
        return layoutAttributes
    }

}
