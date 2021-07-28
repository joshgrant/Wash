//
//  UnitDetailRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 7/28/21.
//

import Foundation

struct UnitDetailRouter
{
    // MARK: - Variables
    
    var unit: Unit
    var context: Context
    var stream: Stream
    
    weak var delegate: RouterDelegate?
    
    // MARK: - Functions
    
    func routeToLinkUnit(linkDelegate: LinkSearchControllerDelegate)
    {
        let container = LinkSearchControllerContainer(
            context: context,
            stream: stream,
            origin: .unit,
            hasAddButton: false,
            entityType: Unit.self)
        let controller = container.makeController()
        controller.delegate = linkDelegate
        delegate?.navigationController?.pushViewController(controller, animated: true)
    }
}
