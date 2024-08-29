//
//  SeasonsData.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/27/24.
//

import Foundation

struct SeasonsData {
//    static let numberOfEpisodes: [Int:Int] = [1:9]
    static let numberOfEpisodes: [Int:Int] = [1:9]
    static let titlePatterns: [Int:String] = [1:"(Survivor UT Episode \\d+ - )", 2:"(Survivor Texas S\\d+E\\d+ - )"]
    static var seasons: [Season] = []
}
