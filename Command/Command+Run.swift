//
//  Command+Run.swift
//  Wash
//
//  Created by Josh Grant on 4/7/22.
//

import Foundation

extension Command
{
    func run(database: Database) -> [Entity]?
    {
        let context = database.context
        
        var output: [Entity] = []
        
        switch self
        {
        case .help:
            print("Sorry, there's no help available at this time.")
        case .add(let entityType, let name):
            let entity = entityType.insertNewEntity(into: context, name: name)
            output = [entity]
            workspace.insert(entity, at: 0)
        case .setName(let entity, let name):
            if let entity = entity as? SymbolNamed {
                let symbol = Symbol(context: context, name: name)
                entity.symbolName = symbol
            }
            output = [entity]
        case .hide(let entity):
            entity.isHidden = true
            output = [entity]
        case .unhide(let entity):
            entity.isHidden = false
            output = [entity]
        case .view(let printable):
            print(printable.fullDescription)
            if let entity = printable as? Selectable
            {
                output = entity.selection
            }
        case .delete(let entity):
            context.delete(entity)
            output = [entity]
        case .pin(entity: let entity):
            entity.isPinned = true
            output = [entity]
        case .unpin(entity: let entity):
            entity.isPinned = false
            output = [entity]
        case .select(let index):
            guard index < workspace.count else { return [] }
            
            let item = workspace[index]
            workspace.remove(at: index)
            workspace.insert(item, at: 0)
            if let item = item as? Selectable
            {
                output = item.selection
            }
            else
            {
                output = [item]
            }
        case .choose(let index, let lastResult):
            let item = lastResult[index]
            workspace.insert(item, at: 0)
            output = [item]
        case .pinned:
            output = runPinned(context: context)
        case .library:
            output = runLibrary(context: context)
        case .all(let entityType):
            output = runAll(entityType: entityType, context: context)
        case .unbalanced:
            output = runUnbalanced(context: context)
        case .priority:
            output = runPriority(context: context)
        case .dashboard:
            // print out the pinned, unbalanced stocks, unbalanced systems, priority items
            let pinned = runPinned(context: context, shouldPrint: false)
            let unbalanced = runUnbalanced(context: context, shouldPrint: false)
            let priority = runPriority(context: context, shouldPrint: false)
            
            print("Pinned")
            print("------------")
            for pin in pinned {
                print(pin)
            }
            print("")
            print("Unbalanced")
            print("------------")
            for item in unbalanced {
                print(item)
            }
            print("")
            print("Priority")
            print("------------")
            for item in priority {
                print(item)
            }
            print("------------")
        case .suggest:
            // Should we pin an item we view often?
            // Should we find a flow to balance an unbalanced stock?
            // Should we run a priority flow?
            break
        case .events:
            output = runEvents(context: context)
        case .flows:
            output = runFlowsNeedingCompletion(context: context)
        case .running:
            output = allRunningFlows(context: context)
        case .nuke:
            database.clear()
        case .clear:
            workspace.removeAll()
        case .setStockType(let stock, let type):
            stock.source?.valueType = type
            output = [stock]
        case .setCurrent(let stock, let current):
            stock.current = current
            output = [stock]
        case .setIdeal(let stock, let ideal):
            stock.target = ideal
            output = [stock]
        case .setMin(let stock, let min):
            stock.min = min
            output = [stock]
        case .setMax(let stock, let max):
            stock.max = max
            output = [stock]
        case .setUnit(let stock, let unit):
            stock.unit = unit
            output = [stock]
        case .linkOutflow(let stock, let flow):
            stock.addToOutflows(flow)
            output = [stock]
        case .linkInflow(let stock, let flow):
            stock.addToInflows(flow)
            output = [stock]
        case .unlinkOutflow(let stock, let flow):
            stock.removeFromOutflows(flow)
            output = [stock]
        case .unlinkInflow(let stock, let flow):
            stock.removeFromInflows(flow)
            output = [stock]
        case .linkStockEvent(let stock, let event):
            stock.addToEvents(event)
            output = [stock]
        case .unlinkStockEvent(let stock, let event):
            stock.removeFromEvents(event)
            output = [stock]
        case .setAmount(let flow, let amount):
            flow.amount = amount
            output = [flow]
        case .setDelay(let flow, let delay):
            flow.delay = delay
            output = [flow]
        case .setDuration(let flow, let duration):
            flow.duration = duration
            output = [flow]
        case .setRequires(let flow, let requires):
            flow.requiresUserCompletion = requires
            output = [flow]
        case .setFrom(let flow, let stock):
            flow.from = stock
            output = [flow]
        case .setTo(let flow, let stock):
            flow.to = stock
            output = [flow]
        case .run(let flow):
            flow.run(fromUser: true)
            output = [flow]
        case .finish(let flow):
            flow.amountRemaining = 0
            flow.isRunning = false
            output = [flow]
        case .linkFlowEvent(let flow, let event):
            flow.addToEvents(event)
            output = [flow]
        case .unlinkFlowEvent(let flow, let event):
            flow.removeFromEvents(event)
            output = [flow]
        case .setIsActive(let event, let isActive):
            event.isActive = isActive
            output = [event]
        case .linkCondition(let event, let condition):
            event.addToConditions(condition)
            output = [event]
        case .setConditionType(let event, let type):
            event.conditionType = type
            output = [event]
        case .linkFlow(let event, let flow):
            event.addToFlows(flow)
            output = [event]
        case .setCooldown(let event, let cooldown):
            event.cooldownSeconds = cooldown
            output = [event]
        case .setComparison(let condition, let comparison, let type):
            condition.setComparison(comparison, type: type)
            output = [condition]
        case .setLeftHandSource(let condition, let source):
            condition.leftHand = source
            output = [condition]
        case .setLeftHandStock(let condition, let stock):
            condition.leftHand = stock.source
            output = [condition]
        case .setLeftHandNumber(let condition, let number):
            let source = Source(context: context)
            source.valueType = .number
            source.value = number
            condition.leftHand = source
            output = [condition]
        case .setRightHandSource(let condition, let source):
            condition.rightHand = source
            output = [condition]
        case .setRightHandStock(let condition, let stock):
            condition.rightHand = stock.source
            output = [condition]
        case .setRightHandNumber(let condition, let number):
            let source = Source(context: context)
            source.valueType = .number
            source.value = number
            condition.rightHand = source
            output = [condition]
        case .linkSystemFlow(let system, let flow):
            system.addToFlows(flow)
        case .unlinkSystemFlow(let system, let flow):
            system.removeFromFlows(flow)
        case .linkSystemStock(let system, let stock):
            system.addToStocks(stock)
        case .unlinkSystemStock(let system, let stock):
            system.removeFromStocks(stock)
        case .linkProcessFlow(let process, let flow):
            process.addToFlows(flow)
        case .unlinkProcessFlow(let process, let flow):
            process.removeFromFlows(flow)
        case .linkProcessSubprocess(let process, let subprocess):
            process.addToSubProcesses(subprocess)
        case .unlinkProcessSubprocess(let process, let subprocess):
            process.removeFromSubProcesses(subprocess)
        case .runProcess(let process):
            process.run()
        case .linkProcessEvent(let process, let event):
            process.addToEvents(event)
        case .unlinkProcessEvent(let process, let event):
            process.removeFromEvents(event)
        }
        
        context.quickSave()
        
        return output
    }
}
