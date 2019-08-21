
//  PlayerController.swift
//  AssignmentOne

import Foundation

// creating a player struct with all information relevant to the player
struct Player: Equatable {
    var id: String
    var gameIdentifier: Int
    var round: Int
    var score: Int
    
    // creating a comparison function to determine if two players are the same
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
}

class PlayerController {
    
    var playerOne = Player(id: "Player One", gameIdentifier: 1, round: 0, score: 0)
    var playerTwo = Player(id: "Player Two", gameIdentifier: 2, round: 0, score: 0)
    var activePlayer: Player?

    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    var gameFinished = false
    
    // loading relevant information from memory
    func initialise() {
        
        // checking if player one round exists and then loading it if it does
        if doesKeyExist(key: "playerOneRound") {
            playerOne.round = UserDefaults.standard.integer(forKey: "playerOneRound")
        }
        
        // checking if player one score exists and then loading it if it does
        if doesKeyExist(key: "playerOneScore") {
            playerOne.score = UserDefaults.standard.integer(forKey: "playerOneScore")
        }
        
        // checking if player two round exists and then loading it if it does
        if doesKeyExist(key: "playerTwoRound") {
            playerTwo.round = UserDefaults.standard.integer(forKey: "playerTwoRound")
        }
        
        // checking if player two score exists and then loading it if it does
        if doesKeyExist(key: "playerTwoScore") {
            playerTwo.score = UserDefaults.standard.integer(forKey: "playerTwoScore")
        }
        
        // checking if game state exists and then loading it if it does
        if doesKeyExist(key: "gameState") {
            gameState = (UserDefaults.standard.array(forKey: "gameState") as? [Int])!
        }
        
        // setting default active player to player one
        activePlayer = playerOne
        
        // checking if active player id exists and then loading it if it does
        if doesKeyExist(key: "activePlayerId") {
            if UserDefaults.standard.string(forKey: "activePlayerId") == playerTwo.id {
                activePlayer = playerTwo
            }
        }
        
        // checking if game finished exists and then loading it if it does
        if doesKeyExist(key: "gameFinished") {
            gameFinished = UserDefaults.standard.bool(forKey: "gameFinished")
        }
    }
    
    // function to determine if key exists
    func doesKeyExist(key: String) -> Bool {
        return (UserDefaults.standard.object(forKey: key) != nil)
    }
    
    // changes the active player
    func changePlayer() {
        
        if activePlayer == playerOne {
            activePlayer = playerTwo
        }
        else {
            activePlayer = playerOne
        }
        
        // saving active player to memory
        UserDefaults.standard.set(activePlayer?.id, forKey: "activePlayerId")
    }
    
    // updating score for relevant player
    func updateScore(score: Int) {
        
        if activePlayer == playerOne {
            // adding the score to player ones score
            playerOne.score += score
            // saving player one score to memory
            UserDefaults.standard.set(playerOne.score, forKey: "playerOneScore")
        } else {
            // adding the score to player twos score
            playerTwo.score += score
            // saving player two score to memory
            UserDefaults.standard.set(playerTwo.score, forKey: "playerTwoScore")
        }
    }
    
    // incrementing round for relevant player
    func incrementRound() {
        
        if activePlayer == playerOne {
            // incrementing the round for player one
            playerOne.round += 1
            // saving round to memory
            UserDefaults.standard.set(playerOne.round, forKey: "playerOneRound")
        } else {
            // incrementing the round for player two
            playerTwo.round += 1
            // saving round to memory
            UserDefaults.standard.set(playerTwo.round, forKey: "playerTwoRound")
        }
    }
    
    // setting game state for relevant location
    func setGameState(location: Int) {
        
        // checks to make sure neither player has placed a symbol
        if (gameState[location] == 0) {
            // setting game state with relevant player indentifier
            gameState[location] = (activePlayer?.gameIdentifier)!
        }
        // saves game state to memory
        UserDefaults.standard.set(gameState, forKey: "gameState")
    }
    
    // setting game finished
    func setGameFinished(finished: Bool) {
        
        gameFinished = finished
        
        UserDefaults.standard.set(gameFinished, forKey: "gameFinished")
    }
    
    // resetting game
    func resetGame() {
        
        playerOne.round = 0
        playerTwo.round = 0
        playerOne.score = 0
        playerTwo.score = 0
        activePlayer = playerOne
        gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        gameFinished = false
        
        UserDefaults.standard.set(activePlayer?.id, forKey: "activePlayerId")
        UserDefaults.standard.set(playerOne.round, forKey: "playerOneRound")
        UserDefaults.standard.set(playerTwo.round, forKey: "playerTwoRound")
        UserDefaults.standard.set(gameState, forKey: "gameState")
        UserDefaults.standard.set(gameFinished, forKey: "gameFinished") 
    }
}

