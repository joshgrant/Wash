//
//  Process+Extensions.swift
//  Wash
//
//  Created by Joshua Grant on 3/26/22.
//

import Foundation

extension Process: SymbolNamed {}
extension Process: Historable {}

extension Process: Selectable
{
    var selection: [Entity]
    {
        let flows: [Flow] = unwrapped(\Process.flows).sorted()
        let subProcesses: [Process] = unwrapped(\Process.subProcesses).sorted()
        
        return flows + subProcesses
    }
}

extension Process: Printable
{
    public override var description: String
    {
        let name = unwrappedName ?? ""
        let icon = Icon.task.text
        return "\(icon) \(name)"
    }
    
    var fullDescription: String
    {
        var index: Int = 0
        
        var flowsText = ""
        var subProcessesText = ""
        
        for flow: Flow in unwrapped(\Process.flows).sorted()
        {
            flowsText += "\(index): \(flow)\n"
            index += 1
        }
        
        for process: Process in unwrapped(\Process.subProcesses).sorted()
        {
            subProcessesText += "\(index): \(process)\n"
            index += 1
        }
        
        return
"""
Name:       \(unwrappedName ?? "")
Progress:   \(progress.formatted(.percent))

Flows:
-------------
\(flowsText)
Subprocesses:
-------------
\(subProcessesText)
"""
    }
}

extension Process: Comparable
{
    public static func < (lhs: Process, rhs: Process) -> Bool
    {
        return (lhs.unwrappedName ?? "") < (rhs.unwrappedName ?? "")
    }
}

extension Process
{
    // TODO: Is this expensive to compute??
    var progress: Double
    {
        var total: Double = 0
        var current: Double = 0
        
        for flow: Flow in unwrapped(\Process.flows)
        {
            total += 1
            current += flow.percentComplete
        }
        
        for subprocess: Process in unwrapped(\Process.subProcesses)
        {
            total += 1
            current += subprocess.progress
        }
        
        return current / total
    }
    
    func run(context: Context)
    {
        // In a process, should we run all of the subprocesses?
        
        for flow: Flow in unwrapped(\Process.flows)
        {
            flow.run(context: context)
        }
    }
}

extension Process
{
    var completionType: CompletionType
    {
        get
        {
            CompletionType(rawValue: completionTypeRaw) ?? .children
        }
        set
        {
            completionTypeRaw = newValue.rawValue
        }
    }
    
    var orderType: OrderType
    {
        get
        {
            OrderType(rawValue: orderTypeRaw) ?? .independent
        }
        set
        {
            orderTypeRaw = newValue.rawValue
        }
    }
}
