//
//  WalkingVC.swift
//  Final Project App
//
//  Created by Pablo Segovia on 7/24/22.
//

import UIKit
import CoreMotion

class WalkingVC: UIViewController {
    
    var seconds = 3
    var countDownTimer : Timer?
    
    let manager = CMMotionManager()
    var dataMatrix = [[Double]]()
    var dataTimer : Timer?
    
    
    @IBOutlet weak var secondsCounter: UILabel!
    @IBOutlet weak var displayedText: UILabel!
    @IBOutlet weak var helperLabel: UILabel!
    @IBOutlet weak var fullScreenBut: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if Checking.goHome == true{
            self.dismiss(animated: false)
        } else {
            dataMatrix = []
            
//            print(manager.isDeviceMotionAvailable)
            countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)

            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func counter () {
        seconds -= 1
        secondsCounter.text = String(seconds)
        
        if seconds == 0 {
            self.secondsCounter.isHidden = true
            self.displayedText.isHidden = false
            countDownTimer?.invalidate()
            countDownTimer = nil
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.displayedText.text = "Walk!"
                self.helperLabel.isHidden = false
                self.fullScreenBut.isEnabled = true
                self.displayedText.adjustsFontSizeToFitWidth = true
                self.helperLabel.adjustsFontSizeToFitWidth = true
            }
            startGettingData()
        }
    }
    
    func startGettingData() {
        manager.startAccelerometerUpdates()
        manager.startGyroUpdates()
        manager.startDeviceMotionUpdates()
        startTimer()
    }
    
    //Getting Data helpers
    func startTimer () {
        var range = 0
        dataTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            if let accel = self.manager.accelerometerData, let gyro = self.manager.gyroData, let devMotion = self.manager.deviceMotion {
                let t = Double(20 * range)
                let xA = accel.acceleration.x
                let yA = accel.acceleration.y
                let zA = accel.acceleration.z
                let xG = gyro.rotationRate.x
                let yG = gyro.rotationRate.y
                let zG = gyro.rotationRate.z
                let xH = devMotion.attitude.pitch // =X
                let yH = devMotion.attitude.roll // =Y
                let zH = devMotion.attitude.yaw // =Z
//                print("here ", range)
                let compiledData = [t, xA, yA, zA, xG, yG, zG, xH, yH, zH]
                self.dataMatrix.append(compiledData)
                range += 1
            }
        }
    }
    
    func stopTimer () {
        dataTimer?.invalidate()
        dataTimer = nil
    }
    
    //IB Actions
    @IBAction func fullScreenButton(_ sender: UIButton) {
        stopTimer()
        manager.stopAccelerometerUpdates()
        manager.stopGyroUpdates()
        manager.stopDeviceMotionUpdates()
//        for i in 0...(dataMatrix.count-1) {
//            print(dataMatrix[i][5])
//        }
        seconds = 1
//        print(dataMatrix)
        BRUH.BRUH.append(dataMatrix)
        self.performSegue(withIdentifier: "goCam", sender: self)
        
    }
    
}


