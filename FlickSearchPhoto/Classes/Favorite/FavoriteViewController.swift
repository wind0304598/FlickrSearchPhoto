//
//  FavoriteViewController.swift
//  FlickSearchPhoto
//
//  Created by 張聰益 on 2020/1/14.
//  Copyright © 2020 張聰益. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (view.bounds.width - 30) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 20)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectionView.register(SearchPhotoCell.self, forCellWithReuseIdentifier: SearchPhotoCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var favorites = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "我的最愛"
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
}

// MARK: - Setup UI

extension FavoriteViewController {
    private func setupViews() -> Void {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
}

// MARK: - Private Methods

extension FavoriteViewController {
    private func loadFavorites() -> Void {
        guard let photos = UserDefaults.standard.getFavoritePhotos() else {
            return
        }
        favorites.removeAll()
        favorites.append(contentsOf: photos)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = favorites[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchPhotoCell.reuseIdentifier, for: indexPath) as? SearchPhotoCell else {
            fatalError("CollectionView dequeue reusable cell failed.")
        }
        cell.config(with: photo, favorite: true)
        return cell
    }
}
