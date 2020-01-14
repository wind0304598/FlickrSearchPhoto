//
//  AppDelegate.swift
//  FlickSearchPhoto
//
//  Created by 張聰益 on 2020/1/14.
//  Copyright © 2020 張聰益. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabBarController = UITabBarController()
        tabBarController.view.backgroundColor = .white
        
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        let favoriteViewController = FavoriteViewController()
        favoriteViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        tabBarController.viewControllers = [UINavigationController(rootViewController: searchViewController),
                                            UINavigationController(rootViewController: favoriteViewController)]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }

}

