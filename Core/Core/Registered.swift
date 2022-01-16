//
//  Registered.swift
//  Walnut
//
//  Created by Joshua Grant on 7/22/21.
//

import UIKit

public protocol Registered
{
    associatedtype Cell: UICollectionViewCell
    static var registration: UICollectionView.CellRegistration<Cell, Self> { get }
}
