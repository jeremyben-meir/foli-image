//
//  TabBarController.swift
//  snax
//
//  Created by Jessica Yuan on 4/20/19.
//  Copyright © 2019 Jessica Yuan. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var email: String
    var firstName: String
    var lastName: String
    
    init(email: String, firstName: String, lastName: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        

        let accountViewController = AccountViewController(email: email, firstName: firstName, lastName: lastName)
        accountViewController.tabBarItem = UITabBarItem.init(title: "My Account", image: UIImage(named: "acct"), tag: 0)
        let findViewController = FindViewController()
        findViewController.tabBarItem = UITabBarItem.init(title: "Find Foliage", image: UIImage(named: "find"), tag: 0)
        let viewController = ViewController()
        viewController.tabBarItem = UITabBarItem.init(title: "Add Image", image: UIImage(named: "add"), tag: 0)

        
        UITabBar.appearance().tintColor = UIColor(displayP3Red: 9/255, green: 116/255, blue: 79/255, alpha: 1)
        
        
        let viewControllerList = [accountViewController, findViewController, viewController]
        //viewControllers = viewControllerList
        viewControllers = viewControllerList.map{ UINavigationController(rootViewController: $0) }
        //UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().tintColor = UIColor(displayP3Red: 9/255, green: 116/255, blue: 79/255, alpha: 1)
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
