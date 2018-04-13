//
//  MainTabBarController.swift
//  OrderingApp
//
//  Created by Griffin Healy on 4/12/18.
//  Copyright © 2018 Griffin Healy. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController: userProfileController)
        
        navController.tabBarItem.image = #imageLiteral(resourceName: "user_avatar2")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "user_avatar")
        tabBar.tintColor = .green
        
        viewControllers = [navController, UIViewController()]
    }
    
}
