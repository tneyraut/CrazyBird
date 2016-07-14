//
//  Obstacle.swift
//  CrazyBird
//
//  Created by Thomas Mac on 03/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class Obstacle: NSObject {

    internal let imageViewHaut = UIImageView()
    
    internal let imageViewBas = UIImageView()
    
    private var timer = NSTimer()
    
    private var gameViewController = GameViewController()
    
    private var birdHeight = CGFloat(0)
    
    private var maxCoeff = 0
    
    internal func initObstacleInGameViewController(gameViewController: GameViewController, x: CGFloat, width: CGFloat, birdHeight: CGFloat, maxCoeff: Int)
    {
        self.birdHeight = birdHeight
        
        self.maxCoeff = maxCoeff
        
        let decalage = CGFloat(self.getDecalage())
        
        let space = CGFloat(20.0)
        
        self.gameViewController = gameViewController
        
        self.imageViewHaut.frame = CGRectMake(x, 0.0, width, (self.gameViewController.view.frame.size.height - self.birdHeight - space) / 2 + decalage)
        
        self.imageViewHaut.image = UIImage(named:NSLocalizedString("OBSTACLE_HAUT", comment:""))
        
        self.imageViewHaut.hidden = false
        
        self.imageViewBas.frame = CGRectMake(x, self.imageViewHaut.frame.origin.y + self.imageViewHaut.frame.size.height + self.birdHeight + space, width, self.gameViewController.view.frame.size.height - self.imageViewHaut.frame.origin.y - self.imageViewHaut.frame.size.height - self.birdHeight - space)
        
        self.imageViewBas.image = UIImage(named:NSLocalizedString("OBSTACLE_BAS", comment:""))
        
        self.imageViewBas.hidden = false
        
        self.gameViewController.view.addSubview(self.imageViewHaut)
        
        self.gameViewController.view.addSubview(self.imageViewBas)
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target:self, selector:#selector(self.move), userInfo:nil, repeats:true)
    }
    
    private func getDecalage() -> Int
    {
        let coeff = Int(arc4random_uniform(3))
        let signe = arc4random_uniform(2)
        
        if (signe == 1)
        {
            return coeff * 50
        }
        else
        {
            return -1 * coeff * 50
        }
    }
    
    @objc private func move()
    {
        self.imageViewHaut.frame = CGRectMake(self.imageViewHaut.frame.origin.x - 1, self.imageViewHaut.frame.origin.y, self.imageViewHaut.frame.size.width, self.imageViewHaut.frame.size.height)
        
        self.imageViewBas.frame = CGRectMake(self.imageViewBas.frame.origin.x - 1, self.imageViewBas.frame.origin.y, self.imageViewBas.frame.size.width, self.imageViewBas.frame.size.height)
        
        if (self.imageViewHaut.frame.origin.x + self.imageViewHaut.frame.size.width < 0)
        {
            self.gameViewController.obstaclePasse()
            
            let newX = self.getNextX()
            let decalage = CGFloat(self.getDecalage())
            let space = CGFloat(20.0)
            
            self.imageViewHaut.frame = CGRectMake(newX, self.imageViewHaut.frame.origin.y, self.imageViewHaut.frame.size.width, (self.gameViewController.view.frame.size.height - birdHeight - space) / 2 + decalage)
            
            self.imageViewBas.frame = CGRectMake(newX, self.imageViewHaut.frame.origin.y + self.imageViewHaut.frame.size.height + self.birdHeight + space, self.imageViewBas.frame.size.width, self.gameViewController.view.frame.size.height - self.imageViewHaut.frame.origin.y - self.imageViewHaut.frame.size.height - self.birdHeight - space)
        }
    }
    
    private func getNextX() -> CGFloat
    {
        var i = 0
        var resultat = CGFloat(0)
        let space = CGFloat(200.0)
        while (i < self.gameViewController.obstaclesArray.count)
        {
            let obstacle = self.gameViewController.obstaclesArray[i] as! Obstacle
            if (obstacle.imageViewHaut.frame.origin.x + obstacle.imageViewHaut.frame.size.width + space > resultat)
            {
                resultat = obstacle.imageViewHaut.frame.origin.x + obstacle.imageViewHaut.frame.size.width + space
            }
            
            i += 1
        }
        if (resultat < self.gameViewController.view.frame.size.width)
        {
            resultat = self.gameViewController.view.frame.size.width
        }
        return resultat
    }
    
    internal func stopAnimation()
    {
        self.timer.invalidate()
    }
    
}
