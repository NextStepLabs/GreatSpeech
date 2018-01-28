//
//  InfoSpeech.swift
//  GreatSpeech
//
//  Created by Aibek Rakhim on 1/28/18.
//  Copyright © 2018 NextStep Labs. All rights reserved.
//

import UIKit
import EasyPeasy

class InfoSpeech: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    let cellIdentifier = "cell"
    var fillers: [String : Int]?
    var words: [String]?
    var word: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView(frame: .zero)
        
        setupView()
        setupConstraints()
        
        print(word ?? "")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
        
        if indexPath.row == 0 {
            
            cell.textLabel?.text = "Время"
            cell.detailTextLabel?.text = "00:00"
            
        }else if indexPath.row == 1 {
            
            cell.textLabel?.text = "Все слова"
            var count = 0
            
            if let words = words{
                if words.count > 0 {
                    count = words.count
                }
            }
            cell.detailTextLabel?.text = "\(count)"
            cell.accessoryType = .disclosureIndicator
            
        } else if indexPath.row == 2 {
            
            cell.textLabel?.text = "Паразиты"
            var count = 0
            
            if let fillers = fillers {
                if fillers.count > 0 {
                    count = fillers.count
                }
            }
            
            cell.detailTextLabel?.text = "\(count)"
            cell.accessoryType = .disclosureIndicator
            
        } else if indexPath.row == 3 {
            
            cell.textLabel?.text = "Чистота слов"
            cell.detailTextLabel?.text = "\(20)"
            
        }
        
        return cell
    }
}
extension InfoSpeech {
    func setupView() {
        [tableView].forEach { self.view.addSubview($0) }
    }
    
    func setupConstraints() {
        tableView <- [
            Top(65),
            Left(0),
            Right(0),
            Bottom(0)
        ]
    }
}
