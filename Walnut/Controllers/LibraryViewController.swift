//
//  LibraryViewController.swift
//  Walnut
//
//  Created by Joshua Grant on 1/17/22.
//

import Foundation
import Protyper

class LibraryViewController: ViewController
{
    var context: Context
    
    init(context: Context)
    {
        self.context = context
        super.init(title: "Library", view: View())
    }
    
    override func display()
    {
        EntityType.libraryVisible.enumerated().forEach { item in
            let index = item.offset + 1
            let name = item.element.title
            let count = item.element.count(in: context)
            let icon = item.element.icon.text
            print("\(index): \(icon) \(name) (\(count))")
        }
    }
    
    override func handle(command: Command)
    {
        guard let command = TableSelectionCommand(command: command) else { return }
        guard let row = command.row else { return }
        let type = EntityType.libraryVisible[row - 1]
        let controller = EntityListViewController(entityType: type, context: context)
        navigationController?.push(controller: controller)
    }
}
