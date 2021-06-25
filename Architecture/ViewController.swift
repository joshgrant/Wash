//
//  ViewController.swift
//  Architecture
//
//  Created by Joshua Grant on 6/23/21.
//

import UIKit

class ViewController: UIViewController
{
    // MARK: - Variables
    
    var id = UUID()
    
    // 1. We have an object that manages the state
    // 2. We have an object that manages the visual presentation
    // 3. We have an object that responds to events (UI or system)
    // 4. We have an object that contains the most recent data
    // 5. We have an object that knows how to route
    // 6. We have an object that coordinates the others
    // 7. We have an object that's responsible for verifying everything (tests)
    
    // Actually, with event passing, tests become super easy to write. Just call the publisher and verify that the stream contains the proper event.
    
    // MARK: - Initialization
    
    init()
    {
        super.init(nibName: nil, bundle: nil)
        subscribe(to: AppDelegate.shared.mainStream)
        configureButton()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func configureButton()
    {
        let frame = CGRect(
            origin: .zero,
            size: .init(
                width: 100,
                height: 100))
        
        let button = UIButton(frame: frame)
        button.backgroundColor = .yellow
        
        button.addTarget(
            self,
            action: #selector(buttonDidTouchUpInside(sender:)),
            for: .touchUpInside)
        
        view.addSubview(button)
    }
    
    @objc func buttonDidTouchUpInside(sender: UIButton)
    {
        let data = EventData(
            token: "viewController.buttonPress",
            info: ["button": sender])
        let event = Event(data: data)
        AppDelegate.shared.mainStream.send(event: event)
    }
}

extension ViewController: Subscriber
{
    func receive(event: Event)
    {
        print("VIEW CONTROLLER: \(event)")
    }
}
