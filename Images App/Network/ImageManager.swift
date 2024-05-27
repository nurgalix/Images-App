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

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case dataParsingFailed(Error)
}


struct ImageManager {
    private let urlString = "https://jsonplaceholder.typicode.com/photos"
    
    var delegate: ImageManagerDelegate?
    
    func performRequest() throws {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(NetworkError.requestFailed(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(NetworkError.requestFailed(NSError(domain: "No data", code: -1, userInfo: nil)))
                }
                return
            }
            
            do {
                let images = try self.parseJSON(from: data)
                DispatchQueue.main.async {
                    self.delegate?.didFetchImages(images)
                }
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(error)
                }
            }
        }.resume()
    }
    
    func parseJSON(from imageData: Data) throws -> [Image] {
        let decoder = JSONDecoder()
        do {
            let images = try decoder.decode([Image].self, from: imageData)
            return images
        } catch {
            throw NetworkError.dataParsingFailed(error)
        }
    }
}
