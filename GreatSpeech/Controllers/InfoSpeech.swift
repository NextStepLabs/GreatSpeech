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
    var fillers = [String : Int]()
    var words = [String]()
    var gradientLayer: CAGradientLayer!

    var fillerNO: Int = 0
    var wordNO: Int = 0

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
        createGradientLayer()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
        
        if indexPath.row == 0 {
            
            cell.textLabel?.text = "Время"
            cell.detailTextLabel?.text = "00:00"
            
        }else if indexPath.row == 1 {
            
            cell.textLabel?.text = "Все слова"
            var count = 0
            
            if wordNO > 0 {
                count = wordNO
            }
            
            cell.detailTextLabel?.text = "\(count)"
            cell.accessoryType = .disclosureIndicator
            
        } else if indexPath.row == 2 {
            
            cell.textLabel?.text = "Паразиты"
            var count = 0
            
            if fillerNO > 0 {
                count = fillerNO
            }
            
            cell.detailTextLabel?.text = "\(count)"
            cell.accessoryType = .disclosureIndicator
            
        } else if indexPath.row == 3 {
            
            cell.textLabel?.text = "Чистота слов"
            cell.detailTextLabel?.text = "\(20)"
            
        }
        
        return cell
    }
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 73.0/255.0, green: 187.0/255.0, blue: 158.0/255.0, alpha: 1.0).cgColor,
                                UIColor(red: 31.0/255.0, green: 105.0/255.0, blue: 74.0/255.0, alpha: 1.0).cgColor]
        gradientLayer.locations = [0, 1]
        let thisView = UIView(frame: tableView.frame)
        thisView.layer.addSublayer(gradientLayer)
        self.tableView.backgroundView = thisView
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
