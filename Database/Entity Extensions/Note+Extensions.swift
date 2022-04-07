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
}
