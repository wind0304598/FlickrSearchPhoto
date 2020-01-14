//
//  SearchViewController.swift
//  FlickSearchPhoto
//
//  Created by 張聰益 on 2020/1/14.
//  Copyright © 2020 張聰益. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let dataSource = SearchDataSource()
    
    private lazy var numberSet = CharacterSet(charactersIn: "0123456789")
    
    private lazy var searchField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "欲搜尋內容"
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var pageSizeField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "每頁呈現數量"
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("搜尋", for: .normal)
        button.setBackgroundImage(UIColor.systemBlue.image(), for: .normal)
        button.setBackgroundImage(UIColor.gray.image(), for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(tapSearchButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "搜尋輸入頁"
        dataSource.delegate = self
        setupViews()
    }
}

// MARK: - Setup UI

extension SearchViewController {
    
    private func setupViews() -> Void {
        view.backgroundColor = .white
        
        let objectSize = CGSize(width: view.frame.width - 32, height: 32)
        
        view.addSubview(pageSizeField)
        pageSizeField.frame = CGRect(origin: .zero, size: objectSize)
        pageSizeField.center = CGPoint(x: view.center.x, y: view.center.y - objectSize.height - 10)
        
        view.addSubview(searchField)
        searchField.frame = pageSizeField.frame
        searchField.center.y = pageSizeField.center.y - objectSize.height - 10
        
        view.addSubview(searchButton)
        searchButton.frame = pageSizeField.frame
        searchButton.center.y = pageSizeField.center.y + objectSize.height + 10
    }
}

// MARK: - Button Actions

extension SearchViewController {
    
    @objc private func tapSearchButton() -> Void {
        search()
    }
}

// MARK: - Actions

extension SearchViewController {
    @objc private func textFieldDidChange() -> Void {
        let hasSearchText = searchField.text?.count ?? 0 > 0
        let hasPageSize = pageSizeField.text?.count ?? 0 > 0
        searchButton.isEnabled = hasSearchText && hasPageSize
    }
    
    private func search() -> Void {
        guard let text = searchField.text, let pageSizeString = pageSizeField.text, let pageSize = Int(pageSizeString) else {
            return
        }
        dataSource.search(text, with: pageSize)
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let _ = textField.text else {
            return true
        }
        
        let incomingString = CharacterSet(charactersIn: string)
        return numberSet.isSuperset(of: incomingString)
    }
}

// MARK: - SearchDataSourceDelegate

extension SearchViewController: SearchDataSourceDelegate {
    func dataSource(_ dataSource: SearchDataSource, didFetchWithResult result: Result) {
        
    }
}

// MARK: - Tool

extension UIColor {
    func image() -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
