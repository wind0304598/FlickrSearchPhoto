//
//  FlickrApi.swift
//  FlickSearchPhoto
//
//  Created by 張聰益 on 2020/1/14.
//  Copyright © 2020 張聰益. All rights reserved.
//

import Foundation

private let kApiKey = "452c654457ac2a04c3bd138ae06c8761"
private let kSearchApiUrlString = "https://www.flickr.com/services/rest/?format=json&nojsoncallback=1&method=flickr.photos.search"

private struct SearchResponse: Decodable {
    let result: Result
    
    enum CodingKeys: String, CodingKey {
        case result = "photos"
    }
}

struct Result: Decodable {
    let photos: [Photo]
    let page: Int
    
    enum CodingKeys: String, CodingKey {
        case photos = "photo"
        case page = "page"
    }
}

struct Photo: Decodable {
    let id, secret, server: String
    let title: String
    
    var imageUrl: URL {
        return URL(string: "https://live.staticflickr.com/\(server)/\(id)_\(secret).jpg")!
    }
}

protocol SearchDataSourceDelegate: class {
    func dataSource(_ dataSource: SearchDataSource, didFetchWithResult result: Result) -> Void
}

final class SearchDataSource {
    
    weak var delegate: SearchDataSourceDelegate?
    
    private let searchText: String
    private let pageSize: Int
    
    private var dataTask: URLSessionDataTask?
    private var page = 1
    
    init(withSearchText text: String, pageSize aPageSize: Int) {
        searchText = text
        pageSize = aPageSize
    }
}

// MARK: - Private Methods

extension SearchDataSource {
    
    private func searchInternal() -> Void {
        dataTask?.cancel()
        guard let url = URL(string: "\(kSearchApiUrlString)&api_key=\(kApiKey)&text=\(searchText)&per_page=\(pageSize)&page=\(page)") else {
            return
        }
        dataTask = URLSession.init(configuration: .default).dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard let self = self else { return }
            defer {
                self.dataTask = nil
            }
            
            if let error = error {
                NSLog("Data task error with message:\n\(error.localizedDescription)")
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                NSLog("Response error")
                return
            }
            do {
                let response = try JSONDecoder().decode(SearchResponse.self, from: data)
                DispatchQueue.main.async {
                    self.delegate?.dataSource(self, didFetchWithResult: response.result)
                }
            } catch {
                print("Json decoder error with message:")
            }
        })
        dataTask?.resume()
    }
}

// MARK: - Public Methods

extension SearchDataSource {
    func search() -> Void {
        page = 1
        searchInternal()
    }
    
    func loadMore() -> Void {
        page += 1
        searchInternal()
    }
}
