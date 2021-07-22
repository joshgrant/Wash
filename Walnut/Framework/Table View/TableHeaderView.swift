//
//  TableHeaderView.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

open class TableHeaderView: View<TableHeaderViewModel>
{
    // MARK: - Initialization
    
    required public init(model: TableHeaderViewModel)
    {
        super.init(model: model)
        
        backgroundColor = .systemGroupedBackground
        
        let stackView = makeMainStackView()
        embed(stackView)
    }
    
    // MARK: - Factory
    
    private func makeTitleView() -> UILabel
    {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor.tableViewHeaderFont
        
        label.text = model.title
        label.text = model.title.localizedUppercase
        
        return label
    }
    
    private func makeMainStackView() -> UIStackView
    {
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.spacing = 5
        
        mainStackView.addArrangedSubview(SpacerView(width: 5))
        
        if model.hasDisclosureTriangle
        {
            mainStackView.addArrangedSubview(makeDisclosureButton())
        }
        
        if let image = model.icon?.image
        {
            mainStackView.addArrangedSubview(makeImageView(image: image))
        }
        
        mainStackView.addArrangedSubview(makeTitleView())
        mainStackView.addArrangedSubview(SpacerView())
        
        if model.hasSearchButton
        {
            mainStackView.addArrangedSubview(makeSearchButton())
        }
        
        if model.hasLinkButton
        {
            mainStackView.addArrangedSubview(makeLinkButton())
        }
        
        if model.hasAddButton
        {
            mainStackView.addArrangedSubview(makeAddButton())
        }
        
        if model.hasEditButton
        {
            mainStackView.addArrangedSubview(makeEditButton())
        }
        
        mainStackView.addArrangedSubview(SpacerView(width: 5))
        
        return mainStackView
    }
    
    public func makeDisclosureButton() -> UIButton
    {
        let button = UIButton()
        button.setImage(Icon.arrowDown.image, for: .normal)
        button.tintColor = .tableViewHeaderIcon
        button.set(width: 44, height: 44)
        button.addTarget(
            model.disclosureTriangleActionClosure,
            action: #selector(model.disclosureTriangleActionClosure?.perform(sender:)),
            for: .touchUpInside)
        return button
    }
    
    public func makeImageView(image: UIImage) -> UIImageView
    {
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.tableViewHeaderIcon
        return imageView
    }
    
    public func makeSearchButton() -> UIButton
    {
        let button = UIButton()
        button.setImage(Icon.search.image, for: .normal)
        button.tintColor = .tableViewHeaderIcon
        button.set(width: 44, height: 44)
        button.addTarget(model.searchButtonActionClosure,
                         action: #selector(model.searchButtonActionClosure?.perform(sender:)),
                         for: .touchUpInside)
        return button
    }
    
    public func makeLinkButton() -> UIButton
    {
        let button = UIButton()
        button.setImage(Icon.link.image, for: .normal)
        button.tintColor = .tableViewHeaderIcon
        button.set(width: 44, height: 44)
        button.addTarget(model.linkButtonActionClosure,
                         action: #selector(model.linkButtonActionClosure?.perform(sender:)),
                         for: .touchUpInside)
        return button
    }
    
    public func makeAddButton() -> UIButton
    {
        let button = UIButton()
        button.setImage(Icon.add.image, for: .normal)
        button.tintColor = .tableViewHeaderIcon
        button.set(width: 44, height: 44)
        button.addTarget(model.addButtonActionClosure,
                         action: #selector(model.addButtonActionClosure?.perform(sender:)),
                         for: .touchUpInside)
        return button
    }
    
    func makeEditButton() -> UIButton
    {
        let button = UIButton()
        button.setTitle(model.editButtonTitle, for: .normal)
        button.setTitleColor(.tableViewHeaderFont, for: .normal)
        button.set(width: 44, height: 44)
        button.addTarget(model.editButtonActionClosure,
                         action: #selector(model.editButtonActionClosure?.perform(sender:)),
                         for: .touchUpInside)
        return button
    }
}
