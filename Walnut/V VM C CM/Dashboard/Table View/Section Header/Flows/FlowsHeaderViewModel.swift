//
//  FlowsHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation

class FlowsHeaderViewModel: TableHeaderViewModel
{
    convenience init()
    {
        self.init(
            title: "Flows".localized,
            icon: .flow)
    }
}
