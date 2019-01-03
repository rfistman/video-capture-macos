//
//  AppDelegate.swift
//  video-capture-macos
//
//  Created by Rhythmic Fistman on 3/1/19.
//  Copyright © 2019 Rhythmic Fistman. All rights reserved.
//

// https://stackoverflow.com/questions/54009139/how-to-use-the-avfoundation-to-capture-video-data-in-macos

import Cocoa
import AVFoundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var window: NSWindow!

    lazy var sampleBufferDelegateQueue = DispatchQueue(label: "CVCameraInput")
    lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .hd1280x720
        
        let device = AVCaptureDevice.default(for: .video)!
        let input = try! AVCaptureDeviceInput(device: device)
        session.addInput(input)
        
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
            kCVPixelBufferMetalCompatibilityKey as String: true
        ]
        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: self.sampleBufferDelegateQueue)
        session.addOutput(output)
        
        // At this point, both the input and output are successfully added to the session
        
        return session
    }()

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Process captured CMSampleBuffer
        NSLog("didOutput \(sampleBuffer)")
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.captureSession.startRunning()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

