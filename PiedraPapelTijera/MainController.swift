//
//  ViewController.swift
//  PiedraPapelTijera
//
//  Created by Gabriel Castañaza on 29/7/15.
//  Copyright (c) 2015 Ministerio de Salud. All rights reserved.
//

import UIKit
import CoreData
import Haneke

class MainController: UIViewController, NSURLConnectionDataDelegate {
    
    let urlUsersJSON = NSURL(string: "http://www.mocky.io/v2/55ba2a4f3b5df2d3022f13eb")
    var usersData = NSMutableData()
    
    var playButton = UIButton()
    
    var round = ""
    
    var lastWinner: Player!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.background
        
        if haveLastWinner(){
            initLastWinner(true)
        }
        
        initPlayButton()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let round: AnyObject = userDefaults.valueForKey("round") {
            
            self.round = round as! String
            if self.round != "" {
            
                self.playButton.setTitle("Continuar Torneo", forState: UIControlState.Normal)
                self.playButton.enabled = true
                
            }else{
                getData()
            }
            
        }
        else {
            getData()
        }
        
    }
    
    func haveLastWinner()->Bool{
        let req = NSFetchRequest(entityName: "Tournament")
        var sortDescriptor = NSSortDescriptor(key: "start", ascending: false)
        req.sortDescriptors = [sortDescriptor]
        req.fetchLimit = 1
        if let results = managedObjectContext!.executeFetchRequest(req, error: nil) as? [Tournament] {
            
            if results.count > 0{
                
                var tournament = results.first!
                
                lastWinner = tournament.winner

                return true
            }
        }
        
        return false
        
    }
    
    
    
    // MARK: - Data

    
    func getData(){
        
        let req = NSFetchRequest(entityName: "Player")
        
        if let results = managedObjectContext!.executeFetchRequest(req, error: nil) as? [Player] {
            
            if results.count == 0{
                getJSON()
            }else{
                
                self.playButton.enabled = true
                
            }
            
        }
        
        
        
    }
    
    func getJSON(){
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var request = NSURLRequest(URL: urlUsersJSON!)
        var connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        connection?.start()
        
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        
        NSLog(error.localizedDescription)
        
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
        usersData.appendData(data)
        
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.playButton.enabled = true
        
        let usersJson = JSON(data: usersData)
        
        
        for (index: String, userJson: JSON) in usersJson["players"] {

            println(userJson["name"])
            
            var player = NSEntityDescription.insertNewObjectForEntityForName("Player",
                inManagedObjectContext: self.managedObjectContext!) as! Player
            
            player.name = userJson["name"].stringValue
            player.gender = userJson["gender"].stringValue
            player.country = userJson["country"].stringValue
            
            let cache = Shared.imageCache
            let URL = NSURL(string: userJson["avatar"].stringValue )!
            let fetcher = NetworkFetcher<UIImage>(URL: URL)
            cache.fetch(URL: URL){ data in
                player.avatar = data.asData()
                
                self.save()
                
            }
            
        }
        
        save()
        
    }
    
    func save() {
        var error : NSError?
        if( !managedObjectContext!.save(&error) ) {
            println(error?.localizedDescription)
        }
    }
    
    // MARK: - UI
    
    func initLastWinner(last: Bool){
        
        // view
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
        view.backgroundColor = UIColor.whiteColor()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSizeMake(0, 10);
        view.layer.shadowRadius = 0;
        view.layer.shadowOpacity = 0.1;
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let viewsC = ["container": view]
        
        self.view.addSubview(view)
        
        self.view.addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("V:|-40-[container(==150)]-|", options: .allZeros, metrics: nil, views: viewsC))
        self.view.addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("H:[container(==200)]", options: .allZeros, metrics: nil, views: viewsC))
        
        self.view.addConstraint(NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.0, constant: 0.0))
        
        //Winner
        var win = LabelPlayer()
        win.text = "¡Ganador!"
        if last{
            win.text = "Ganador Anterior:"
        }
        win.setWin()
        var avatar = AvatarImage()
        avatar.image = UIImage(data: lastWinner.avatar)
        var name = LabelPlayer()
        name.text = lastWinner.name
        name.setBold()
        
        let views = ["avatar":avatar, "name":name, "win":win]
        
        view.addSubview(avatar)
        view.addSubview(name)
        view.addSubview(win)
        
        view.addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("V:|-[win]-[avatar(==60)]-[name]|", options: .allZeros, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("H:[avatar(==60)]", options: .allZeros, metrics: nil, views: views))
        avatar.addCenterConstraint()
        name.addCenterConstraint()
        win.addCenterConstraint()
        
        
        
        
        
    }
    
    func initPlayButton(){
        
        var width = CGFloat(250.0)
        var height = CGFloat(50.0)
        
        self.playButton.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.playButton.setTitle("Descargando Jugadores...", forState: UIControlState.Disabled)
        self.playButton.setTitle("Iniciar Torneo", forState: UIControlState.Normal)
        self.playButton.enabled = false
        self.playButton.addTarget(self, action: "playButtonPress", forControlEvents: UIControlEvents.TouchUpInside)
        self.playButton.addTarget(self, action: "playButtonDown:", forControlEvents: UIControlEvents.TouchDown)
        self.playButton.addTarget(self, action: "playButtonUp:", forControlEvents: UIControlEvents.TouchDragOutside)
        
        
        //add view
        self.view.addSubview(self.playButton)
        
        //Constraints
        self.playButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.playButton,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.0, constant: 0.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.playButton,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1.0, constant: 0.0))
        
        self.playButton.addConstraint(NSLayoutConstraint(item: self.playButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: width))
        
        self.playButton.addConstraint(NSLayoutConstraint(item: self.playButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: height))
        
        // Gradients and Shadow
        self.playButton.layer.cornerRadius = 10
        self.playButton.layer.masksToBounds = false
        self.playButton.layer.shadowOffset = CGSizeMake(0, 10);
        self.playButton.layer.shadowRadius = 0;
        self.playButton.layer.shadowOpacity = 0.2;
        
        var gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.playButton.layer.bounds
        gradientLayer.colors = [Colors.celesteGradientClaro.CGColor, Colors.celesteGradientOscuro.CGColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.cornerRadius = self.playButton.layer.cornerRadius
        self.playButton.layer.addSublayer(gradientLayer)
        
        
        
    }
    
    func pressButton(){
        self.playButton.layer.shadowOffset = CGSizeMake(0, 6);
        self.playButton.bounds = CGRect(x: 0, y: -4, width: self.playButton.bounds.width, height: self.playButton.bounds.height)
    }
    func upButton(){
        self.playButton.layer.shadowOffset = CGSizeMake(0, 10);
        self.playButton.bounds = CGRect(x: 0, y: 0, width: self.playButton.bounds.width, height: self.playButton.bounds.height)
    }
    
    func playButtonDown(sender:UIButton!){
        pressButton()
    }
    func playButtonUp(sender:UIButton!){
        upButton()
    }
    
    func playButtonPress(){
        
        upButton()
        
        
        showMatchesRound(round)
        
        
    }
    
    //MARK: - Nav
    
    func showMatchesRound(round:String){
        
        var matchesController = MatchesController()
        matchesController.round = round
        matchesController.mainController = self
        
        var nav = UINavigationController(rootViewController: matchesController)
        
        self.presentViewController(nav, animated: true, completion: nil)
    }


}

