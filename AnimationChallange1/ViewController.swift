//
//  ViewController.swift
//  AnimationChallange1
//
//  Created by Muhammad Tafani Rabbani on 14/05/19.
//  Copyright © 2019 Muhammad Tafani Rabbani. All rights reserved.
//

import UIKit
import CoreMotion

struct backgroundTimer {
    static var currentBackgroundDate : NSDate?
}

class ViewController: UIViewController {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var mCircle: UIView!
    
    var listCircle : [UIView] = []
    var tempX : Double = 0.0
    var tempY : Double = 0.0
    var lay : Bool = false
    var motion = CMMotionManager()
    var timer: Timer!
    var seconds : Int = 0
    
    var customAnim = CustomAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view circle
        runTimer()
        mCircle.layer.cornerRadius = mCircle.frame.size.width/2
        mCircle.clipsToBounds = true
        
        //enable tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickView(_:)))
        tapGesture.delegate = self as? UIGestureRecognizerDelegate
        mCircle.addGestureRecognizer(tapGesture)
        
        //makingbuble
        for _ in 0...600{
            createBuble()
        }
        
        for mUI in listCircle{
            view.addSubview(mUI)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(pauseApp(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: Selector(("pauseApp")), name: UIApplication.didEnterBackgroundNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: Selector(("startApp")), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    @objc func pauseApp(_ sender: UIApplication){
        timer.invalidate()//invalidate timer
        backgroundTimer.currentBackgroundDate = NSDate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
      gyro()
    }
    
    func gyro(){
        if motion.isDeviceMotionAvailable{
            motion.deviceMotionUpdateInterval = 0.1
            motion.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, errot) in
                self.handleDeviceMotionUpdate(deviceMotion: data!)
            }
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds <= 600{
            customAnim.fadeOut(view: listCircle[seconds])
            seconds += 1
        }
        
    }
    
    func degrees(radians:Double) -> Double {
        return 180 / .pi * radians
    }
    
    func handleDeviceMotionUpdate(deviceMotion:CMDeviceMotion) {
        let attitude = deviceMotion.attitude
       
        let pitch = degrees(radians: attitude.pitch)
        
        if pitch > 15 {
            lay = false
            print(seconds)
            timer.invalidate()
            if seconds <= 600{
                seconds = 0
                customAnim.fadeIn(view: background)
                customAnim.fadeIn(view: mCircle)
            }else{
                background.image = UIImage(named: "background2")
                mCircle.backgroundColor = .white
                customAnim.fadeIn(view: background)
                customAnim.fadeIn(view: mCircle)
            }
            for mUI in listCircle{
                customAnim.fadeOut(view: mUI)
            }
        }else if pitch < 16{
            print(seconds)
            customAnim.fadeOut(view: background)
            customAnim.fadeOut(view: mCircle)
            if !lay{
                runTimer()
                for mUI in listCircle{
                    if seconds <= 600 {
                        seconds = 0
                        customAnim.fadeIn(view: mUI)
                        customAnim.springMovement(view: mUI)
                    }
                }
                lay = true
            }
            
        }
    }
    
    @objc func clickView(_ sender: UIView) {
        seconds = 0
        
        background.image = UIImage(named: "background")
        mCircle.backgroundColor = .black
        customAnim.fadeOut(view:mCircle)
        customAnim.fadeOut(view:background)
        customAnim.fadeIn(view: background)
        customAnim.fadeIn(view: mCircle)
    }
    
    //
    func createBuble(){
        let randomX = Int.random(in: 1...400)
        let randomY = Int.random(in: 1...1000)
        let myNewView=UIView(frame: CGRect(x: randomX, y: randomY, width: 30, height: 30))
        // Change UIView background colour
        customAnim.changeColor(view: myNewView)
        // Add rounded corners to UIView
        myNewView.layer.cornerRadius=myNewView.frame.size.width/2
        myNewView.clipsToBounds = true
        
        // Add UIView as a Subview
        self.listCircle.append(myNewView)
    }
    
    
}
