//
//  EventDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 1/6/22.
//

import Foundation
import UIKit

class EventDetailController: ListController<EventDetailSection, EventDetailItem, EventDetailBuilder>
{
    // MARK: - Variables
    
    var router: EventDetailRouter
    
    // MARK: - Initialization
    
    override init(builder: EventDetailBuilder)
    {
        router = builder.makeRouter()
        super.init(builder: builder)
        
        title = builder.event.title
        builder.textEditDelegate = self
        builder.toggleDelegate = self
        router.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        reload(animated: animated)
    }
    
    // MARK: - Collection View
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let item = dataSource.itemIdentifier(for: indexPath)
        switch item {
        case .detail(let detailItem):
            let entity = detailItem.entity
            let message = EntitySelectionMessage(entity: entity)
            builder.stream.send(message: message)
        default:
            break
        }
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}

extension EventDetailController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        title = textField.text
        builder.event.unwrappedName = textField.text
        builder.context.quickSave()
    }
}

extension EventDetailController: ToggleItemDelegate
{
    func toggleDidChangeValue(_ toggle: UISwitch)
    {
        builder.event.isActive = toggle.isOn
    }
}

extension EventDetailController: RouterDelegate { }
