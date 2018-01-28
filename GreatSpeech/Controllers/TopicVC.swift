//
//  TopicVC.swift
//  GreatSpeech
//
//  Created by Aibek Rakhim on 1/27/18.
//  Copyright © 2018 NextStep Labs. All rights reserved.
//

import UIKit
import EasyPeasy

class TopicVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let topicTableView = UITableView()
    let idCell = "myCell"
    let array = ["Семья", "Образование", "Хобби", "Путешествие"]
    var gradientLayer: CAGradientLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //MARK: call functions
        setupViews()
        setupingConstraints()
        navigationItem.title = "Темы для спитча"
        
        //TableView
        topicTableView.rowHeight = 60
        topicTableView.delegate = self
        topicTableView.dataSource = self
        topicTableView.register(UITableViewCell.self, forCellReuseIdentifier: idCell)
        topicTableView.tableFooterView = UIView(frame: .zero)
        
        createGradientLayer()
    }

    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recordVC = RecordVC()
        recordVC.titleText = self.array[indexPath.row]
        self.navigationController?.pushViewController(recordVC, animated: true)
    }
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 73.0/255.0, green: 187.0/255.0, blue: 158.0/255.0, alpha: 1.0).cgColor,
                                UIColor(red: 31.0/255.0, green: 105.0/255.0, blue: 74.0/255.0, alpha: 1.0).cgColor]
        gradientLayer.locations = [0, 1]
        let thisView = UIView(frame: topicTableView.frame)
        thisView.layer.addSublayer(gradientLayer)
        self.topicTableView.backgroundView = thisView
    }
}

//MARK: Extension for setuping UI
extension TopicVC {
    
    func setupViews() {
        
        [topicTableView].forEach {
            self.view.addSubview($0)
        }
        
    }
    
    func setupingConstraints() {
        topicTableView <- [
            Top(0).to(navigationController?.navigationBar ?? view),
            Left(0),
            Right(0),
            Bottom(50)
        ]
    }
}
