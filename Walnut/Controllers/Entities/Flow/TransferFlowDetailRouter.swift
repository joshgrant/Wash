//
//  TransferFlowDetailRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 6/28/21.
//

import Foundation

class TransferFlowDetailRouter: Router
{
    // MARK: - Defined types
    
    enum Destination
    {
        case stockPicker
        case eventDetail(event: Event)
        case historyDetail(history: History)
    }
    
    // MARK: - Variables
    
    var id = UUID()
    
    weak var root: NavigationController?
    weak var stream: Stream?
    weak var context: Context?
    
    // MARK: - Initialization
    
    init(root: NavigationController?, context: Context?, stream: Stream? = nil)
    {
        let s = stream ?? AppDelegate.shared.mainStream
        
        self.root = root
        self.stream = s
        self.context = context
        subscribe(to: s)
    }
    
    // MARK: - Functions
    
    func route(to destination: Destination, completion: (() -> Void)?)
    {
        switch destination
        {
        case .stockPicker:
            print("Route to stock picker")
        case .eventDetail(let event):
            print("Route to event detail: \(event)")
        case .historyDetail(let history):
            print("Route to history: \(history)")
        }
    }
}

extension TransferFlowDetailRouter: Subscriber
{
    func receive(message: Message)
    {
        switch message
        {
        case let m as TableViewSelectionMessage:
            handleTableViewSelectionMessage(m)
        default:
            break
        }
    }
    
    // TODO: Should have some enum for the table view sections
    private func handleTableViewSelectionMessage(_ message: TableViewSelectionMessage)
    {
        if message.token == .transferFlowDetail
        {
            switch message.indexPath.section
            {
            case 0: // Info
                handleInfoSectionSelection(row: message.indexPath.row)
            case 1: // Events Section
                handleEventSectionSelection(row: message.indexPath.row)
            case 2: // History Section
                handleHistorySectionSelection(row: message.indexPath.row)
            default:
                assertionFailure("Not a valid index path")
            }
        }
    }
    
    private func handleInfoSectionSelection(row: Int)
    {
        switch row
        {
        case 1: // From
        // TODO: Open stock detail picker
            let searchController = LinkSearchController(entityType: Stock.self, context: context)
            let navigationController = NavigationController(rootViewController: searchController)
            root?.present(
                navigationController,
                animated: true,
                completion: nil)
        case 2: // To
        // TODO: Open detail stock picker
            break
        case 3: // Amount
        // TODO: Open amount picker
            break
        case 4: // Duration
        // TODO: Open duration picker
            break
        default:
            break
        }
    }
    
    private func handleEventSectionSelection(row: Int)
    {
        
    }
    
    private func handleHistorySectionSelection(row: Int)
    {
        
    }
}
