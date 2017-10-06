//
//  ViewController.swift
//  MyApp33
//
//  Created by user22 on 2017/10/6.
//  Copyright © 2017年 Brad Big Company. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var audioEngine = AVAudioEngine()
    var request = SFSpeechAudioBufferRecognitionRequest()
    let speechRecog = SFSpeechRecognizer(locale: Locale(identifier: "zh-TW"))
    var recogTask:SFSpeechRecognitionTask? = nil
    
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBAction func start(_ sender: Any) {
        if audioEngine.isRunning {
            // 中斷
            audioEngine.stop()
            request.endAudio()
            audioEngine.reset()
        }else {
            // 開始錄
            audioEngine = AVAudioEngine()
            startRecording()
        }
        
        
    }
    
    func startRecording(){
        // 處理目前正在辨識中的任務
        if recogTask != nil {
            recogTask?.cancel()
            recogTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
            
            request = SFSpeechAudioBufferRecognitionRequest()
            request.shouldReportPartialResults = true
            
            let inputNode = audioEngine.inputNode
            
            speechRecog?.recognitionTask(with: request, resultHandler: { (result, error) in
                if result != nil {
//                    self.textLabel.text =  result?.bestTranscription.formattedString
                    
                    self.textView.text = result?.bestTranscription.formattedString
                    
                }
            })
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: { (buffer, when) in
                self.request.append(buffer)
            })
            
            audioEngine.prepare()
            do {
                try audioEngine.start()
            }catch {
                print("error2: \(error)")
            }
            
            
            
        }catch{
            print("error: \(error)")
        }
        
        
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SFSpeechRecognizer.requestAuthorization { (status) in
            switch status {
            case .authorized:
                print("OK")
            case .denied:
                print("xx")
            default:
                print("other")
            }
        }
        
    }

}

