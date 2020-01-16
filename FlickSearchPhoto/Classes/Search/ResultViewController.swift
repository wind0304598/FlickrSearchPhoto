//
//  ResultViewController.swift
//  FlickSearchPhoto
//
//  Created by 張聰益 on 2020/1/15.
//  Copyright © 2020 張聰益. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    private let dataSource: SearchDataSource
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (view.bounds.width - 30) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 20)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectionView.register(SearchPhotoCell.self, forCellWithReuseIdentifier: SearchPhotoCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    init(withSearchText text: String, pageSize: Int) {
        dataSource = SearchDataSource(withSearchText: text, pageSize: pageSize)
        super.init(nibName: nil, bundle: nil)
        
        dataSource.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "搜尋結果頁"
        view.backgroundColor = .white
        setupViews()
        dataSource.search()
    }
}

// MARK: - Setup UI

extension ResultViewController {
    private func setupViews() -> Void {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
}

// MARK: - UICollectionViewDataSource

extension ResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = dataSource.photos[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchPhotoCell.reuseIdentifier, for: indexPath) as? SearchPhotoCell else {
            fatalError("CollectionView dequeue reusable cell failed.")
        }
        cell.config(with: photo, favorite: dataSource.isFavorite(at: indexPath))
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard dataSource.photos.count - indexPath.row <= 2 else {
            return
        }
        dataSource.loadMore()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if dataSource.isFavorite(at: indexPath) {
            dataSource.unfavorite(at: indexPath)
        } else {
            dataSource.favorite(at: indexPath)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - SearchDataSourceDelegate

extension ResultViewController: SearchDataSourceDelegate {
    func dataSource(_ dataSource: SearchDataSource, didInsertPhotosWithRange range: Range<Int>, deletedAmount amount: Int) {
        if let first = range.first, first == 0, amount > 0 {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredVertically, animated: false)
        }
        collectionView.performBatchUpdates({
            if amount > 0 {
                var deletedIndexPath = IndexPath()
                (0..<amount as Range<Int>).forEach{ deletedIndexPath.append($0) }
                self.collectionView.deleteItems(at: [deletedIndexPath])
            }

            let indexPaths = range.map{ IndexPath(row: $0, section: 0) }
            self.collectionView.insertItems(at: indexPaths)
        })
    }
}
