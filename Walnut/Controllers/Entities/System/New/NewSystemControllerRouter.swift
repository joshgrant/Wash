//
//  NewSystemControllerRouter.swift
//  Walnut
//
//  Created by Joshua Grant on 7/21/21.
//

import Foundation

class NewSystemControllerRouterContainer: DependencyContainer
{
    
}

class NewSystemControllerRouter: Router<NewSystemControllerRouterContainer>
{
    func routeCancel()
    {
        delegate?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func routeDone()
    {
        delegate?.navigationController?.dismiss(animated: true, completion: nil)
    }
}
