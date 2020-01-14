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
        
    }
}

// MARK: - SearchDataSourceDelegate

extension ResultViewController: SearchDataSourceDelegate {
    func dataSource(_ dataSource: SearchDataSource, didFetchWithResult result: Result) {
        
    }
}
