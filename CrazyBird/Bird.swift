//
//  Bird.swift
//  CrazyBird
//
//  Created by Thomas Mac on 03/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class Bird: NSObject {

    internal let imageView = UIImageView()
    
    private var timer = NSTimer()
    
    private var gameViewController = UIViewController()
    
    internal func initBirdInGameViewController(gameViewController: GameViewController)
    {
        self.gameViewController = gameViewController
        
        self.imageView.frame = CGRectMake(50.0, (self.gameViewController.view.frame.size.height - 50.0) / 2, 50.0, 50.0)
        
        self.imageView.image = UIImage(named:NSLocalizedString("BIRD", comment:""))
        
        self.imageView.hidden = false
        
        self.gameViewController.view.addSubview(self.imageView)
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target:self, selector:#selector(self.move), userInfo:nil, repeats:true)
    }
    
    @objc private func move()
    {
        if ((self.gameViewController as! GameViewController).accelerometre.accelerometerData?.acceleration.y == nil)
        {
            return
        }
        let newY = self.imageView.frame.origin.y + CGFloat(((self.gameViewController as! GameViewController).accelerometre.accelerometerData?.acceleration.y)! * 5)
        
        if (newY >= 0 && newY + self.imageView.frame.size.height <= self.gameViewController.view.frame.size.height)
        {
            self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, newY, self.imageView.frame.size.width, self.imageView.frame.size.height)
        }
        
        var i = 0
        while (i < (self.gameViewController as! GameViewController).obstaclesArray.count)
        {
            if (self.isCollisionWithObstacle((self.gameViewController as! GameViewController).obstaclesArray[i] as! Obstacle))
            {
                (self.gameViewController as! GameViewController).endOfGame()
            }
            i += 1
        }
    }
    
    private func isCollisionWithObstacle(obstacle: Obstacle) -> Bool
    {
        let marge = CGFloat(10.0)
        if (self.imageView.frame.origin.x + marge > obstacle.imageViewHaut.frame.origin.x && self.imageView.frame.origin.x + marge < obstacle.imageViewHaut.frame.origin.x + obstacle.imageViewHaut.frame.size.width && self.imageView.frame.origin.y + marge < obstacle.imageViewHaut.frame.origin.y + obstacle.imageViewHaut.frame.size.height)
        {
            return true
        }
        if (self.imageView.frame.origin.x + self.imageView.frame.size.width - marge > obstacle.imageViewHaut.frame.origin.x && self.imageView.frame.origin.x + self.imageView.frame.size.width - marge < obstacle.imageViewHaut.frame.origin.x + obstacle.imageViewHaut.frame.size.width && self.imageView.frame.origin.y + marge < obstacle.imageViewHaut.frame.origin.y + obstacle.imageViewHaut.frame.size.height)
        {
            return true
        }
        if (self.imageView.frame.origin.x + marge > obstacle.imageViewBas.frame.origin.x && self.imageView.frame.origin.x + marge < obstacle.imageViewBas.frame.origin.x + obstacle.imageViewBas.frame.size.width && self.imageView.frame.origin.y + self.imageView.frame.size.height - marge > obstacle.imageViewBas.frame.origin.y)
        {
            return true
        }
        if (self.imageView.frame.origin.x + self.imageView.frame.size.width - marge > obstacle.imageViewBas.frame.origin.x && self.imageView.frame.origin.x + self.imageView.frame.size.width - marge < obstacle.imageViewBas.frame.origin.x + obstacle.imageViewBas.frame.size.width && self.imageView.frame.origin.y + self.imageView.frame.size.height - marge > obstacle.imageViewBas.frame.origin.y)
        {
            return true
        }
        return false
    }
    
    internal func stopAnimation()
    {
        self.timer.invalidate()
    }
    
}
