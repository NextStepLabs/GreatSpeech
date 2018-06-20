//
//  ViewController.swift
//  GreatSpeech
//
//  Created by Aibek Rakhim on 1/27/18.
//  Copyright © 2018 NextStep Labs. All rights reserved.
//

import UIKit
import Speech
import EasyPeasy
import FirebaseDatabase

class RecordVC: UIViewController, SFSpeechRecognizerDelegate {
    
    //MARK: Declaring the UI elements
    let startButton = UIButton()
    let detectedTextLabel = UILabel()
    let firstLabel = UILabel()
    let secondLabel = UILabel()
    let thirdLabel = UILabel()
    
    //MARK: Initializing of the AudioEngine, Speech recognizer, Firebase, Properties
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ru-Ru"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var mostRecentlyProcessedSegmentDuration: TimeInterval = 0
    var gradientLayer: CAGradientLayer!
    var state = false
    var initialized = false
    var allText = " "
    var counts : [String : Int] = [ : ]
    var ref : DatabaseReference!
    let refData = "Data"
    let refFiller = "Filler"
    var fillers: Array<String>!
    var titleText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = titleText ?? "hello"
        
        setupViews()
        setupingConstraints()
        
        createGradientLayer()
        
        //setuping firebase
        self.ref = Database.database().reference()
        ref.child(refFiller).observe(.value, with:{(snapshot) in
            print(snapshot.value as! String)
            let allFillers = snapshot.value as! String
            self.fillers = allFillers.components(separatedBy: CharacterSet.alphanumerics.inverted).filter{ $0 != "" }
            print("fillers \(self.fillers ?? [""])")
        }
        )
        
    }
    
    //MARK: IBActions start and cancel
    @objc func startButtonPressed(sender: UIButton) {
        if state {
            stopRecording()
            state = !state
            sender.setTitle("Начать", for: UIControlState.normal)
            self.startButton.backgroundColor = UIColor.blue
        }else{
            SFSpeechRecognizer.requestAuthorization {
                [unowned self] (authStatus) in
                switch authStatus {
                case .authorized:
                    do {
                        try self.startRecording()
                        self.state = !self.state
                    } catch let error {
                        print("There was a problem starting recording: \(error.localizedDescription)")
                    }
                case .denied:
                    print("Speech recognition authorization denied")
                case .restricted:
                    print("Not available on this device")
                case .notDetermined:
                    print("Not determined")
                }
            }
        }
        
    }
    
    @objc func backButtonPressed(sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 73.0/255.0, green: 187.0/255.0, blue: 158.0/255.0, alpha: 1.0).cgColor,
                                UIColor(red: 31.0/255.0, green: 105.0/255.0, blue: 74.0/255.0, alpha: 1.0).cgColor]
        gradientLayer.locations = [0, 1]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
extension RecordVC {
    fileprivate func startRecording() throws {
        mostRecentlyProcessedSegmentDuration = 0
        DispatchQueue.main.async {
            self.detectedTextLabel.text = ""
            self.startButton.backgroundColor = UIColor.red
            self.startButton.setTitle("Стоп", for: UIControlState.normal)
        }
        
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        if initialized {
                initialized = !initialized
        } else {
            node.removeTap(onBus: 0)
            node.installTap(onBus: 0, bufferSize: 1024,
                            format: recordingFormat) { [unowned self]
                                (buffer, _) in
                                self.request.append(buffer)
            }
            initialized = !initialized
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        recognitionTask = speechRecognizer?.recognitionTask(with: request) {
            [unowned self]
            (result, _) in
            if let transcription = result?.bestTranscription {
                self.updateUIWithTranscription(transcription)
            }
        }
    }
    
    fileprivate func stopRecording() {
        audioEngine.stop()
        request.endAudio()
        recognitionTask?.cancel()
        if let labelText = detectedTextLabel.text {
            allText = ""
            counts = [ : ]
            allText = labelText.lowercased()
            let words = allText.components(separatedBy: CharacterSet.alphanumerics.inverted).filter{ return ($0 != "" && $0.count != 1) }
            words.forEach { self.counts[$0, default: 0] += 1 }
            let finalCounts = self.counts.sorted{ $0.value > $1.value }
            print("Counts ",finalCounts )
            var badWords : [String: Int] = [ : ]
            finalCounts.forEach{
                if (((words.count / 5) / 2) < $0.value && self.fillers.contains($0.key)){
                    badWords[$0.key] = $0.value
                }
            }
            let alert = UIAlertController(title: "Анализ",
                                          message: "\(words.count) слов высказано \n \(badWords.count) паразит слова", preferredStyle: .alert)
            
            let okBtn = UIAlertAction(title: "Подробнее", style: .default, handler: { (action) in
                let infoSpeech = InfoSpeech()
                infoSpeech.fillerNO = badWords.count
                infoSpeech.wordNO = words.count
                self.navigationController?.pushViewController(infoSpeech, animated: true)
            })
            let cancelBtn = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alert.addAction(okBtn)
            alert.addAction(cancelBtn)
            self.present(alert, animated: true, completion: nil)
            
            if !allText.isEmpty {
                ref.child(refData).childByAutoId().setValue(allText)
            }
        }
    }
}

extension RecordVC {
    fileprivate func updateUIWithTranscription(_ transcription: SFTranscription) {
        self.detectedTextLabel.text = transcription.formattedString
        
        if let lastSegment = transcription.segments.last,
            lastSegment.duration > mostRecentlyProcessedSegmentDuration {
            mostRecentlyProcessedSegmentDuration = lastSegment.duration
        }
    }
}



//MARK: Extension for setuping UI
extension RecordVC {
    
    func setupViews() {
        
        //start button setuping
        startButton.backgroundColor = UIColor.blue
        startButton.setTitleColor(UIColor.blue, for: .highlighted)
        startButton.setTitleColor(UIColor.white, for: .normal)
        startButton.titleLabel?.font = UIFont(name: "ProximaNova-Semibold", size: 16.0)
        startButton.setTitle("Начать", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonPressed(sender:)), for: .touchUpInside)
        
        //detectedText label setuping
        detectedTextLabel.backgroundColor = UIColor.white
        detectedTextLabel.textColor = UIColor.black
        detectedTextLabel.numberOfLines = 0
        detectedTextLabel.adjustsFontSizeToFitWidth = true
        
        // first question label setuping
        firstLabel.text = "1. Расскажите о себе"
        firstLabel.textAlignment = .left
        firstLabel.adjustsFontSizeToFitWidth = true
        
        //second question label setuping
        secondLabel.text = "2. Расскажите про ваш хобби"
        secondLabel.textAlignment = .left
        secondLabel.adjustsFontSizeToFitWidth = true
        
        //third question label setuping
        thirdLabel.text = "3. Расскажите про вашу работу"
        thirdLabel.textAlignment = .left
        thirdLabel.adjustsFontSizeToFitWidth = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_arrow"), style: .plain, target: self, action: #selector(backButtonPressed(sender:)))
        
        view.backgroundColor = UIColor.white
        
        //adding UIElements to superView
        [firstLabel, secondLabel, thirdLabel, startButton, detectedTextLabel].forEach {
            view.addSubview($0)
        }
    }
    
    func setupingConstraints() {
        
        firstLabel <- [
            Top(75),
            Left(15),
            Right(15)
        ]
        
        secondLabel <- [
            Top(10).to(firstLabel),
            Left(15),
            Right(15)
        ]

        thirdLabel <- [
            Top(10).to(secondLabel),
            Left(15),
            Right(15)
        ]

        startButton <- [
            CenterX(0),
            Bottom(55),
            Width(200),
            Height(60)
        ]
        
        detectedTextLabel <- [
            Top(10).to(thirdLabel),
            Left(15),
            Right(15),
            Height(250)
        ]
    }
}
