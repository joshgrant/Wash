//
//  Registered.swift
//  Walnut
//
//  Created by Joshua Grant on 7/22/21.
//

import UIKit

protocol Registered
{
    associatedtype Cell: UICollectionViewCell
    var registration: UICollectionView.CellRegistration<Cell, Self> { get }
}
