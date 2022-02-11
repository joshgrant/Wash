//
//  Row.swift
//  Walnut
//
//  Created by Josh Grant on 1/27/22.
//

import Foundation
import Protyper

extension EntityDetailViewController
{
    enum Row: CustomStringConvertible
    {
        case text(string: String)
        case detail(index: Int, text: String)
        case flow(index: Int, flow: Flow)
        case note(index: Int, note: Note)
        case keyValue(index: Int, key: String, value: String)
        case editable(index: Int, text: String?, placeholder: String)
        case toggle(index: Int, text: String, isOn: Bool)
        
        var description: String
        {
            switch self {
            case .text(let string):
                return string
            case .detail(let index, let text):
                return "\(index). \(text)"
            case .flow(let index, let flow):
                // TODO: Why is to/from flipped here???
                let left = "\(index). \(flow.title):"
                let right = "\(flow.to?.title ?? "None") -> \(flow.from?.title ?? "None") (\(String(format: "%.2f", flow.amount)))"
                return description(left: left, right: right)
            case .note(let index, let note):
                return " \(index). \(note.firstLine ?? "")\n    \(note.secondLine ?? "")"
            case .keyValue(let index, let key, let value):
                let left = "\(index). \(key):"
                return description(left: left, right: value)
            case .editable(let index, let text, let placeholder):
                let left = "\(index). \(text ?? placeholder)"
                let right = Icon.edit.text
                return description(left: left, right: right)
            case .toggle(let index, let text, let isOn):
                let left = "\(index). \(text):"
                let right = isOn ? Icon.checkBoxFilled.text : Icon.checkBoxEmpty.text
                return description(left: left, right: right)
            }
        }
        
        func description(left: String, right: String) -> String
        {
            let padding = String.centerPadding(left: left, right: right, width: consoleWidth)
            return "\(left)\(padding)\(right)"
        }
    }
}
