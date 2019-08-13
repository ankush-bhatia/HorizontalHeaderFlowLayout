//
//  HeaderFlowLayout.swift
//  CustomFlowLayoutDemo
//
//  Created by Ankush Bhatia on 09/08/19.
//  Copyright © 2019 Ankush Bhatia. All rights reserved.
//

import UIKit

@objc public protocol HeaderFlowLayoutDelegate: class {
    @objc optional func collectionView(_ collectionView: UICollectionView, headerSectionInsetAt section: Int) -> UIEdgeInsets
    @objc optional func collectionView(_ collectionView: UICollectionView, headerItemSizeAtIndexPath indexPath: IndexPath) -> CGSize
    @objc optional func collectionView(_ collectionView: UICollectionView, interItemSpacingForSection section: Int) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, headerSizeForSection section: Int) -> CGSize
}

public class HeaderFlowLayout: UICollectionViewLayout {
    
    // MARK: - Properties
    weak var delegate: HeaderFlowLayoutDelegate?

    var headerAttributes: [IndexPath: UICollectionViewLayoutAttributes] {
        get {
            return getSectionHeaderAttributes()
        }
    }
    
    var itemAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    var currentX: CGFloat = 0.0
    var currentY: CGFloat = 0.0

    /// Provides content size to collectionView
    override public var collectionViewContentSize: CGSize {
        get {
            return contentSize()
        }
    }

    /// Prepares item attributes for the collectionView
    override public func prepare() {
        prepareItemAttributes()
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)
        var finalAttributes = [UICollectionViewLayoutAttributes]()
        for (_, attribute) in itemAttributes {
            if rect.intersects(attribute.frame) {
                finalAttributes.append(attribute)
            }
        }
        
        let sectionHeaderAttributes = Array(headerAttributes.values)
        return finalAttributes + sectionHeaderAttributes
    }

    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath]
    }

    override public func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                                       at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return headerAttributes[indexPath]
        default:
            return nil
        }

    }

    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

//    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//
//    }
//
//    override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//
//    }

//    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
//
//    }

}

// MARK: - Prepare Item Attributes
extension HeaderFlowLayout {
    func prepareItemAttributes() {
        guard let _collectionView = collectionView else {
            return
        }
        resetAttributes()
        let sectionCount = _collectionView.numberOfSections
        guard sectionCount > 0 else {
            return
        }
        for section in 0..<sectionCount {
            let itemCount = _collectionView.numberOfItems(inSection: section)
            guard itemCount > 0 else {
                continue
            }
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)
                let attribute = itemAttributes(at: indexPath)
                itemAttributes[indexPath] = attribute
            }
        }
    }
    
    private func resetAttributes() {
        itemAttributes.removeAll()
        currentX = 0.0
        currentY = 0.0
    }
    
    private func itemAttributes(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.alpha = 1.0
        let itemSize = sizeOfItem(at: indexPath)
        attributes.frame = CGRect(origin: itemOrigin(for: indexPath),
                                  size: itemSize)
        updateVariables(for: itemSize,
                        atIndexPath: indexPath)
        return attributes
    }

    private func itemOrigin(for indexPath: IndexPath) -> CGPoint {
        var origin: CGPoint = .zero
        origin.x = currentX
        if indexPath.section == 0 && indexPath.row == 0 {
            let sectionInset = inset(forSection: indexPath.section)
            currentY = sectionInset.top + sizeOfHeader(atSection: indexPath.section).height
        }
        origin.y = currentY
        return origin
    }

    private func updateVariables(for frame: CGSize,
                                 atIndexPath indexPath: IndexPath) {
        let sectionInset = inset(forSection: indexPath.section)
        currentX += frame.width + itemSpacing(forSection: indexPath.section)
        currentY = sectionInset.top + sizeOfHeader(atSection: indexPath.section).height
    }

    private func sizeOfItem(at indexPath: IndexPath) -> CGSize {
        let defaultSize: CGSize = .zero
        guard let _collectionView = collectionView,
            let delegate = _collectionView.delegate as? HeaderFlowLayoutDelegate else {
            return defaultSize
        }
        return delegate.collectionView?(_collectionView, headerItemSizeAtIndexPath: indexPath) ?? defaultSize
    }

    private func itemSpacing(forSection section: Int) -> CGFloat {
        let defaultItemSpacing: CGFloat = 0.0
        guard let _collectionView = collectionView,
            let delegate = _collectionView.delegate as? HeaderFlowLayoutDelegate else {
                return defaultItemSpacing
        }
        return delegate.collectionView?(_collectionView, interItemSpacingForSection: section) ?? defaultItemSpacing
    }
    
}

// MARK: - Header Attributes
extension HeaderFlowLayout {
    private func getSectionHeaderAttributes() -> [IndexPath: UICollectionViewLayoutAttributes] {
        guard let _collectionView = collectionView else {
            return [:]
        }
        let noOfSections = _collectionView.numberOfSections
        guard noOfSections > 0 else {
            return [:]
        }
        var attributes = [IndexPath: UICollectionViewLayoutAttributes]()
        for section in 0..<noOfSections {
            let indexPath = IndexPath(row: 0, section: section)
            attributes[indexPath] = headerAttributes(atIndexPath: indexPath)
        }
        return attributes
    }
    
    private func headerAttributes(atIndexPath indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                          with: indexPath)
        let origin = headerOrigin(atIndexPath: indexPath)
        let size = sizeOfHeader(atSection: indexPath.section)
        attributes.frame = CGRect(x: origin.x,
                                  y: origin.y,
                                  width: size.width,
                                  height: size.height)
        return attributes
    }

    private func sizeOfHeader(atSection section: Int) -> CGSize {
        let defaultSize: CGSize = .zero
        guard let _collectionView = collectionView,
            let delegate = _collectionView.delegate as? HeaderFlowLayoutDelegate else {
            return defaultSize
        }
        return delegate.collectionView?(_collectionView, headerSizeForSection: section) ?? defaultSize
    }
    
    private func headerOrigin(atIndexPath indexPath: IndexPath) -> CGPoint {
        if let itemsCount = collectionView?.numberOfItems(inSection: indexPath.section),
            let firstItemAttributes = layoutAttributesForItem(at: indexPath),
            let lastItemAttributes = layoutAttributesForItem(at: IndexPath(row: itemsCount-1, section: indexPath.section)){
            let edgeX = collectionView!.contentOffset.x + collectionView!.contentInset.left
            let xByLeftBoundary = max(edgeX,firstItemAttributes.frame.minX)
            //
            let width = sizeOfHeader(atSection: indexPath.section).width
            let xByRightBoundary = lastItemAttributes.frame.maxX - width
            let x = min(xByLeftBoundary,xByRightBoundary)
            return CGPoint(x: x, y: 0)
        }else{
            return CGPoint(x: inset(forSection: indexPath.section).left,
                           y:0)
        }
    }

}

// MARK: - Content Size
extension HeaderFlowLayout {
    private func contentSize() -> CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }
        var maxX: CGFloat = 0.0
        
        let lastSectionIndex = collectionView.numberOfSections - 1
        let lastIndexInSection = collectionView.numberOfItems(inSection: lastSectionIndex) - 1
        let lastIndexPath = IndexPath(item: lastIndexInSection, section: lastSectionIndex)
        if let lastItemAttributes = layoutAttributesForItem(at: lastIndexPath) {
            maxX = lastItemAttributes.frame.maxX
        } else {
            maxX = 0.0
        }

        let contentWidth = maxX + inset(forSection: lastSectionIndex).right
        let contentHeight = collectionView.bounds.size.height - collectionView.contentInset.top - collectionView.contentInset.bottom
        return CGSize(width: contentWidth, height: contentHeight)
    }
}

// MARK: - General Functions
extension HeaderFlowLayout {
    private func inset(forSection section: Int) -> UIEdgeInsets {
        let defaultInsets = UIEdgeInsets.zero
        guard let _collectionView = collectionView,
            let delegate = _collectionView.delegate as? HeaderFlowLayoutDelegate,
            section >= 0 else {
            return defaultInsets
        }
        return delegate.collectionView?(_collectionView, headerSectionInsetAt: section) ?? defaultInsets
    }
}
