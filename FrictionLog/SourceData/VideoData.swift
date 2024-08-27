//
//  VideoData.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/26/24.
//

import Foundation

struct VideoData {
    static var videos: [Video] = []
    static let numberOfEpisodes: [Int:Int] = [1:9]
    static let titlePattern: [Int:String] = [1:"Survivor UT Episode \\d+ - ", 2:"(Survivor Texas S\\d+E\\d+ - )"]
    
    
}
