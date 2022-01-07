//
//  ForecastItem.swift
//  Walnut
//
//  Created by Joshua Grant on 7/22/21.
//

import UIKit

final class ForecastItem: Hashable, Identifiable
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
    
    static func == (lhs: ForecastItem, rhs: ForecastItem) -> Bool
    {
        lhs.id == rhs.id
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
}

extension ForecastItem: Registered
{
    static var registration: UICollectionView.CellRegistration<UICollectionViewListCell, ForecastItem> =
    {
        .init { cell, indexPath, item in
            var configuration = UIListContentConfiguration.subtitleCell()
            configuration.text = item.text
            configuration.secondaryText = item.secondaryText
            configuration.secondaryTextProperties.color = .secondaryLabel
            cell.contentConfiguration = configuration
            cell.accessories = [.disclosureIndicator()]
        }
    }()
}
