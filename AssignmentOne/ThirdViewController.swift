
//  ThirdViewController.swift
//  AssignmentOne

import UIKit

class ThirdViewController: UIViewController {
    
    var playerController: PlayerController!
    
    var questionSet = 0
    
    @IBOutlet weak var playerLabel: UILabel!
    
    @IBOutlet weak var entertainmentButton: UIButton!
    @IBOutlet weak var scienceButton: UIButton!
    @IBOutlet weak var artButton: UIButton!
    @IBOutlet weak var sportButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: getBackgroundImage(id: 1))
        
        entertainmentButton.layer.cornerRadius = 10
        scienceButton.layer.cornerRadius = 10
        artButton.layer.cornerRadius = 10
        sportButton.layer.cornerRadius = 10
        backButton.layer.cornerRadius = 10
        
        playerLabel.layer.masksToBounds = true
        playerLabel.layer.cornerRadius = 10
        
        playerLabel.text = playerController.activePlayer?.id
        
        updateColour()
        
        disableQuestionButton()
    }
    
    // setting player controller in destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is MainMenuViewController {
            let vc = segue.destination as? MainMenuViewController
            vc?.playerController = playerController
        }
        if segue.destination is SecondViewController {
            let vc = segue.destination as? SecondViewController
            vc?.questionSet = questionSet
            vc?.playerController = playerController
        }
    }
    
    // handling entertainment button press
    @IBAction func entertainmentButton(_ sender: Any) {
        questionSet = 0
        self.performSegue(withIdentifier: "secondViewSegue", sender: sender)
    }
    
    // handling science button press
    @IBAction func scienceButton(_ sender: Any) {
        questionSet = 1
         self.performSegue(withIdentifier: "secondViewSegue", sender: sender)
    }
    
    // handling art button press
    @IBAction func artButton(_ sender: Any) {
        questionSet = 2
         self.performSegue(withIdentifier: "secondViewSegue", sender: sender)
    }
    
    // handling sport button press
    @IBAction func sportButton(_ sender: Any) {
        questionSet = 3
         self.performSegue(withIdentifier: "secondViewSegue", sender: sender)
    }
    
    func disableQuestionButton() {
        
        var questionUsed = UserDefaults.standard.array(forKey: "QuestionsUsed") as? [[Bool]] ?? [[Bool]]()
        
        // if nothing is found in memory then the default will be called (all questions available)
        if questionUsed.isEmpty == false {
            // check if all entertainment questions have been used
            if checkArrayEqualsTrue(array: questionUsed[0]) {
                entertainmentButton.isEnabled = false
                entertainmentButton.backgroundColor = UIColor.darkGray
                entertainmentButton.setTitleColor(UIColor.gray, for: .normal)
            }
            // check if all science questions have been used
            if checkArrayEqualsTrue(array: questionUsed[1]) {
                scienceButton.isEnabled = false
                scienceButton.backgroundColor = UIColor.darkGray
                scienceButton.setTitleColor(UIColor.gray, for: .normal)
            }
            // check if all art questions have been used
            if checkArrayEqualsTrue(array: questionUsed[2]) {
                artButton.isEnabled = false
                artButton.backgroundColor = UIColor.darkGray
                artButton.setTitleColor(UIColor.gray, for: .normal)
            }
            // check if all sport questions have been used
            if checkArrayEqualsTrue(array: questionUsed[3]) {
                sportButton.isEnabled = false
                sportButton.backgroundColor = UIColor.darkGray
                sportButton.setTitleColor(UIColor.gray, for: .normal)
            }
        }
    }
    
    func checkArrayEqualsTrue(array: [Bool]) -> Bool {
        
        // go through each element in the array and check if it is true
        for elem in array {
            if elem != true {
                return false
            }
        }
        return true
    }
    
    
    // updating the colour of each button and label depending on the chosen theme
    func updateColour() {
        
        playerLabel.backgroundColor = getColour()
        
        entertainmentButton.backgroundColor = getColour()
        scienceButton.backgroundColor = getColour()
        artButton.backgroundColor = getColour()
        sportButton.backgroundColor = getColour()
        backButton.backgroundColor = getColour()
    }
}
