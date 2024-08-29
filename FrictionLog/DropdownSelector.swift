//
//  DropdownSelector.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/28/24.
//

import UIKit
import Foundation

class DropdownSelector: UIView, UITableViewDataSource, UITableViewDelegate {
    let options: [String]
    let dropdownButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Create a label with left alignment
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = Constants.textColor
        
        // Create a chevron down image
        let chevronImage = UIImage(systemName: "chevron.down")
        let imageView = UIImageView(image: chevronImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add label and image to a stack view
        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.axis = .horizontal
        stackView.spacing = 8 // Space between the label and the image
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(stackView)
        
        // Constraints for stack view to fill button
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: button.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: button.bottomAnchor),
        ])
        
        return button
    }()
    
    let dropdownTableView = UITableView()
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.0 // Initially hidden
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    var isDropdownVisible = false
    
    init(options: [String]) {
        self.options = options
        super.init(frame: .zero)
        setupDropdownButton()
        setupDropdownTableView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDropdownButton() {
        dropdownButton.addTarget(self, action: #selector(dropdownButtonTapped), for: .touchUpInside)
        dropdownButton.tintColor = Constants.textColor
        if let label = dropdownButton.subviews.first?.subviews.first as? UILabel {
            label.text = options[0] // Update button label with selected option
        }
        addSubview(dropdownButton)
        
        // Set up button constraints
        NSLayoutConstraint.activate([
            dropdownButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            dropdownButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            dropdownButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            dropdownButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    private func setupDropdownTableView() {
        addSubview(blurEffectView)
        dropdownTableView.dataSource = self
        dropdownTableView.delegate = self
        dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
        dropdownTableView.isHidden = true // Initially hidden
        dropdownTableView.layer.cornerRadius = Constants.cornerRadius
        dropdownTableView.backgroundColor = UIColor.clear
        // Add the dropdown table view to the main view
        addSubview(dropdownTableView)
        
        let tableViewHeight = min(CGFloat(options.count * 48), 500)
        print(tableViewHeight)
        // Set up constraints for the dropdown
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: dropdownButton.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: dropdownButton.trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: dropdownButton.bottomAnchor, constant: 8),
            blurEffectView.heightAnchor.constraint(equalToConstant: tableViewHeight),
            
            dropdownTableView.leadingAnchor.constraint(equalTo: dropdownButton.leadingAnchor),
            dropdownTableView.trailingAnchor.constraint(equalTo: dropdownButton.trailingAnchor),
            dropdownTableView.topAnchor.constraint(equalTo: dropdownButton.bottomAnchor, constant: 8),
            dropdownTableView.heightAnchor.constraint(equalToConstant: tableViewHeight)
        ])
    }
    
    @objc private func dropdownButtonTapped() {
        print("Toggle!")
        isDropdownVisible.toggle() // Toggle visibility
        dropdownTableView.isHidden = !isDropdownVisible
        // Show or hide the blur effect based on the dropdown state
        if dropdownTableView.isHidden {
            UIView.animate(withDuration: 0.3) {
                self.blurEffectView.alpha = 0.0
                self.dropdownTableView.alpha = 0.0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.blurEffectView.alpha = 0.8 // Adjust blur opacity here
                self.dropdownTableView.alpha = 1.0
            }
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count // Number of items in the dropdown
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = options[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = Constants.textColor
        return cell
    }
    
    // MARK: - UITableViewDelegate Method
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = options[indexPath.row]
        if let label = dropdownButton.subviews.first?.subviews.first as? UILabel {
            label.text = selected // Update button label with selected option
        }
        tableView.deselectRow(at: indexPath, animated: true) // Deselect row
        
        isDropdownVisible = false
        blurEffectView.alpha = 0.0
        dropdownTableView.isHidden = true // Hide dropdown after selection
    }
}
