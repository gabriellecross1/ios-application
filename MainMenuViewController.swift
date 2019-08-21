
//  MainMenuViewController.swift
//  AssignmentOne


import UIKit

class MainMenuViewController: UIViewController {
    
    var playerController: PlayerController!
    
    @IBOutlet weak var playGameButton: UIButton!
    @IBOutlet weak var rulesButton: UIButton!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var themeList = ["Maroon", "Orange", "Blue", "Green"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: getBackgroundImage(id: 0))
        
        playGameButton.layer.cornerRadius = 10
        rulesButton.layer.cornerRadius = 10
        dropDownButton.layer.cornerRadius = 10
        tableView.layer.cornerRadius = 10
        
        tableView.isHidden = true
        
        updateColour()
        
        // GABBY - use this to hard reset the questions
        //UserDefaults.standard.set([[false, false, false, false, false], [false, false, false, false, false], [false, false, false, false, false], [false, false, false, false, false]], forKey: "QuestionsUsed")
    }
    
    // setting player controller in destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ThirdViewController {
            let vc = segue.destination as? ThirdViewController
            vc?.playerController = playerController
        }
        if segue.destination is RulesViewController {
            let vc = segue.destination as? RulesViewController
            vc?.playerController = playerController
        }
        if segue.destination is ViewController {
            let vc = segue.destination as? ViewController
            vc?.playerController = playerController
        }
    }
    
    // creating animated dropdown button
    @IBAction func onClickDropButton(_ sender: Any) {
        
        if tableView.isHidden {
            animate(toggle: true)
        } else {
            animate(toggle: false)
        }
    }
    
    // determining which view controller to enter depending on whether the game has finished or not
    @IBAction func playGameButton(_ sender: Any) {
        
        if playerController.gameFinished {
            self.performSegue(withIdentifier: "goToGameSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: "playSegue", sender: self)
        }
    }
    
    // animate function used by theme button
    func animate(toggle: Bool) {
        
        if toggle {
            UIView.animate(withDuration: 0.3) {
                self.tableView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.tableView.isHidden = true
            }
        }
    }
    
    // updating the colour of each button depending on the chosen theme
    func updateColour() {
        
        playGameButton.backgroundColor = getColour()
        rulesButton.backgroundColor = getColour()
        dropDownButton.backgroundColor = getColour()
        self.view.backgroundColor = UIColor(patternImage: getBackgroundImage(id: 0))
    }
}


extension MainMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    // returns number of themes
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeList.count
    }
    
    // populates dropdown menu
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        cell.textLabel?.text = themeList[indexPath.row]
        return cell
    }
    
    // changes the colour of the theme
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(themeList[indexPath.row], forKey: "Colour")
        updateColour()
        animate(toggle: false)
    }
}
