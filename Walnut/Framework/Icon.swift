//
//  Icon.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import Cocoa

public enum Icon: String
{
    case add = "plus"
    case pin = "pin"
    case pinFill = "pin.fill"
    case flow = "wind"
    case forecast = "calendar"
    case system = "network"
    case stock = "shippingbox"
    case event = "sparkles"
    case conversion = "arrow.left.arrow.right"
    case rightArrow = "arrow.right"
    case leftArrow = "arrow.left"
    case condition = "switch.2"
    case dimension = "move.3d"
    case unit = "atom"
    case symbol = "asterisk.circle"
    case note = "note.text"
    case task = "flowchart"
    case search = "magnifyingglass"
    case dashboard = "speedometer"
    case library = "books.vertical"
    case inbox = "tray.and.arrow.down"
    case settings = "gearshape"
    case copy = "doc.on.doc"
    case activateFlow = "play.circle"
    case link = "link"
    case question = "questionmark"
    case filter = "line.horizontal.3.decrease.circle"
    case checkBoxEmpty = "circle"
    case checkBoxFilled = "checkmark.circle" // or try .fill
    case priority = "exclamationmark.triangle.fill" // or remove the fill
    case state = "square.on.circle"
    case min = "dial.min"
    case max = "dial.max.fill"
    case refresh = "arrow.clockwise"
    
    case rightChevron = "chevron.right"
    
    // Keyboard
    case negative = "minus"
    case infinity = "infinity"
    case delete = "delete.left"
    case enter = "return"
    
    case arrowDown = "arrowtriangle.down.fill"
    case arrowRight = "arrowtriangle.right.fill"
    
    var image: NSImage? { .init(systemSymbolName: rawValue, accessibilityDescription: nil) }
    
    public func textIcon() -> String
    {
        switch self
        {
        case .add: return "􀅼"
        case .pin: return "􀎦"
        case .pinFill: return "􀎦"
        case .flow: return "􀇤"
        case .forecast: return "􀉉"
        case .system: return "􀤆"
        case .stock: return "􀐚"
        case .event: return "􀆿"
        case .conversion: return "􀄭"
        case .rightArrow: return "􀄫"
        case .leftArrow: return "􀄪"
        case .condition: return "􀜊"
        case .dimension: return "􀢅"
        case .unit: return "􀬚"
        case .symbol: return "􀕬"
        case .note: return "􀓕"
        case .task: return "􀐕"
        case .search: return "􀊫"
        case .dashboard: return "􀍾"
        case .library: return "􀬒"
        case .inbox: return "􀈧"
        case .settings: return "􀣋"
        case .copy: return "􀉁"
        case .activateFlow: return "􀊕"
        case .link: return "􀉣"
        case .question: return "􀅍"
        case .filter: return "􀌈"
        case .checkBoxEmpty: return "􀀀"
        case .checkBoxFilled: return "􀁢" // or try .fill
        case .priority: return "􀇿" // or remove the fill
        case .state: return "􀐉"
        case .min: return "􀍺"
        case .max: return "􀪑"
        case .refresh: return "􀅈"
        case .rightChevron: return "􀆊"
        case .negative: return "􀅽"
        case .infinity: return "􀯠"
        case .delete: return "􀆛"
        case .enter: return "􀅇"
        case .arrowDown: return "􀄥"
        case .arrowRight: return "􀄧"
        }
    }
}
