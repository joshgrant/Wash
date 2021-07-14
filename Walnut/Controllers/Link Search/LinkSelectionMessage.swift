//
//  LinkSelectionMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 7/9/21.
//

import Foundation

class LinkSelectionMessage: Message
{
    var link: Entity
    var origin: LinkSearchController.Origin
    
    init(link: Entity, origin: LinkSearchController.Origin)
    {
        self.link = link
        self.origin = origin
    }
}
