//
//  CircularFlowLayout.swift
//  TestInfiniteScroll
//
//  Created by Виктор Леонов on 29.01.2020.
//  Copyright © 2020 Viktor Leonov. All rights reserved.
//

import UIKit

import UIKit

class CircularCollectionViewLayout: UICollectionViewFlowLayout {
    
    private var isScrolling = false
//    override func invalidateLayout() {
//        super.invalidateLayout()
//
//        self.collectionView?.setContentOffset(CGPoint(x: -200, y: 0), animated: false)
//    }
//
    override func prepare() {
        let contentOffset = self.collectionView?.contentOffset ?? CGPoint()
        let contentSize = super.collectionViewContentSize
        
        let rightContentEdge =  contentSize.width + minimumLineSpacing
        let leftContentEdge = CGFloat(0.0)
        
        // Changing collectionView offset after reaching its content edges
        if contentOffset.x <= leftContentEdge && !isScrolling {
            self.collectionView?.contentOffset.x = rightContentEdge
        } else if contentOffset.x > rightContentEdge {
            self.collectionView?.contentOffset.x = leftContentEdge
        }
//        updateInsets()
        super.prepare()
    }
    
//    private func updateInsets() {
//      guard let collectionView = collectionView,
//        let itemAttribute = layoutAttributesForItem(at: IndexPath(row: 0, section: 0)) else { return }
//        collectionView.contentInset.left = 40.0 //(collectionView.bounds.size.width - itemAttribute.size.width) / 2
//    }
    
    override var collectionViewContentSize: CGSize {
        let contentSize = super.collectionViewContentSize
        let collectionViewSize = self.collectionView?.bounds.size ?? CGSize()
        
        // Adding collectionView's height/width to the contentSize to allow changing offset unnoticeably without any screen artifacts
        return CGSize(width: contentSize.width + collectionViewSize.width + minimumLineSpacing, height: contentSize.height)
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let contentSize = super.collectionViewContentSize
        
        var layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
        
        let newRect = CGRect(x: rect.origin.x - contentSize.width, y: rect.origin.y, width: rect.width, height: rect.height)
        if let wrappingAttributes = super.layoutAttributesForElements(in: newRect){
            wrappingAttributes.forEach{
                $0.center.x += contentSize.width + minimumLineSpacing
            }
            
            layoutAttributes += wrappingAttributes
        }
        
        return layoutAttributes
    }
    
//    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let collectionViewSize = self.collectionView?.bounds.size ?? CGSize()
//
//        let layoutAttributes = super.layoutAttributesForItem(at: indexPath)
//        layoutAttributes?.center.x += collectionViewSize.width
//
//        return layoutAttributes
//    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let collectionViewSize = self.collectionView?.bounds.size ?? CGSize()
        let contentSize = super.collectionViewContentSize
        
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath) else {
            return nil
        }
        layoutAttributes.center.x -= (collectionViewSize.width - layoutAttributes.size.width) / 2
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let contentSize = super.collectionViewContentSize
        let collectionViewSize = self.collectionView?.bounds.size ?? CGSize()
        
        if (newBounds.origin.x <= collectionViewSize.width) || (newBounds.origin.x >= contentSize.width - collectionViewSize.width) {
            return true
        }

        return super.shouldInvalidateLayout(forBoundsChange: newBounds)
    }
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        isScrolling = true
        
        let layoutAttributes = layoutAttributesForElements(in: collectionView!.bounds)

        var targetContentOffset = CGPoint()

        let collectionCenter = collectionView!.bounds.width / 2
        let proposedCentrationOffset = proposedContentOffset.x + collectionCenter

        let closest = layoutAttributes!.sorted{ abs($0.center.x - proposedCentrationOffset) < abs($1.center.x - proposedCentrationOffset) }.first ?? UICollectionViewLayoutAttributes()

        var stopPosition = floor(closest.center.x - collectionCenter)
        if stopPosition < 0 {
            let lastItem = layoutAttributesForItem(at: IndexPath(row: 8, section: 0)) // items count ...
            let currentOffset = self.collectionView?.contentOffset.x ?? CGFloat(0.0)
            stopPosition = lastItem?.frame.minX ?? CGFloat(0.0)
            self.collectionView?.contentOffset.x = stopPosition + currentOffset
        }

        targetContentOffset = CGPoint(x: stopPosition, y: proposedContentOffset.y)
        
        isScrolling = false
        return targetContentOffset
    }
}
