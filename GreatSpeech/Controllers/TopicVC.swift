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
    }

    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath)
        cell.textLabel?.text = "Row number\(indexPath.row+1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(RecordVC(), animated: true)
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
