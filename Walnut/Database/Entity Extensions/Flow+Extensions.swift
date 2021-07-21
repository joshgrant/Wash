//
//  Flow+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 6/18/21.
//

import Foundation
import CoreData

extension Flow: Named {}
extension Flow: Pinnable {}

extension Flow
{
    static var dashboardSuggestedFlowsPredicate: NSPredicate
    {
        .init(format: "suggestedIn.@count > %i", 0)
    }
    
    static func makeDashboardSuggestedFlowsFetchRequest() -> NSFetchRequest<Flow>
    {
        let request: NSFetchRequest<Flow> = Flow.fetchRequest()
        request.predicate = dashboardSuggestedFlowsPredicate
        request.shouldRefreshRefetchedObjects = true
        return request
    }
}
