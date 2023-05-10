//
//  TranscriptionViewModel.swift
//  Craven Connections
//
//  Created by Craven on 5/4/23.
//

import Foundation
import Speech

final class TranscriptionViewModel: NSObject, ObservableObject {
    enum RecordingState {
        case notStarted
        case recording
        case finished
    }
    
    // Properties
    @Published var transcriptions: [Transcription] = []
    @Published var transcriptionsByLanguage: [String: [Transcription]] = [:]
    @Published var recordingState: RecordingState = .notStarted
    @Published var errorMessage: String = ""
    
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    // Initializers
    override init() {
        super.init()
        speechRecognizer?.delegate = self
        requestAuthorization()
    }
    
    // Methods
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { [weak self] (status) in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    print("Speech recognizer authorized")
                case .denied:
                    self?.errorMessage = "User denied access to speech recognition"
                case .restricted:
                    self?.errorMessage = "Speech recognition restricted on this device"
                case .notDetermined:
                    self?.errorMessage = "Speech recognition not yet authorized"
                default:
                    self?.errorMessage = "Speech recognition authorization failed"
                }
            }
        }
    }
    
    func startRecording() {
        // Check if the speech recognizer is available
        guard let speechRecognizer = speechRecognizer else {
            errorMessage = "Speech recognizer not available"
            return
        }
        
        // Check if the recognition task is already running
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        // Set the recording state to recording
        recordingState = .recording
        
        // Configure the audio session for recording
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            errorMessage = "Error configuring audio session: \(error.localizedDescription)"
            return
        }
        
        // Configure the recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            errorMessage = "Unable to create recognition request"
            return
        }
        recognitionRequest.shouldReportPartialResults = true
        
        // Configure the recognition task
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] (result, error) in
            if let result = result {
                let transcription = Transcription(transcript: result.bestTranscription.formattedString)
                DispatchQueue.main.async {
                    self?.transcriptions.append(transcription)
                    self?.updateTranscriptionsByLanguage()
                }
            }
            if let error = error {
                print("Error in recognitionTask: \(error.localizedDescription)")
            }
        })
        
        // Start the audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            errorMessage = "Error starting audio engine: \(error.localizedDescription)"
            return
        }
        
        // Install a tap on the audio engine's input node to forward audio buffers to the recognition request
        guard let inputNode = audioEngine.inputNode else {
            errorMessage = "Audio engine has no input node"
            return
        }
