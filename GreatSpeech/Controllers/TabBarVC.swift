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
        topicVC.navigationItem.title = "Темы для разговора"
        topicVC.navigationController?.navigationBar.tintColor = UIColor(red: 79.0/255.0, green: 87.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        topicVC.navigationController?.navigationBar.barTintColor = UIColor.white
        topicVC.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "", size: <#T##CGFloat#>)]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "ProximaNova-Bold", size: 18.0)!, NSAttributedStringKey.foregroundColor: UIColor(red: 79.0/255.0, green: 87.0/255.0, blue: 102.0/255.0, alpha: 1.0)]
        
        let analyzeVC = AnalyzingFillerVC()
        analyzeVC.view.backgroundColor = UIColor.blue
        analyzeVC.tabBarItem.image = UIImage(named: "profile_tabBar_unselected")
        analyzeVC.tabBarItem.selectedImage = UIImage(named: "profile_tabBar_selected")?.withRenderingMode(.alwaysOriginal)

        self.viewControllers = [topicVC, analyzeVC]
        selectedViewController = topicVC

    }
}
