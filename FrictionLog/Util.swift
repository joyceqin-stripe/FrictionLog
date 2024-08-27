//
//  Util.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/22/24.
//

import UIKit
import Foundation

struct Util {
    static func loadImage(from urlString: String) {
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Create a data task to fetch the image
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                return
            }
            
            // Ensure there is valid data
            guard let data = data, let image = UIImage(data: data) else {
                print("No image data returned or unable to create UIImage")
                return
            }
            
            // Update the UI on the main thread
            DispatchQueue.main.async {
                ImageData.images.updateValue(image, forKey: urlString)
            }
        }
        
        task.resume() // Start the data task
    }
    
    static func toJSON(codable: Codable) -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // Optional: for human-readable JSON
        
        do {
            let jsonData = try encoder.encode(codable)
            return jsonData
        } catch {
            print("Error encoding: \(error.localizedDescription)")
            return Data()
        }
    }
}
