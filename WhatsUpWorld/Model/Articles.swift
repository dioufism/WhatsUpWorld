//
//  Articles.swift
//  WhatsUpWorld
//
//  Created by ousmane diouf on 10/12/23.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]?
    
    //response when status code is 4xx
    let code: String?
    let message: String?
}

struct Article: Codable, Identifiable {
    var id: String { url }
    let source: Source
    let title: String
    let url: String
    let publishedAt: Date
    let content: String
    
    let urlToImage: String?
    let description: String?
    let author: String?
}

struct Source: Codable {
    let name: String
}

extension Article {
    var authorText: String { author ?? "" }
    var descriptionText: String { description ?? "" }
    
    var imageUrl: URL? {
        guard let url = urlToImage else { return nil }
        
        guard let safeUrl = URL(string: url) else {
            return nil
        }
        
        return safeUrl
    }
}

extension Article {
    static var previewData: [Article] {
        //TODO: clean up force unwrap
        let previewDataUrl =  Bundle.main.url(forResource: "news", withExtension: "json")!
        
        let data = try! Data(contentsOf: previewDataUrl)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let apiResponse = try? decoder.decode(NewsResponse.self, from: data)
        
        return apiResponse?.articles ?? []
    }
}


