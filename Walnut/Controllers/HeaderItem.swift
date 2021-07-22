//
//  HeaderItem.swift
//  Walnut
//
//  Created by Joshua Grant on 7/22/21.
//

import UIKit

struct HeaderItem: Hashable, Identifiable
{
    // MARK: - Variables
    
    let id = UUID()
    
    var text: String
    var image: UIImage?
    
    var disclosure: UICellAccessory.ActionHandler?
    var link: UICellAccessory.ActionHandler?
    var add: UICellAccessory.ActionHandler?
    var edit: UICellAccessory.ActionHandler?
    
    // MARK: - Equatable
    
    static func == (lhs: HeaderItem, rhs: HeaderItem) -> Bool {
        lhs.id == rhs.id
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
}

extension HeaderItem: Registered
{
    var registration: UICollectionView.CellRegistration<UICollectionViewListCell, HeaderItem>
    {
        .init { cell, indexPath, item in
            var configuration = UIListContentConfiguration.groupedHeader()
            configuration.text = item.text
            cell.contentConfiguration = configuration
            cell.backgroundConfiguration = UIBackgroundConfiguration.listGroupedHeaderFooter()
            
            cell.accessories = [
                makeImageAccessory(),
                makeOutlineAccessory()
            ]
        }
    }
    
    private func makeOutlineAccessory() -> UICellAccessory
    {
        let options = UICellAccessory.OutlineDisclosureOptions(
            style: .cell,
            tintColor: .secondaryLabel)
        let accessory = UICellAccessory.outlineDisclosure(options: options)
        return accessory
    }
    
    private func makeImageAccessory() -> UICellAccessory
    {
        let imageView = UIImageView(image: image)
        imageView.tintColor = .secondaryLabel
        let configuration = UICellAccessory.CustomViewConfiguration(
            customView: imageView,
            placement: .leading(displayed: .always, at: { _ in 0 }))
        return UICellAccessory.customView(configuration: configuration)
    }
}
