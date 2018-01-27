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
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ru-Ru"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupingConstraints()
        self.requestSpeechAuthorization()
    }
    
    //MARK: IBActions start and cancel
    @objc func startButtonPressed(sender: UIButton) {
        if isRecording == true {
            audioEngine.stop()
            recognitionTask?.cancel()
            isRecording = false
            startButton.backgroundColor = UIColor.gray
        } else {
            self.recordAndRecognizeSpeech()
            isRecording = true
            startButton.backgroundColor = UIColor.red
        }
    }
    
    @objc func backButtonPressed(sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func cancelRecording() {
        audioEngine.stop()
        if let node = audioEngine.inputNode as AVAudioInputNode?{
            node.removeTap(onBus: 0)
        }
        recognitionTask?.cancel()
    }
    
    func recordAndRecognizeSpeech() {
        guard let node = audioEngine.inputNode as AVAudioInputNode? else { return }
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            self.sendAlert(message: "audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.sendAlert(message: "not supported your locale")
            return
        }
        if !myRecognizer.isAvailable {
            self.sendAlert(message: "not available")
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                //                print("result \(result)")
                let bestString = result.bestTranscription.formattedString
                self.detectedTextLabel.text = bestString
                
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[indexTo...])
                }
                self.checkForColorsSaid(resultString: lastString)
            } else if let error = error {
                self.sendAlert(message: "a speech recognition error.")
                print(error)
            }
        })
    }
    
    //MARK: - Check Authorization Status
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.startButton.isEnabled = true
                case .denied:
                    self.startButton.isEnabled = false
                    self.detectedTextLabel.text = "User denied access to speech recognition"
                case .restricted:
                    self.startButton.isEnabled = false
                    self.detectedTextLabel.text = "Speech recognition restricted"
                case .notDetermined:
                    self.startButton.isEnabled = false
                    self.detectedTextLabel.text = "not yet authorized"
                }
            }
        }
    }
    
    //MARK: - UI / Set view color.
    func checkForColorsSaid(resultString: String) {
        switch resultString {
        case "блин":
            view.backgroundColor = UIColor.red
        case "черт":
            view.backgroundColor = UIColor.orange
        case "ой":
            view.backgroundColor = UIColor.yellow
        case "вот":
            view.backgroundColor = UIColor.green
        case "уфф":
            view.backgroundColor = UIColor.blue
        case "тупой":
            view.backgroundColor = UIColor.purple
        case "так":
            view.backgroundColor = UIColor.black
        case "однако":
            view.backgroundColor = UIColor.white
        case "ааа":
            view.backgroundColor = UIColor.gray
        case "стоп":
            cancelRecording()
        default: break
        }
    }
    
    //MARK: - Alert
    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Speech Recognizer Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        firstLabel.text = "Расскажите о себе"
        firstLabel.textAlignment = .left
        firstLabel.adjustsFontSizeToFitWidth = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_arrow"), style: .plain, target: self, action: #selector(backButtonPressed(sender:)))
        
        view.backgroundColor = UIColor.white
        
        //adding UIElements to superView
        [firstLabel, detectedTextLabel, startButton].forEach {
            view.addSubview($0)
        }
    }
    
    func setupingConstraints() {
        
        firstLabel <- [
            Top(5).to(view),
            Left(15),
            Right(15)
        ]
        
        detectedTextLabel <- [
            Top(10).to(firstLabel),
            Left(15),
            Right(15),
            Bottom(10).to(startButton)
        ]
        
        startButton <- [
            Width(100),
            Height(100),
            CenterX(0),
            CenterY(0)
        ]
    }
}
