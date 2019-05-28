//
//  CustomAnimation.swift
//  AnimationChallange1
//
//  Created by Muhammad Tafani Rabbani on 17/05/19.
//  Copyright © 2019 Muhammad Tafani Rabbani. All rights reserved.
//

import UIKit
class CustomAnimation{
    
    func springMovement(view : UIView){
        
        UIView.animate(withDuration: Double.random(in: 1...3), delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [.curveEaseOut,.repeat,.autoreverse], animations: {
            self.changePos(view: view)
            
            self.changeColor(view : view)
        }) { (isFinish) in
            
        }
    }
    func springMovement2(view : UIView){
        
        UIView.animate(withDuration: Double.random(in: 1...3), delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [.curveEaseOut,.repeat,.autoreverse], animations: {
            
            let randomX = Int.random(in: 1...100)
            let randomY = Int.random(in: 1...100)
            view.center = CGPoint(x: randomX, y: randomY)
            
        }) { (isFinish) in
            
        }
    }
    
    func changePos(view : UIView){
        let randomX = Int.random(in: 1...400)
        let randomY = Int.random(in: 1...1000)
        view.center = CGPoint(x: randomX, y: randomY)
    }
    
    func changeColor(view : UIView){
        let red = Double.random(in: 0.5...1)
        let blue = Double.random(in: 0.5...1)
        let yellow = Double.random(in: 0.5...1)
        view.backgroundColor = UIColor.init(red: CGFloat(red), green: CGFloat(yellow), blue: CGFloat(blue), alpha: 1)
    }
    
    func fadeOut(view : UIView){
        UIView.animate(withDuration: Double.random(in: 1...1.5), animations: {
            //scale 2x
            view.transform = CGAffineTransform(scaleX: 2, y: 2)
            // transparant
            view.alpha = 0
        }) { (isFinished) in
        }
    }
    
    func fadeIn(view : UIView){
        UIView.animate(withDuration: Double.random(in: 1...1.5)) {
            // balikin ke size semula
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
            view.alpha = 1
        }
    }
}
