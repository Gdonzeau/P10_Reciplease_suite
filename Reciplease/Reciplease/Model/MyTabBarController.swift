//
//  TabBarController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 15/08/2021.
//

import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    static var shared = MyTabBarController()
    
    override func viewDidLoad() {
        self.delegate = self
        super.viewDidLoad()
        self.selectedIndex = 0
        //print("Item : \(String(describing: TabBarController.shared.tabBar.selectedItem))")
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item : \(String(describing: item.title))")
        if let itemName = item.title {
            if itemName == "Search" {
                Parameters.shared.state = "search"
                print("On change les paramètres pour : \(Parameters.shared.state)")
            } else if itemName == "Favorites" {
                Parameters.shared.state = "favorites"
                print("On change les paramètres pour : \(Parameters.shared.state)")
            } else {
                print("Pas de changement ???")
            }
            
        }
    }

    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //print("Selected view controller : \(viewController)")
    }
}


