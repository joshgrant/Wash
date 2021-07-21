//
//  DashboardPinnedListItem.swift
//  Walnut
//
//  Created by Joshua Grant on 7/20/21.
//

import Foundation
import UIKit

struct RightImageListItem: ListItem
{
    var entity: Entity
    var text: String
    var icon: Icon
    var disclosure: Bool
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, RightImageListItem>
    {
        .init { cell, indexPath, item in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = item.text
            cell.contentConfiguration = configuration
            cell.accessories = makeAccessories(item: item)
        }
    }
    
    private func makeIconImageView(item: Self) -> UIImageView
    {
        let image = item.icon.getImage()
        let imageView = UIImageView(image: image, highlightedImage: image)
        imageView.tintColor = .secondaryLabel
        return imageView
    }
    
    private func makeRightIconAccessory(item: Self) -> UICellAccessory
    {
        let customView = makeIconImageView(item: item)
        let configuration = UICellAccessory.CustomViewConfiguration(
            customView: customView,
            placement: .trailing(displayed: .always, at: { _ in 0 }))
        return .customView(configuration: configuration)
    }
    
    private func makeAccessories(item: Self) -> [UICellAccessory]
    {
        [
            makeRightIconAccessory(item: item),
            .disclosureIndicator()
        ]
    }
}
