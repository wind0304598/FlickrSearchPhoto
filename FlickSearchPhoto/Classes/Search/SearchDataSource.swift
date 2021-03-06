//
//  FlickrApi.swift
//  FlickSearchPhoto
//
//  Created by 張聰益 on 2020/1/14.
//  Copyright © 2020 張聰益. All rights reserved.
//

import Foundation

private let kApiKey = "51adeca3a9cfc2fa1719fb8b33daa0b0"
private let kSearchApiUrlString = "https://www.flickr.com/services/rest/"

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

struct Photo: Codable {
    let id, secret, server: String
    let title: String
    
    var imageUrl: URL {
        return URL(string: "https://live.staticflickr.com/\(server)/\(id)_\(secret).jpg")!
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case secret
        case server
        case title
    }
}

protocol SearchDataSourceDelegate: class {
    func dataSource(_ dataSource: SearchDataSource, didInsertPhotosWithRange range: Range<Int>, deletedAmount amount: Int) -> Void
}

final class SearchDataSource {
    
    weak var delegate: SearchDataSourceDelegate?
    
    private let searchText: String
    private let pageSize: Int
    
    private var dataTask: URLSessionDataTask?
    private var page = 1
    private(set) var photos = [Photo]()
    private(set) var favorites = [Photo]()
    
    init(withSearchText text: String, pageSize aPageSize: Int) {
        searchText = text
        pageSize = aPageSize
        setupFavorites()
    }
}

// MARK: - Private Methods

extension SearchDataSource {
    
    private func searchInternal() -> Void {
        dataTask?.cancel()
        var components = URLComponents(string: kSearchApiUrlString)
        guard let _ = components else {
            NSLog("URLComponents are nil")
            return
        }
        
        components!.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: kApiKey),
            URLQueryItem(name: "per_page", value: "\(pageSize)"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "text", value: searchText),
        ]
        guard let url = components?.url else {
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
                    var oldCount = self.photos.count
                    var deletedAmount = 0
                    if response.result.page == 1 {
                        deletedAmount = oldCount
                        oldCount = 0
                        self.photos.removeAll()
                    }
                    self.photos.append(contentsOf: response.result.photos)
                    self.page += 1
                    self.delegate?.dataSource(self, didInsertPhotosWithRange: oldCount..<self.photos.count, deletedAmount: deletedAmount)
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
        guard dataTask == nil else {
            return
        }
        searchInternal()
    }
    
    func favorite(at indexPath: IndexPath) -> Void {
        let photo = photos[indexPath.row]
        favorites.append(photo)
        UserDefaults.standard.favorite(photos: favorites)
    }
    
    func unfavorite(at indexPath: IndexPath) -> Void {
        let photo = photos[indexPath.row]
        favorites.removeAll { (favorite) -> Bool in
            return favorite.id == photo.id
        }
        UserDefaults.standard.favorite(photos: favorites)
    }
    
    func isFavorite(at indexPath: IndexPath) -> Bool {
        let photo = photos[indexPath.row]
        return favorites.first(where: { $0.id == photo.id }) != nil
    }
}

// MARK: - Favorite Related

extension SearchDataSource {
    private func setupFavorites() -> Void {
        guard let favorites = UserDefaults.standard.getFavoritePhotos() else {
            return
        }
        self.favorites.append(contentsOf: favorites)
    }
}

// MARK: - Tool

extension UserDefaults {
    
    func favorite(photos: [Photo]) -> Void {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(photos), forKey: "Favorites")
    }
    
    func getFavoritePhotos() -> [Photo]? {
        guard let data = UserDefaults.standard.value(forKey: "Favorites") as? Data else {
            return nil
        }
        return try? PropertyListDecoder().decode(Array<Photo>.self, from: data)
    }
}
