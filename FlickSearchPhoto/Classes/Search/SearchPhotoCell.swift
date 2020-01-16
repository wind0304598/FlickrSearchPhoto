//
//  SearchPhotoCell.swift
//  FlickSearchPhoto
//
//  Created by 張聰益 on 2020/1/15.
//  Copyright © 2020 張聰益. All rights reserved.
//

import UIKit

class SearchPhotoCell: UICollectionViewCell {
    private let photoImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .gray
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private let likeImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Search/ic_like")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        clipsToBounds = true
        addSubview(photoImageView)
        addSubview(titleLabel)
        addSubview(likeImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = CGRect(origin: .zero, size: CGSize(width: bounds.width, height: bounds.width))
        titleLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: titleLabel.font.lineHeight)
        titleLabel.center.y = photoImageView.bounds.maxY + titleLabel.font.lineHeight / 2.0
        likeImageView.frame = CGRect(x: bounds.maxX - 28, y: 0, width: 28, height: 28)
    }
}

// MARK: - Public Methods

extension SearchPhotoCell {
    func config(with photo: Photo, favorite: Bool) -> Void {
        photoImageView.setupImage(from: photo.imageUrl)
        titleLabel.text = photo.title
        likeImageView.image = UIImage(named: favorite ? "Search/ic_liked" : "Search/ic_like")
    }
}
