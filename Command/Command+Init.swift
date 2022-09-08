////
////  Command+Init.swift
////  Wash
////
////  Created by Josh Grant on 4/7/22.
////
//
//import Foundation
//
//extension Command
//{
//    init?(commandData: CommandData, workspace: inout [Entity], lastResult: [Entity], quit: inout Bool)
//    {
//        switch commandData.command.lowercased()
//        {
//        case "help":
//            self = .help
//        case "add":
//            guard let type = commandData.getEntityType() else { return nil }
//            let name = commandData.getName(startingAt: 1)
//            self = .add(entityType: type, name: name)
//        case "set-name":
//            guard let entity = workspace.first as? SymbolNamed else { return nil }
//            guard let name = commandData.getName() else { return nil }
//            self = .setName(entity: entity, name: name)
//        case "hide":
//            guard let entity = workspace.first else { return nil }
//            self = .hide(entity: entity)
//        case "unhide":
//            guard let entity = workspace.first else { return nil }
//            self = .unhide(entity: entity)
//        case "view":
//            guard let entity = workspace.first as? Printable else { return nil }
//            self = .view(entity: entity)
//        case "delete":
//            guard let entity = workspace.first else { return nil }
//            self = .delete(entity: entity)
//        case "pin":
//            guard let entity = workspace.first as? Pinnable else { return nil }
//            self = .pin(entity: entity)
//        case "unpin":
//            guard let entity = workspace.first as? Pinnable else { return nil }
//            self = .unpin(entity: entity)
//        case "select":
//            guard let index = commandData.getIndex() else { return nil }
//            self = .select(index: index)
//        case "choose":
//            guard let index = commandData.getIndex() else { return nil }
//            guard index < lastResult.count else { return nil }
//            self = .choose(index: index, lastResult: lastResult)
//        case "history":
//            guard let entity = workspace.first as? Historable else { return nil }
//            self = .history(entity: entity)
//        case "pinned":
//            self = .pinned
//        case "library":
//            self = .library
//        case "all":
//            guard let entityType = commandData.getEntityType() else { return nil }
//            self = .all(entityType: entityType)
//        case "unbalanced":
//            self = .unbalanced
//        case "priority":
//            self = .priority
//        case "dashboard":
//            self = .dashboard
//        case "suggest":
//            self = .suggest
//        case "events":
//            self = .events
//        case "flows":
//            self = .flows
//        case "running":
//            self = .running
//        case "hidden":
//            self = .hidden
//        case "quit":
//            quit = true
//            return nil
//        case "nuke":
//            self = .nuke
//        case "clear":
//            self = .clear
//        case "set-stock-type":
//            guard let stock = workspace.first as? Stock else { return nil }
//            guard let type = commandData.getSourceValueType() else { return nil }
//            self = .setStockType(stock: stock, type: type)
//        case "set-current":
//            guard let stock = workspace.first as? Stock else { return nil }
//            guard let number = commandData.getNumber() else { return nil }
//            self = .setCurrent(stock: stock, current: number)
//        case "set-ideal":
//            guard let stock = workspace.first as? Stock else { return nil }
//            guard let number = commandData.getNumber() else { return nil }
//            self = .setIdeal(stock: stock, ideal: number)
//        case "set-min":
//            guard let stock = workspace.first as? Stock else { return nil }
//            guard let number = commandData.getNumber() else { return nil }
//            self = .setMin(stock: stock, min: number)
//        case "set-max":
//            guard let stock = workspace.first as? Stock else { return nil }
//            guard let number = commandData.getNumber() else { return nil }
//            self = .setMax(stock: stock, max: number)
//        case "set-unit":
//            guard let (stock, unit): (Stock, Unit) = Self.getEntities(commandData: commandData, workspace: workspace) else { return nil }
//            self = .setUnit(stock: stock, unit: unit)
//        case "link-outflow":
//            guard let (stock, flow): (Stock, Flow) = Self.getEntities(commandData: commandData, workspace: workspace) else { return nil }
//            self = .linkOutflow(stock: stock, flow: flow)
//        case "link-inflow":
//            guard let (stock, flow): (Stock, Flow) = Self.getEntities(commandData: commandData, workspace: workspace) else { return nil }
//            self = .linkInflow(stock: stock, flow: flow)
//        case "unlink-outflow":
//            guard let (stock, flow): (Stock, Flow) = Self.getEntities(commandData: commandData, workspace: workspace) else { return nil }
//            self = .unlinkOutflow(stock: stock, flow: flow)
//        case "unlink-inflow":
//            guard let (stock, flow): (Stock, Flow) = Self.getEntities(commandData: commandData, workspace: workspace) else { return nil }
//            self = .unlinkInflow(stock: stock, flow: flow)
//        case "set-amount":
//            guard let (flow, amount): (Flow, Double) = Self.getEntityAndDouble(commandData: commandData, workspace: workspace) else { return nil }
//            guard amount > 0 else
//            {
//                print("Flow amount can't be < 0. Try switching the inflow/outflow arrangement.")
//                return nil
//            }
//            self = .setAmount(flow: flow, amount: amount)
//        case "set-delay":
//            guard let (flow, delay): (Flow, Double) = Self.getEntityAndDouble(commandData: commandData, workspace: workspace) else { return nil }
//            self = .setDelay(flow: flow, delay: delay)
//        case "set-duration":
//            guard let (flow, duration): (Flow, Double) = Self.getEntityAndDouble(commandData: commandData, workspace: workspace) else { return nil }
//            self = .setDuration(flow: flow, duration: duration)
//        case "set-requires":
//            guard let (flow, requires): (Flow, Bool) = Self.getEntityAndBool(commandData: commandData, workspace: workspace) else { return nil }
//            self = .setRequires(flow: flow, requires: requires)
//        case "set-from":
//            guard let (flow, stock): (Flow, Stock) = Self.getEntities(commandData: commandData, workspace: workspace) else { return nil }
//            self = .setFrom(flow: flow, stock: stock)
//        case "set-to":
//            guard let (flow, stock): (Flow, Stock) = Self.getEntities(commandData: commandData, workspace: workspace) else { return nil }
//            self = .setTo(flow: flow, stock: stock)
//        case "run":
//            if let flow: Flow = Self.getEntity(in: workspace, warn: false)
//            {
//                self = .run(flow: flow)
//            }
//            else if let process: Process = Self.getEntity(in: workspace, warn: false)
//            {
//                self = .runProcess(process: process)
//            }
//            else
//            {
//                print("Failed to run. No matching type")
//                return nil
//            }
//        case "finish":
//            guard let flow: Flow = Self.getEntity(in: workspace) else { return nil }
//            self = .finish(flow: flow)
//        case "set-repeats":
//            guard let (flow, repeats): (Flow, Bool) = Self.getEntityAndBool(commandData: commandData, workspace: workspace) else { return nil }
//            self = .setRepeats(flow: flow, repeats: repeats)
//        case "set-active":
//            guard let (event, isActive): (Event, Bool) = Self.getEntityAndBool(commandData: commandData, workspace: workspace) else { return nil }
//            self = .setIsActive(event: event, isActive: isActive)
//        case "link-condition":
//            guard let (event, condition): (Event, Condition) = Self.getEntities(commandData: commandData, workspace: workspace) else { return nil }
//            self = .linkCondition(event: event, condition: condition)
//        case "set-condition-type":
//            guard let event = Self.getEntity(in: workspace) as? Event else { return nil }
//            guard let conditionType = commandData.getConditionType() else { return nil }
//            self = .setConditionType(event: event, type: conditionType)
//        case "set-cooldown":
//            guard let (event, cooldown): (Event, Double) = Self.getEntityAndDouble(commandData: commandData, workspace: workspace) else { return nil }
//            self = .setCooldown(event: event, cooldown: cooldown)
//        case "set-comparison":
//            guard let condition = Self.getEntity(in: workspace) as? Condition else { return nil }
//            guard let comparison = commandData.getComparisonType() else { return nil }
//            guard let type = commandData.getArgument(at: 1) else { return nil }
//            self = .setComparison(condition: condition, comparison: comparison, type: type)
//        case "set-left-hand":
//            if let (condition, number): (Condition, Double) = Self.getEntityAndDouble(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .setLeftHandNumber(condition: condition, number: number)
//            }
//            else if let (condition, source): (Condition, Source) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .setLeftHandSource(condition: condition, source: source)
//            }
//            else if let (condition, stock): (Condition, Stock) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .setLeftHandStock(condition: condition, stock: stock)
//            }
//            else
//            {
//                print("Failed to parse the left-hand.")
//                return nil
//            }
//        case "set-right-hand":
//            if let (condition, number): (Condition, Double) = Self.getEntityAndDouble(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .setRightHandNumber(condition: condition, number: number)
//            }
//            else if let (condition, source): (Condition, Source) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .setRightHandSource(condition: condition, source: source)
//            }
//            else if let (condition, stock): (Condition, Stock) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .setRightHandStock(condition: condition, stock: stock)
//            }
//            else
//            {
//                print("Failed to parse the right-hand.")
//                return nil
//            }
//        case "link-flow":
//            if let (event, flow): (Event, Flow) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .linkFlow(event: event, flow: flow)
//            }
//            else if let (system, flow): (System, Flow) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .linkSystemFlow(system: system, flow: flow)
//            }
//            else if let (process, flow): (Process, Flow) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .linkProcessFlow(process: process, flow: flow)
//            }
//            else
//            {
//                print("Failed to link flow. No matching types.")
//                return nil
//            }
//        case "unlink-flow":
//            if let (system, flow): (System, Flow) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .unlinkSystemFlow(system: system, flow: flow)
//            }
//            else if let (process, flow): (Process, Flow) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .unlinkProcessFlow(process: process, flow: flow)
//            }
//            else
//            {
//                print("Failed to unlink flow. No matching types.")
//                return nil
//            }
//        case "link-stock":
//            if let (system, stock): (System, Stock) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .linkSystemStock(system: system, stock: stock)
//            }
//            else
//            {
//                print("Failed to link stock. No matching types")
//                return nil
//            }
//        case "unlink-stock":
//            if let (system, stock): (System, Stock) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .unlinkSystemStock(system: system, stock: stock)
//            }
//            else
//            {
//                print("Failed to unlink stock. No matching types")
//                return nil
//            }
//        case "link-event":
//            if let (flow, event): (Flow, Event) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .linkFlowEvent(flow: flow, event: event)
//            }
//            else if let (stock, event): (Stock, Event) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .linkStockEvent(stock: stock, event: event)
//            }
//            else if let (process, event): (Process, Event) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .linkProcessEvent(process: process, event: event)
//            }
//            else
//            {
//                print("Failed to link event. No matching types.")
//                return nil
//            }
//        case "unlink-event":
//            if let (flow, event): (Flow, Event) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .unlinkFlowEvent(flow: flow, event: event)
//            }
//            else if let (stock, event): (Stock, Event) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .unlinkStockEvent(stock: stock, event: event)
//            }
//            else if let (process, event): (Process, Event) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .unlinkProcessEvent(process: process, event: event)
//            }
//            else
//            {
//                print("Failed to unlink event. No matching types.")
//                return nil
//            }
//        case "link-process":
//            if let (process, subprocess): (Process, Process) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .linkProcessSubprocess(process: process, subprocess: subprocess)
//            }
//            else
//            {
//                print("Failed to link subprocess. No matching types.")
//                return nil
//            }
//        case "unlink-process":
//            if let (process, subprocess): (Process, Process) = Self.getEntities(commandData: commandData, workspace: workspace, warn: false)
//            {
//                self = .unlinkProcessSubprocess(process: process, subprocess: subprocess)
//            }
//            else
//            {
//                print("Failed to unlink subprocess. No matching types.")
//                return nil
//            }
//        case "boolean-stock-flow":
//            let name = commandData.getName(startingAt: 0)
//            self = .booleanStockFlow(name: name)
//        default:
//            return nil
//        }
//    }
//}
