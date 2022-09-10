//
//  System+Extensions.swift
//  Wash
//
//  Created by Joshua Grant on 3/26/22.
//

import Foundation

extension System: SymbolNamed {}
extension System: Pinnable {}
extension System: Historable {}

extension System
{
    public override var description: String
    {
        let name = unwrappedName ?? ""
        let icon = Icon.system.text
        return "\(icon) \(name)"
    }
}

extension System: Printable
{
    var fullDescription: String
    {
        var index: Int = 0
        var stockString = ""
        var flowString = ""
        
        for stock: Stock in unwrapped(\System.stocks).sorted()
        {
            stockString += "\(index): \(stock.description)\n"
            index += 1
        }
        
        for flow: Flow in unwrapped(\System.flows).sorted()
        {
            flowString += "\(index): \(flow.description)\n"
            index += 1
        }
        
        return
"""
Info:
-------
Name: \(unwrappedName ?? "")
Percent ideal: \(percentIdeal.formatted(.percent))

Stocks:
-------
\(stockString)
Flows:
-------
\(flowString)
"""
    }
}

extension System
{
    var percentIdeal: Double
    {
        var total: Double = 0
        var ideal: Double = 0
        
        for stock: Stock in unwrapped(\System.stocks)
        {
            total += stock.percentIdeal
            ideal += 1
        }
        
        if ideal == 0 { return 1 }
        
        return total / ideal
    }
}

extension System: Selectable
{
    var selection: [Entity]
    {
        let stocks: [Stock] = unwrapped(\System.stocks).sorted()
        let flows: [Flow] = unwrapped(\System.flows).sorted()
        return stocks + flows
    }
}

extension System: Insertable
{
    typealias T = System
    
    static func insert(name: String, into context: Context) -> System
    {
        let system = System(context: context)
        system.unwrappedName = name
        return system
    }
}
