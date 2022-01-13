//
//  EventDetailItem.swift
//  Walnut
//
//  Created by Joshua Grant on 1/9/22.
//

import Foundation

enum EventDetailItem: Hashable
{
    case header(HeaderItem)
    case text(TextEditItem)
    case toggle(ToggleItem)
    // TODO: Condition Item
    case detail(DetailItem)
}

extension EventDetailItem: Identifiable
{
    var id: UUID
    {
        switch self
        {
        case .header(let item): return item.id
        case .text(let item): return item.id
        case .toggle(let item): return item.id
        case .detail(let item): return item.id
        }
    }
}
