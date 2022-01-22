//
//  Flow+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 6/18/21.
//

import Foundation
import CoreData

extension Flow: SymbolNamed {}
extension Flow: Pinnable {}

// TODO: Flow "amounts" can be dynamic or static - i.e for some "user-completed" flows
// the amount should be "enterable" like - how much water did you just drinik?

public extension Flow
{
    override var description: String
    {
        dashboardDescription
    }
    
    var dashboardDescription: String
    {
        let name = unwrappedName ?? ""
        let icon = Icon.flow.text
        return "\(icon) \(name)"
    }
}

extension Flow
{
    // We're taking a different approach for suggestions. Rather than have it be a property,
    // a flow will be suggested:
    // 1. a system must be out of balance
    // 2. the system must have a flow that can resolve the balance
    
//    static var dashboardSuggestedFlowsPredicate: NSPredicate
//    {
//        .init(format: "suggestedIn.@count > %i", 0)
//    }
//
//    static func makeDashboardSuggestedFlowsFetchRequest() -> NSFetchRequest<Flow>
//    {
//        let request: NSFetchRequest<Flow> = Flow.fetchRequest()
//        request.predicate = dashboardSuggestedFlowsPredicate
//        request.shouldRefreshRefetchedObjects = true
//        return request
//    }
}
