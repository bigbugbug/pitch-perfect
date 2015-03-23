//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by John Chan on 3/7/15.
//  Copyright (c) 2015 John Chan. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var audioPlayer : AVAudioPlayer!    //AVAudioPLayer IOS foundation class
    var receivedAudio : RecordedAudio!  //User define class
    var audioEngine : AVAudioEngine!    // AVAudioEngine IOS foundation class
    // convert NSURL to AVAudioFIle
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
// initilized this to be used for pitch change
        audioEngine = AVAudioEngine()
// convert NSURL to AVAudioFile
        audioFile = AVAudioFile(forReading:receivedAudio.filePathUrl,error:nil)

        // Do any additional setup after loading the view.
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
//            var filePathUrl = NSURL.fileURLWithPath(filePath)
//            audioPlayer = AVAudioPlayer(contentsOfURL: filePathUrl, error: nil)
//        }
//        else
//        {
//            println("the filePath is empty")
//        }
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 /*
// Play audio from start with inputed rate
*/
    func playAudio(rate:Float)
    {
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
 
    /*
    // Play Slow Audio
    */
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(0.5)
        
    }

    /*
    // Play Fast Audio
    */
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(1.5)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
    }
    
    func playAudioWithVariablePitch(pitch : Float)
    {
        var pitchPlayer = AVAudioPlayerNode()
        var timePitch = AVAudioUnitTimePitch()
 //       var reverbNode = AVAudioUnitReverb()
 
        timePitch.pitch = pitch
 //       reverbNode.inputFormatForBus(0)
        // stop all audio
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioEngine.attachNode(pitchPlayer)
        audioEngine.attachNode(timePitch)
    
        audioEngine.connect(pitchPlayer, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        // audioFile was converted from our seguel value
        pitchPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        pitchPlayer.play()
        
    }
    
    func playAudioWithReverb(pitch : Float)
    {
        var inputNode: AVAudioInputNode!
        var unitReverb = AVAudioUnitReverb()
        var player = AVAudioPlayerNode()
        let file = AVAudioFile(forReading:audioFile.url,error:nil)
        
     inputNode = audioEngine.inputNode
        unitReverb.wetDryMix=50
        audioEngine.attachNode(unitReverb)
        
//        let inputFormat = unitReverb.inputFormatForBus(0)
//        // stop all audio
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()

        audioEngine.connect(inputNode, to: unitReverb, format: file.processingFormat)
       audioEngine.connect(player, to: unitReverb, format: file.processingFormat)

       audioEngine.connect(unitReverb,to: audioEngine.outputNode, format:file.processingFormat)

         // audioFile was converted from our seguel value
        player.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        player.play()
        
    }
    
    @IBAction func playChipmunkAduio(sender: UIButton) {

       
        playAudioWithVariablePitch(1000);

    }
    
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(-1000);
    }
    
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playAudioWithReverb(1000);    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
