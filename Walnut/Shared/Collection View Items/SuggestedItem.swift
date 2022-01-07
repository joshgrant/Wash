//
//  SuggestedItem.swift
//  Walnut
//
//  Created by Joshua Grant on 7/22/21.
//

import UIKit

protocol SuggestedItemDelegate: AnyObject
{
    func suggestedItemUpdated(to checked: Bool, item: SuggestedItem)
}

final class SuggestedItem: Hashable, Identifiable
{
    // MARK: - Variables
    
    let id = UUID()
    
    let text: String
    let secondaryText: String
    var checked: Bool
    
    weak var delegate: SuggestedItemDelegate?
    
    // MARK: - Initialization
    
    init(text: String, secondaryText: String, checked: Bool, delegate: SuggestedItemDelegate?)
    {
        self.text = text
        self.secondaryText = secondaryText
        self.checked = checked
        self.delegate = delegate
    }
    
    // MARK: - Equatable
    
    static func == (lhs: SuggestedItem, rhs: SuggestedItem) -> Bool
    {
        lhs.id == rhs.id
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id)
    }
}

extension SuggestedItem: Registered
{
    static var registration: UICollectionView.CellRegistration<UICollectionViewListCell, SuggestedItem> =
    {
        .init { cell, indexPath, item in
            print("Checked: \(item.checked)")
            var configuration = UIListContentConfiguration.subtitleCell()
            configuration.text = item.text
            configuration.secondaryText = item.secondaryText
            configuration.secondaryTextProperties.color = .secondaryLabel
            cell.contentConfiguration = configuration
            cell.accessories = [
                item.makeCheckboxAccessory(),
                .disclosureIndicator()
            ]
        }
    }()
    
    private func makeCheckboxAccessory() -> UICellAccessory
    {
        let button = UIButton(type: .custom)
        
        // TODO: Use icons
        if checked
        {
            button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
        else
        {
            button.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        
        button.addTarget(
            self,
            action: #selector(buttonDidTouchUpInside(_:)),
            for: .touchUpInside)
        
        let configuration = UICellAccessory.CustomViewConfiguration(
            customView: button,
            placement: .trailing(displayed: .always, at: { _ in 0}))
        return .customView(configuration: configuration)
    }
    
    @objc func buttonDidTouchUpInside(_ sender: UIButton)
    {
        checked.toggle()
        delegate?.suggestedItemUpdated(to: checked, item: self)
    }
}

