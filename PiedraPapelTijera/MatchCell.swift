//
//  MatchCell.swift
//  PiedraPapelTijera
//
//  Created by Gabriel Castañaza on 30/7/15.
//  Copyright (c) 2015 Ministerio de Salud. All rights reserved.
//

import UIKit

class MatchCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    static let hSpace = 10.0
    
    var avatarA: AvatarImage!
    var avatarB: AvatarImage!
    
    var moveA: MoveImage!
    var moveB: MoveImage!
    
    var nameA:LabelPlayer!
    var nameB:LabelPlayer!
    var genderA:LabelPlayer!
    var genderB:LabelPlayer!
    var countryA:LabelPlayer!
    var countryB:LabelPlayer!
    var winA:LabelPlayer!
    var winB:LabelPlayer!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Cell size and clearColor
        frame = CGRect(origin: CGPointZero, size: CGSize(width: frame.size.width, height: 300))
        self.backgroundColor = UIColor.clearColor()
        self.backgroundView?.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        selectionStyle = UITableViewCellSelectionStyle.None
        
        // vs view
        var vsView = UIView(frame: CGRect(x: 10, y: 10, width: frame.width-20, height: 220))
        vsView.backgroundColor = UIColor.whiteColor()
        vsView.layer.cornerRadius = 10
        vsView.layer.masksToBounds = false
        vsView.layer.shadowOffset = CGSizeMake(0, 10);
        vsView.layer.shadowRadius = 0;
        vsView.layer.shadowOpacity = 0.1;
        
        // move view
        var moveView = UIView(frame: CGRect(x: 20, y: 20, width: frame.width-40, height: 280))
        moveView.backgroundColor = Colors.moveBack
        moveView.layer.cornerRadius = 10
        moveView.layer.masksToBounds = false
        moveView.layer.shadowOffset = CGSizeMake(0, 10);
        moveView.layer.shadowRadius = 0;
        moveView.layer.shadowOpacity = 0.1;
        
        //players Views
        var playerAView = UIView(frame: CGRect(x: 10, y: 10, width: (frame.width-20)/2, height: frame.height-0))
        
        var playerBView = UIView(frame: CGRect(x: (frame.width-20)/2, y: 10, width: (frame.width-20)/2, height: frame.height-0))
        
        //Player A
        avatarA = AvatarImage()
        nameA = LabelPlayer()
        nameA.setBold()
        genderA = LabelPlayer()
        countryA = LabelPlayer()
        winA = LabelPlayer()
        winA.setWin()
        moveA = MoveImage()
        
        let viewsA = ["avatar":avatarA, "name":nameA, "gender":genderA, "country":countryA, "win":winA, "move":moveA]
        
        playerAView.addSubview(avatarA)
        playerAView.addSubview(nameA)
        playerAView.addSubview(genderA)
        playerAView.addSubview(countryA)
        playerAView.addSubview(winA)
        playerAView.addSubview(moveA)
        
        playerAView.addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("V:|-[avatar(==60)]-[name]-[gender]-[country]-[win]-[move(==100)]|", options: .allZeros, metrics: nil, views: viewsA))
        playerAView.addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("H:[avatar(==60)]", options: .allZeros, metrics: nil, views: viewsA))
        playerAView.addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("H:[move(==100)]", options: .allZeros, metrics: nil, views: viewsA))
        avatarA.addCenterConstraint()
        nameA.addCenterConstraint()
        genderA.addCenterConstraint()
        countryA.addCenterConstraint()
        winA.addCenterConstraint()
        moveA.addCenterConstraint()
        
        //player B
        avatarB = AvatarImage()
        nameB = LabelPlayer()
        nameB.setBold()
        genderB = LabelPlayer()
        countryB = LabelPlayer()
        winB = LabelPlayer()
        winB.setWin()
        moveB = MoveImage()
        
        let viewsB = ["avatar":avatarB, "name":nameB, "gender":genderB, "country":countryB, "win":winB, "move":moveB]
        
        playerBView.addSubview(avatarB)
        playerBView.addSubview(nameB)
        playerBView.addSubview(genderB)
        playerBView.addSubview(countryB)
        playerBView.addSubview(winB)
        playerBView.addSubview(moveB)
        
        playerBView.addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("V:|-[avatar(==60)]-[name]-[gender]-[country]-[win]-[move(==100)]|", options: .allZeros, metrics: nil, views: viewsB))
        playerBView.addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("H:[avatar(==60)]", options: .allZeros, metrics: nil, views: viewsB))
        playerAView.addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("H:[move(==100)]", options: .allZeros, metrics: nil, views: viewsA))
        avatarB.addCenterConstraint()
        nameB.addCenterConstraint()
        genderB.addCenterConstraint()
        countryB.addCenterConstraint()
        winB.addCenterConstraint()
        moveB.addCenterConstraint()
        
        // adding Subviews
        
//        playerBView.addSubview(avatarB)
        
        

        addSubview(moveView)
        addSubview(vsView)
        
        addSubview(playerBView)
        addSubview(playerAView)
        
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class LabelPlayer: UILabel {
    
    static let height = CGFloat(30.0)
    
    init(){

        super.init(frame: CGRect(
            x: 0.0,
            y: 0.0,
            width: 0,
            height: LabelPlayer.height)
        )
        
        textAlignment = NSTextAlignment.Center
        
        setTranslatesAutoresizingMaskIntoConstraints(false)
        font = font.fontWithSize(19)
        textColor = Colors.textColor
    }
    
    func setBold(){
        
        font = UIFont.boldSystemFontOfSize(19)
        
    }
    
    func setWin(){
        font = UIFont(name: "MarkerFelt-Wide", size: 23)
    }
    
    func winColor(){
        textColor = Colors.textWin
    }
    func loseColor(){
        textColor = Colors.textLose
    }
    
    func addCenterConstraint(){
        superview!.addConstraint(NSLayoutConstraint(item: self,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: superview,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.0, constant: 0.0))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MoveImage: UIImageView {
    
    static let width = 100.0
    static let height = 100.0
    
    init(){
        super.init(frame: CGRect(
            x: 0,
            y: 0,
            width: AvatarImage.width,
            height: AvatarImage.height)
        )
        
        contentMode = UIViewContentMode.Center
        setTranslatesAutoresizingMaskIntoConstraints(false)
        
    }
    
    func animAppear(){
        
        
        transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        alpha = 0.0
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
            self.alpha = 1.0
            
        })
        
    }
    
    func addCenterConstraint(){
        superview!.addConstraint(NSLayoutConstraint(item: self,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: superview,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.0, constant: 0.0))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AvatarImage: UIImageView {
    
    static let width = 60.0
    static let height = 60.0
    
    init(){
        super.init(frame: CGRect(
            x: 0,
            y: 0,
            width: AvatarImage.width,
            height: AvatarImage.height)
        )
        
        backgroundColor = UIColor.grayColor()
        layer.cornerRadius = CGFloat(AvatarImage.width/2)
        contentMode = UIViewContentMode.ScaleAspectFill
        layer.masksToBounds = true
        
        setTranslatesAutoresizingMaskIntoConstraints(false)

    }
    
    func addCenterConstraint(){
        superview!.addConstraint(NSLayoutConstraint(item: self,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: superview,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.0, constant: 0.0))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
