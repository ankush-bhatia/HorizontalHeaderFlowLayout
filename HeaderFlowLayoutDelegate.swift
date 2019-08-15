//
//  HeaderFlowLayoutDelegate.swift
//  HorizontalHeaderFlowLayout
//
//  Created by Ankush Bhatia on 16/08/19.
//

import Foundation

@objc public protocol HeaderFlowLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, itemSizeAtIndexPath indexPath: IndexPath) -> CGSize
    @objc optional func collectionView(_ collectionView: UICollectionView, sectionInsetAt section: Int) -> UIEdgeInsets
    @objc optional func collectionView(_ collectionView: UICollectionView, interItemSpacingForSection section: Int) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, headerSizeForSection section: Int) -> CGSize
}
