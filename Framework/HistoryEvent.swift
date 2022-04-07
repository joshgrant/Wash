//
//  HistoryEvent.swift
//  Wash
//
//  Created by Joshua Grant on 3/26/22.
//

import Foundation

public enum HistoryEvent: Int16, CaseIterable
{
    case created
    case deleted
    
    case updatedValue
    
    case setName
    case hidden
    case unhidden
    case pinned
    case unpinned
    
    // Event
    case updatedCooldownSeconds
    case updatedConditionType
    case linkedCondition
    case toggledActive
    
    case unlinkedEvent
    case linkedEvent
    
    // Stock
    case linkedInflow
    case linkedOutflow
    case unlinkedInflow
    case unlinkedOutflow
    case setUnit
    case setMax
    case setMin
    case setIdeal
    case setCurrent
    case setStockType
    
    // Flow / Process
    case ran
    case finished
    case setToStock
    case removedToStock
    case setFromStock
    case removedFromStock
    case setRequiresUserCompletion
    case updatedDuration
    case updatedDelay
    case updatedAmount
    
    case linkedStock
    case unlinkedStock
    
    case linkedSystem
    case unlinkedSystem
    
    case linkedFlow
    case unlinkedFlow
    
    case linkedProcess
    case unlinkedProcess
    
    // Process
    case addedEvent
    case removedEvent
    
    case addedSubprocess
    case removedSubprocess
    
    case addedToParentProcess
    case removedFromParentProcess
}

extension HistoryEvent
{
    static let fallback: HistoryEvent = .created
}

extension HistoryEvent: CustomStringConvertible
{
    public var description: String
    {
        switch self
        {
        case .created: return "Created".localized
        case .deleted: return "Deleted".localized
        case .setName: return "Set name".localized
        case .hidden: return "Hidden".localized
        case .unhidden: return "Unhidden".localized
        case .pinned: return "Pinned".localized
        case .unpinned: return "Unpinned".localized
        case .updatedCooldownSeconds: return "Updated cooldown seconds".localized
        case .updatedConditionType: return "Updated condition type".localized
        case .linkedCondition: return "Linked condition".localized
        case .toggledActive: return "Toggled active".localized
        case .unlinkedEvent: return "Unlinked event".localized
        case .linkedEvent: return "Linked event".localized
        case .linkedInflow: return "Linked inflow".localized
        case .linkedOutflow: return "Linked outflow".localized
        case .unlinkedInflow: return "Unlinked inflow".localized
        case .unlinkedOutflow: return "Unlinked outflow".localized
        case .setUnit: return "Set unit".localized
        case .setMax: return "Set max".localized
        case .setMin: return "Set min".localized
        case .setIdeal: return "Set ideal".localized
        case .setCurrent: return "Set current".localized
        case .setStockType: return "Set stock type".localized
        case .ran: return "Ran".localized
        case .finished: return "Finished".localized
        case .setToStock: return "Set to stock".localized
        case .removedToStock: return "Unset to stock".localized
        case .setFromStock: return "Set from stock".localized
        case .removedFromStock: return "Unset from stock".localized
        case .setRequiresUserCompletion: return "Set `Requires User Completion`"
        case .updatedDuration: return "Updated duration"
        case .updatedDelay: return "Updated delay"
        case .updatedAmount: return "Updated amount"
        case .linkedStock: return "Linked stock"
        case .unlinkedStock: return "Unlinked stock"
        case .linkedSystem: return "Linked system"
        case .unlinkedSystem: return "Unlinked system"
        case .linkedFlow: return "Linked flow"
        case .unlinkedFlow: return "Unlinked flow"
        case .linkedProcess: return "Linked process"
        case .unlinkedProcess: return "Unlinked process"
        case .addedEvent: return "Added event"
        case .removedEvent: return "Removed event"
        case .addedSubprocess: return "Added subprocess"
        case .removedSubprocess: return "Removed subprocess"
        case .addedToParentProcess: return "Added to parent process"
        case .removedFromParentProcess: return "Removed from parent process"
        case .updatedValue: return "Updated value"
        }
    }
}
