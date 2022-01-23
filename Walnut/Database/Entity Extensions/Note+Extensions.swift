//
//  Note+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 1/8/22.
//

import Foundation

extension Note: Named
{
    public var unwrappedName: String? { unwrappedBlocks.first?.text }
}

extension Note
{
    var unwrappedBlocks: [Block] { return self.unwrapped(\Note.blocks) }
    
    var firstLine: String?
    {
        String(unwrappedBlocks.first?.text?.prefix(25) ?? "")
    }
    
    var secondLine: String?
    {
        guard unwrappedBlocks.count > 1 else { return "" }
        return String(unwrappedBlocks[1].text?.prefix(25) ?? "")
    }
}
