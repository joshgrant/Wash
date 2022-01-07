//
//  LibraryItem.swift
//  Walnut
//
//  Created by Joshua Grant on 7/28/21.
//

import UIKit

struct LeftImageItem: Hashable, Identifiable
{
    // MARK: - Variables
    
    var id = UUID()
    
    var entityType: EntityType
    var context: Context
    
    var text: String { entityType.title }
    var secondaryText: String { "\(entityType.count(in: context))" }
    var image: UIImage { entityType.icon.image }
    
    // MARK: - Equatable
    
    static func == (lhs: LeftImageItem, rhs: LeftImageItem) -> Bool
    {
        lhs.id == rhs.id
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
}

extension LeftImageItem: Registered
{
    static var registration: UICollectionView.CellRegistration<UICollectionViewListCell, LeftImageItem> =
    {
        .init { cell, indexPath, item in
            var configuration = UIListContentConfiguration.valueCell()
            configuration.text = item.text
            configuration.secondaryText = item.secondaryText
            configuration.image = item.image
            configuration.imageProperties.tintColor = .systemGray
            cell.contentConfiguration = configuration
            cell.accessories = [.disclosureIndicator()]
        }
    }()
}
