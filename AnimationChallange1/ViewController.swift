//
//  ViewController.swift
//  AnimationChallange1
//
//  Created by Muhammad Tafani Rabbani on 14/05/19.
//  Copyright © 2019 Muhammad Tafani Rabbani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var efSelection: UISegmentedControl!
    @IBOutlet weak var mCircle: UIView!
    var listCircle : [UIView] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //view circle
        
        mCircle.layer.cornerRadius = mCircle.frame.size.width/2
        mCircle.clipsToBounds = true
        //enable tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickView(_:)))
        tapGesture.delegate = self as? UIGestureRecognizerDelegate
        mCircle.addGestureRecognizer(tapGesture)
//        for mUI in listCircle{
//            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [.repeat,.autoreverse], animations: {
//                let mX = Int.random(in: 1...400)
//                let mY = Int.random(in: 1...1000)
//                mUI.center = CGPoint(x: mX, y: mY)
//            }) { (Bool) in
//
//            }
//            view.addSubview(mUI)
//        }
    }
   
    @objc func clickView(_ sender: UIView) {
        let sel = efSelection.selectedSegmentIndex
        // chosing animation
        if sel == 0{
            fadeOut()
        }else if sel == 1 {
            springMovement()
        }
    }
    
    func createBuble(){
        let randomX = Int.random(in: 1...400)
        let randomY = Int.random(in: 1...1000)
        let myNewView=UIView(frame: CGRect(x: randomX, y: randomY, width: 30, height: 30))
        // Change UIView background colour
        let red = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        let yellow = Double.random(in: 0...1)
        myNewView.backgroundColor = UIColor.init(red: CGFloat(red), green: CGFloat(yellow), blue: CGFloat(blue), alpha: 1)
        // Add rounded corners to UIView
        myNewView.layer.cornerRadius=myNewView.frame.size.width/2
        myNewView.clipsToBounds = true
        
        // Add UIView as a Subview
        self.listCircle.append(myNewView)
    }
    
    func springMovement(){
       
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.changePos()
            
            self.changeColor()
        }) { (isFinish) in
            
        }
    }
    
    func changePos(){
        let randomX = Int.random(in: 1...300)
        let randomY = Int.random(in: 1...800)
        mCircle.center = CGPoint(x: randomX, y: randomY)
    }
    func changeColor(){
        let red = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        let yellow = Double.random(in: 0...1)
        mCircle.backgroundColor = UIColor.init(red: CGFloat(red), green: CGFloat(yellow), blue: CGFloat(blue), alpha: 1)
    }
    func fadeOut(){
        UIView.animate(withDuration: 0.5, animations: {
            //scale 2x
            self.mCircle.transform = CGAffineTransform(scaleX: 2, y: 2)
            // transparant
            self.mCircle.alpha = 0
        }) { (isFinished) in
            self.changePos()
            
            self.fadeIn()
        }
    }
    func fadeIn(){
        UIView.animate(withDuration: 0.5) {
            // balikin ke size semula
            self.mCircle.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.changeColor()
            self.mCircle.alpha = 1
        }
    }
    
}

