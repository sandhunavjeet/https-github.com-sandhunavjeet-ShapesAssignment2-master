//
//  ViewController.swift
//  ParticleIOSStarter
//
//  Created by Parrot on 2019-06-29.
//  Copyright © 2019 Parrot. All rights reserved.

import UIKit
import Particle_SDK

class ViewController: UIViewController {

    // MARK: User variables
    // MARK: User variables
    let USERNAME = "navsandhu343@gmail.com"
    let PASSWORD = "Ajaib@111"
    
    // MARK: Device
    // Jenelle's device
    //let DEVICE_ID = "36001b001047363333343437"
    // Antonio's device
    let DEVICE_ID = "370034001047363333343437"
    var myPhoton : ParticleDevice?
    
    // MARK: Other variables
    var gameScore:Int = 0

    
    //fsm,
    //fake changeseffdf
    
    @IBOutlet weak var circle: UIImageView!
    @IBOutlet weak var square: UIImageView!
    @IBOutlet weak var triangle: UIImageView!
    
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var questionTextView: UITextView!
    
    @IBOutlet weak var correctOrNot: UITextView!
    
    @IBAction func questionButton(_ sender: UIButton) {
        
        
        
        
        let text: String = userInput.text ?? "anything here"
    questionTextView.text = "\(text)"
    }
    @IBAction func last(_ sender: UIButton) {
        questionTextView.text = "choose Circle"
         circle.image = UIImage(named: "circle")
        
        
    }
    @IBAction func middle(_ sender: UIButton) {
        questionTextView.text = "choose Square"
         circle.image = UIImage(named: "square")
    }
    
    @IBAction func next(_ sender: UIButton) {
        
        questionTextView.text = "choose Triangle"
        circle.image = UIImage(named: "triangle")
    }
    
    
    
    
    
    
    // MARK: Outlets
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        var output = questionTextView.text
        
        if(output == "circle")
        {
            
            let tapCircle = UITapGestureRecognizer(target: self, action: #selector(ViewController.turnParticleGreen))
            circle.addGestureRecognizer(tapCircle)
            circle.isUserInteractionEnabled = true
            
            
            let tapSquare = UITapGestureRecognizer(target: self, action: #selector(ViewController.turnParticleRed))
            square.addGestureRecognizer(tapSquare)
            square.isUserInteractionEnabled = true
            
            
            
            
            let tapTriangle = UITapGestureRecognizer(target: self, action: #selector(ViewController.turnParticleRed))
            triangle.addGestureRecognizer(tapTriangle)
            triangle.isUserInteractionEnabled = true
            
        }
            
            
        else if(output == "choose Square"){
            
            
            let tapCircle = UITapGestureRecognizer(target: self, action: #selector(ViewController.turnParticleRed))
            circle.addGestureRecognizer(tapCircle)
            circle.isUserInteractionEnabled = true
            
            let tapSquare = UITapGestureRecognizer(target: self, action: #selector(ViewController.turnParticleGreen))
            square.addGestureRecognizer(tapSquare)
            square.isUserInteractionEnabled = true
            
            
            let tapTriangle = UITapGestureRecognizer(target: self, action: #selector(ViewController.turnParticleRed))
            triangle.addGestureRecognizer(tapTriangle)
            triangle.isUserInteractionEnabled = true
            
            
        }
            
            
        else if(output == "choose Triangle"){
            
            
            let tapCircle = UITapGestureRecognizer(target: self, action: #selector(ViewController.turnParticleRed))
            circle.addGestureRecognizer(tapCircle)
            circle.isUserInteractionEnabled = true
            
            let tapSquare = UITapGestureRecognizer(target: self, action: #selector(ViewController.turnParticleRed))
            square.addGestureRecognizer(tapSquare)
            square.isUserInteractionEnabled = true
            
            
            let tapTriangle = UITapGestureRecognizer(target: self, action: #selector(ViewController.turnParticleGreen))
            triangle.addGestureRecognizer(tapTriangle)
            triangle.isUserInteractionEnabled = true
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        // 1. Initialize the SDK
        ParticleCloud.init()
 
        // 2. Login to your account
        ParticleCloud.sharedInstance().login(withUser: self.USERNAME, password: self.PASSWORD) { (error:Error?) -> Void in
            if (error != nil) {
                // Something went wrong!
                print("Wrong credentials or as! ParticleCompletionBlock no internet connectivity, please try again")
                // Print out more detailed information
                print(error?.localizedDescription)
            }
            else {
                print("Login success!")

                // try to get the device
                self.getDeviceFromCloud()

            }
        } // end login
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Get Device from Cloud
    // Gets the device from the Particle Cloud
    // and sets the global device variable
    func getDeviceFromCloud() {
        ParticleCloud.sharedInstance().getDevice(self.DEVICE_ID) { (device:ParticleDevice?, error:Error?) in
            
            if (error != nil) {
                print("Could not get device")
                print(error?.localizedDescription)
                return
            }
            else {
                print("Got photon from cloud: \(device?.id)")
                self.myPhoton = device
                
                // subscribe to events
                self.subscribeToParticleEvents()
            }
            
        } // end getDevice()
    }
    
    
    //MARK: Subscribe to "playerChoice" events on Particle
    func subscribeToParticleEvents() {
        var handler : Any?
        handler = ParticleCloud.sharedInstance().subscribeToDeviceEvents(
            withPrefix: "playerChoice",
            deviceID:self.DEVICE_ID,
            handler: {
                (event :ParticleEvent?, error : Error?) in
            
            if let _ = error {
                print("could not subscribe to events")
            } else {
                print("got event with data \(event?.data)")
                let choice = (event?.data)!
                if (choice == "A") {
                    self.turnParticleGreen()
                    self.gameScore = self.gameScore + 1;
                }
                else if (choice == "B") {
                    self.turnParticleRed()
                }
            }
        })
    }
    
    
    
    @objc func turnParticleGreen() {
        
        print("Pressed the change lights button")
        
        let parameters = ["green"]
        var task = myPhoton!.callFunction("answer", withArguments: parameters) {
            (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("Sent message to Particle to turn green")
                
                
               self.correctOrNot.text = "CORRECT! WELL-DONE"
            }
            else {
                print("Error when telling Particle to turn green")
            }
        }
        //var bytesToReceive : Int64 = task.countOfBytesExpectedToReceive
        
    }
    
    @objc func turnParticleRed() {
        
        print("Pressed the change lights button")
        
        let parameters = ["red"]
        var task = myPhoton!.callFunction("answer", withArguments: parameters) {
            (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("Sent message to Particle to turn red")
                
                self.correctOrNot.text = "Sorry!! try again"
            }
                
            else {
                print("Error when telling Particle to turn red")
            }
        }
        //var bytesToReceive : Int64 = task.countOfBytesExpectedToReceive
        
    }
    
    
    @IBAction func testScoreButtonPressed(_ sender: Any) {
        
        print("score button pressed")
        
        // 1. Show the score in the Phone
        // ------------------------------
        self.scoreLabel.text = "Score:\(self.gameScore)"
        
        // 2. Send score to Particle
        // ------------------------------
        let parameters = [String(self.gameScore)]
        var task = myPhoton!.callFunction("score", withArguments: parameters) {
            (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("Sent message to Particle to show score: \(self.gameScore)")
            }
            else {
                print("Error when telling Particle to show score")
            }
        }
        
        
        
        // 3. done!
        
        
    }
    
}

