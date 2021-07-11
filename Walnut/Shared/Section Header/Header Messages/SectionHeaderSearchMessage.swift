//
//  SectionHeaderSearchMessage.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation

class SectionHeaderSearchMessage: Message
{
    var entityToSearchFrom: Entity
    var typeToSearch: NamedEntity.Type
    
    init(entityToSearchFrom: Entity, typeToSearch: NamedEntity.Type)
    {
        self.entityToSearchFrom = entityToSearchFrom
        self.typeToSearch = typeToSearch
    }
}
