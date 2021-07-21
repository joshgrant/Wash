//
//  ListSectionHeaderView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/20/21.
//

import Foundation
import UIKit

class ListSectionHeaderView: UIView
{
    // MARK: - Variables
    
    var model: SectionHeaderListItem
    
    // MARK: - Initialization
    
    init(model: SectionHeaderListItem)
    {
        self.model = model
        super.init(frame: .zero)
        
        backgroundColor = .systemGroupedBackground
        
        let stackView = makeMainStackView()
        embed(stackView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Factory
    
    private func makeTitleView() -> UILabel
    {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor.tableViewHeaderFont
        
        label.text = model.text
        label.text = model.text.localizedUppercase
        
        return label
    }
    
    private func makeMainStackView() -> UIStackView
    {
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.spacing = 5
        
        mainStackView.addArrangedSubview(SpacerView(width: 5))
        
        if model.disclosure
        {
//            mainStackView.addArrangedSubview(makeDisclosureButton())
        }
        
        if let image = model.icon?.getImage()
        {
            mainStackView.addArrangedSubview(makeImageView(image: image))
        }
        
        mainStackView.addArrangedSubview(makeTitleView())
        mainStackView.addArrangedSubview(SpacerView())
        
        if model.search != nil
        {
            mainStackView.addArrangedSubview(makeSearchButton())
        }
        
        if model.link != nil
        {
            mainStackView.addArrangedSubview(makeLinkButton())
        }
        
        if model.add != nil
        {
            mainStackView.addArrangedSubview(makeAddButton())
        }
        
        if model.edit != nil
        {
            mainStackView.addArrangedSubview(makeEditButton())
        }
        
        mainStackView.addArrangedSubview(SpacerView(width: 5))
        
        return mainStackView
    }
    
//    public func makeDisclosureButton() -> UIButton
//    {
//        let button = UIButton()
//        button.setImage(Icon.arrowDown.getImage(), for: .normal)
//        button.tintColor = .tableViewHeaderIcon
//        button.set(width: 44, height: 44)
//        button.addTarget(
//            model.disclosureTriangleActionClosure,
//            action: #selector(model.disclosureTriangleActionClosure?.perform(sender:)),
//            for: .touchUpInside)
//        return button
//    }
    
    public func makeImageView(image: UIImage) -> UIImageView
    {
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.tableViewHeaderIcon
        return imageView
    }
    
    public func makeSearchButton() -> UIButton
    {
        let button = UIButton()
        button.setImage(Icon.search.getImage(), for: .normal)
        button.tintColor = .tableViewHeaderIcon
        button.set(width: 44, height: 44)
        button.addTarget(model.search,
                         action: #selector(model.search?.perform(sender:)),
                         for: .touchUpInside)
        return button
    }
    
    public func makeLinkButton() -> UIButton
    {
        let button = UIButton()
        button.setImage(Icon.link.getImage(), for: .normal)
        button.tintColor = .tableViewHeaderIcon
        button.set(width: 44, height: 44)
        button.addTarget(model.link,
                         action: #selector(model.link?.perform(sender:)),
                         for: .touchUpInside)
        return button
    }
    
    public func makeAddButton() -> UIButton
    {
        let button = UIButton()
        button.setImage(Icon.add.getImage(), for: .normal)
        button.tintColor = .tableViewHeaderIcon
        button.set(width: 44, height: 44)
        button.addTarget(model.add,
                         action: #selector(model.add?.perform(sender:)),
                         for: .touchUpInside)
        return button
    }
    
    func makeEditButton() -> UIButton
    {
        let button = UIButton()
        button.setTitle(.edit, for: .normal)
        button.setTitleColor(.tableViewHeaderFont, for: .normal)
        button.set(width: 44, height: 44)
        button.addTarget(model.edit,
                         action: #selector(model.edit?.perform(sender:)),
                         for: .touchUpInside)
        return button
    }
}
