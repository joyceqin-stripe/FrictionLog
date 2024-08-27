////
////  QuantityController.swift
////  FrictionLog
////
////  Created by Joyce Qin on 8/26/24.
////
//
//import UIKit
//import Foundation
//
//class QuantityController: UIViewController {
//    var quantity: Int = 1
//    
//    private let containerView = UIView()
//    private let minus = UIButton(type: .custom)
//    private let text = UITextField()
//    private let plus = UIButton(type: .custom)
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupContainerView()
//        setupLabel()
//        setupLayout()
//        view.backgroundColor = Constants.background
//    }
//    
//    private func setupContainerView() {
//        // Set up container view
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(containerView)
//    }
//    
//    private func setupButtons() {
//        minus.translatesAutoresizingMaskIntoConstraints = false
//        minus.backgroundColor = Constants.accentColor // Button background color
//        minus.layer.cornerRadius = 40 // Half of width/height for a perfect circle
//        minus.clipsToBounds = true // Ensure corners are clipped to form a circle
//        minus.setImage(UIImage(systemName: "minus")?.withRenderingMode(.alwaysTemplate), for: .normal) // Use SF Symbols
//        minus.tintColor = .white // Icon color
//        // Add action for the button
//        minus.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
//        
//        // Set the button's size
//        minus.frame = CGRect(x: 0, y: 0, width: 80, height: 80) // Set the size of the button
//        
//        plus.translatesAutoresizingMaskIntoConstraints = false
//        plus.backgroundColor = Constants.accentColor // Button background color
//        plus.layer.cornerRadius = 40 // Half of width/height for a perfect circle
//        plus.clipsToBounds = true // Ensure corners are clipped to form a circle
//        plus.setImage(UIImage(systemName: "minus")?.withRenderingMode(.alwaysTemplate), for: .normal) // Use SF Symbols
//        plus.tintColor = .white // Icon color
//        // Add action for the button
//        plus.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
//        
//        // Set the button's size
//        plus.frame = CGRect(x: 0, y: 0, width: 80, height: 80) // Set the size of the button
//        
//        // Add to view
//        containerView.addSubview(minus)
//        containerView.addSubview(plus)
//    }
//    
//    private func setupLabel() {
//        // Set up labels
//        text.translatesAutoresizingMaskIntoConstraints = false // Use Auto Layout
//        text.borderStyle = .roundedRect // Rounded borders
//        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2) // Background color
//        text.textColor = .black // Text color
//        text.font = UIFont.systemFont(ofSize: 16) // Font size
//        text.clearButtonMode = .whileEditing // Show clear button while editing
//        text.quantity = 
//        // Optionally, add padding
//        addPaddingToTextField()
//        
//        // Step 3: Add the text field to the view
//        view.containerView(textField)
//        
//    }
//    
//    private func setupLayout() {
//        NSLayoutConstraint.activate([
//            minus.widthAnchor.constraint(equalToConstant: 80),
//            minus.heightAnchor.constraint(equalToConstant: 80),
//            plus.widthAnchor.constraint(equalToConstant: 80),
//            plus.heightAnchor.constraint(equalToConstant: 80),
//            
//        ])
//    }
//    
//    @objc private func minusTapped() {
//        print("Minus button tapped!")
//        // Handle button tap action here
//    }
//    
//    @objc private func plusTapped() {
//        print("Minus button tapped!")
//        // Handle button tap action here
//    }
//    
//}
