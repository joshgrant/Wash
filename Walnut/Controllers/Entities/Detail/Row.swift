//
//  Row.swift
//  Walnut
//
//  Created by Josh Grant on 1/27/22.
//

import Foundation

extension EntityDetailViewController
{
    enum Row: CustomStringConvertible
    {
        case text(string: String)
        case detail(index: Int, text: String)
        case flow(index: Int, flow: Flow)
        case note(index: Int, note: Note)
        case keyValue(key: String, value: String)
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
                return " \(index). \(flow.title): \(flow.to?.title ?? "None") -> \(flow.from?.title ?? "None") (\(String(format: "%.2f", flow.amount)))"
            case .note(let index, let note):
                return " \(index). \(note.firstLine ?? "")\n    \(note.secondLine ?? "")"
            case .keyValue(let key, let value):
                return "\(key): \(value)"
            case .editable(let index, let text, let placeholder):
                return "\(index). \(text ?? placeholder)           \(Icon.edit.text)"
            case .toggle(let index, let text, let isOn):
                return "\(index). \(text): \(isOn ? Icon.checkBoxFilled.text : Icon.checkBoxEmpty.text)"
            }
        }
    }
}
