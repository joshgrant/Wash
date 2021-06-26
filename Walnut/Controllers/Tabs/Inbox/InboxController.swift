//
//  InboxController.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

class InboxController: ViewController<
                        InboxControllerModel,
                        InboxViewModel,
                        InboxView>
{
    // MARK: - Initialization
    
    override init(
        controllerModel: InboxControllerModel,
        viewModel: InboxViewModel)
    {
        super.init(
            controllerModel: controllerModel,
            viewModel: viewModel)
        
        tabBarItem = makeTabBarItem()
        title = model.tabBarItemTitle
        view.backgroundColor = model.backgroundColor
    }
}

extension InboxController: ViewControllerTabBarDelegate
{
    func makeTabBarItem() -> UITabBarItem
    {
        UITabBarItem(
            title: model.tabBarItemTitle,
            image: model.tabBarImage,
            tag: model.tabBarTag)
    }
}

extension InboxController
{
    static func makeControllerModel() -> InboxControllerModel
    {
        InboxControllerModel()
    }
    
    static func makeViewModel() -> InboxViewModel
    {
        InboxViewModel()
    }
    
    static func makeController() -> InboxController
    {
        let controllerModel = makeControllerModel()
        let viewModel = makeViewModel()
        
        return InboxController(
            controllerModel: controllerModel,
            viewModel: viewModel)
    }
}
