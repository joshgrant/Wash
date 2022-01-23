////
////  StockDetailViewController.swift
////  Walnut
////
////  Created by Joshua Grant on 1/17/22.
////
//
//import Foundation
//import Protyper
//
//class StockDetailView: View
//{
//    var stock: Stock
//
//    init(stock: Stock)
//    {
//        self.stock = stock
//    }
//
//    override func display()
//    {
//        print("1. Info")
//        print("   —–––")
//        printInfo()
//        print("")
//
//        print("2. \(Icon.state.text) States")
//        print("   —–––")
//        print("")
//
//        print("3. \(Icon.leftArrow.text) Inflows")
//        print("   —–––")
//        printFlows(stock.unwrappedInflows)
//        print("")
//
//        print("4. \(Icon.rightArrow.text) Outflows")
//        print("   —–––")
//        printFlows(stock.unwrappedOutflows)
//        print("")
//
//        print("5. \(Icon.note.text) Notes")
//        print("   —–––")
//        printNotes(stock.unwrapped(\Stock.notes))
//        print("")
//    }
//
//    private func printInfo()
//    {
//        if stock.uniqueID == ContextPopulator.sinkId || stock.uniqueID == ContextPopulator.sourceId
//        {
//            print("Value: Infinity")
//        }
//        else
//        {
//            let current = String(format: "%.2f", stock.current)
//            let target = String(format: "%.2f", stock.target)
//            print("Current: \(current)")
//            print("Target: \(target)")
//        }
//    }
//
//    private func printFlows(_ flows: [Flow])
//    {
//        for item in flows.enumerated()
//        {
//            let flow = item.element
//            let title = flow.title
//            let from = flow.from?.title ?? "None"
//            let to = flow.to?.title ?? "None"
//            let amount = String(format: "%.2f", flow.amount)
//            print("  \(item.offset + 1). \(title) : \(from) -> \(to) (\(amount))")
//        }
//    }
//
//    private func printNotes(_ notes: [Note])
//    {
//        for item in notes.enumerated()
//        {
//            let note = item.element
//            let title = note.firstLine ?? ""
//            let detail = note.secondLine ?? ""
//            print("  \(item.offset + 1). \(title)")
//            print("    \(detail)")
//        }
//    }
//}
//
//class StockDetailViewController: ViewController
//{
//    var stock: Stock
//
//    init(stock: Stock)
//    {
//        self.stock = stock
//        super.init(title: stock.title,
//                   view: StockDetailView(stock: stock))
//
//        let rightItem = stock.isPinned ? Icon.pinFill.text : ""
//        navigationItem = .init(title: stock.title, rightItem: rightItem)
//    }
//
//    override func handle(command: Command)
//    {
//        switch command.rawString
//        {
//        case "pin":
//            stock.isPinned = true
////            navigationController?.updateItems()
////            display()
//        case "unpin":
//            stock.isPinned = false
////            navigationController?.updateItems()
////            display()
//        default:
//            break
//        }
//    }
//}
