//
//  EntityListTableViewDelegate.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import UIKit

class EntityListTableViewDelegate: TableViewDelegate
{
    // MARK: - Variables
    
    var entityType: Entity.Type
    weak var context: Context?
    
    init(model: TableViewDelegateModel, entityType: Entity.Type, context: Context?)
    {
        self.entityType = entityType
        self.context = context
        super.init(model: model)
    }
    
    // MARK: - Functions
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let pinAction = UIContextualAction(style: .normal, title: "Pin".localized) { action, view, completion in
            completion(true)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete".localized) { action, view, completion in
            // TODO: Delete the cell at index path // reload data
            // TOO: Actually have to delete the value in the data source...
            guard let context = self.context else { completion(false); return }
            
            context.perform
            {
                let object = self.entityType.all(context: context)[indexPath.row]
                print(object)
                context.delete(object)
                context.quickSave()
                
                DispatchQueue.main.async
                {
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
            }
            completion(true)
        }
        
        let actions: [UIContextualAction] = [deleteAction, pinAction]
        
        return .init(actions: actions)
    }
}
