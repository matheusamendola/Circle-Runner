//
//  GameHander.swift
//  
//
//  Created by Matheus Amendola on 01/09/20.
//

import Foundation

class GameHander {
    var score: Int
    var highScore: Int
    
    class var sharedInstance: GameHander{
        struct Singleton{
            static let instance = GameHander()
        }
        
        return Singleton.instance
    }
    
    init() {
        score = 0
        highScore = 0
        
        let userDefaults = UserDefaults.standard
        highScore = userDefaults.integer(forKey: "highScore")
    }
    
    func saveGameStats(){
        highScore = max(score, highScore)
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(highScore, forKey: "highScore")
        userDefaults.synchronize()
    }
    
}
