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
}

public class HeaderFlowLayout: UICollectionViewLayout {
    
    // MARK: - Properties
    weak var delegate: HeaderFlowLayoutDelegate?
    var sectionHeaderAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]

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

        // TODO: - Add Header Attributes
        return finalAttributes
    }

    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath]
    }

//    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//
//    }
//
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
        attributes.frame = CGRect(origin: itemOrigin(),
                                  size: itemSize)
        updateVariables(for: itemSize,
                        atIndexPath: indexPath)
        return attributes
    }

    private func itemOrigin() -> CGPoint {
        var origin: CGPoint = .zero
        origin.x = currentX
        origin.y = currentY
        return origin
    }

    private func updateVariables(for frame: CGSize,
                                 atIndexPath indexPath: IndexPath) {
        currentX += frame.width + itemSpacing(forSection: indexPath.section)
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
