//
//  EntityDetailViewController.swift
//  Walnut
//
//  Created by Joshua Grant on 1/22/22.
//

import Foundation
import Protyper

/// The detail view controller is responsible for showing all of the different
/// entity details. They have a configuration (which sections they want)
/// as well as information on how to access the data in those sections. Because
/// a lof of sections are reused (notes, for example) this reduces some duplication
class EntityDetailViewController: ViewController
{
    var entity: Named
    var configuration: Configuration
    
    init(entity: Named, configuration: Configuration)
    {
        self.entity = entity
        self.configuration = configuration
        super.init(title: entity.title, view: nil)
    }
    
    override func display()
    {
        let data = configuration.dataProvider(entity).sorted { $0.key < $1.key }
        for item in data.enumerated()
        {
            let index = item.offset + 1
            let section = item.element.key
            let rows = item.element.value
            
            print("\(index). \(section)")
            print("   —–––")
            for row in rows
            {
                print(row)
            }
            print("")
        }
    }
    
    override func handle(command: Command)
    {
        switch command.rawString
        {
        case "pin":
            entity.isPinned = true
        case "unpin":
            entity.isPinned = false
        default:
            break
        }
        
        navigationItem?.rightItem = entity.isPinned ? Icon.pinFill.text : nil
    }
}
