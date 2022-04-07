//
//  Historable.swift
//  Wash
//
//  Created by Josh Grant on 4/7/22.
//

import Foundation

protocol Historable
{
    var history: NSSet? { get set }
    func addToHistory(_ value: History)
    func addToHistory(_ values: NSSet)
    func removeFromHistory(_ value: History)
    func removeFromHistory(_ values: NSSet)
}

extension Historable
{
    func logHistory(_ eventType: HistoryEvent, context: Context)
    {
        let history = History(context: context)
        history.date = .now
        history.eventType = eventType
        addToHistory(history)
    }
}
