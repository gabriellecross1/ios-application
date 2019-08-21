
//  ViewController.swift
//  AssignmentOne

import UIKit

class ViewController: UIViewController {
    
    var playerController: PlayerController!
    
    var gameIsActive = true
    var playerHasWon = false
    var hasPlayerPlayed = false
    
    var timer = Timer()
    
    let winningCombinations = [[0, 1, 2, 3], [4, 5, 6, 7], [8, 9, 10, 11], [12, 13, 14, 15], [0, 4, 8, 12], [1, 5, 9, 13], [2, 6, 10, 14], [3, 7, 11, 15], [0, 5, 10, 15], [3, 6, 9, 12]]
    
    @IBOutlet weak var scoreboardButton: UIButton!
    @IBOutlet weak var mainMenuButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    
    @IBOutlet var Buttons: [UIButton]!
    @IBOutlet var FlashButtons: [UIButton]!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: getBackgroundImage(id: 1))
        
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        
        scoreboardButton.layer.cornerRadius = 10
        mainMenuButton.layer.cornerRadius = 10
        playAgainButton.layer.cornerRadius = 10
        
        updateColour()
        
        // setting label text to show which players turn it is
        if((playerController.activePlayer?.gameIdentifier)! == 1) {
            label.text = "PLAYER ONE: CROSS!"
        } else {
            label.text = "PLAYER TWO: NOUGHT!"
        }
        
        // checking game state and setting appropriate images
        for i in 1...16 {
            
            let button = view.viewWithTag(i) as! UIButton
            
            if((playerController.gameState[i-1]) == 1) {
                button.setImage(UIImage(named: "cross.png"), for: UIControlState())
            } else if((playerController.gameState[i-1]) == 2) {
                button.setImage(UIImage(named: "nought.png"), for: UIControlState())
            }
        }
        
        // calling check win function
        checkWin()
        // checking for draw if there is no win
        if playerHasWon == false {
            checkDraw()
        }
        // only allow player to play if game is still active (no win or draw)
        if gameIsActive {
            hasPlayerPlayed = false
        }
    }
    
    // setting player controller in destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ThirdViewController
        {
            let vc = segue.destination as? ThirdViewController
            vc?.playerController = playerController
        }
        if segue.destination is MainMenuViewController
        {
            let vc = segue.destination as? MainMenuViewController
            vc?.playerController = playerController
        }
    }
    
    // handling grid button press
    @IBAction func action(_ sender: AnyObject)
    {
        // only allow an action if player hasn't already played
        if hasPlayerPlayed == false {
            
            // setting if overall game has finished
            playerController.setGameFinished(finished: false)
            
            // when the game is active
            if (gameIsActive == true)
            {
                // setting game state in player controller
                playerController.setGameState(location: sender.tag-1)
                
                // set image depending on player
                if((playerController.activePlayer?.gameIdentifier)! == 1) {
                    sender.setImage(UIImage(named: "cross.png"), for: UIControlState())
                } else {
                    sender.setImage(UIImage(named: "nought.png"), for: UIControlState())
                }
            }
            
            // calling check win function
            checkWin()
            // checking for draw if there is no win
            if playerHasWon == false {
                checkDraw()
            }
            
            // when game is active change player and set timer to go back to question sets
            if gameIsActive == true {
                playerController.changePlayer()
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(infoTimeOut), userInfo: nil, repeats:true)
            }
            
            // setting player has played
            // this is used to ensure player can't place more than one symbols
            hasPlayerPlayed = true
        }
    }
    
    // handling play again button press
    @IBAction func playAgain(_ sender: Any) {
        
        // resetting game
        playerController.resetGame()
        
        gameIsActive = true
        
        playAgainButton.isHidden = true
        
        // setting all the symbols in the grid to nil so that they don't appear in the next game
        for i in 1...16 {
            let button = view.viewWithTag(i) as! UIButton
            button.setImage(nil, for: UIControlState())
        }
        
        // resetting the questions used array
        UserDefaults.standard.set([[false, false, false, false, false], [false, false, false, false, false], [false, false, false, false, false], [false, false, false, false, false]], forKey: "QuestionsUsed")
        
        // moving to the next view
        self.performSegue(withIdentifier: "nextTurnSegue", sender: self)
    }
    
    // handling main menu button press
    @IBAction func mainMenu(_ sender: UIButton) {
        
        //resetting game
        playerController.resetGame()
        
        gameIsActive = true
        
        playAgainButton.isHidden = true
        
        // setting all the symbols in the grid to nil so that they don't appear in the next game
        for i in 1...16 {
            let button = view.viewWithTag(i) as! UIButton
            button.setImage(nil, for: UIControlState())
        }
        
        // resetting the questions used array
        UserDefaults.standard.set([[false, false, false, false, false], [false, false, false, false, false], [false, false, false, false, false], [false, false, false, false, false]], forKey: "QuestionsUsed")
    }
    
    // handling pop up view for scoreboard
    @IBAction func showPopup(_ sender: Any) {
        
        // finding the pop up view controller within main.storyboard and instantiating
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! ScoreboardViewController
        // setting player controller in pop up view controller
        popOverVC.playerController = playerController
        // adding the pop up view controller as a child of the current view controller (ViewController)
        self.addChildViewController(popOverVC)
        // set up view controller
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    // checking for a win
    func checkWin() {
        
        // cycling through all possible win combinations
        for combination in winningCombinations
        {
            // performing win check
            if playerController.gameState[combination[0]] != 0 && playerController.gameState[combination[0]] == playerController.gameState[combination[1]] && playerController.gameState[combination[1]] == playerController.gameState[combination[2]] && playerController.gameState[combination[2]] == playerController.gameState[combination[3]]
            {
                gameIsActive = false
                playerHasWon = true
                
                // setting label depending on which player wins
                if playerController.gameState[combination[0]] == 1 {
                    label.text = "CROSS HAS WON!"
                } else {
                    label.text = "NOUGHT HAS WON!"
                }
                
                // setting flash animation for symbols in a winning line
                FlashButtons[combination[0]].flash()
                FlashButtons[combination[1]].flash()
                FlashButtons[combination[2]].flash()
                FlashButtons[combination[3]].flash()
                
                // hiding buttons
                playAgainButton.isHidden = false
                mainMenuButton.isHidden = false
                scoreboardButton.isHidden = false
                
                // setting overall game finished
                playerController.setGameFinished(finished: true)
            }
        }
    }
    
    // checking for a draw
    func checkDraw() {
        
        gameIsActive = false
        
        // checking if there any available moves remaining
        for i in playerController.gameState {
            if i == 0 {
                gameIsActive = true
                break
            }
        }
        
        // when there are no moves available
        if gameIsActive == false {
            // setting label text for a draw
            label.text = "IT WAS A DRAW"
            
            // hiding buttons
            playAgainButton.isHidden = false
            scoreboardButton.isHidden = false
            mainMenuButton.isHidden = false
            
            // setting overall game finished
            playerController.setGameFinished(finished: true)
        }
    }
    
    // time out function used by the timer
    func infoTimeOut() {
        
        // moving to the next view
        self.performSegue(withIdentifier: "nextTurnSegue", sender: self)
        
        // invalidating timer
        timer.invalidate()
    }
    
    // updating colour buttons and labels depending on the theme
    func updateColour() {
        
        label.backgroundColor = getColour()
        scoreboardButton.backgroundColor = getColour()
        mainMenuButton.backgroundColor = getColour()
        playAgainButton.backgroundColor = getColour()
    }
}

