//
//  Video.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/26/24.
//

import Foundation

struct VideoResponse: Codable {
    let items: [Video]
}

struct Video: Codable {
    let id: VideoID
    let snippet: VideoSnippet
}

struct VideoID: Codable {
    let kind: String
    let videoId: String
}

struct VideoSnippet: Codable {
    let title: String
    let description: String
    let publishedAt: String
    let channelId: String
    let thumbnails: [String: Thumbnail]
}

struct Thumbnail: Codable {
    let url: String
    let width: Int
    let height: Int
}
