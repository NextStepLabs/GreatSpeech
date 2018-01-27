//
//  TabBarVC.swift
//  GreatSpeech
//
//  Created by Aibek Rakhim on 1/27/18.
//  Copyright © 2018 NextStep Labs. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: Setuping TabBar VCs
        let topicVC = TopicVC()
        topicVC.view.backgroundColor = UIColor.white
        topicVC.tabBarItem.image = UIImage(named: "microphone_tabBar_unselected")
        topicVC.tabBarItem.selectedImage = UIImage(named: "microphone_tabBar_selected")?.withRenderingMode(.alwaysOriginal)
        let topicNavController = UINavigationController(rootViewController: topicVC)
        
       
        let analyzeVC = AnalyzingFillerVC()
        analyzeVC.view.backgroundColor = UIColor.blue
        analyzeVC.tabBarItem.image = UIImage(named: "profile_tabBar_unselected")
        analyzeVC.tabBarItem.selectedImage = UIImage(named: "profile_tabBar_selected")?.withRenderingMode(.alwaysOriginal)

        self.viewControllers = [topicNavController, analyzeVC]

    }
}
