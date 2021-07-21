////
////  SectionHeaderListItem.swift
////  Walnut
////
////  Created by Joshua Grant on 7/20/21.
////
//
//import Foundation
//import UIKit
//
//struct SectionHeaderListItem: ListItem
//{
//    var text: String
//    var icon: Icon?
//    
//    var disclosure: ActionClosure?
//    var search: ActionClosure?
//    var link: ActionClosure?
//    var add: ActionClosure?
//    var edit: ActionClosure?
//    
//    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, SectionHeaderListItem>
//    {
//        .init { cell, indexPath, item in
//            var configuration = cell.defaultContentConfiguration()
//            configuration.text = item.text
//            cell.contentConfiguration = configuration
//            cell.accessories = makeAccessories()
//        }
//    }
//    
//    private func makeImageViewAccessory() -> UICellAccessory?
//    {
//        let imageView = UIImageView(image: icon?.getImage())
//        imageView.tintColor = UIColor.tableViewHeaderIcon
//        
//        let configuration = UICellAccessory.CustomViewConfiguration(
//            customView: imageView,
//            placement: .leading(displayed: .always, at: { _ in 0 }))
//        let accessory = UICellAccessory.customView(configuration: configuration)
//        return accessory
//    }
//    
//    private func makeSearchButtonAccessory() -> UICellAccessory?
//    {
//        guard let search = search else { return nil }
//        
//        let button = UIButton()
//        button.setImage(Icon.search.getImage(), for: .normal)
//        button.tintColor = .tableViewHeaderIcon
//        button.addTarget(search,
//                         action: #selector(search.perform(sender:)),
//                         for: .touchUpInside)
//        
//        let configuration = UICellAccessory.CustomViewConfiguration(
//            customView: button,
//            placement: .trailing(displayed: .always, at: { _ in 0 }))
//        let accessory = UICellAccessory.customView(configuration: configuration)
//        return accessory
//    }
//    
//    private func makeLinkButtonAccessory() -> UICellAccessory?
//    {
//        guard let link = link else { return nil }
//        
//        let button = UIButton()
//        button.setImage(Icon.link.getImage(), for: .normal)
//        button.tintColor = .tableViewHeaderIcon
//        button.addTarget(link,
//                         action: #selector(link.perform(sender:)),
//                         for: .touchUpInside)
//        
//        let configuration = UICellAccessory.CustomViewConfiguration(
//            customView: button,
//            placement: .trailing(displayed: .always, at: { _ in 0 }))
//        let accessory = UICellAccessory.customView(configuration: configuration)
//        return accessory
//    }
//    
//    private func makeAddButtonAccesory() -> UICellAccessory?
//    {
//        guard let add = add else { return nil }
//        
//        let button = UIButton()
//        button.setImage(Icon.add.getImage(), for: .normal)
//        button.tintColor = .tableViewHeaderIcon
//        button.addTarget(add,
//                         action: #selector(add.perform(sender:)),
//                         for: .touchUpInside)
//        
//        let configuration = UICellAccessory.CustomViewConfiguration(
//            customView: button,
//            placement: .trailing(displayed: .always, at: { _ in 0 }))
//        let accessory = UICellAccessory.customView(configuration: configuration)
//        return accessory
//    }
//    
//    private func makeEditButtonAccesory() -> UICellAccessory?
//    {
//        guard let edit = edit else { return nil }
//        
//        let button = UIButton()
//        button.setTitle(.edit, for: .normal)
//        button.setTitleColor(.tableViewHeaderFont, for: .normal)
//        button.addTarget(edit,
//                         action: #selector(edit.perform(sender:)),
//                         for: .touchUpInside)
//        
//        let configuration = UICellAccessory.CustomViewConfiguration(
//            customView: button,
//            placement: .trailing(displayed: .always, at: { _ in 0 }))
//        let accessory = UICellAccessory.customView(configuration: configuration)
//        return accessory
//    }
//    
//    private func makeDisclosureAccessory() -> UICellAccessory?
//    {
//        guard let disclosure = disclosure else { return nil }
//        
//        let button = UIButton()
//        button.setImage(.init(named: "Disclosure"), for: .normal)
//        button.tintColor = .tableViewHeaderIcon
//        button.addTarget(disclosure,
//                         action: #selector(disclosure.perform(sender:)),
//                         for: .touchUpInside)
//        
//        let configuration = UICellAccessory.CustomViewConfiguration(
//            customView: button,
//            placement: .leading(displayed: .always, at: { _ in 0 }),
//            tintColor: .tableViewHeaderIcon)
//        let accessory = UICellAccessory.customView(configuration: configuration)
//        return accessory
//    }
//    
//    func makeAccessories() -> [UICellAccessory]
//    {
//        let accessories: [UICellAccessory?] = [
//            makeImageViewAccessory(),
//            makeDisclosureAccessory(),
//            makeSearchButtonAccessory(),
//            makeLinkButtonAccessory(),
//            makeAddButtonAccesory(),
//            makeEditButtonAccesory()
//        ]
//        
//        return accessories.compactMap { $0 }
//    }
//}
//
//extension SectionHeaderListItem
//{
//    static let info = SectionHeaderListItem(text: .info)
//    static let events = SectionHeaderListItem(text: .events)
//    static let history = SectionHeaderListItem(text: .history)
//    static let pinned = SectionHeaderListItem(text: .pinned, icon: .pin, disclosure: ActionClosure(performClosure: { sender in
//        print("Hello, world!")
//    }))
//    static let flows = SectionHeaderListItem(text: .flows, icon: .flow)
//    static let forecast = SectionHeaderListItem(text: .forecast, icon: .forecast)
//    static let priority = SectionHeaderListItem(text: .priority, icon: .priority)
//    static let valueType = SectionHeaderListItem(text: .valueType)
//    static let transitionType = SectionHeaderListItem(text: .transitionType)
//    static let references = SectionHeaderListItem(text: .references)
//    static let links = SectionHeaderListItem(text: .links)
//    static let ideal = SectionHeaderListItem(text: .ideal)
//    static let current = SectionHeaderListItem(text: .current)
//    static let stateMachine = SectionHeaderListItem(text: .states)
//    static let constraints = SectionHeaderListItem(text: .constraints)
//    static let goal = SectionHeaderListItem(text: .goal)
//}
