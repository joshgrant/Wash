//
//  Command.swift
//  Wash
//
//  Created by Joshua Grant on 9/8/22.
//

import Foundation

class Command
{
    // MARK: - Variables
    
    var context: Context
    var command: String
    var arguments: [String]
    var workspace: Workspace
    
    // MARK: - Initialization
    
    init?(input: String, workspace: Workspace, context: Context)
    {
        let (command, arguments) = Self.parse(input: input)
        self.command = command
        self.arguments = arguments
        self.workspace = workspace
        self.context = context
    }
    
    static func parse(input: String) -> (String, [String])
    {
        var command = ""
        var arguments: [String] = []

        var word = ""
        var openQuote = false

        func assign()
        {
            if command == ""
            {
                command = word
            }
            else
            {
                arguments.append(word)
            }

            word = ""
        }

        for char in Array(input)
        {
            if char == "\""
            {
                openQuote.toggle()
            }

            if !openQuote && char == " "
            {
                assign()
            }
            else
            {
                word.append(char)
            }
        }

        assign()
        
        return (command, arguments)
    }
    
    // MARK: - Public functions
    
    func run(database: Database) -> [Entity]
    {
        return []
    }
}

// MARK: - Argument parsing

private extension Command
{
    func entityType() throws -> EntityType
    {
        guard arguments.count > 0 else { throw ParsingError.noArguments }
        return try EntityType(string: arguments[0])
    }
    
    func name(startingAt index: Int = 0) throws -> String
    {
        guard arguments.count > index else { throw ParsingError.indexOutsideOfArgumentsBounds(index) }
        return arguments[index...].joined(separator: " ")
    }
    
    func index() throws -> Int
    {
        guard var first = arguments.first else { throw ParsingError.noArguments }
        
        // For the cases where we want a wild-card to distinguish it from a number input
        if first.first == "$"
        {
            first.removeFirst()
        }
        
        guard let number = Int(first) else { throw ParsingError.argumentDidNotMatchType(Int.self) }
        return number
    }
    
    func sourceValueType() throws -> SourceValueType
    {
        guard let first = arguments.first else { throw ParsingError.noArguments }
        return try SourceValueType(string: first.lowercased())
    }
    
    func value<T: LosslessStringConvertible>() throws -> T
    {
        guard let first = arguments.first else { throw ParsingError.noArguments }
        guard let number = T(first) else { throw ParsingError.argumentDidNotMatchType(T.self) }
        return number
    }
    
    func conditionType() throws -> ConditionType
    {
        guard let string = arguments.first else { throw ParsingError.noArguments }
        return try ConditionType(string: string)
    }
    
    func comparisonType() throws -> ComparisonType
    {
        guard let string = arguments.first else { throw ParsingError.noArguments }
        return try ComparisonType(string: string)
    }
    
    func argument(at index: Int) throws -> String
    {
        guard arguments.count > index else { throw ParsingError.indexOutsideOfArgumentsBounds(index) }
        return arguments[index]
    }
}

// MARK: - Commands

private extension Command
{
    func help() throws -> [Entity]
    {
        print("Sorry, no help is available at this time.")
        return []
    }
    
    func add() throws -> [Entity]
       {
           let entityType = try entityType()
           let name = try name(startingAt: 1)
           
           let entity = entityType.insertNewEntity(into: context, name: name)
           workspace.entities.insert(entity, at: 0)
           
           return [entity]
       }
       
       func setName() throws -> [Entity]
       {
           let entity: SymbolNamed = try workspace.first()
           let name = try name()
           
           let symbol = Symbol(context: context, name: name)
           entity.symbolName = symbol
           
           return [entity]
       }
       
       func hide() throws -> [Entity]
       {
           let entity: Entity = try workspace.first()
           entity.isHidden = true
           return [entity]
       }
       
       func unhide() throws -> [Entity]
       {
           let entity: Entity = try workspace.first()
           entity.isHidden = false
           return [entity]
       }
       
       func view() throws -> [Entity]
       {
           let entity: Printable = try workspace.first()
           print(entity.fullDescription)
           
           if let entity = entity as? Selectable
           {
               return entity.selection
           }
       }
       
       func delete() throws -> [Entity]
       {
           let entity = try workspace.first()
           context.delete(entity)
           return [entity]
       }
       
       func pin() throws -> [Entity]
       {
           let entity: Pinnable = try workspace.first()
           entity.isPinned = true
           return [entity]
       }
       
       func unpin() throws -> [Entity]
       {
           let entity: Pinnable = try workspace.first()
           entity.isPinned = false
           return [entity]
       }
       
       func select() throws -> [Entity]
       {
           let index = try index()
           let entity: Entity = try workspace.entity(at: index)
           workspace.entities.remove(at: index)
           workspace.entities.insert(entity, at: 0)
           
           if let entity = entity as? Selectable
           {
               return entity.selection
           }
           else
           {
               return [entity]
           }
       }
       
       func choose() throws -> [Entity]
       {
           let index = try index()
           
           guard index < workspace.lastResult.count else
           {
               throw ParsingError.lastResultIndexOutOfBounds(index)
           }
           
           let entity = workspace.lastResult[index]
           workspace.entities.insert(entity, at: 0)
           
           return [entity]
       }
       
       func history() throws -> [Entity]
       {
           let entity: Historable = try workspace.first()
           
           guard let history = entity.history else
           {
               throw ParsingError.noHistory
           }
           
           for item in history
           {
               print(item)
           }
       }
       
       func pinned()
       {
           //            output = runPinned(context: context)
       }
       
       func library()
       {
           //            output = runLibrary(context: context)
       }
       
       func all() throws -> [Entity]
       {
           let entityType = try entityType()
           //            output = runAll(entityType: entityType, context: context)
       }
       
       func unbalanced()
       {
           //            output = runUnbalanced(context: context)
       }
       
       func priority()
       {
           //            output = runPriority(context: context)
       }
       
       func dashboard()
       {
           // print out the pinned, unbalanced stocks, unbalanced systems, priority items
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
       }
       
       func suggest()
       {
           //            // Should we pin an item we view often?
           //            // Should we find a flow to balance an unbalanced stock?
           //            // Should we run a priority flow?
       }
       
       func events()
       {
           //            output = runEvents(context: context)
       }
       
       func flows()
       {
           //            output = runFlowsNeedingCompletion(context: context)
       }
       
       func running()
       {
           //            output = allRunningFlows(context: context)
       }
       
       func hidden()
       {
           //            output = allHidden(context: context)
       }
       
       func quit()
       {
           // TODO: Communicate to quit the application
       }
       
       func nuke()
       {
           //            database.clear()
       }
       
       func clear()
       {
           //            workspace.removeAll()
       }
       
       func setStockType() throws -> [Entity]
       {
           let stock: Stock = try workspace.first()
           let type = try sourceValueType()
           stock.source?.valueType = type
           return [stock]
       }
       
       func setCurrent() throws -> [Entity]
       {
           let stock: Stock = try workspace.first()
           let number: Double = try value()
           stock.current = number
           return [stock]
       }
       
       func setIdeal() throws -> [Entity]
       {
           let stock: Stock = try workspace.first()
           let number: Double = try value()
           stock.target = number
           return [stock]
       }
       
       func setMin() throws -> [Entity]
       {
           let stock: Stock = try workspace.first()
           let number: Double = try value()
           stock.min = number
           return [stock]
       }
       
       func setMax() throws -> [Entity]
       {
           let stock: Stock = try workspace.first()
           let number: Double = try value()
           stock.max = number
           return [stock]
       }
       
       func setUnit() throws -> [Entity]
       {
           let index = try index()
           let stock: Stock = try workspace.first()
           let unit: Unit = try workspace.entity(at: index)
           stock.unit = unit
           return [stock]
       }
       
       func linkOutflow() throws -> [Entity]
       {
           let index = try index()
           let stock: Stock = try workspace.first()
           let flow: Flow = try workspace.entity(at: index)
           stock.addToOutflows(flow)
           return [stock]
       }
       
       func linkInflow() throws -> [Entity]
       {
           let index = try index()
           let stock: Stock = try workspace.first()
           let flow: Flow = try workspace.entity(at: index)
           stock.addToInflows(flow)
           return [stock]
       }
       
       func unlinkOutflow() throws -> [Entity]
       {
           let index = try index()
           let stock: Stock = try workspace.first()
           let flow: Flow = try workspace.entity(at: index)
           stock.removeFromOutflows(flow)
           return [stock]
       }
       
       func unlinkInflow() throws -> [Entity]
       {
           let index = try index()
           let stock: Stock = try workspace.first()
           let flow: Flow = try workspace.entity(at: index)
           stock.removeFromInflows(flow)
           return [stock]
       }
       
       func setAmount() throws -> [Entity]
       {
           let flow: Flow = try workspace.first()
           let amount: Double = try value()
           
           guard amount > 0 else { throw ParsingError.flowAmountInvalid(amount) }
           flow.amount = amount
           return [flow]
       }
       
       func setDelay() throws -> [Entity]
       {
           let flow: Flow = try workspace.first()
           let delay: Double = try value()
           flow.delay = delay
           return [flow]
       }
       
       func setDuration() throws -> [Entity]
       {
           let flow: Flow = try workspace.first()
           let duration: Double = try value()
           flow.duration = duration
           return [flow]
       }
       
       func setRequires() throws -> [Entity]
       {
           let flow: Flow = try workspace.first()
           let requires: Bool = try value()
           flow.requiresUserCompletion = requires
           return [flow]
       }
       
       func setFrom() throws -> [Entity]
       {
           let index = try index()
           let flow: Flow = try workspace.first()
           let stock: Stock = try workspace.entity(at: index)
           flow.from = stock
           return [flow]
       }
       
       func setTo() throws -> [Entity]
       {
           let index = try index()
           let flow: Flow = try workspace.first()
           let stock: Stock = try workspace.entity(at: index)
           flow.to = stock
           return [flow]
       }
       
       func run() throws -> [Entity]
       {
           if let flow: Flow = try? workspace.first()
           {
               flow.run(fromUser: true)
               return [flow]
           }
           else if let process: Process = try? workspace.first()
           {
               process.run()
               return [process]
           }
       }
       
       func finish() throws -> [Entity]
       {
           let flow: Flow = try workspace.first()
           flow.amountRemaining = 0
           flow.isRunning = false
           return [flow]
       }
       
       func setRepeats() throws -> [Entity]
       {
           let flow: Flow = try workspace.first()
           let repeats: Bool = try value()
           flow.repeats = repeats
           return [flow]
       }
       
       func setActive() throws -> [Entity]
       {
           let event: Event = try workspace.first()
           let active: Bool = try value()
           event.isActive = active
           return [event]
       }
       
       func linkCondition() throws -> [Entity]
       {
           let index = try index()
           let event: Event = try workspace.first()
           let condition: Condition = try workspace.entity(at: index)
           event.addToConditions(condition)
           return [event]
       }
    
        func unlinkCondition() throws -> [Entity]
    {
        let index = try index()
        let event: Event = try workspace.first()
        let condition: Condition = try workspace.entity(at: index)
        event.removeFromConditions(condition)
        return [event]
    }
       
       func setConditionType() throws -> [Entity]
       {
           let event: Event = try workspace.first()
           let conditionType = try conditionType()
           event.conditionType = conditionType
           return [event]
       }
       
       func setCooldown() throws -> [Entity]
       {
           let event: Event = try workspace.first()
           let cooldown: Double = try value()
           event.cooldownSeconds = cooldown
           return [event]
       }
       
       func setComparison() throws -> [Entity]
       {
           let condition: Condition = try workspace.first()
           let comparison = try comparisonType()
           let type = try argument(at: 1)
       }
       
       func setLeftHand() throws -> [Entity]
       {
           let condition: Condition = try workspace.first()
           
           if let leftHand: Double = try? value()
           {
               
           }
           else if
               let index = try? index(),
               let source: Source = try workspace.entity(at: index)
           {
               
           }
           else if
               let index = try? index(),
               let stock: Stock = try workspace.entity(at: index)
           {
               
           }
           else
           {
               throw ParsingError.workspaceEntityCannotPerformThisOperation
           }
       }
       
       func setRightHand() throws -> [Entity]
       {
           let condition: Condition = try workspace.first()
           
           if let rightHand: Double = try? value()
           {
               
           }
           else if
               let index = try? index(),
               let source: Source = try workspace.entity(at: index)
           {
               
           }
           else if
               let index = try? index(),
               let stock: Stock = try workspace.entity(at: index)
           {
               
           }
           else
           {
               throw ParsingError.workspaceEntityCannotPerformThisOperation
           }
       }
       
       func linkFlow() throws -> [Entity]
       {
           let index = try index()
           let flow: Flow = try workspace.entity(at: index)
           
           if let event: Event = try? workspace.first()
           {
               event.addToFlows(flow)
               return [event]
           }
           else if let system: System = try? workspace.first()
           {
               system.addToFlows(flow)
               return [system]
           }
           else if let process: Process = try? workspace.first()
           {
               process.addToFlows(flow)
               return [process]
           }
           else
           {
               throw ParsingError.workspaceEntityCannotPerformThisOperation
           }
       }
       
       func unlinkFlow() throws -> [Entity]
       {
           let index = try index()
           let flow: Flow = try workspace.entity(at: index)
           
           if let event: Event = try? workspace.first()
           {
               
           }
           else if let system: System = try? workspace.first()
           {
               
           }
           else if let process: Process = try? workspace.first()
           {
               
           }
           else
           {
               throw ParsingError.workspaceEntityCannotPerformThisOperation
           }
       }
       
       func linkStock() throws -> [Entity]
       {
           let index = try index()
           let stock: Stock = try workspace.entity(at: index)
           let system: System = try workspace.first()
       }
       
       func unlinkStock() throws -> [Entity]
       {
           let index = try index()
           let stock: Stock = try workspace.entity(at: index)
           let system: System = try workspace.first()
       }
       
       func linkEvent() throws -> [Entity]
       {
           let index = try index()
           let event: Event = try workspace.entity(at: index)
           
           if let flow: Flow = try? workspace.first()
           {
               
           }
           else if let stock: Stock = try? workspace.first()
           {
               
           }
           else if let process: Process = try? workspace.first()
           {
               
           }
           else
           {
               throw ParsingError.workspaceEntityCannotPerformThisOperation
           }
       }
       
       func unlinkEvent() throws -> [Entity]
       {
           let index = try index()
           let event: Event = try workspace.entity(at: index)
           
           if let flow: Flow = try? workspace.first()
           {
               
           }
           else if let stock: Stock = try? workspace.first()
           {
               
           }
           else if let process: Process = try? workspace.first()
           {
               
           }
           else
           {
               throw ParsingError.workspaceEntityCannotPerformThisOperation
           }
       }
       
       func linkProcess() throws -> [Entity]
       {
           let index = try index()
           let subprocess: Process = try workspace.entity(at: index)
           let process: Process = try workspace.first()
       }
       
       func unlinkProcess() throws -> [Entity]
       {
           let index = try index()
           let subprocess: Process = try workspace.entity(at: index)
           let process: Process = try workspace.first()
       }
       
       func booleanStockFlow() throws -> [Entity]
       {
           let name = try name()
       }
   }
