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
        let firstVC = FirstVC()
        firstVC.view.backgroundColor = UIColor.white
        firstVC.tabBarItem.image = UIImage(named: "microphone_tabBar_unselected")
        firstVC.tabBarItem.selectedImage = UIImage(named: "microphone_tabBar_selected")?.withRenderingMode(.alwaysOriginal)
        
        let analyzeVC = AnalyzingFillerVC()
        analyzeVC.view.backgroundColor = UIColor.white
        analyzeVC.tabBarItem.image = UIImage(named: "profile_tabBar_unselected")
        analyzeVC.tabBarItem.image = UIImage(named: "profile_tabBar_selected")?.withRenderingMode(.alwaysOriginal)

        self.viewControllers = [firstVC, analyzeVC]

    }
}
