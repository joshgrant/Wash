//
//  LibraryView.swift
//  Walnut
//
//  Created by Joshua Grant on 1/17/22.
//

import Foundation

class LibraryView: View
{
    var context: Context
    
    init(context: Context)
    {
        self.context = context
    }
    
    func display()
    {
        EntityType.libraryVisible.enumerated().forEach { item in
            let index = item.offset + 1
            let name = item.element.title
            let count = item.element.count(in: context)
            let icon = item.element.icon.textIcon()
            print("\(index): \(icon) \(name) (\(count))")
        }
    }
    
    func handle(section: Int?, row: Int?, command: String?)
    {
        
    }
}
