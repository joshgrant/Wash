//
//  ListSectionHeader.swift
//  Walnut
//
//  Created by Joshua Grant on 7/21/21.
//

import Foundation
import UIKit

struct ListSectionHeaderModel
{
    var text: String
    var icon: Icon?
    
    var disclose: ActionClosure?
    var link: ActionClosure?
    var add: ActionClosure?
    var edit: ActionClosure?
}

class ListSectionHeader: UICollectionReusableView
{
    // MARK: - Variables
    
    var stackView: UIStackView
    
    // MARK: - Initialization
    
    override init(frame: CGRect)
    {
        stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.set(height: 44)
        
        super.init(frame: frame)
        
        embed(stackView, bottomPriority: .defaultHigh)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Factory
    
    func configure(with model: ListSectionHeaderModel)
    {
        stackView.completelyRemoveAllArrangedSubviews()
        
        let views = [
            SpacerView(width: 5),
            makeDisclosureButton(with: model),
            makeImageView(with: model),
            makeTitleLabel(with: model),
            SpacerView(),
            makeLinkButton(with: model),
            makeAddButton(with: model),
            makeEditButton(with: model),
            SpacerView(width: 5)
        ]
        
        for view in views
        {
            guard let view = view else { continue }
            stackView.addArrangedSubview(view)
        }
    }
    
    private func makeDisclosureButton(with model: ListSectionHeaderModel) -> UIButton?
    {
        guard let disclose = model.disclose else { return nil }
        
        let button = UIButton()
        
        button.setImage(.init(named: "Disclose"), for: .normal)
        button.tintColor = .tableViewHeaderIcon
        button.set(width: 44, height: 44)
        button.addTarget(
            disclose,
            action: #selector(disclose.perform(sender:)),
            for: .touchUpInside)
        
        return button
    }
    
    private func makeImageView(with model: ListSectionHeaderModel) -> UIImageView?
    {
        guard let image = model.icon?.getImage() else { return nil }
        let imageView = UIImageView(image: image)
        imageView.tintColor = .tableViewHeaderIcon
        return imageView
    }
    
    private func makeTitleLabel(with model: ListSectionHeaderModel) -> UILabel
    {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 13)
        label.textColor = .tableViewHeaderFont
        label.text = model.text.localizedUppercase
        
        return label
    }
    
    public func makeLinkButton(with model: ListSectionHeaderModel) -> UIButton?
    {
        guard let link = model.link else { return nil }
        
        let button = UIButton()
        
        button.setImage(Icon.link.getImage(), for: .normal)
        button.tintColor = .tableViewHeaderIcon
        button.set(width: 44, height: 44)
        button.addTarget(link,
                         action: #selector(link.perform(sender:)),
                         for: .touchUpInside)
        
        return button
    }
    
    public func makeAddButton(with model: ListSectionHeaderModel) -> UIButton?
    {
        guard let add = model.add else { return nil }
        
        let button = UIButton()
        
        button.setImage(Icon.add.getImage(), for: .normal)
        button.tintColor = .tableViewHeaderIcon
        button.set(width: 44, height: 44)
        button.addTarget(add,
                         action: #selector(add.perform(sender:)),
                         for: .touchUpInside)
        
        return button
    }
    
    func makeEditButton(with model: ListSectionHeaderModel) -> UIButton?
    {
        guard let edit = model.edit else { return nil }
        
        let button = UIButton()
        
        button.setTitle(.edit, for: .normal)
        button.setTitleColor(.tableViewHeaderFont, for: .normal)
        button.set(width: 44, height: 44)
        button.addTarget(edit,
                         action: #selector(edit.perform(sender:)),
                         for: .touchUpInside)
        
        return button
    }
}
