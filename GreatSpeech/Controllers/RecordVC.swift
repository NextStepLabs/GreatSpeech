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

class RecordVC: UIViewController, SFSpeechRecognizerDelegate {
    
    //MARK: Declaring the UI elements
    let startButton = UIButton()
    let detectedTextLabel = UILabel()
    let firstLabel = UILabel()
    let secondLabel = UILabel()
    let thirdLabel = UILabel()
    
    //MARK: Initializing of the AudioEngine, Speech recognizer
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var mostRecentlyProcessedSegmentDuration: TimeInterval = 0
    var state = false
    var initialized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupingConstraints()
    }
    
    //MARK: IBActions start and cancel
    @objc func startButtonPressed(sender: UIButton) {
//        stopRecording()
        if state {
            stopRecording()
            state = !state
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
}
extension RecordVC {
    fileprivate func startRecording() throws {
        mostRecentlyProcessedSegmentDuration = 0
        DispatchQueue.main.async {
            self.detectedTextLabel.text = ""
            self.startButton.backgroundColor = UIColor.red
        }
        
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        if initialized {
                initialized = !initialized
        } else {
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
        self.startButton.backgroundColor = UIColor.blue
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
