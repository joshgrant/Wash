//
//  SubtitleCheckboxItem.swift
//  Walnut
//
//  Created by Joshua Grant on 7/20/21.
//

import Foundation
import UIKit

struct SubtitleCheckboxListItem: ListItem
{
    var entity: Entity
    var text: String
    var secondaryText: String
    var isChecked: Bool
    var disclosure: Bool
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, SubtitleCheckboxListItem>
    {
        .init { cell, indexPath, item in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = text
            configuration.secondaryText = secondaryText
            configuration.prefersSideBySideTextAndSecondaryText = false
            cell.contentConfiguration = configuration
            cell.accessories = makeAccessories(item: item)
        }
    }
    
    private func makeCheckboxView(item: Self) -> UIButton
    {
        let icon: Icon = item.isChecked ? .checkBoxFilled : .checkBoxEmpty
        let button = UIButton(type: .custom)
        button.setImage(icon.image, for: .normal)
        return button
    }
    
    private func makeCheckboxAccessory(item: Self) -> UICellAccessory
    {
        let customView = makeCheckboxView(item: item)
        let configuration = UICellAccessory.CustomViewConfiguration(
            customView: customView,
            placement: .trailing(displayed: .always, at: { _ in 0 }))
        return .customView(configuration: configuration)
    }
    
    private func makeAccessories(item: Self) -> [UICellAccessory]
    {
        [
            makeCheckboxAccessory(item: item),
            .disclosureIndicator()
        ]
    }
}
