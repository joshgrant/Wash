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
            if let entity = entity as? Historable {
                entity.logHistory(.setName, context: context)
            }
            
        case .hide(let entity):
            entity.isHidden = true
            output = [entity]
            if let entity = entity as? Historable {
                entity.logHistory(.hidden, context: context)
            }
            
        case .unhide(let entity):
            entity.isHidden = false
            output = [entity]
            if let entity = entity as? Historable {
                entity.logHistory(.unhidden, context: context)
            }
            
        case .view(let printable):
            print(printable.fullDescription)
            if let entity = printable as? Selectable
            {
                output = entity.selection
            }
        case .delete(let entity):
            context.delete(entity)
            output = [entity]
            if let entity = entity as? Historable {
                entity.logHistory(.deleted, context: context)
            }
            
        case .pin(entity: let entity):
            entity.isPinned = true
            output = [entity]
            if let entity = entity as? Historable {
                entity.logHistory(.pinned, context: context)
            }
            
        case .unpin(entity: let entity):
            entity.isPinned = false
            output = [entity]
            if let entity = entity as? Historable {
                entity.logHistory(.unpinned, context: context)
            }
            
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
        case .history(let historable):
            for item in historable.history ?? .init() {
                print(item)
            }
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
            stock.logHistory(.setStockType, context: context)
            
        case .setCurrent(let stock, let current):
            stock.current = current
            output = [stock]
            stock.logHistory(.setCurrent, context: context)
            
        case .setIdeal(let stock, let ideal):
            stock.target = ideal
            output = [stock]
            stock.logHistory(.setIdeal, context: context)
            
        case .setMin(let stock, let min):
            stock.min = min
            output = [stock]
            stock.logHistory(.setMin, context: context)
            
        case .setMax(let stock, let max):
            stock.max = max
            output = [stock]
            stock.logHistory(.setMax, context: context)
            
        case .setUnit(let stock, let unit):
            stock.unit = unit
            output = [stock]
            stock.logHistory(.setUnit, context: context)
            
        case .linkOutflow(let stock, let flow):
            stock.addToOutflows(flow)
            output = [stock]
            stock.logHistory(.linkedOutflow, context: context)
            flow.logHistory(.setFromStock, context: context)
            
        case .linkInflow(let stock, let flow):
            stock.addToInflows(flow)
            output = [stock]
            stock.logHistory(.linkedInflow, context: context)
            flow.logHistory(.setToStock, context: context)
            
        case .unlinkOutflow(let stock, let flow):
            stock.removeFromOutflows(flow)
            output = [stock]
            stock.logHistory(.unlinkedOutflow, context: context)
            flow.logHistory(.removedFromStock, context: context)
            
        case .unlinkInflow(let stock, let flow):
            stock.removeFromInflows(flow)
            output = [stock]
            stock.logHistory(.unlinkedInflow, context: context)
            flow.logHistory(.removedToStock, context: context)
            
        case .linkStockEvent(let stock, let event):
            stock.addToEvents(event)
            output = [stock]
            stock.logHistory(.linkedEvent, context: context)
            event.logHistory(.linkedStock, context: context)
            
        case .unlinkStockEvent(let stock, let event):
            stock.removeFromEvents(event)
            output = [stock]
            stock.logHistory(.unlinkedEvent, context: context)
            event.logHistory(.unlinkedStock, context: context)
            
        case .setAmount(let flow, let amount):
            flow.amount = amount
            output = [flow]
            flow.logHistory(.updatedAmount, context: context)
            
        case .setDelay(let flow, let delay):
            flow.delay = delay
            output = [flow]
            flow.logHistory(.updatedDelay, context: context)
            
        case .setDuration(let flow, let duration):
            flow.duration = duration
            output = [flow]
            flow.logHistory(.updatedDuration, context: context)
            
        case .setRequires(let flow, let requires):
            flow.requiresUserCompletion = requires
            output = [flow]
            flow.logHistory(.setRequiresUserCompletion, context: context)
            
        case .setFrom(let flow, let stock):
            flow.from = stock
            output = [flow]
            flow.logHistory(.setFromStock, context: context)
            
        case .setTo(let flow, let stock):
            flow.to = stock
            output = [flow]
            flow.logHistory(.setToStock, context: context)
            
        case .run(let flow):
            flow.run(fromUser: true)
            output = [flow]
            flow.logHistory(.ran, context: context)
            
        case .finish(let flow):
            flow.amountRemaining = 0
            flow.isRunning = false
            output = [flow]
            flow.logHistory(.finished, context: context)
            
        case .linkFlowEvent(let flow, let event):
            flow.addToEvents(event)
            output = [flow]
            flow.logHistory(.linkedEvent, context: context)
            flow.logHistory(.linkedFlow, context: context)
            
        case .unlinkFlowEvent(let flow, let event):
            flow.removeFromEvents(event)
            output = [flow]
            flow.logHistory(.unlinkedEvent, context: context)
            event.logHistory(.unlinkedFlow, context: context)
            
        case .setIsActive(let event, let isActive):
            event.isActive = isActive
            output = [event]
            event.logHistory(.toggledActive, context: context)
            
        case .linkCondition(let event, let condition):
            event.addToConditions(condition)
            output = [event]
            event.logHistory(.linkedCondition, context: context)
            
        case .setConditionType(let event, let type):
            event.conditionType = type
            output = [event]
            event.logHistory(.updatedConditionType, context: context)
            
        case .linkFlow(let event, let flow):
            event.addToFlows(flow)
            output = [event]
            event.logHistory(.linkedFlow, context: context)
            
        case .setCooldown(let event, let cooldown):
            event.cooldownSeconds = cooldown
            output = [event]
            event.logHistory(.updatedCooldownSeconds, context: context)
            
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
            system.logHistory(.linkedFlow, context: context)
            flow.logHistory(.linkedSystem, context: context)
            
        case .unlinkSystemFlow(let system, let flow):
            system.removeFromFlows(flow)
            system.logHistory(.unlinkedFlow, context: context)
            flow.logHistory(.unlinkedSystem, context: context)
            
        case .linkSystemStock(let system, let stock):
            system.addToStocks(stock)
            system.logHistory(.linkedStock, context: context)
            stock.logHistory(.linkedSystem, context: context)
            
        case .unlinkSystemStock(let system, let stock):
            system.removeFromStocks(stock)
            system.logHistory(.unlinkedStock, context: context)
            stock.logHistory(.unlinkedSystem, context: context)
            
        case .linkProcessFlow(let process, let flow):
            process.addToFlows(flow)
            process.logHistory(.linkedFlow, context: context)
            flow.logHistory(.linkedProcess, context: context)
            
        case .unlinkProcessFlow(let process, let flow):
            process.removeFromFlows(flow)
            process.logHistory(.unlinkedFlow, context: context)
            flow.logHistory(.unlinkedProcess, context: context)
            
        case .linkProcessSubprocess(let process, let subprocess):
            process.addToSubProcesses(subprocess)
            process.logHistory(.addedSubprocess, context: context)
            subprocess.logHistory(.addedToParentProcess, context: context)
            
        case .unlinkProcessSubprocess(let process, let subprocess):
            process.removeFromSubProcesses(subprocess)
            process.logHistory(.removedSubprocess, context: context)
            subprocess.logHistory(.removedFromParentProcess, context: context)
            
        case .runProcess(let process):
            process.run()
            process.logHistory(.ran, context: context)
            
        case .linkProcessEvent(let process, let event):
            process.addToEvents(event)
            process.logHistory(.addedEvent, context: context)
            
        case .unlinkProcessEvent(let process, let event):
            process.removeFromEvents(event)
            process.logHistory(.removedEvent, context: context)
        }
        
        context.quickSave()
        
        return output
    }
}
