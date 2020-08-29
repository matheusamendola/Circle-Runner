//
//  GameScene.swift
//  Circle Runner
//
//  Created by Matheus Amendola on 29/08/20.
//  Copyright © 2020 Matheus Amendola. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    var player: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        createPlayer()
                
    }
    
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


    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
