//
//  LibraryView.swift
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
            let icon = item.element.icon.textIcon()
            print("\(index): \(icon) \(name) (\(count))")
        }
    }
    
    override func handle(command: Command) {
        
    }
}
