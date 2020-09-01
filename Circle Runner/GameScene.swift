//
//  GameScene.swift
//  Circle Runner
//
//  Created by Matheus Amendola on 29/08/20.
//  Copyright © 2020 Matheus Amendola. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox

enum Enemies:Int {
    case small
    case medium
    case large
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: Collision Categories
    let playerCategory:UInt32 = 0x1 << 0
    let enemyCategory:UInt32 = 0x1 << 1
    
    var player: SKSpriteNode?
    
    var yVelocity: Int = -300
    var backgroundNoise: SKAudioNode!
    // MARK: - HUD Var
    var pause: SKSpriteNode?
    var scoreLabel: SKLabelNode?
    var currentScore: TimeInterval = 0{
        didSet{
            self.scoreLabel?.text = "\(Int(self.currentScore))"
            GameHander.sharedInstance.score = (Int(self.currentScore))
        }
    }
    
    // MARK: - Entry Point
    
    override func didMove(to view: SKView) {
        createPlayer()
        createHUD()
        lauchGameScore()
        
        self.physicsWorld.contactDelegate = self
        
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.spwanEnemies()
            }, SKAction.wait(forDuration: 0.5)])))
        
        if let musicURL = Bundle.main.url(forResource: "backgroud", withExtension: "mp3"){
            backgroundNoise = SKAudioNode(url: musicURL)
            addChild(backgroundNoise)
        }
    }
    
    // MARK: - Player
    
    func createPlayer(){
        player = SKSpriteNode(imageNamed: "player")
        player?.physicsBody = SKPhysicsBody(circleOfRadius: player!.size.width / 2)
        player?.physicsBody?.linearDamping = 0
        player?.physicsBody?.categoryBitMask = playerCategory
        player?.physicsBody?.collisionBitMask = 0
        player?.physicsBody?.contactTestBitMask = enemyCategory
        player?.position = CGPoint(x: 0, y: -265)
        self.addChild(player!)
        
        
        let light = SKEmitterNode(fileNamed: "light")!
        light.targetNode = self.scene
        
        let playerSize = player?.size
        
        light.particleSize = playerSize!
        player?.addChild(light)
        light.position = CGPoint(x: 0, y: 0)
    }
    
    func createHUD(){
        pause = self.childNode(withName: "pause") as? SKSpriteNode
        scoreLabel = self.childNode(withName: "score") as? SKLabelNode
        
        currentScore = 0
        
    }
    
    // MARK: -
    
    func createEnemy(type:Enemies) -> SKShapeNode?{
        let enemySprite = SKShapeNode()
        enemySprite.name = "ENEMY"
        
        switch type {
        case .small:
            enemySprite.path = CGPath(rect: CGRect(x: 0, y: -10, width: 137, height: 30), transform: nil)
            enemySprite.fillColor = UIColor(named: "Color02")!
        case .medium:
            enemySprite.path = CGPath(rect: CGRect(x: 0, y: -10, width: 182, height: 30), transform: nil)
            enemySprite.fillColor = UIColor(named: "Color04")!
        case .large:
            enemySprite.path = CGPath(rect: CGRect(x: 0, y: -10, width: 242, height: 30), transform: nil)
            enemySprite.fillColor = UIColor(named: "Color05")!

        }
        
        let randomFloat = CGFloat.random(in: -255...100)
        
        enemySprite.position.x = randomFloat
        enemySprite.position.y = 420

        enemySprite.physicsBody = SKPhysicsBody(edgeLoopFrom: enemySprite.path!)
        enemySprite.physicsBody?.categoryBitMask = enemyCategory
        enemySprite.physicsBody?.velocity = CGVector(dx: 0, dy: yVelocity)
        
        return enemySprite
    }
    
    func spwanEnemies () {
                    
        let randomEnemyType = Enemies(rawValue: GKRandomSource.sharedRandom().nextInt(upperBound: 3))!
        if let newEnemy = createEnemy(type: randomEnemyType) {
            self.addChild(newEnemy)
        }
            
        //Remove inimigos quando sai da tela
        self.enumerateChildNodes(withName: "ENEMY") { (node:SKNode, nil) in
            if node.position.y < -430 || node.position.y > self.size.height + 150 {
                node.removeFromParent()
            }
        }
    }
    
    func lauchGameScore(){
        let timeAction = SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.currentScore += 1
            }, SKAction.wait(forDuration: 1)]))
        scoreLabel?.run(timeAction)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let pauseTouch = touches.first{
            let location = pauseTouch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            
            if node?.name == "pause", let scene = self.scene{
                if scene.isPaused{
                    scene.isPaused = false
                } else {
                    scene.isPaused = true
                }
            }
        }
        
        for touch in touches{
            let location = touch.location(in: self)
            if (player?.contains(location))!{
                player?.position.x = location.x
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if (player?.contains(location))!{
                player?.position.x = location.x
            }
        }
    }
    
    func gameOver(){
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        GameHander.sharedInstance.saveGameStats()
        print(GameHander.sharedInstance.score)
        
        let transition = SKTransition.fade(withDuration: 1)
        if let gameOverScene = SKScene(fileNamed: "GameOverScene"){
            gameOverScene.scaleMode = .aspectFit
            self.view?.presentScene(gameOverScene, transition: transition)
            //self.removeAllChildren()
            self.removeFromParent()
        }
        
    }

    //MARK: - Update

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var playerBody:SKPhysicsBody
        var otherBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            playerBody = contact.bodyA
            otherBody = contact.bodyB
        }else{
            playerBody = contact.bodyB
            otherBody = contact.bodyA
        }
        
        if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == enemyCategory {
            gameOver()
        }
        
        
    }
}
