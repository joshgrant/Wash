//
//  NewEntityViewController.swift
//  Walnut
//
//  Created by Joshua Grant on 1/24/22.
//

import Foundation
import Protyper

class NewEntityViewController: ViewController
{
    var entityType: EntityType
    var context: Context
    
    init(entityType: EntityType, context: Context)
    {
        self.entityType = entityType
        self.context = context
        super.init(title: entityType.title, view: nil)
    }
    
    override func display()
    {
        // TODO: Something's wrong with presented view controllers... this one isn't showing...
        switch entityType {
        case .stock:
            print("Title:")
            let title = readLine()
            print("Unit:")
            let unit = readLine()
            print("Min:")
            let min = readLine() ?? "0"
            print("Max:")
            let max = readLine() ?? "1"
            print("Ideal:")
            let ideal = readLine() ?? "1"
            print("Current:")
            let current = readLine() ?? "0"
            print("Done!")
            let stock = Stock(context: context)
            stock.symbolName = Symbol(context: context, name: title)
            stock.unit = newUnit(from: unit ?? "")
            stock.minimum = valueSource(from: min)
            stock.maximum = valueSource(from: max)
            stock.ideal = valueSource(from: ideal)
            stock.source = valueSource(from: current)
            let controller = EntityDetailViewController(entity: stock, configuration: .stock)
            navigationController?.push(controller: controller)
        case .flow:
            break
        case .task:
            break
        case .event:
            break
        case .conversion:
            break
        case .condition:
            break
        case .symbol:
            break
        case .note:
            break
        case .unit:
            break
        }
        // Here we start the process of asking the user to provide all of the information
        // That's required for creating a new entity
        //
        // Because this changes depending on which entity we're creating, we need to figure out
        // a set of questions to ask the user which they can fill out, 1 by 1
        //
        // For a stock:
        // 1. Title (symbolName)
        // 2. Unit?
        // 2. Does it use a state machine?
        //      2a. If so, what are the possible states?
        //          2a1. What is the start range for the state?
        //          2a2. What is the end range for the state
        //      2b. What is the ideal state?
        //      2c. What is the current state?
        // 3. If not:
            // 3a. What is the ideal value?
        //          3a1. Does it derive its ideal from a source?
            //      3a2. If not, what's the static ideal value?
            // 3b. What is the current value?
            //      3b1. Does it derive it's current value from a source?
            // 3c. What is the minimum value?
            //      3c1. Does it derive its minimum from a source?
            // 3d. What is the maximum value?
        //          3d1. Does it derive its maximum from a source?
    }
    
    private func valueSource(from string: String) -> Source
    {
        let source = Source(context: context)
        source.value = Double(string) ?? 0
        return source
    }
    
    private func newUnit(from string: String) -> Unit
    {
        let unit = Unit(context: context)
        unit.symbolName = Symbol(context: context, name: string)
        return unit
    }
}
