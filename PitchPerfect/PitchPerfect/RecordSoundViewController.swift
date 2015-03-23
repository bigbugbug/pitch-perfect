//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by John Chan on 3/7/15.
//  Copyright (c) 2015 John Chan. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController,AVAudioRecorderDelegate {

    // outlet for label recordingInProgess
    @IBOutlet weak var recordingInProgress: UILabel!
    // outlet for label stopButton
    @IBOutlet weak var stopButton: UIButton!
    // output for label recordButton
    @IBOutlet weak var recordButton: UIButton!
    // create object AVAudioRecorder to be use in recording
    var audioRecorder:AVAudioRecorder!
    // get new object audio created for passing to different controller
    var recordedAudio:RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden=true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }

    /*
    // this action below will be executed when record button is pressed
    */
    @IBAction func recordAudio(sender: UIButton) {
              println("in recordAudio")
        recordingInProgress.hidden = false  // Enable recordingInProgress label
        stopButton.hidden = false           // Enable Stop Button
        recordButton.enabled = false        // Record Button is disabled
        
        //Inside func recordAudio(sender: UIButton)
        // get a dirpath we can use to store our wav file
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        // combine the dirpath and filename
        var pathArray = [dirPath, recordingName]
        // change the path to NSURL to be use by audioRecorder object
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        // setup the audioRecorder object and record the voice
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    
    /*
    // this action below will be executed when stop button is pressed
    */
    @IBAction func StopButton(sender: UIButton) {
        recordingInProgress.hidden = true
        recordButton.enabled = true
        audioRecorder.stop()        // stop audio
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    
    /*
    // this function called by IOS when recording did finish by IOS
    */
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        println("finished recording")
        if (flag)
        {
            // save recorder audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            // move to next scene
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio )
        }
        else
        {
            println("Recording was not sucessful")
            recordButton.enabled = true
            stopButton.hidden = true
            
        }
        
    }
    
    /*
    // this function prepare the seque between two controllers. The ID is recorded and created by auidoRecorderDidFinishRecording
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
        
    }
    
  

}

