//
//  ToggleItem.swift
//  Walnut
//
//  Created by Joshua Grant on 7/28/21.
//

import UIKit

@objc protocol ToggleItemDelegate: AnyObject
{
    func toggleDidChangeValue(_ toggle: UISwitch)
}

struct ToggleItem: Hashable, Identifiable
{
    // MARK: - Variables
    
    var id = UUID()
    
    var text: String
    var isOn: Bool
    
    weak var delegate: ToggleItemDelegate?
    
    // MARK: - Equatable
    
    static func == (lhs: ToggleItem, rhs: ToggleItem) -> Bool
    {
        lhs.id == rhs.id
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
}

extension ToggleItem: Registered
{
    static var registration: UICollectionView.CellRegistration<UICollectionViewListCell, ToggleItem> =
    {
        .init { cell, indexPath, item in
            var configuration = UIListContentConfiguration.cell()
            configuration.text = item.text
            cell.contentConfiguration = configuration
            cell.accessories = [
                item.makeToggleAccessory()
            ]
        }
    }()
    
    private func makeToggleAccessory() -> UICellAccessory
    {
        let toggle = UISwitch()
        toggle.addTarget(
            delegate,
            action: #selector(delegate?.toggleDidChangeValue(_:)),
            for: .valueChanged)
        toggle.isOn = isOn
        
        let configuration = UICellAccessory.CustomViewConfiguration(customView: toggle, placement: .trailing(displayed: .always, at: { _ in 0 }))
        return .customView(configuration: configuration)
    }
}
