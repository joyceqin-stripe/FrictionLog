//
//  ViewController.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/21/24.
//

import UIKit
import StripePaymentSheet

class ViewController: UIViewController {
    private let titleLabel = UILabel()
//    private let seasonDropdownButton = UIButton()
//    private let seasonsDropdownTableView = UITableView()
    private var seasonsDropdownSelector: DropdownSelector?
    private let episodesTableView = UITableView()
    private let seasonSelector = UIPickerView()
    private var isPickerVisible = false
    private var seasons: [Int:Season] = [:]
    private var season: Int = 1
    // Replace with your actual channel ID and API key
    private let channelId = "UC-I2gENMqpajEe8LVxjCohg"
    private let apiKey = "AIzaSyAca-PL7QPgVsNVUJPcVgNpikaJaucu72g"
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.background
        VideoData.fetchVideos(from: channelId, apiKey: apiKey, completion: handleVideos)
        
    }
    
    private func handleVideos(seasons: [Int:Season]) {
        self.seasons = seasons
        let options = self.seasons.map { key, _ in
            "Season \(key)"
        }
        print(options)
        seasonsDropdownSelector = DropdownSelector(options: options)
        seasonsDropdownSelector!.translatesAutoresizingMaskIntoConstraints = false
        setupTitleLabel()
        setupEpisodesTableView()
        view.addSubview(seasonsDropdownSelector!)
        setupLayout()
//        self.seasonSelector.reloadAllComponents()
//        self.episodesTableView.reloadData()
        
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        if let customFont = UIFont(name: "Survivant", size: 36) {
            titleLabel.font = customFont // Replace with your custom font
        } else {
            titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
            print("Custom font not found. Using system font instead.")
        }
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = Constants.textColor
        titleLabel.text = "Survivor Texas"
        view.addSubview(titleLabel)
    }
    
//    private func setupSeasonDropdownButton() {
//        // Configure the button with a title and down arrow
//        seasonDropdownButton.setTitle("Season \(self.season)", for: .normal)
//        seasonDropdownButton.setImage(UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        seasonDropdownButton.tintColor = Constants.textColor
//        seasonDropdownButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//        seasonDropdownButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(seasonDropdownButton)
//        
//    }
    
//    private func setupPickerView() {
//        seasonSelector.translatesAutoresizingMaskIntoConstraints = false
//        seasonSelector.delegate = self
//        seasonSelector.dataSource = self
//        seasonSelector.isHidden = !isPickerVisible
//        seasonSelector.setValue(Constants.textColor, forKey: "textColor")
//        seasonSelector.backgroundColor = .systemFill
//        view.addSubview(seasonSelector)
//        NSLayoutConstraint.activate([
//            seasonSelector.topAnchor.constraint(equalTo: seasonDropdownButton.bottomAnchor, constant: Constants.padding),
//            seasonSelector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
//            seasonSelector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
//        ])
//    }
//    
//    private func setupSeasonsDropdownTableView() {
//        seasonsDropdownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
//        seasonsDropdownTableView.backgroundColor = Constants.background
//        seasonsDropdownTableView.translatesAutoresizingMaskIntoConstraints = false
//        seasonsDropdownTableView.dataSource = self
//        seasonsDropdownTableView.delegate = self
//        seasonsDropdownTableView.isUserInteractionEnabled = true
//        seasonsDropdownTableView.rowHeight = UITableView.automaticDimension
//        view.addSubview(episodesTableView)
//    }
    
    private func setupEpisodesTableView() {
        episodesTableView.register(EpisodeCell.self, forCellReuseIdentifier: "EpisodeCell")
        episodesTableView.backgroundColor = Constants.background
        episodesTableView.translatesAutoresizingMaskIntoConstraints = false
        episodesTableView.dataSource = self
        episodesTableView.delegate = self
        episodesTableView.isUserInteractionEnabled = true // Make sure user interaction is enabled
        //        tableView.rowHeight = UITableView.automaticDimension
        episodesTableView.rowHeight = Constants.padding * 2 + Constants.productImageDimension
        view.addSubview(episodesTableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            
            
            episodesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            episodesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            episodesTableView.topAnchor.constraint(equalTo: seasonsDropdownSelector!.bottomAnchor, constant: Constants.padding),
            episodesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding/2),
            
            seasonsDropdownSelector!.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.padding),
            seasonsDropdownSelector!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            seasonsDropdownSelector!.heightAnchor.constraint(equalToConstant: 48),
            seasonsDropdownSelector!.widthAnchor.constraint(equalToConstant: 128),
        ])
    }
    
    @objc private func buttonTapped() {
        // Toggle picker view visibility
        isPickerVisible.toggle()
        seasonSelector.isHidden = !isPickerVisible
        
    }
    
}

extension ViewController : UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.seasons[season]?.episodes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell
        let episode = self.seasons[season]!.episodes[indexPath.row]
        cell.configure(with: episode, thumbnail: episode.thumbnail)
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // One column in the picker
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.seasons.count // Number of rows based on the data source
    }
    
    // MARK: - UIPickerViewDelegate Methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Season \(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.season = row + 1
        episodesTableView.reloadData()
    }
}

