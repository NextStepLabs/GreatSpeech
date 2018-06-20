//
//  AnalyzingFillerVC.swift
//  GreatSpeech
//
//  Created by Aibek Rakhim on 1/27/18.
//  Copyright © 2018 NextStep Labs. All rights reserved.
//

import UIKit
import EasyPeasy
import FirebaseDatabase

class AnalyzingFillerVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    let tableView = UITableView()
    let cellIdentifier = "cell"
    var fillers : Array<String>!
    var words = [String]()
    var gradientLayer: CAGradientLayer!
    var fillerNO: Int = 0
    var wordNO: Int = 0
    var ref: DatabaseReference!
    var allText = " "
    var counts : [String : Int] = [ : ]
    var badWords : [String: Int] = [ : ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        ref.observe(.value, with: {(snapshot) in
            var allFillers = snapshot.childSnapshot(forPath: "Filler").value as? String ?? ""
            self.fillers = allFillers.components(separatedBy: CharacterSet.alphanumerics.inverted).filter{ $0 != "" }
            
            self.ref.child("Data").observe(.value, with:{ (dataSnapshot) in
                if let values = dataSnapshot.value as? [String : String]{
                    for obj in values {
                        print(obj.value)
                        self.allText.append(obj.value)
                    }
                    
                    let words = self.allText.components(separatedBy: CharacterSet.alphanumerics.inverted).filter{ return ($0 != "" && $0.count != 1) }
                    words.forEach { self.counts[$0, default: 0] += 1 }
                    let finalCounts = self.counts.sorted{ $0.value > $1.value }
                    print("Counts ",finalCounts )
                    let sentence = words.count / 5
                        finalCounts.forEach{
                            if (((sentence / 2) < $0.value && self.fillers.contains($0.key)) || sentence / 6 < $0.value){
                                self.badWords[$0.key] = $0.value
                                self.tableView.reloadData()
                            }
                        }
                    self.tableView.reloadData()
                        return
                    
                    print("bad word \(self.badWords)")
                    
                    
                }
            })
        })
        
        view.backgroundColor = UIColor.white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView(frame: .zero)
        
        setupView()
        setupConstraints()
        createGradientLayer()
        self.navigationItem.title = "Паразиты"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return badWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
        
        cell.textLabel?.text = Array(badWords.keys)[indexPath.row]
        cell.detailTextLabel?.text = "\(Array(badWords)[indexPath.row].value)"
        cell.accessoryType = .disclosureIndicator
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
extension AnalyzingFillerVC {
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

