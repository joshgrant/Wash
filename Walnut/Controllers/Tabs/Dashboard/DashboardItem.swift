//
//  DashboardItem.swift
//  Walnut
//
//  Created by Joshua Grant on 7/20/21.
//

import Foundation
import UIKit

enum DashboardItem: Hashable
{
    case header(HeaderItem)
    case pinned(PinnedItem)
    case suggested(SuggestedItem)
    case forecast(ForecastItem)
    case priority(PriorityItem)
}

extension DashboardItem: Identifiable
{
    var id: UUID
    {
        switch self
        {
        case .header(let item): return item.id
        case .pinned(let item): return item.id
        case .suggested(let item): return item.id
        case .forecast(let item): return item.id
        case .priority(let item): return item.id
        }
    }
}
