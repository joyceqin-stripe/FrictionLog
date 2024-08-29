//
//  VideoData.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/26/24.
//

import UIKit
import Foundation

struct VideoData {
    static var videos: [Video] = []
    static func fetchVideos(from channelId: String, apiKey: String, videos: [Video] = [], images: [String:UIImage] = [:], pageToken: String? = nil, completion: @escaping ([Int:Season]) -> ()) {
        var urlString = "https://www.googleapis.com/youtube/v3/search?key=\(apiKey)&channelId=\(channelId)&part=snippet,id&order=date&maxResults=50"
        if let pageToken = pageToken {
            urlString += "&pageToken=\(pageToken)"
        }
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
                let jsonData: Data = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "&#39;", with: "'").data(using: .utf8)!
                let videoResponse = try JSONDecoder().decode(VideoResponse.self, from: jsonData)
                var allVideos: [Video] = videos
                let newVideos: [Video] = videoResponse.items
                allVideos.append(contentsOf: newVideos)
                var allImages: [String:UIImage] = images
                for video in newVideos {
                    let url = video.snippet.thumbnails["default"]!.url
                    Util.loadImage(from: url) { thumbnail in
                        allImages[url] = thumbnail
                        if (allImages.count == allVideos.count) {
                            if let nextPageToken = videoResponse.nextPageToken {
                                fetchVideos(from: channelId, apiKey: apiKey, videos: allVideos, pageToken: nextPageToken, completion: completion)
                            }
                            else {
                                allVideos.removeLast()
                                allVideos.reverse()
                                DispatchQueue.main.async {
                                    completion(organizedSeasons(videos: allVideos, thumbnails: allImages))
                                }
                            }
                        }
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
                do {
                    let videoResponse: VideoResponse = try JSONDecoder().decode(VideoResponse.self, from: MockData.jsonString.data(using: .utf8)!)
                    var allVideos: [Video] = videos
                    let newVideos: [Video] = videoResponse.items
                    allVideos.append(contentsOf: newVideos)
                    var allImages: [String:UIImage] = images
                    for video in newVideos {
                        let url = video.snippet.thumbnails["default"]!.url
                        Util.loadImage(from: url) { thumbnail in
                            allImages[url] = thumbnail
                            if (allImages.count == allVideos.count) {
                                if let nextPageToken = videoResponse.nextPageToken {
                                    fetchVideos(from: channelId, apiKey: apiKey, videos: allVideos, pageToken: nextPageToken, completion: completion)
                                }
                                else {
                                    allVideos.removeLast()
                                    allVideos.reverse()
                                    DispatchQueue.main.async {
                                        completion(organizedSeasons(videos: allVideos, thumbnails: allImages))
                                    }
                                }
                            }
                        }
                    }
                }
                catch {
                    print("Couldn't do it man")
                }
            }
        }
        
        task.resume() // Start the data task
    }
    
    private static func organizedSeasons(videos: [Video], thumbnails: [String:UIImage]) -> [Int:Season] {
        var seasons: [Int:Season] = [:]
        var startIndex = 0
        var season = 1
        while startIndex < videos.endIndex {
            let numberOfEpisodes = SeasonsData.numberOfEpisodes[season]
            if numberOfEpisodes == nil {
                let endIndex = videos.endIndex - 1
                let episodeVideos: [Video] = Array(videos[startIndex...endIndex])
                let episodes: [Episode] = episodeVideos.enumerated().map { (episodeIndex, episodeVideo) in
                    let unformattedTitle = episodeVideo.snippet.title
                    let formattedTitle = formatTitle(unformattedTitle: unformattedTitle, season: season, episode: episodeIndex + 1)
                    return Episode(season: season, episode: episodeIndex + 1, formattedTitle: formattedTitle, video: episodeVideo, thumbnail: thumbnails[episodeVideo.snippet.thumbnails["default"]!.url]!)
                    
                }
                seasons[season] = Season(id: season, episodes: episodes, titlePattern: SeasonsData.titlePatterns[season] ?? "")
                startIndex = endIndex + 1
            }
            else {
                var endIndex = startIndex + numberOfEpisodes! - 1
                if (endIndex >= videos.endIndex) {
                    endIndex = videos.endIndex - 1
                }
                let episodeVideos: [Video] = Array(videos[startIndex...endIndex])
                let episodes: [Episode] = episodeVideos.enumerated().map { (episodeIndex, episodeVideo) in
                    let unformattedTitle = episodeVideo.snippet.title
                    let formattedTitle = formatTitle(unformattedTitle: unformattedTitle, season: season, episode: episodeIndex + 1)
                    return Episode(season: season, episode: episodeIndex + 1, formattedTitle: formattedTitle, video: episodeVideo, thumbnail: thumbnails[episodeVideo.snippet.thumbnails["default"]!.url]!)
                }
                seasons[season] = Season(id: season, episodes: episodes, titlePattern: SeasonsData.titlePatterns[season]!)
                season += 1
                startIndex = endIndex + 1
            }
        }
        return seasons
    }
    
    private static func formatTitle(unformattedTitle: String, season: Int, episode: Int) -> String {
        if SeasonsData.titlePatterns[season] != nil {
            do {
                var formattedTitle = unformattedTitle
                let regex = try NSRegularExpression(pattern: SeasonsData.titlePatterns[season]!, options: [])
                let range = NSRange(location: 0, length: unformattedTitle.utf16.count)
                if let match = regex.firstMatch(in: unformattedTitle, options: [], range: range) {
                    let captureRange = match.range(at: 1) // First capture group
                    // Convert NSRange to Range<String.Index>
                    if let captureRangeSwift = Range(captureRange, in: unformattedTitle) {
                        formattedTitle.removeSubrange(captureRangeSwift)
                    }}
                return "\(episode). \(formattedTitle)"
            }
            catch {
                return unformattedTitle
            }
        }
        else {
            return unformattedTitle
        }
    }
}
