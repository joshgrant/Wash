//
//  DashboardListFactory.swift
//  Walnut
//
//  Created by Joshua Grant on 1/6/22.
//

import UIKit

protocol DashboardListFactory: Factory
{
    func makeRefreshButton(target: DashboardListResponder) -> UIBarButtonItem
    func makeSpinnerButton() -> UIBarButtonItem
    func makeRouter() -> DashboardListRouter
}
