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
            
            let accessories: [UICellAccessory?] = [
                makeImageAccessory(),
                makeLinkAccessory(),
                makeAddAccessory(),
                makeSpacerAccesory(),
                makeOutlineAccessory()
            ]
            
            cell.accessories = accessories.compactMap { $0 }
        }
    }
    
    private func makeSpacerAccesory() -> UICellAccessory
    {
        let view = UIView()
        let configuration = UICellAccessory.CustomViewConfiguration(
            customView: view,
            placement: .trailing(displayed: .always, at: { _ in 0 }),
            reservedLayoutWidth: .custom(10),
            maintainsFixedSize: true)
        return .customView(configuration: configuration)
    }
    
    private func makeAddAccessory() -> UICellAccessory?
    {
        guard let _ = add else { return nil }
        
        let button = UIButton(type: .custom)
        button.setImage(Icon.add.image, for: .normal)
        button.tintColor = .tableViewHeaderIcon
        let configuration = UICellAccessory.CustomViewConfiguration(
            customView: button,
            placement: .trailing(displayed: .always, at: { _ in 0 }))
        return .customView(configuration: configuration)
    }
    
    private func makeLinkAccessory() -> UICellAccessory?
    {
        guard let _ = link else { return nil }
        
        let button = UIButton(type: .custom)
        button.setImage(Icon.link.image, for: .normal)
        button.tintColor = .tableViewHeaderIcon
        let configuration = UICellAccessory.CustomViewConfiguration(
            customView: button,
            placement: .trailing(displayed: .always, at: { _ in 0 }))
        return .customView(configuration: configuration)
    }
    
    private func makeOutlineAccessory() -> UICellAccessory?
    {
        guard let _ = disclosure else { return nil }
        let options = UICellAccessory.OutlineDisclosureOptions(
            style: .cell,
            tintColor: .tableViewHeaderIcon)
        let accessory = UICellAccessory.outlineDisclosure(options: options)
        return accessory
    }
    
    private func makeImageAccessory() -> UICellAccessory?
    {
        guard let image = image else { return nil }
        let imageView = UIImageView(image: image)
        imageView.tintColor = .secondaryLabel
        let configuration = UICellAccessory.CustomViewConfiguration(
            customView: imageView,
            placement: .leading(displayed: .always, at: { _ in 0 }))
        return UICellAccessory.customView(configuration: configuration)
    }
}
