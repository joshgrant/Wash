//
//  Architect.swift
//  Walnut
//
//  Created by Joshua Grant on 7/22/21.
//

import UIKit

enum Section: Int, CaseIterable
{
    case pinned
    case suggested
    case forecast
    case priority
}

enum Item: Hashable
{
    case header(HeaderItem)
    case pinned(PinnedItem)
    case suggested(SuggestedItem)
    case forecast(ForecastItem)
    case priority(PriorityItem)
}

extension Item: Identifiable
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

// ---

class FooterView: UICollectionReusableView
{
}

// ---
