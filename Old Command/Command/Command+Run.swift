
//        case .pinned:
//            output = runPinned(context: context)
//        case .library:
//            output = runLibrary(context: context)
//        case .all(let entityType):
//            output = runAll(entityType: entityType, context: context)
//        case .unbalanced:
//            output = runUnbalanced(context: context)
//        case .priority:
//            output = runPriority(context: context)
//        case .dashboard:
//            // print out the pinned, unbalanced stocks, unbalanced systems, priority items
//            let pinned = runPinned(context: context, shouldPrint: false)
//            let unbalanced = runUnbalanced(context: context, shouldPrint: false)
//            let priority = runPriority(context: context, shouldPrint: false)
//            
//            print("Pinned")
//            print("------------")
//            for pin in pinned {
//                print(pin)
//            }
//            print("")
//            print("Unbalanced")
//            print("------------")
//            for item in unbalanced {
//                print(item)
//            }
//            print("")
//            print("Priority")
//            print("------------")
//            for item in priority {
//                print(item)
//            }
//            print("------------")
//        case .suggest:
//            // Should we pin an item we view often?
//            // Should we find a flow to balance an unbalanced stock?
//            // Should we run a priority flow?
//            break
//        case .events:
//            output = runEvents(context: context)
//        case .flows:
//            output = runFlowsNeedingCompletion(context: context)
//        case .running:
//            output = allRunningFlows(context: context)
//        case .hidden:
//            output = allHidden(context: context)
//        case .nuke:
//            database.clear()
//        case .clear:
//            workspace.removeAll()



//            




//            

//        case .linkStockEvent(let stock, let event):
//            stock.addToEvents(event)
//            output = [stock]
//            stock.logHistory(.linkedEvent, context: context)
//            event.logHistory(.linkedStock, context: context)
//            
//        case .unlinkStockEvent(let stock, let event):
//            stock.removeFromEvents(event)
//            output = [stock]
//            stock.logHistory(.unlinkedEvent, context: context)
//            event.logHistory(.unlinkedStock, context: context)








//        case .linkFlowEvent(let flow, let event):
//            flow.addToEvents(event)
//            output = [flow]
//            flow.logHistory(.linkedEvent, context: context)
//            flow.logHistory(.linkedFlow, context: context)
//            
//        case .unlinkFlowEvent(let flow, let event):
//            flow.removeFromEvents(event)
//            output = [flow]
//            flow.logHistory(.unlinkedEvent, context: context)
//            event.logHistory(.unlinkedFlow, context: context)
//            
//        case .setIsActive(let event, let isActive):
//            event.isActive = isActive
//            output = [event]
//            event.logHistory(.toggledActive, context: context)
//            
//        case .linkCondition(let event, let condition):
//            event.addToConditions(condition)
//            output = [event]
//            event.logHistory(.linkedCondition, context: context)
//            
//        case .setConditionType(let event, let type):
//            event.conditionType = type
//            output = [event]
//            event.logHistory(.updatedConditionType, context: context)
//            
//        case .linkFlow(let event, let flow):
//            event.addToFlows(flow)
//            output = [event]
//            event.logHistory(.linkedFlow, context: context)
//            
//        case .setCooldown(let event, let cooldown):
//            event.cooldownSeconds = cooldown
//            output = [event]
//            event.logHistory(.updatedCooldownSeconds, context: context)
//            
//        case .setComparison(let condition, let comparison, let type):
//            condition.setComparison(comparison, type: type)
//            output = [condition]
//        case .setLeftHandSource(let condition, let source):
//            condition.leftHand = source
//            output = [condition]
//        case .setLeftHandStock(let condition, let stock):
//            condition.leftHand = stock.source
//            output = [condition]
//        case .setLeftHandNumber(let condition, let number):
//            let source = Source(context: context)
//            source.valueType = .number
//            source.value = number
//            condition.leftHand = source
//            output = [condition]
//        case .setRightHandSource(let condition, let source):
//            condition.rightHand = source
//            output = [condition]
//        case .setRightHandStock(let condition, let stock):
//            condition.rightHand = stock.source
//            output = [condition]
//        case .setRightHandNumber(let condition, let number):
//            let source = Source(context: context)
//            source.valueType = .number
//            source.value = number
//            condition.rightHand = source
//            output = [condition]
//        case .linkSystemFlow(let system, let flow):
//            system.addToFlows(flow)
//            system.logHistory(.linkedFlow, context: context)
//            flow.logHistory(.linkedSystem, context: context)
//            
//        case .unlinkSystemFlow(let system, let flow):
//            system.removeFromFlows(flow)
//            system.logHistory(.unlinkedFlow, context: context)
//            flow.logHistory(.unlinkedSystem, context: context)
//            
//        case .linkSystemStock(let system, let stock):
//            system.addToStocks(stock)
//            system.logHistory(.linkedStock, context: context)
//            stock.logHistory(.linkedSystem, context: context)
//            
//        case .unlinkSystemStock(let system, let stock):
//            system.removeFromStocks(stock)
//            system.logHistory(.unlinkedStock, context: context)
//            stock.logHistory(.unlinkedSystem, context: context)
//            
//        case .linkProcessFlow(let process, let flow):
//            process.addToFlows(flow)
//            process.logHistory(.linkedFlow, context: context)
//            flow.logHistory(.linkedProcess, context: context)
//            
//        case .unlinkProcessFlow(let process, let flow):
//            process.removeFromFlows(flow)
//            process.logHistory(.unlinkedFlow, context: context)
//            flow.logHistory(.unlinkedProcess, context: context)
//            
//        case .linkProcessSubprocess(let process, let subprocess):
//            process.addToSubProcesses(subprocess)
//            process.logHistory(.addedSubprocess, context: context)
//            subprocess.logHistory(.addedToParentProcess, context: context)
//            
//        case .unlinkProcessSubprocess(let process, let subprocess):
//            process.removeFromSubProcesses(subprocess)
//            process.logHistory(.removedSubprocess, context: context)
//            subprocess.logHistory(.removedFromParentProcess, context: context)
//            
//        case .runProcess(let process):
//            process.run()
//            process.logHistory(.ran, context: context)
//            
//        case .linkProcessEvent(let process, let event):
//            process.addToEvents(event)
//            process.logHistory(.addedEvent, context: context)
//            
//        case .unlinkProcessEvent(let process, let event):
//            process.removeFromEvents(event)
//            process.logHistory(.removedEvent, context: context)
//        case .booleanStockFlow(let name):
//            
//            guard let name = name else {
//                print("Please enter a name, or we can't create a boolean stock & flow.")
//                return output
//            }
//            
//            let stock = EntityType.stock.insertNewEntity(into: context, name: name) as! Stock
//            stock.current = 0
//            stock.target = 1
//            stock.max = 1
//            stock.valueType = .boolean
//            
//            let checkFlow = EntityType.flow.insertNewEntity(into: context, name: "Check: " + name) as! Flow
//            checkFlow.amount = 1
//            checkFlow.duration = 0
//            checkFlow.delay = 0
//            checkFlow.from = ContextPopulator.sourceStock(context: context)
//            checkFlow.to = stock
//            
//            let uncheckFlow = EntityType.flow.insertNewEntity(into: context, name: "Uncheck: " + name) as! Flow
//            uncheckFlow.amount = 1
//            uncheckFlow.duration = 0
//            uncheckFlow.delay = 0
//            uncheckFlow.from = stock
//            uncheckFlow.to = ContextPopulator.sinkStock(context: context)
//            
//            output = [stock, checkFlow, uncheckFlow]
//            
//            workspace.insert(stock, at: 0)
//            workspace.insert(checkFlow, at: 1)
//            workspace.insert(uncheckFlow, at: 2)
//        }
//        
//        context.quickSave()
//        
//        return output
//    }
//}
