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
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        clipsToBounds = true
        addSubview(photoImageView)
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = CGRect(origin: .zero, size: CGSize(width: bounds.width, height: bounds.width))
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: photoImageView.center.x, y: photoImageView.bounds.maxY + titleLabel.font.lineHeight / 2.0)
    }
}

// MARK: - Public Methods

extension SearchPhotoCell {
    func config(with photo: Photo) -> Void {
        photoImageView.setupImage(from: photo.imageUrl)
        titleLabel.text = photo.title
        print(String(describing: photo))
    }
}
