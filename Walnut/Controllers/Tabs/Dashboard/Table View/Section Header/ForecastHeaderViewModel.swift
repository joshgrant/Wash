//
//  ForecastHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation

class ForecastHeaderViewModel: TableHeaderViewModel
{
    convenience init()
    {
        self.init(
            title: "Forecast".localized,
            icon: .forecast)
    }
}
