//
//  DashboardListRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 1/6/22.
//

import Foundation

class DashboardListRouter
{
    var context: Context
    var stream: Stream
    
    weak var delegate: RouterDelegate?
    
    init(context: Context, stream: Stream)
    {
        self.context = context
        self.stream = stream
    }
    
    // MARK: - Functions
    
    func routeToDetail(entity: Entity)
    {
        let detail = entity.detailController(
            context: context,
            stream: stream)
        delegate?.navigationController?.pushViewController(detail, animated: true)
    }
}
