//
//  ViewController.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/21/24.
//

import UIKit
import StripePaymentSheet

class ViewController: UIViewController {
    let titleView = UIView()
    let titleImage = UIImageView()
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.background
        setupTitleLabel()
        setupLayout()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        if let customFont = UIFont(name: "Survivant", size: 48) {
            titleLabel.font = customFont // Replace with your custom font
        } else {
            titleLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
            print("Custom font not found. Using system font instead.")
        }
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = Constants.textColor
        titleLabel.text = "Survivor Texas"
        view.addSubview(titleLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

