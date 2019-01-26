//
//  GameScene.swift
//  Dots
//
//  Created by Bjarte Sjursen on 29.07.2016.
//  Copyright (c) 2016 Sjursen Software. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var parentViewController : GameViewController!
    var playerDot : PlayerDot!
    var gyroscopeManager : GyroscopeManager!
    var stayPaused = false
    var activeGame = false
    var speechBubble : SKSpriteNode!
    var speechBubbleScoreLabel : SKLabelNode!
    var speechBubbleUsernameLabel : SKLabelNode!
    
    var gameplayTimer : GameplayTimer {
        get {
            if parentViewController.gameplayTimer != nil {
                return parentViewController.gameplayTimer!
            }
            else {
                fatalError("Gameplaytimer were nil when trying to use it")
            }
        }
        set {
            self.gameplayTimer = newValue
        }
        
    }
    
    override var isPaused: Bool {
        get {
            return super.isPaused
        }
        set {
            if (!stayPaused) {
                super.isPaused = newValue
            }
            stayPaused = false
        }
    }
    
    func setStayPaused() {
        if (super.isPaused) {
            self.stayPaused = true
        }
    }

    
    override func didMove(to view: SKView) {
        
        setupScene()
        playerDot = PlayerDot(x: view.bounds.midY, y: view.bounds.midX)
        addChild(playerDot)
        gyroscopeManager = GyroscopeManager(playerDot: playerDot)
        addSpeechBubble()
        
    }
    
    fileprivate func setupScene(){
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self
        self.physicsBody?.restitution = 0.0
        self.scene!.backgroundColor = gameSceneBackgroundColor
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    func timerInvocationHandler(){
        
        gameplayTimer.timerInvocationHandler()
        
        if gameplayTimer.counter.truncatingRemainder(dividingBy: 5) == 0 || gameplayTimer.counter == 1 {
            let randomX = CGFloat(arc4random_uniform(UInt32(self.frame.size.width)))
            let randomY = CGFloat(arc4random_uniform(UInt32(self.frame.size.height)))
            addDot(randomX, y: randomY)
        }
        
    }
    
    func addDot(_ x : CGFloat, y : CGFloat){
        
        //First add a dotTarget to give the player a warning
        let dotTarget = DotTarget(x: x, y: y)
        addChild(dotTarget)
        
        dotTarget.fadeOutAndScale({

            let dot = Dot(x: x, y: y)
            self.addChild(dot)
            dot.applyImpulse(10, dy: 10)
            dotTarget.removeFromParent()
            
        })
        
        
    }
    
    
    //This is the code used for boarding the player
    
    func addSpeechBubble(){
        
        let thread = DispatchQueue(label: "addSpeechBubble", attributes: [])
        
        thread.async(execute: {
            
            self.speechBubble = SKSpriteNode(imageNamed: "speech")
            self.speechBubble.anchorPoint = CGPoint(x: 0.84, y: 0.22)
            
            self.speechBubbleUsernameLabel = SKLabelNode(text: "")
            self.speechBubbleUsernameLabel.fontColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.9)
            self.speechBubbleUsernameLabel.fontName = "Helvetica-bold"
            self.speechBubbleUsernameLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            self.speechBubbleUsernameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            self.speechBubbleUsernameLabel.fontSize = 40
            self.speechBubble.addChild(self.speechBubbleUsernameLabel)
            self.speechBubbleUsernameLabel.zPosition = 12
            self.speechBubbleUsernameLabel.position.x -= 350
            self.speechBubbleUsernameLabel.position.y += 300
            
            
            self.speechBubbleScoreLabel = SKLabelNode(text: "")
            self.speechBubbleScoreLabel.fontColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.9)
            self.speechBubbleScoreLabel.fontName = "Helvetica-bold"
            self.speechBubbleScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            self.speechBubbleScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            self.speechBubbleScoreLabel.fontSize = 40
            self.speechBubble.addChild(self.speechBubbleScoreLabel)
            self.speechBubbleScoreLabel.zPosition = 12
            self.speechBubbleScoreLabel.position.x -= 350
            self.speechBubbleScoreLabel.position.y += 200
            
            
            
            self.speechBubble.setScale(0.6)
            
            //This code is added for performance reasons, so it won't take too long when loading the speech bubble in game
            self.addChild(self.speechBubble)
            self.perform(#selector(self.removeSpeechBubble), with: nil, afterDelay: 1)

        
        })

        
    }
    
    func scene1(){
        //Present text 1
        speechBubble.removeFromParent()
        playerDot.addChild(speechBubble)
        speechBubbleUsernameLabel.text = "Welcome to Dots"
        speechBubble.run(SKAction.fadeIn(withDuration: 0.5))
        
    }
    
    func scene2(){
        //Present text 2
        speechBubble.run(SKAction.fadeOut(withDuration: 0.5), completion: {
            
            self.speechBubbleUsernameLabel.text = "Make me stay on the screen"
            self.speechBubbleScoreLabel.text = "for as long as possible"
            self.speechBubble.run(SKAction.fadeIn(withDuration: 0.5))
            
        })
    }
    
    func scene3(){
        //Present text 3
        //Move player back to mid screen
        
        //Present text 2
        speechBubble.run(SKAction.fadeOut(withDuration: 0.5), completion: {
            
            self.speechBubbleUsernameLabel.text = "You tilt the phone"
            self.speechBubbleScoreLabel.text = "to make me move"
            self.speechBubble.run(SKAction.fadeIn(withDuration: 0.5))
            self.playerDot.physicsBody!.isDynamic = true
            
        })
        
        
    }
    
    func scene4(){
        //Present text 4
        
        playerDot.moveTo(frame.midX, y: frame.midY - 100, duration: 0.5, completionHandler: {
            self.playerDot.resetPhysics()
            self.playerDot.physicsBody?.isDynamic = false
            
            self.speechBubble.run(SKAction.fadeOut(withDuration: 0.5), completion: {
                
                self.speechBubbleUsernameLabel.text = "There’s 2 things"
                self.speechBubbleScoreLabel.text = ""
                self.speechBubble.run(SKAction.fadeIn(withDuration: 0.5))
                
            })
            
        })
        
    }
    
    func scene5(){
        //Present text 5
        
        speechBubble.run(SKAction.fadeOut(withDuration: 0.5), completion: {
            self.speechBubbleUsernameLabel.text = "Avoid the dots.."
            self.speechBubble.run(SKAction.fadeIn(withDuration: 0.5))
        })
        
    }
    
    func scene6(){
        //Present text 6
        
        speechBubble.run(SKAction.fadeOut(withDuration: 0.5), completion: {
            self.speechBubbleUsernameLabel.text = "And avoid the"
            self.speechBubbleScoreLabel.text = "borders of the screen"
            self.speechBubble.run(SKAction.fadeIn(withDuration: 0.5))
        })
        
    }
    
    func scene7(){
        //Present text 7
        //Reset UI
        
        speechBubble.run(SKAction.fadeOut(withDuration: 0.5), completion: {
            self.speechBubbleUsernameLabel.text = "Good luck!"
            self.speechBubbleScoreLabel.text = ""
            self.speechBubble.run(SKAction.fadeIn(withDuration: 0.5))
            self.parentViewController.okButton.titleLabel?.adjustsFontSizeToFitWidth = true
        })

        
    }
    
    func scene8(){
        
        speechBubble.run(SKAction.fadeOut(withDuration: 0.5), completion: {
            self.speechBubbleUsernameLabel.text = "PS: for max control hold"
            self.speechBubbleScoreLabel.text = "the phone horizontal at start"
            self.speechBubble.run(SKAction.fadeIn(withDuration: 0.5))
            self.parentViewController.okButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.parentViewController.okButton.setTitle("▶︎", for: UIControlState())
        })
        
    }
    
    func removeSpeechBubble(){
        speechBubble.removeFromParent()
    }
    
    func boardPlayer(_ scene : Int){
        
        switch scene {
            case 1:
                parentViewController.okButton.isHidden = false
                parentViewController.gamePlayTimerButton.isHidden = true
                parentViewController.pauseButton.isHidden = true
                playerDot.physicsBody?.isDynamic = false
                playerDot.moveTo(frame.midX, y: frame.midY - 100, duration: 0.5, completionHandler: {})
                scene1()
                break
            case 2:
                scene2()
                break
            case 3:
                scene3()
                break
            case 4:
                scene4()
                break
            case 5:
                scene5()
                break
            case 6:
                scene6()
                break
            case 7:
                scene7()
                break
            case 8:
                scene8()
                break
            case 9:
                startGame()
                parentViewController.okButton.isHidden = true
                parentViewController.gamePlayTimerButton.isHidden = false
                parentViewController.pauseButton.isHidden = false
                speechBubble.removeFromParent()
                playerDot.physicsBody?.isDynamic = true
            break
            default:
                break
        }
        
    }
    
    //Change game state functions
    func startGame(){
        
        isPaused = false
        
        var nrTimesPlayed = UserDefaults.standard.integer(forKey: numberOfTimesPlayedString)
    
        self.playerDot.enableCollisionDetection()
        
        if !activeGame {
            
            parentViewController.gameplayTimer.stop()
            
            playerDot.moveTo(frame.midX, y: frame.midY, duration: 0.5, completionHandler: {
                
                if nrTimesPlayed == 0 {
                    self.boardPlayer(1)
                    nrTimesPlayed += 1
                    UserDefaults.standard.set(nrTimesPlayed, forKey: numberOfTimesPlayedString)
                    UserDefaults.standard.synchronize()
                }
                else {
                    self.parentViewController.gameplayTimer.resume()
                    self.playerDot.resetPhysics()
                    self.activeGame = true
                    nrTimesPlayed += 1
                    UserDefaults.standard.set(nrTimesPlayed, forKey: numberOfTimesPlayedString)
                    UserDefaults.standard.synchronize()
                }
            })
            
        } else {
            self.parentViewController.gameplayTimer.resume()
        }
        
        
        
    }
    
    func removeDots(){
        
        for child in self.children {
            if child != playerDot {
                
                child.physicsBody?.collisionBitMask = 0
                child.physicsBody?.contactTestBitMask = 0
                child.physicsBody?.categoryBitMask = 0
                child.physicsBody?.isDynamic = false
                child.removeAllActions()
                child.run(SKAction.fadeOut(withDuration: 0.5), completion: {child.removeFromParent()})
                
            }
        }

        
    }
    
    func stopGame(){
        
        for child in self.children {
            if child != playerDot {
                child.removeFromParent()
            }
        }

        playerDot.physicsBody?.isDynamic = true
        
        activeGame = false
        isPaused = false
        playerDot.enableCollisionDetection()
    }
    
    func pauseGame(){
        
        gameplayTimer.pause()
        isPaused = true
        
    }
    
    func restartGame(){
        
        activeGame = false
        removeDots()
        startGame()
        
    }
    
    func gameOver(){
        
        activeGame = false
        isPaused = true
        playerDot.disableCollisionDetection()
        gameplayTimer.pause()
        parentViewController.gameOver()
        
    }

    func didBegin(_ contact: SKPhysicsContact) {
        
        if activeGame && (contact.bodyA.categoryBitMask == playerCollisionCategory || contact.bodyB.categoryBitMask == playerCollisionCategory) {
            
            gameOver()
            
            let currentScore = Int(gameplayTimer.counter)
            let bestScore = UserDefaults.standard.integer(forKey: myScoreString)
            
            if currentScore > bestScore {
                UserDefaults.standard.set(currentScore, forKey: myScoreString)
                UserDefaults.standard.synchronize()
                
                // See if there is a valid token available for use so one can update the score
                if token != "" {
                    
                    let username = UserDefaults.standard.string(forKey: usernameString)!
                    
                    // Check if this is the first time the score needs to be set
                    let firstScore = UserDefaults.standard.object(forKey: firstScoreString) as! Bool?
                    
                    if firstScore == nil || firstScore == true {
                        UserDefaults.standard.set(false, forKey: firstScoreString)
                        UserDefaults.standard.synchronize()
                        
                        if Reachability.isConnectedToNetwork() {
                            NetworkManager.setScore(username, score: currentScore, token: token, completionHandler: setScoreHandler)
                        }

                    } else {
                        if Reachability.isConnectedToNetwork() {
                            NetworkManager.updateScore(username, score: currentScore, token: token, completionHandler: updateScoreHandler)
                        }
                    }
                    
                    parentViewController.displayScore()
                    
                }
            }

            
        }
        
    }
    
    func setScoreHandler(_ data : Data?, response : URLResponse?, error : NSError?){
        if error == nil && data != nil {
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                print(json)
            } catch {
                print("Error while fetching data from mongo")
            }
        }
    }
    
    func updateScoreHandler(_ data : Data?, response : URLResponse?, error : NSError?){
        if error == nil && data != nil {
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                print(json)
            } catch {
                print("Error while fetching data from mongo")
            }
        }
    }

    

}
