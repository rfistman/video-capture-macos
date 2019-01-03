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

class CameraInput: NSObject {
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
}

extension CameraInput/*: CVInput*/ {
    func start() {
        guard !self.captureSession.isRunning else {
            return
        }
        
        self.captureSession.startRunning()
    }
    
    func stop() {
        guard self.captureSession.isRunning else {
            return
        }
        
        self.captureSession.stopRunning()
    }
}

extension CameraInput: AVCaptureVideoDataOutputSampleBufferDelegate {
    // private breaks this!
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Handle captured frame
        NSLog("didOutput \(sampleBuffer)")
    }
}
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var window: NSWindow!
    lazy var cameraInput = CameraInput()

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.cameraInput.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

