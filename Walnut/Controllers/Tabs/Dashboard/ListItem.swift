//
//  ListItem.swift
//  Walnut
//
//  Created by Joshua Grant on 7/20/21.
//

import Foundation
import UIKit

protocol ListItem: Hashable
{
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Self> { get }
}
