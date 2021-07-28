//
//  DetailItem.swift
//  Walnut
//
//  Created by Joshua Grant on 7/28/21.
//

import UIKit

struct DetailItem: Hashable, Identifiable
{
    // MARK: - Variables
    
    var id = UUID()
    
    var text: String
    
    // MARK: - Equatable
    
    static func == (lhs: DetailItem, rhs: DetailItem) -> Bool
    {
        lhs.id == rhs.id
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
}

extension DetailItem: Registered
{
    var registration: UICollectionView.CellRegistration<UICollectionViewListCell, DetailItem>
    {
        .init { cell, indexPath, item in
            var configuration = UIListContentConfiguration.cell()
            configuration.text = item.text
            cell.contentConfiguration = configuration
            cell.accessories = [.disclosureIndicator()]
        }
    }
}
