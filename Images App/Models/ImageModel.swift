//
//  ImageModel.swift
//  Images App
//
//  Created by Nurgali on 21.05.2024.
//

import Foundation


struct Image: Decodable {
    let albumId, id: Int
    let title: String
    let url, thumbnailUrl: String
}
