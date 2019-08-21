
//  ScoreboardViewController.swift
//  AssignmentOne

import UIKit

class ScoreboardViewController: UIViewController {
    
    var playerController: PlayerController!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var playerOneLabel: UILabel!
    @IBOutlet weak var playerTwoLabel: UILabel!
    
    @IBOutlet weak var viewMenu: UIView!
    
    override func viewDidLoad() {
        
        // call super function
        super.viewDidLoad()
        
        viewMenu.backgroundColor = UIColor(patternImage: getBackgroundImage(id: 1))
        
        // set colour properties
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        updateColour()
        
        // round button
        closeButton.layer.cornerRadius = 10
        
        // update label text
        playerOneLabel.text = playerOneLabel.text! + " \(playerController.playerOne.score)"
        playerTwoLabel.text = playerTwoLabel.text! + " \(playerController.playerTwo.score)"
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        
        // remove scoreboard from view
        self.view.removeFromSuperview()
    }
    
    func updateColour() {
        
        // set colour of buttons
        closeButton.backgroundColor = getColour()
    }
}

