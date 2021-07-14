//
//  NewStockRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

class NewStockRouter: Router
{
    // MARK: - Defined types
    
    enum Destination
    {
        case back
        case currentIdealState
        case states
        case minMax
        case unitSearch
    }
    
    // MARK: - Variables
    
    var newStockModel: NewStockModel
    
    weak var context: Context?
    weak var delegate: RouterDelegate?
    
    // MARK: - Initialization
    
    init(newStockModel: NewStockModel, context: Context?)
    {
        self.newStockModel = newStockModel
        self.context = context
    }
    
    // MARK: - Functions
    
    func route(to destination: Destination, completion: (() -> Void)?)
    {
        switch destination
        {
        case .back:
            delegate?.navigationController?.popViewController(animated: true)
        case .currentIdealState:
            routeToCurrentIdealState()
        case .states:
            routeToStates()
        case .minMax:
            routeToMinMax()
        case .unitSearch:
            routeToUnitSearch()
        }
    }
    
    private func routeToCurrentIdealState()
    {
        let currentIdealController = CurrentIdealController(
            newStockModel: newStockModel,
            context: context)
        delegate?.navigationController?.pushViewController(currentIdealController, animated: true)
    }
    
    private func routeToStates()
    {
        
    }
    
    private func routeToMinMax()
    {
        let minMaxController = MinMaxController(newStockModel: newStockModel, context: context)
        delegate?.navigationController?.pushViewController(minMaxController, animated: true)
    }
    
    private func routeToUnitSearch()
    {
        let linkController = LinkSearchController(
            origin: .newStock,
            entityType: Unit.self,
            context: context,
            hasAddButton: true)
        delegate?.navigationController?.pushViewController(linkController, animated: true)
    }
}
