//
//  UITableViewCell+Extension.swift
//  FlickSearchPhoto
//
//  Created by 張聰益 on 2020/1/15.
//  Copyright © 2020 張聰益. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
