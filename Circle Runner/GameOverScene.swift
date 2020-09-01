//
//  Gameover.swift
//  Circle Runner
//
//  Created by Matheus Amendola on 01/09/20.
//  Copyright © 2020 Matheus Amendola. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var lastScoreLabel:SKLabelNode?
    var bestScoreLabel:SKLabelNode?
    
    var playButton:SKSpriteNode?
    
    var backgroundMusic: SKAudioNode!
    
    override func didMove(to view: SKView) {
        lastScoreLabel = self.childNode(withName: "lastScoreLabel") as? SKLabelNode
        bestScoreLabel = self.childNode(withName: "bestScoreLabel") as? SKLabelNode
        
        lastScoreLabel?.text = "\(GameHander.sharedInstance.score)"
        bestScoreLabel?.text = "\(GameHander.sharedInstance.highScore)"
        
        playButton = self.childNode(withName: "tryAgain") as? SKSpriteNode
        
//         if let musicURL = Bundle.main.url(forResource: "MenuHighscoreMusic", withExtension: "mp3") {
//            backgroundMusic = SKAudioNode(url: musicURL)
//            addChild(backgroundMusic)
//        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton {
                let transition = SKTransition.fade(withDuration: 1)
                if let gameScene = SKScene(fileNamed: "GameScene") {
                gameScene.scaleMode = .aspectFit
                self.view?.presentScene(gameScene, transition: transition)
                self.removeAllChildren()
                }
            }
        }
    }
}
