//
//  ImageManager.swift
//  Images App
//
//  Created by Nurgali on 21.05.2024.
//

import Foundation

protocol ImageManagerDelegate {
    func didFetchImages(_ images: [Image])
    func didFailWithError(_ error: Error)
}

struct ImageManager {
    private let urlString = "https://jsonplaceholder.typicode.com/photos"
    
    var delegate: ImageManagerDelegate?
    
    func performRequest() {
        guard let url = URL(string: urlString) else {
            // TODO: Make throwable
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            print(error)
            
            if let data,
               let images = self.parseJSON(from: data) {
                DispatchQueue.main.async {
                    self.delegate?.didFetchImages(images)
                }
            }
        }.resume()
    }
    
    func parseJSON(from imageData: Data) -> [Image]? {
        let decoder = JSONDecoder()
        do {
            let images = try decoder.decode([Image].self, from: imageData)
            return images
        } catch {
            // TODO: Handle error properly
            print(error)
            return nil
        }
    }
}
