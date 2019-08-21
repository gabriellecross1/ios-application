
//  RulesViewController.swift
//  AssignmentOne

import UIKit

class RulesViewController: UIViewController {
    
    var playerController: PlayerController!

    @IBOutlet weak var mainMenuButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: getBackgroundImage(id: 1))
        
        mainMenuButton.layer.cornerRadius = 10
        
        updateColour()
    }
    
    // setting player controller in destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is MainMenuViewController {
            let vc = segue.destination as? MainMenuViewController
            vc?.playerController = playerController
        }
    }
    
    // updating the colour of the menu button depending on the chosen theme
    func updateColour() {
        
        mainMenuButton.backgroundColor = getColour()
    }
}
