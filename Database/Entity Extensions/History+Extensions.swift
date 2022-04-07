//
//  History+Extensions.swift
//  Wash
//
//  Created by Joshua Grant on 3/26/22.
//

import Foundation

extension History
{
    var eventType: HistoryEvent
    {
        get { HistoryEvent(rawValue: eventTypeRaw) ?? .fallback }
        set { eventTypeRaw = newValue.rawValue }
    }
}

extension History
{
    public override var description: String
    {
        let icon = Icon.forecast.text
        let formattedDate = date?.formatted(.dateTime.month().day().hour().minute()) ?? "nil"
        return "\(icon) \(eventType) @ \(formattedDate)"
    }
}
