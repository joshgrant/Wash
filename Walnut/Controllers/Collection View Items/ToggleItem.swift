//
//  ToggleItem.swift
//  Walnut
//
//  Created by Joshua Grant on 7/28/21.
//

import UIKit

struct ToggleItem: Hashable, Identifiable
{
    // MARK: - Variables
    
    var id = UUID()
    
    var text: String
    var isOn: Bool
    
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
    var registration: UICollectionView.CellRegistration<UICollectionViewListCell, ToggleItem>
    {
        .init { cell, indexPath, item in
            var configuration = UIListContentConfiguration.cell()
            configuration.text = item.text
            cell.contentConfiguration = configuration
            cell.accessories = [
                makeToggleAccessory(isOn: item.isOn)
            ]
        }
    }
    
    private func makeToggleAccessory(isOn: Bool) -> UICellAccessory
    {
        let toggle = UISwitch()
        toggle.isOn = isOn
        
        let configuration = UICellAccessory.CustomViewConfiguration(customView: toggle, placement: .trailing(displayed: .always, at: { _ in 0 }))
        return .customView(configuration: configuration)
    }
}
