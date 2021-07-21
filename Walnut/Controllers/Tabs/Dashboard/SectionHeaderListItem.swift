//
//  SectionHeaderListItem.swift
//  Walnut
//
//  Created by Joshua Grant on 7/20/21.
//

import Foundation
import UIKit

struct SectionHeaderListItem: ListItem
{
    var text: String
    var icon: Icon?
    
    var disclosure: Bool = true
    
    var search: ActionClosure?
    var link: ActionClosure?
    var add: ActionClosure?
    var edit: ActionClosure?
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, SectionHeaderListItem>
    {
        .init { cell, indexPath, item in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = item.text
            configuration.image = item.icon?.getImage() // TODO: Custom image view
            // TODO: Add the search, link, add, and edit buttons
            
            cell.contentConfiguration = configuration
            cell.accessories = makeAccessories()
        }
    }
    
    func makeAccessories() -> [UICellAccessory]
    {
        let options = UICellAccessory.OutlineDisclosureOptions(style: .header)
        
        return [
//            .customView(configuration: .init(customView: <#T##UIView#>, placement: <#T##UICellAccessory.Placement#>))
            .outlineDisclosure(options: options)
        ]
    }
}

extension SectionHeaderListItem
{
    static let info = SectionHeaderListItem(text: .info)
    static let events = SectionHeaderListItem(text: .events)
    static let history = SectionHeaderListItem(text: .history)
    static let pinned = SectionHeaderListItem(text: .pinned, icon: .pin)
    static let flows = SectionHeaderListItem(text: .flows, icon: .flow)
    static let forecast = SectionHeaderListItem(text: .forecast, icon: .forecast)
    static let priority = SectionHeaderListItem(text: .priority, icon: .priority)
    static let valueType = SectionHeaderListItem(text: .valueType)
    static let transitionType = SectionHeaderListItem(text: .transitionType)
    static let references = SectionHeaderListItem(text: .references)
    static let links = SectionHeaderListItem(text: .links)
    static let ideal = SectionHeaderListItem(text: .ideal)
    static let current = SectionHeaderListItem(text: .current)
    static let stateMachine = SectionHeaderListItem(text: .states)
    static let constraints = SectionHeaderListItem(text: .constraints)
    static let goal = SectionHeaderListItem(text: .goal)
}
