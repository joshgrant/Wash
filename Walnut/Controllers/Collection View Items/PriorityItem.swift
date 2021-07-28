//
//  PriorityItem.swift
//  Walnut
//
//  Created by Joshua Grant on 7/22/21.
//

import UIKit

final class PriorityItem: Hashable, Identifiable
{
    // MARK: - Variables
    
    let id = UUID()
    
    let text: String
    let secondaryText: String
    
    // MARK: - Initialization
    
    init(text: String, secondaryText: String)
    {
        self.text = text
        self.secondaryText = secondaryText
    }
    
    // MARK: - Equatable
    
    static func == (lhs: PriorityItem, rhs: PriorityItem) -> Bool
    {
        lhs.id == rhs.id
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
}

extension PriorityItem: Registered
{
    var registration: UICollectionView.CellRegistration<UICollectionViewListCell, PriorityItem>
    {
        .init { cell, indexPath, item in
            var configuration = UIListContentConfiguration.valueCell()
            configuration.text = item.text
            configuration.secondaryText = item.secondaryText
            cell.contentConfiguration = configuration
            cell.accessories = [.disclosureIndicator()]
        }
    }
}
