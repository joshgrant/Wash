//
//  PriorityHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation

class PriorityHeaderViewModel: TableHeaderViewModel
{
    convenience init()
    {
        self.init(
            title: "Priority".localized,
            icon: .system)
    }
}
