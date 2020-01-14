//
//  UIImageView+Extension.swift
//  FlickSearchPhoto
//
//  Created by 張聰益 on 2020/1/15.
//  Copyright © 2020 張聰益. All rights reserved.
//

import UIKit

extension UIImageView {
    public func setupImage(from urlString: String?) -> Void {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession(configuration: .default).dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, let data = data, error == nil else { return }
            DispatchQueue.main.async() {    // execute on main thread
                self.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}
