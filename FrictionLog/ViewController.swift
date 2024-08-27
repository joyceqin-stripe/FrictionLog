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
    private let tableView = UITableView()
    // Replace with your actual channel ID and API key
    private let channelId = "UC-I2gENMqpajEe8LVxjCohg"
    private let apiKey = "AIzaSyAca-PL7QPgVsNVUJPcVgNpikaJaucu72g"
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.background
        setupTitleLabel()
        setupTableView()
        setupLayout()
        fetchVideos(from: channelId, apiKey: apiKey)
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
    
    private func setupTableView() {
        tableView.register(VideoCell.self, forCellReuseIdentifier: "VideoCell")
        tableView.backgroundColor = Constants.background
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isUserInteractionEnabled = true // Make sure user interaction is enabled
        tableView.rowHeight = Constants.padding * 2 + Constants.productImageDimension
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.padding),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding),
        ])
    }
    
    func fetchVideos(from channelId: String, apiKey: String) {
        let urlString = "https://www.googleapis.com/youtube/v3/search?key=\(apiKey)&channelId=\(channelId)&part=snippet,id&order=date"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching videos: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                // Parse JSON response
                let videoResponse = try JSONDecoder().decode(VideoResponse.self, from: data)
                VideoData.videos = videoResponse.items
                for video in VideoData.videos {
                    Util.loadImage(from: video.snippet.thumbnails["default"]!.url)
                }
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume() // Start the data task
    }
}

extension ViewController : UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(VideoData.videos.count)
        return VideoData.videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        let video = VideoData.videos[indexPath.row]
        cell.configure(with: video)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

