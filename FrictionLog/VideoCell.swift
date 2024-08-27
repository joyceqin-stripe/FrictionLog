//
//  VideoCell.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/26/24.
//


import Foundation
import UIKit

//protocol VideoCellDelegate: AnyObject {
//    func didTapProductDetails(in cell: ProductCell)
//}

class VideoCell: UITableViewCell {
//    weak var delegate: VideoCellDelegate?
    private let containerView = UIView()
    private let videoThumbnailView = UIImageView()
    private let titleLabel = UILabel()
    
    private var video: Video?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setupContainerView()
        setupImageView()
        setupLabels()
        setupLayout()
        contentView.backgroundColor = Constants.background
    }
    
    private func setupContainerView() {
        // Set up container view
        containerView.backgroundColor = Constants.secondaryBackground
        containerView.layer.cornerRadius = Constants.cornerRadius
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        containerView.isUserInteractionEnabled = true // Make sure user interaction is enabled
    }

    private func setupImageView() {
        // Set up image view
        videoThumbnailView.clipsToBounds = true
        videoThumbnailView.translatesAutoresizingMaskIntoConstraints = false
        videoThumbnailView.contentMode = .scaleAspectFill
        videoThumbnailView.isUserInteractionEnabled = true // Make sure user interaction is enabled
        containerView.addSubview(videoThumbnailView)
    }
    
    private func setupLabels() {
        // Set up labels
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = Constants.textColor
        titleLabel.isUserInteractionEnabled = true
        containerView.addSubview(titleLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            // Set up layout constraints for containerView
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding/2),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding/2),
            // Set up layout constraints for imageView
            videoThumbnailView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            videoThumbnailView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.padding),
            videoThumbnailView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.padding),
            videoThumbnailView.widthAnchor.constraint(equalTo: videoThumbnailView.heightAnchor),
            // Set up layout constraints for productNameLabel
            titleLabel.leadingAnchor.constraint(equalTo: videoThumbnailView.trailingAnchor, constant: Constants.padding),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding),
        ])
    }
    
//    @objc private func viewProductDetails() {
//        delegate?.didTapProductDetails(in: self)
//    }
    
    func configure(with video: Video) {
        // Update the UI with the Video data
        self.video = video
        videoThumbnailView.image = ImageData.images[video.snippet.thumbnails["default"]!.url]
        titleLabel.text = video.snippet.title
    }
    
}

