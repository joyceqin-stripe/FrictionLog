//
//  ImageData.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/26/24.
//

import UIKit
import Foundation

struct ImageData {
    static var episodeThumbnails: [String: UIImage] = [:]
    static var productThumbnails: [String: UIImage] = [:]
    static var images: [String:UIImage] = [:]
}

// Define a notification name
extension Notification.Name {
    static let didLoadEpisodeThumbnail = Notification.Name("didLoadEpisodeThumbnail")
}

extension Notification.Name {
    static let didLoadProductThumbnail = Notification.Name("didLoadProductThumbnail")
}
