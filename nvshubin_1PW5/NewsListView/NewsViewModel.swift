//
//  NewsViewModel.swift
//  nvshubin_1PW5
//
//  Created by Nikita on 06.12.2022.
//

import UIKit

final class NewsViewModel : Codable {
    let title: String
    let description: String
    let imageURL: URL?
    let articleURL: URL?
    var imageData: Data? = nil
    
    
    init(title: String, description: String, imageURL: URL?, articleURL: URL?) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.articleURL = articleURL
    }
}
