//
//  GameScene.swift
//  Palatine High School
//
//  Created by Dominic Vitucci on 2/28/15.
//  Copyright (c) 2015 Dominic Vitucci. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    let verticalPipeGap = 150.0
    
    var bird:SKSpriteNode!
    var skyColor:SKColor!
    var pipeTextureUp:SKTexture!
    var pipeTextureDown:SKTexture!
    var movePipesAndRemove:SKAction!
    var moving:SKNode!
    var pipes:SKNode!
    var canRestart = Bool()
    var scoreLabelNode:SKLabelNode!
    var score = NSInteger()
    var highScore = NSInteger()
    var highScoreLabelNode:SKLabelNode!
    var defaults = NSUserDefaults.standardUserDefaults()
    var gameoverLabelNode:SKLabelNode!
    var worldHighScore = NSInteger()
    var worldHighScoreLabel:SKLabelNode!
    var worldHighScoreLabel2:SKLabelNode!
    
    let birdCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    
    override func didMoveToView(view: SKView) {
        
        canRestart = false
        
        // setup physics
        self.physicsWorld.gravity = CGVectorMake( 0.0, -5.0 )
        self.physicsWorld.contactDelegate = self
        
        // setup background color
        skyColor = SKColor(red: 51.0/255.0, green: 71.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
        
        moving = SKNode()
        self.addChild(moving)
        pipes = SKNode()
        moving.addChild(pipes)
        
        // ground
        let groundTexture = SKTexture(imageNamed: "Ground")
        groundTexture.filteringMode = .Nearest // shorter form for SKTextureFilteringMode.Nearest
        
        let moveGroundSprite = SKAction.moveByX(-groundTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.02 * groundTexture.size().width * 2.0))
        let resetGroundSprite = SKAction.moveByX(groundTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveGroundSprite,resetGroundSprite]))
        
        for var i:CGFloat = 0; i < 2.0 + self.frame.size.width / ( groundTexture.size().width * 2.0 ); ++i {
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2.0)
            sprite.runAction(moveGroundSpritesForever)
            moving.addChild(sprite)
        }
        
        // skyline
        let skyTexture = SKTexture(imageNamed: "Sky")
        skyTexture.filteringMode = .Nearest
        
        let moveSkySprite = SKAction.moveByX(-skyTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.1 * skyTexture.size().width * 2.0))
        let resetSkySprite = SKAction.moveByX(skyTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSkySpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveSkySprite,resetSkySprite]))
        
        for var i:CGFloat = 0; i < 2.0 + self.frame.size.width / ( skyTexture.size().width * 2.0 ); ++i {
            let sprite = SKSpriteNode(texture: skyTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -20
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
            sprite.runAction(moveSkySpritesForever)
            moving.addChild(sprite)
        }
        
        // Clouds
        let cloudTexture = SKTexture(imageNamed: "Clouds")
        cloudTexture.filteringMode = .Nearest
        
        let moveCloudSprite = SKAction.moveByX(-cloudTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.1 * cloudTexture.size().width * 2.0))
        let resetCloudSprite = SKAction.moveByX(cloudTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveCloudSpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveCloudSprite,resetCloudSprite]))
        
        for var i:CGFloat = 0; i < 2.0 + self.frame.size.width / ( cloudTexture.size().width * 2.0 ); ++i {
            let sprite = SKSpriteNode(texture: cloudTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -40
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 1.0 + groundTexture.size().height * 2.0 + skyTexture.size().height * 2.0 )
            sprite.runAction(moveCloudSpritesForever)
            moving.addChild(sprite)
        }
        
        
        // create the pipes textures
        pipeTextureUp = SKTexture(imageNamed: "Pipe Bottom")
        pipeTextureUp.filteringMode = .Nearest
        pipeTextureDown = SKTexture(imageNamed: "Pipe Top")
        pipeTextureDown.filteringMode = .Nearest
        
        // create the pipes movement actions
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeTextureUp.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
        // spawn the pipes
        let spawn = SKAction.runBlock({() in self.spawnPipes()})
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
        
        // setup our bird
        let birdTexture1 = SKTexture(imageNamed: "Snow Man Up")
        birdTexture1.filteringMode = .Nearest
        let birdTexture2 = SKTexture(imageNamed: "Snow Man Down")
        birdTexture2.filteringMode = .Nearest
        
        let anim = SKAction.animateWithTextures([birdTexture1, birdTexture2], timePerFrame: 0.2)
        let flap = SKAction.repeatActionForever(anim)
        
        bird = SKSpriteNode(texture: birdTexture1)
        bird.setScale(0.065)
        bird.position = CGPoint(x: self.frame.size.width * 0.35, y:self.frame.size.height * 0.6)
        bird.runAction(flap)
        
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        
        self.addChild(bird)
        
        
        
        
        // create the ground
        var ground = SKNode()
        ground.position = CGPointMake(0, groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, groundTexture.size().height * 2.0))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        self.addChild(ground)
        
        // Initialize label and create a label which holds the score
        score = 0
        scoreLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        scoreLabelNode.position = CGPointMake( CGRectGetMidX( self.frame ), 3 * self.frame.size.height / 4 )
        scoreLabelNode.zPosition = 100
        scoreLabelNode.text = String(score)
        self.addChild(scoreLabelNode)
        
        
        
    }
    
    func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPointMake( self.frame.size.width + pipeTextureUp.size().width * 2, 0 )
        pipePair.zPosition = -10
        
        let height = UInt32( UInt(self.frame.size.height / 4) )
        let y = arc4random() % height + height
        
        let pipeDown = SKSpriteNode(texture: pipeTextureDown)
        pipeDown.setScale(2.0)
        pipeDown.position = CGPointMake(0.0, CGFloat(Double(y)) + pipeDown.size.height + CGFloat(verticalPipeGap))
        
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
        pipeDown.physicsBody?.dynamic = false
        pipeDown.physicsBody?.categoryBitMask = pipeCategory
        pipeDown.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeTextureUp)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPointMake(0.0, CGFloat(Double(y)))
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody?.dynamic = false
        pipeUp.physicsBody?.categoryBitMask = pipeCategory
        pipeUp.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeUp)
        
        var contactNode = SKNode()
        contactNode.position = CGPointMake( pipeDown.size.width + bird.size.width / 2, CGRectGetMidY( self.frame ) )
        contactNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake( pipeUp.size.width, self.frame.size.height ))
        contactNode.physicsBody?.dynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(contactNode)
        
        pipePair.runAction(movePipesAndRemove)
        pipes.addChild(pipePair)
        
    }
    
    func resetScene (){
        // Move bird to original position and reset velocity
        bird.position = CGPointMake(self.frame.size.width / 2.5, CGRectGetMidY(self.frame))
        bird.physicsBody?.velocity = CGVectorMake( 0, 0 )
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.speed = 1.0
        bird.zRotation = 0.0
        
        // Remove all existing pipes
        pipes.removeAllChildren()
        
        // Reset _canRestart
        canRestart = false
        
        
        // Reset score
        score = 0
        scoreLabelNode.text = String(score)
        
        //Remove Highscore Labels
        self.highScoreLabelNode.removeFromParent()
        self.gameoverLabelNode.removeFromParent()
        
        //        if worldHighScoreLabel != nil {
        //            self.worldHighScoreLabel.removeFromParent()
        //
        //        }
        //
        //        if worldHighScoreLabel2 != nil {
        //            self.worldHighScoreLabel2.removeFromParent()
        //
        //        }
        
        
        
        // Restart animation
        moving.speed = 1
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if moving.speed > 0  {
            for touch: AnyObject in touches {
                let location = touch.locationInNode(self)
                
                bird.physicsBody?.velocity = CGVectorMake(0, 0)
                bird.physicsBody?.applyImpulse(CGVectorMake(0, 40))
                
            }
        }else if canRestart {
            self.resetScene()
        }
    }
    
    // TODO: Move to utilities somewhere. There's no reason this should be a member function
    func clamp(min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
        if( value > max ) {
            return max
        } else if( value < min ) {
            return min
        } else {
            return value
        }
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        bird.zRotation = self.clamp( -1, max: 0.5, value: bird.physicsBody!.velocity.dy * ( bird.physicsBody!.velocity.dy < 0 ? 0.003 : 0.001 ) )
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if moving.speed > 0 {
            if ( contact.bodyA.categoryBitMask & scoreCategory ) == scoreCategory || ( contact.bodyB.categoryBitMask & scoreCategory ) == scoreCategory {
                // Bird has contact with score entity
                score++
                scoreLabelNode.text = String(score)
                
                // Add a little visual feedback for the score increment
                scoreLabelNode.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration:NSTimeInterval(0.1)), SKAction.scaleTo(1.0, duration:NSTimeInterval(0.1))]))
            } else {
                
                moving.speed = 0
                
                bird.physicsBody?.collisionBitMask = worldCategory
                bird.runAction(  SKAction.rotateByAngle(CGFloat(M_PI) * CGFloat(bird.position.y) * 0.01, duration:1), completion:{self.bird.speed = 0 })
                
                
                // Flash background if contact is detected
                self.removeActionForKey("flash")
                self.runAction(SKAction.sequence([SKAction.repeatAction(SKAction.sequence([SKAction.runBlock({
                    self.backgroundColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
                }),SKAction.waitForDuration(NSTimeInterval(0.05)), SKAction.runBlock({
                    self.backgroundColor = self.skyColor
                }), SKAction.waitForDuration(NSTimeInterval(0.05))]), count:4), SKAction.runBlock({
                    self.canRestart = true
                })]), withKey: "flash")
                
                NSUserDefaults.standardUserDefaults().integerForKey("highscore")
                
                //Check if score is higher than NSUserDefaults stored value and change NSUserDefaults stored value if it's true
                if score > NSUserDefaults.standardUserDefaults().integerForKey("highscore")
                {
                    NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "highscore")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                
                NSUserDefaults.standardUserDefaults().integerForKey("highscore")
                
                var highscoreShow = defaults.integerForKey("highscore")
                
                highScoreLabelNode = SKLabelNode(fontNamed: "MarkerFelt-Wide")
                highScoreLabelNode.position = CGPointMake(CGRectGetMidX(self.frame), 530)
                highScoreLabelNode.zPosition = 10
                highScoreLabelNode.fontSize = 30
                highScoreLabelNode.text = "Your Highscore: \(highscoreShow)"
                highScoreLabelNode.fontColor = UIColor.redColor()
                self.addChild(highScoreLabelNode)
                
                
                gameoverLabelNode = SKLabelNode(fontNamed: "MarkerFelt-Wide")
                gameoverLabelNode.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.height/6)
                gameoverLabelNode.zPosition = 10
                gameoverLabelNode.text = "GameOver"
                gameoverLabelNode.fontColor = UIColor.redColor()
                self.addChild(gameoverLabelNode)
                
                
                
                //                var query = PFQuery(className:"GameScore")
                //                query.getObjectInBackgroundWithId("lAw40mnJfb") {
                //                    (gameScore: PFObject!, error: NSError!) -> Void in
                //                    if error != nil {
                //                        NSLog("%@", error)
                //                    } else if self.score > self.worldHighScore {
                //                        gameScore["score"] = self.score
                //                        gameScore.saveInBackground()
                //
                //                        self.worldHighScore = gameScore.objectForKey("score") as Int
                //
                //                        self.worldHighScoreLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
                //                        self.worldHighScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), 475)
                //                        self.worldHighScoreLabel.zPosition = 10
                //                        self.worldHighScoreLabel.fontSize = 30
                //                        self.worldHighScoreLabel.text = "World Highscore: \(self.worldHighScore)"
                //                        self.worldHighScoreLabel.fontColor = UIColor.redColor()
                //                        self.addChild(self.worldHighScoreLabel)
                //
                //                    }
                //
                //                    else {
                //
                //                        var query2 = PFQuery(className:"GameScore")
                //                        query.getObjectInBackgroundWithId("lAw40mnJfb") {
                //                            (gameScore: PFObject!, error: NSError!) -> Void in
                //                            if error == nil {
                //
                //
                //                                self.worldHighScore = gameScore.objectForKey("score") as Int
                //
                //                                self.worldHighScoreLabel2 = SKLabelNode(fontNamed: "MarkerFelt-Wide")
                //                                self.worldHighScoreLabel2.position = CGPointMake(CGRectGetMidX(self.frame), 475)
                //                                self.worldHighScoreLabel2.zPosition = 10
                //                                self.worldHighScoreLabel2.fontSize = 30
                //                                self.worldHighScoreLabel2.text = "World Highscore: \(self.worldHighScore)"
                //                                self.worldHighScoreLabel2.fontColor = UIColor.redColor()
                //                                self.addChild(self.worldHighScoreLabel2)
                //                                
                //                                
                //                                NSLog("%@", gameScore)
                //                            } else {
                //                                NSLog("%@", error)
                //                            }
                //                            
                //                        }
                //
                //                       NSLog("No New High Score")
                //                    }
                //                }
                
                
                
                println("Game Ended")
                
                
            }
        }
    }
}
