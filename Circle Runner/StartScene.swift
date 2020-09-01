//
//  StartScene.swift
//  Circle Runner
//
//  Created by Matheus Amendola on 01/09/20.
//  Copyright © 2020 Matheus Amendola. All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
 var playButton:SKSpriteNode?
 var gameScene:SKScene!

 var player: SKSpriteNode?
 
 
 
 override func didMove(to view: SKView) {
     playButton = self.childNode(withName: "start") as? SKSpriteNode
    createPlayer()
     
//     if let musicURL = Bundle.main.url(forResource: "MenuHighscoreMusic", withExtension: "mp3") {
//         backgroundMusic = SKAudioNode(url: musicURL)
//         addChild(backgroundMusic)
//     }
     
     
     
 }
    
    func createPlayer(){
        player = SKSpriteNode(imageNamed: "player")
        player?.physicsBody = SKPhysicsBody(circleOfRadius: player!.size.width / 2)
        player?.physicsBody?.linearDamping = 0

        player?.physicsBody?.collisionBitMask = 0

        player?.position = CGPoint(x: 0.5, y: 0.5)
        self.addChild(player!)
        
        
        let light = SKEmitterNode(fileNamed: "light")!
        light.targetNode = self.scene
        
        let playerSize = player?.size
        
        light.particleSize = playerSize!
        player?.addChild(light)
        light.position = CGPoint(x: 0, y: 0)
    }
 
 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     if let touch = touches.first {
         let pos = touch.location(in: self)
         let node = self.atPoint(pos)
         
         if node == playButton {
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.impactOccurred()
             let transition = SKTransition.fade(withDuration: 1)
             gameScene = SKScene(fileNamed: "GameScene")
             gameScene.scaleMode = .aspectFit
             self.view?.presentScene(gameScene, transition: transition)
            self.removeAllChildren()
             
         }
     }
 }
}
