//
//  NewStockRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 7/14/21.
//

import Foundation
import UIKit

class NewStockRouterContainer: DependencyContainer
{
    // MARK: - Variables
    
    var model: NewStockModel
    var context: Context
    var stream: Stream
 
    // MARK: - Initialization
    
    init(model: NewStockModel, context: Context, stream: Stream)
    {
        self.model = model
        self.context = context
        self.stream = stream
    }
}

class NewStockRouter: Router<NewStockRouterContainer>
{
    // MARK: - Variables
    
//    var newStockModel: NewStockModel
    
//    weak var context: Context?
    
    // MARK: - Initialization
    
//    init(newStockModel: NewStockModel, context: Context?)
//    {
//        self.newStockModel = newStockModel
//        self.context = context
//    }
    
    // MARK: - Functions
    
    func routeDismiss()
    {
        delegate?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func routeBack()
    {
        delegate?.navigationController?.popViewController(animated: true)
    }
    
    func routeToNext()
    {
        if container.model.stockType == .boolean
        {
            routeToCurrentIdealState()
        }
        else if container.model.isStateMachine
        {
            routeToStates()
        }
        else if container.model.stockType == .percent
        {
            routeToCurrentIdealState()
        }
        else
        {
            routeToMinMax()
        }
    }
    
    func routeToCurrentIdealState()
    {
        let container = CurrentIdealControllerDependencyContainer(
            model: container.model,
            context: container.context,
            stream: container.stream)
        let currentIdealController = CurrentIdealController(container: container)
        delegate?.navigationController?.pushViewController(currentIdealController, animated: true)
    }
    
    func routeToStates()
    {
        let container = NewStockStateContainer(
            model: container.model,
            context: container.context,
            stream: container.stream)
        let stateController = NewStockStateController(container: container)
        delegate?.navigationController?.pushViewController(stateController, animated: true)
    }
    
    func routeToMinMax()
    {
        let minMaxController = MinMaxController(
            newStockModel: container.model,
            context: container.context)
        delegate?.navigationController?.pushViewController(minMaxController, animated: true)
    }
    
    func routeToUnitSearch()
    {
        let linkController = LinkSearchController(
            origin: .newStock,
            entityType: Unit.self,
            context: container.context,
            hasAddButton: true)
        delegate?.navigationController?.pushViewController(linkController, animated: true)
    }
}
