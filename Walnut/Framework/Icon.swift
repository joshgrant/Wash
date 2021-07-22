//
//  Icon.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

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
    case process = "flowchart"
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
    
    var image: UIImage { UIImage(systemName: self.rawValue)! }
    
    public func textIcon() -> String
    {
        switch self
        {
        case .stock: return "􀐚"
        case .system: return "􀤆"
        default:
            return ""
        }
    }
}
