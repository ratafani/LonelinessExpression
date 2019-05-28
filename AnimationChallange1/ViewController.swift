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

    @IBOutlet weak var secondLayer: UIView!
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var mCircle: UIView!
    
    var listCircle : [UIView] = []
    var listCircle2 : [UIView] = []
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
        restartView()
        mCircle.layer.cornerRadius = mCircle.frame.size.width/2
        mCircle.clipsToBounds = true
        
        //enable tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickView(_:)))
        tapGesture.delegate = self as? UIGestureRecognizerDelegate
        mCircle.addGestureRecognizer(tapGesture)
        
        
        //makingbuble
        for _ in 0...600{
            createBuble()
            createBuble2()
        }
        
        for mUI in listCircle{
            view.addSubview(mUI)
        }
        for mUI in listCircle2{
            secondLayer.addSubview(mUI)
            customAnim.fadeIn(view: mUI)
            customAnim.springMovement(view: mUI)
        }
        
        secondLayer.frame = CGRect(x: 10, y: 10, width: 200, height: 200)
        secondLayer.layer.cornerRadius = 100
        secondLayer.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(pauseApp(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
    }
    
    @objc func pauseApp(_ sender: UIApplication){
        timer.invalidate()//invalidate timer
        backgroundTimer.currentBackgroundDate = NSDate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gyro()

        let tap = UITapGestureRecognizer(target: self, action: #selector(showMoreActions(_:)))
        tap.numberOfTapsRequired = 1
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(showMoreActions(_:)))
        tap.numberOfTapsRequired = 1
//        pan.maximumNumberOfTouches = 1
        view.addGestureRecognizer(tap)
//        view.addGestureRecognizer(pan)
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
//            print(seconds)
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
//            print(seconds)
            customAnim.fadeOut(view: background)
            customAnim.fadeOut(view: mCircle)
            if !lay{
                runTimer()
                secondLayerDismiss()
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
       restartView()
    }
    
    func restartView(){
        seconds = 0
        
        background.image = UIImage(named: "background")
        mCircle.backgroundColor = .black
        customAnim.fadeOut(view:mCircle)
        customAnim.fadeOut(view:background)
        customAnim.fadeIn(view: background)
        customAnim.fadeIn(view: mCircle)
    }
    
     @objc func showMoreActions(_ touch: UITapGestureRecognizer) {
        
        let touchPoint = touch.location(in: self.view)
//        print(touchPoint)
        if(!lay && seconds <= 600){
           if secondLayer.isHidden{
                secondLayer.isHidden = false
                //blur effect
                let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.tag = 101
                blurEffectView.frame = background.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                background.addSubview(blurEffectView)
                
                secondLayer.center = CGPoint.init(x: touchPoint.x, y: touchPoint.y)
                let mx = self.secondLayer.frame.minX
                let my = self.secondLayer.frame.minY
                self.secondLayer.frame = CGRect(x: self.secondLayer.frame.minX, y: self.secondLayer.frame.minY, width: 10, height: 10)
                //            secondLayer.layer.cornerRadius = 5
                UIView.animate(withDuration: 0.3) {
                    self.secondLayer.frame = CGRect(x: mx, y: my, width: 200, height: 200)
                    self.secondLayer.layer.cornerRadius = 100
                }
                
            } else{
                secondLayerDismiss()
            }
        }
        
    }
    
    func secondLayerDismiss(){
        if let viewWithTag = self.background.viewWithTag(101) {
            viewWithTag.removeFromSuperview()
        }else{
//            print("No!")
        }
        
        let mx = self.secondLayer.frame.minX
        let my = self.secondLayer.frame.minY
        UIView.animate(withDuration: 0.3, animations: {
            self.secondLayer.frame = CGRect(x: mx, y: my, width: 2, height: 2)
            self.secondLayer.layer.cornerRadius = 1
        }) { (finished) in
            self.secondLayer.frame = CGRect(x: mx, y: my, width: 200, height: 200)
            self.secondLayer.layer.cornerRadius = 100
            self.secondLayer.isHidden = true
        }
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
    
    func createBuble2(){
        let randomX = Int.random(in: 1...400)
        let randomY = Int.random(in: 1...1000)
        let myNewView=UIView(frame: CGRect(x: randomX, y: randomY, width: 30, height: 30))
        // Change UIView background colour
        customAnim.changeColor(view: myNewView)
        // Add rounded corners to UIView
        myNewView.layer.cornerRadius=myNewView.frame.size.width/2
        myNewView.clipsToBounds = true
        
        // Add UIView as a Subview
        self.listCircle2.append(myNewView)
    }
    
}
