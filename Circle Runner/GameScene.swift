//
//  GameScene.swift
//  Circle Runner
//
//  Created by Matheus Amendola on 29/08/20.
//  Copyright © 2020 Matheus Amendola. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Enemies:Int {
    case small
    case medium
    case large
}

class GameScene: SKScene {
    
    var player: SKSpriteNode?
    
    var yVelocity: Int = -300
    
    var scoreLabel: SKLabelNode?
    var currentScore: TimeInterval = 0{
        didSet{
            self.scoreLabel?.text = "\(Int(self.currentScore))"
        }
    }
    // MARK: - Entry Point
    
    override func didMove(to view: SKView) {
        createPlayer()
        createHUD()
        lauchGameScore()
        
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.spwanEnemies()
            }, SKAction.wait(forDuration: 0.5)])))
    }
    
    // MARK: - Player
    
    func createPlayer(){
        player = SKSpriteNode(imageNamed: "player")
        player?.physicsBody = SKPhysicsBody(circleOfRadius: player!.size.width / 2)
        player?.physicsBody?.linearDamping = 0
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

    //MARK: - Update

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
