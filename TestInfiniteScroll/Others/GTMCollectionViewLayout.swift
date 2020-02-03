//
//  GTMCollectionLayout.swift
//  GameTimer
//
//  Created by Roman Sch on 24/06/2019.
//  Copyright © 2019 Roman Sch. All rights reserved.
//

import UIKit

protocol GTMCollectionViewLayoutDelegate: AnyObject {
    
    //section?
    func numberOfItemInCollectionView() -> Int
    func heightForCellAt(indexPath: IndexPath) -> CGFloat
    func heightForHeader(in section: Int) -> CGFloat
}

class GTMCollectionViewLayout: UICollectionViewLayout {
    
    fileprivate var numberOfColumns = 2
    fileprivate var cellPadding: CGFloat = 10
    fileprivate var cellPaddingSide: CGFloat = 2
    fileprivate var defaultCellHeight: CGFloat = 200

    fileprivate var sectionInset = UIEdgeInsets(top: 150, left: 20, bottom: 150, right: 20)
    
    enum LayoutDirection {
        case horizontal
        case vertical
    }
    
    var direction: LayoutDirection = .horizontal
    
    weak var delegate: GTMCollectionViewLayoutDelegate?

    //frames attributes
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = self.collectionView else { return 0 }
        return (direction == .horizontal ? collectionView.bounds.width : collectionView.bounds.height) - sectionInset.left - sectionInset.right
    }

    fileprivate var yOffset = [CGFloat]()

    // MARK: - UICollectionViewLayout

    override var collectionViewContentSize: CGSize {

        if self.direction == .horizontal {
            return CGSize(width: contentWidth, height: contentHeight)
        } else {
            return CGSize(width: contentHeight, height: contentWidth)
        }
    }

    override public func invalidateLayout() {

        cache.removeAll()
        contentHeight = 0
        yOffset = [CGFloat]()

        super.invalidateLayout()
    }

    override func prepare() {
        super.prepare()
        
        guard cache.isEmpty, let collectionView = self.collectionView else { return }
        for section in 0..<collectionView.numberOfSections {
            var column = 0
            updateOffsetSection(with: numberOfColumns)
            for item in 0..<collectionView.numberOfItems(inSection: section) {

                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                var frame = frameForCell(in: column, and: indexPath, and: direction)
                
                attributes.frame = frame
                
                cache.append(attributes)

                updateOffset(for: column, with: frame, and: direction)
                contentHeight = max(contentHeight, direction == .horizontal ? frame.maxY : frame.maxX)
                
                column = column < (numberOfColumns - 1) ? column + 1 : 0
            }
            contentHeight += sectionInset.bottom
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }
        visibleLayoutAttributes.append(self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0))!)
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        return cache[indexPath.item * (indexPath.section + 1)]
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        print(indexPath.section)
        print(elementKind)
        var supplementaryViewAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        supplementaryViewAttributes.frame = CGRect(x: 0, y: yOffset[0], width: 200, height: 200)
        return supplementaryViewAttributes
    }

    override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.initialLayoutAttributesForAppearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)
    }

    // MARK: - calculate size

    private func updateOffsetSection(with numberOfColumns: Int) {
        yOffset = Array(repeating: (yOffset.max() ?? 0.0) + sectionInset.top, count: numberOfColumns)
    }

    private func updateOffset(for column: Int, with frame: CGRect, and direction: LayoutDirection) {
        switch direction {
        case .horizontal:
            yOffset[column] = frame.maxY
        case .vertical:
            yOffset[column] = frame.maxX
        }
    }

    private func offsetForCell(in column: Int, and indexPath: IndexPath) -> CGPoint {
        let xOffset = (0..<column).reduce(into: sectionInset.left) { $0 = $0 + widthForColumn($1) }
        return CGPoint(x: xOffset, y: yOffset[column])
    }
    
    private func widthForColumn(_ column: Int) -> CGFloat {
        return contentWidth / CGFloat(numberOfColumns)
    }
    
    private func heightForCell(in column: Int, and indexPath: IndexPath) -> CGFloat {
        return cellPadding * 2 + (delegate?.heightForCellAt(indexPath: indexPath) ?? defaultCellHeight)
    }

    private func frameForCell(in column: Int, and indexPath: IndexPath, and direction: LayoutDirection) -> CGRect {
        
        let offset = offsetForCell(in: column, and: indexPath)
        
        let frame = CGRect(x: offset.x,
                           y: offset.y,
                           width: widthForColumn(column),
                           height: heightForCell(in: column, and: indexPath))
        
        let insetFrame = frame.insetBy(dx: cellPaddingSide, dy: cellPadding)


        if self.direction == .vertical {
            return CGRect(x: insetFrame.minY, y: insetFrame.minX, width: insetFrame.height, height: insetFrame.width)
        }
        return insetFrame
    }

}
