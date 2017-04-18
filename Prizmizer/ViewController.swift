//
//  ViewController.swift
//  Prizmizer
//
//  Created by Vikram Sundaram on 4/15/17.
//  Copyright © 2017 VKTRY Studios. All rights reserved.
//

import UIKit
import AVFoundation
import AudioKit

//these can be accessed by all keys in the interface
var micWolf: AKMicrophone?
var freqTracker: AKFrequencyTracker?
var micBooster: AKBooster?
var dShift: AKPitchShifter?
var mixer: AKMixer?
var mixer2: AKMixer?
var mixer3: AKMixer?
var mixer4: AKMixer?
var mixer5: AKMixer?
var mixer6: AKMixer?
var mixer7: AKMixer?
var mixer8: AKMixer?
var mixer9: AKMixer?

//Buttons are the shifts per key
var buttons = [AKPitchShifter?](repeating: nil, count:8)
var octave = 0
//Creates an array of doubles
var calcCorrection = Array(repeating: 0.0, count: 8)


class ViewController: UIViewController {
    //D key outlet
    
    @IBOutlet var FrequencyInHz: UILabel!
    @IBOutlet var Dkey: UIButton!
    var timer: Timer!
    var timerOne: Timer!
    //makes sure that its not initialized twice
    var initialized = 0
    //Sets up AudioKit Parameters
    
    
    func initAudioSystem()
    {
        
        if(initialized == 0){
        micWolf = AKMicrophone()
        freqTracker = AKFrequencyTracker.init(micWolf!, hopSize: 1024, peakCount: 20)
        micBooster = AKBooster(freqTracker!, gain: 0.0000001)
        //AudioKit.output = micBooster
        //AKSettings.rampTime = 0.5
       //init array
        //Buttons are initialized
        for index in 0...7
        {
            buttons[index] = AKPitchShifter(micWolf!, shift: 12, windowSize: 100000, crossfade: 0)
            AKSettings.rampTime = 0.005
            }
           //micBooster?.gain = 0.00000000000001
            //micWolf?.volume = 1
        //leap of faith
        //dShift = AKPitchShifter(micWolf!, shift: 12, windowSize: 4096, crossfade: 0)
        //Added all the frequency shifts to mixer
        mixer = AKMixer((micBooster!),(buttons[0]!),buttons[1]!,buttons[2]!,buttons[3]!,buttons[4]!,buttons[5]!,buttons[6]!,buttons[7]!)
        /*mixer2 = AKMixer(mixer!, buttons[1]!)
        mixer3 = AKMixer(mixer2!, buttons[2]!)
        mixer4 = AKMixer(mixer3!, buttons[3]!)
        mixer5 = AKMixer(mixer4!, buttons[4]!)
        mixer6 = AKMixer(mixer5!, buttons[5]!)
        mixer7 = AKMixer(mixer6!, buttons[6]!)
        mixer8 = AKMixer(mixer7!, buttons[7]!)*/
       //mixer9 = AKMixer(buttons)
        AudioKit.output = mixer
        AudioKit.start()
        //set all shifts to stop
            for index in 0...7
            {
                buttons[index]?.stop()
            }
            dShift?.stop()
            micBooster?.stop()
            //micBooster?.start()
        //tells us we've initialized
        initialized = 1
        }
    }
    
    //displays frequency
    func frequencyDetection()
    {
        //Displays frequency
       //FrequencyInHz.text = "\(freqTracker?.frequency) Hz"
        //print(freqTracker?.frequency)
    }
    
    func imFrancis(originput: Double, keyPressed: integer_t) -> Double
    {
        var shift: Double
        shift = Double(keyPressed + 12*octave) - (12*(log2(originput/440)) + 42)
        print(shift)
        return shift
    }
    
    //continuous frequency detection
    

   /* @IBAction func buttonDown(_ sender: Any) {
        print("hello")
        dShift?.start()
    }
    
    @IBAction func buttonUpTwo(_ sender: Any) {
        dShift?.stop()
        //AudioKit.stop()
    }
    @IBAction func buttonUp(_ sender: Any) {
        //AudioKit.stop()
    }*/
    
    
    @IBAction func OnePushedDown(_ sender: Any) {
        
        buttons[0]?.start()
    }
    @IBAction func OneReleased(_ sender: UIButton) {
        buttons[0]?.stop()
    }
    @IBAction func TwoPushedDown(_ sender: UIButton) {
        buttons[1]?.start()
    }
    @IBAction func TwoReleased(_ sender: UIButton) {
        buttons[1]?.stop()
    }
    @IBAction func ThreePushedDown(_ sender: UIButton) {
        buttons[2]?.start()
    }
    @IBAction func ThreeReleased(_ sender: UIButton) {
        buttons[2]?.stop()
    }
    @IBAction func FourPushedDown(_ sender: UIButton) {
        buttons[3]?.start()
    }
    
    @IBAction func FourReleased(_ sender: UIButton) {
        buttons[3]?.stop()
    }
    @IBAction func FivePushedDown(_ sender: UIButton) {
        buttons[4]?.start()
    }
    @IBAction func FiveReleased(_ sender: UIButton) {
        buttons[4]?.stop()
    }
    @IBAction func SixPushedDown(_ sender: UIButton) {
        buttons[5]?.start()
    }
    @IBAction func SixReleased(_ sender: UIButton) {
        buttons[5]?.stop()
    }
    @IBAction func SevenPushedDown(_ sender: UIButton) {
        buttons[6]?.start()
    }
    @IBAction func SevenReleased(_ sender: UIButton) {
        buttons[6]?.stop()
    }
    @IBAction func EightPushedDown(_ sender: UIButton) {
        buttons[7]?.start()
    }
    @IBAction func EightReleased(_ sender: UIButton) {
        buttons[7]?.stop()
    }
    
    
    
    
    
    
    //assigns shift values to all buttons
    func repeatFreq(){
        buttons[0]?.shift = imFrancis(originput: (freqTracker?.frequency)!, keyPressed: (28))
        buttons[1]?.shift = imFrancis(originput: (freqTracker?.frequency)!, keyPressed: (30))
        buttons[2]?.shift = imFrancis(originput: (freqTracker?.frequency)!, keyPressed: (32))
        buttons[3]?.shift = imFrancis(originput: (freqTracker?.frequency)!, keyPressed: (33))
        buttons[4]?.shift = imFrancis(originput: (freqTracker?.frequency)!, keyPressed: (35))
        buttons[5]?.shift = imFrancis(originput: (freqTracker?.frequency)!, keyPressed: (37))
        buttons[6]?.shift = imFrancis(originput: (freqTracker?.frequency)!, keyPressed: (39))
        buttons[7]?.shift = imFrancis(originput: (freqTracker?.frequency)!, keyPressed: (40))
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAudioSystem()
          timer = Timer.scheduledTimer(timeInterval: 0.000125 , target: self, selector: #selector(repeatFreq), userInfo: nil, repeats: true)
     //binding piano keys to their functions
        //Dkey.addTarget(self, action:#selector(buttonDown(sender:)), for: .touchDown)
        //Dkey.addTarget(self, action:#selector(buttonUp(sender:)), for: [.touchUpInside, .touchUpOutside])
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}
