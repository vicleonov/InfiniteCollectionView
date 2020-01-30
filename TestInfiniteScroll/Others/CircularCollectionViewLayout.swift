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
        
        let contentHeight = super.collectionViewContentSize.height
        let contentWidth = super.collectionViewContentSize.width
        
        let minLineSpacing = self.minimumLineSpacing
        let horizontalOffset = self.collectionView?.contentOffset.x ?? 0
        let verticalOffset = self.collectionView?.contentOffset.y ?? 0
        
        let rightContentEdge =  contentWidth + minLineSpacing
        let leftContentEdge = CGFloat(0.0)
        let topContentEdge = CGFloat(0.0)
        let bottomContentEdge = contentHeight + minLineSpacing
        
        // Changing collectionView offset after reaching its content edges
        switch self.scrollDirection {
        case .vertical:
            if verticalOffset <= topContentEdge {
                self.collectionView?.contentOffset = CGPoint(x: horizontalOffset, y: contentHeight + minLineSpacing)
            } else if verticalOffset > bottomContentEdge {
                self.collectionView?.contentOffset = CGPoint(x: horizontalOffset, y: 0.0)
            }
        case .horizontal:
            if horizontalOffset <= leftContentEdge {
                self.collectionView?.contentOffset = CGPoint(x: contentWidth + minLineSpacing, y: verticalOffset)
            } else if horizontalOffset > rightContentEdge {
                self.collectionView?.contentOffset = CGPoint(x: 0.0, y: verticalOffset)
            }
        @unknown default: fatalError("Correct prepare method for CircularCollectionViewLayout")
        }
        
        super.prepare()
    }
    
    override var collectionViewContentSize: CGSize {
        
        let contentHeight = super.collectionViewContentSize.height
        let contentWidth = super.collectionViewContentSize.width
        
        let minLineSpacing = self.minimumLineSpacing
        let collectionViewHeight = self.collectionView?.bounds.size.height ?? 0
        let collectionViewWidth = self.collectionView?.bounds.size.width ?? 0
        
        // Adding collectionView's height/width to the contentSize to allow changing offset unnoticeably without any screen artifacts
        switch self.scrollDirection {
        case .vertical: return CGSize(width: contentWidth, height: contentHeight + collectionViewHeight + minLineSpacing)
        case .horizontal: return CGSize(width: contentWidth + collectionViewWidth + minLineSpacing, height: contentHeight)
        @unknown default: fatalError("Correct collectionViewContentSize method for CircularCollectionViewLayout")
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        let contentHeight = super.collectionViewContentSize.height
        let contentWidth = super.collectionViewContentSize.width
        
        let collectionViewHeight = self.collectionView?.bounds.size.height ?? 0
        let collectionViewWidth = self.collectionView?.bounds.size.width ?? 0
        
        switch self.scrollDirection {
        case .vertical:
            if (newBounds.origin.y <= collectionViewHeight) || (newBounds.origin.y >= contentHeight - collectionViewHeight) {
                return true
            }
        case .horizontal:
            if (newBounds.origin.x <= collectionViewWidth) || (newBounds.origin.x >= contentWidth - collectionViewWidth) {
                return true
            }
        @unknown default: fatalError("Correct shouldInvalidateLayout method for CircularCollectionViewLayout")
        }
        
        return super.shouldInvalidateLayout(forBoundsChange: newBounds)
    }
    

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
        
        if self.scrollDirection == .vertical {
            
            let wrappingAttributes = super.layoutAttributesForElements(in: CGRect(x: rect.origin.x,
                                                                                  y: rect.origin.y - super.collectionViewContentSize.height,
                                                                                  width: rect.size.width,
                                                                                  height: rect.size.height))
            
            wrappingAttributes?.forEach({ attributes in
                attributes.center = CGPoint(x: attributes.center.x,
                                            y: attributes.center.y + super.collectionViewContentSize.height + self.minimumLineSpacing)
            })
            
            layoutAttributes += wrappingAttributes ?? []

        } else {
            
            let wrappingAttributes = super.layoutAttributesForElements(in: CGRect(x: rect.origin.x - super.collectionViewContentSize.width,
                                                                                  y: rect.origin.y,
                                                                                  width: rect.size.width,
                                                                                  height: rect.size.height))
            
            wrappingAttributes?.forEach({ attributes in
                attributes.center = CGPoint(x: attributes.center.x + super.collectionViewContentSize.width + self.minimumLineSpacing,
                                            y: attributes.center.y)
            })
            
            layoutAttributes += wrappingAttributes ?? []
            
        }
        
        return layoutAttributes
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = super.layoutAttributesForItem(at: indexPath)
        layoutAttributes?.center = CGPoint(x: (layoutAttributes?.center.x ?? 0) + (self.collectionView?.bounds.size.width ?? 0), y: layoutAttributes?.center.y ?? 0)
        
        return layoutAttributes
    }

}
