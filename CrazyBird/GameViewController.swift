//
//  GameViewController.swift
//  CrazyBird
//
//  Created by Thomas Mac on 03/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

class GameViewController: UIViewController {

    internal var accueilTableViewController = AccueilTableViewController()
    
    private var score = 0
    
    internal let accelerometre = CMMotionManager()
    
    private let location = CLLocationManager()
    
    private let bird = Bird()
    
    internal let obstaclesArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage:UIImage(named:NSLocalizedString("BACKGROUND_IMAGE_" + String(self.accueilTableViewController.backgroundImageNumber), comment:""))!)
        
        self.location.delegate = nil
        self.location.headingFilter = kCLHeadingFilterNone
        self.location.distanceFilter = kCLHeadingFilterNone
        self.location.desiredAccuracy = kCLLocationAccuracyBest
        
        self.accelerometre.accelerometerUpdateInterval = 0.1
        
        self.accelerometre.startAccelerometerUpdates()
        
        self.setObstaclesArray()
        
        self.bird.initBirdInGameViewController(self)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated:true)
        
        self.navigationController?.setToolbarHidden(true, animated:true)
        
        super.viewDidAppear(animated)
    }
    
    private func setObstaclesArray()
    {
        var i = self.view.frame.width
        let obstacleWidth = CGFloat(50.0)
        let space = CGFloat(200)
        let maxCoeff = self.getMaxCoeff()
        while (i > space)
        {
            let obstacle = Obstacle()
            obstacle.initObstacleInGameViewController(self, x:self.view.frame.size.width + CGFloat(self.obstaclesArray.count) * (obstacleWidth + space), width:obstacleWidth, birdHeight:50.0, maxCoeff:maxCoeff)
            
            self.obstaclesArray.addObject(obstacle)
            
            i -= space
        }
        if (self.obstaclesArray.count == 0)
        {
            let obstacle = Obstacle()
            obstacle.initObstacleInGameViewController(self, x:self.view.frame.size.width, width:obstacleWidth, birdHeight:50.0, maxCoeff:maxCoeff)
            
            self.obstaclesArray.addObject(obstacle)
        }
    }
    
    private func getMaxCoeff() -> Int
    {
        var resultat = 1
        var i = self.view.frame.size.height
        while (i > 50)
        {
            i -= 50
            resultat += 1
        }
        return resultat
    }
    
    internal func obstaclePasse()
    {
        self.score += 1
    }
    
    internal func endOfGame()
    {
        self.bird.stopAnimation()
        var i = 0
        while (i < self.obstaclesArray.count)
        {
            let obstacle = self.obstaclesArray[i] as! Obstacle
            
            obstacle.stopAnimation()
            
            i += 1
        }
        self.accueilTableViewController.gameFinish(self.score)
        
        let alertController = UIAlertController(title:"Fin de la partie", message:"Vous avez perdu ! Vous avez marqué " + String(self.score) + " points.", preferredStyle:.Alert)
        let alertAction = UIAlertAction(title:"OK", style:.Default) { (_) in self.navigationController?.popViewControllerAnimated(true) }
        alertController.addAction(alertAction)
        
        self.presentViewController(alertController, animated:true, completion:nil)
    }

}
