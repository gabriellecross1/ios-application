
//  SecondViewController.swift
//  AssignmentOne

import UIKit

// creating a question struct with relevant information
struct Question {
    var Question : String!
    var Answers : [String]!
    var Answer : Int!
}

class SecondViewController: UIViewController {
    
    var playerController: PlayerController!

    @IBOutlet weak var QLabel: UILabel!
    @IBOutlet weak var attemptLabel: UILabel!
    @IBOutlet var Buttons: [UIButton]!
    @IBOutlet weak var myTimerLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var questionUsed = [[Bool]]()
    var questions = [[Question]]()
    var questionSet = Int()
    var QNumber = Int()
    var AnswerNumber = Int()
    var attemptsRemaining = Int()
    var playerAnswer = Bool()
    
    var timer = Timer()
    var seconds = 15
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: getBackgroundImage(id: 1))
        
        for button in Buttons {
            button.layer.cornerRadius = 10
        }
        
        updateQuestionsUsed()
        updateRound()
        updateAttemptLabel()
        updateColour()
        
        // setting up question categories
        questions = [
            
            // entertainment questions
            [Question(Question: "Which tech company is known for it's iOS operating system?", Answers: ["Microsoft","Samsung","Apple","Amazon"], Answer: 2),
             Question(Question: "Which British actor played Loki in Avengers Assemble?", Answers: ["Chris Evans","Tom Hiddleston","Liam Hemsworth","Ryan Reynolds"], Answer: 1),
             Question(Question: "Coco, Cars and Inside Out are all films produced by which US animated film company?", Answers: ["Pixar","Dreamworks","Studio Ghibli","Disney"], Answer: 0),
             Question(Question: "In the 2017 film The Greatest Showman who played star performer P.T. Barnum?", Answers: ["Zac Efron","Russell Crow","Ewan McGregor","Hugh Jackman"], Answer: 3),
             Question(Question: "What colour is the 'L' in the Google logo?", Answers: ["Red","Green","Yellow","Blue"], Answer: 1)],
            
            // science questions
            [Question(Question: "What colour is the gemstone Amethyst?", Answers: ["Purple","Red","Blue","Orange"], Answer: 0),
             Question(Question: "In the periodic table, what is the symbol for Zirconium?", Answers: ["Zm","Z","Zi","Zr"], Answer: 3),
             Question(Question: "Dry ice is a frozen form of which gas?", Answers: ["Nitrogen","Hydrogen","Carbon Dioxide","Carbon Monoxide"], Answer: 2),
             Question(Question: "What is the largest fish in the world?", Answers: ["Basking Shark","The Whale Shark","Beluga","Great White Shark"], Answer: 1),
             Question(Question: "Diamonds are a form of which chemical element?", Answers: ["Mercury","Iron","Potassium","Carbon"], Answer: 3)],
            
            // art & literature questions
            [Question(Question: "Hermes is the Greek god of: ", Answers: ["Roads","War","Fire","Land"], Answer: 0),
             Question(Question: "In which author's work might you find the Bolger, Brandybuck and Gamgee families?", Answers: ["J.K Rowling","Stephen Hawking","J.R.R Tolkien","George R. R. Martin"], Answer: 2),
             Question(Question: "Which is the third sign of the Zodiac to be associated with water, the other two being Pisces and Cancer?", Answers: ["Gemini","Leo","Libra","Scorpio"], Answer: 3),
             Question(Question: "Hamlet was the Prince of which country?", Answers: ["Ukraine","Norway","Denmark","Finland"], Answer: 2),
             Question(Question: "What was Louisa Mary Alcott's most famous book?", Answers: ["Little Women","Pride & Predudice","Catcher In The Rye","The Great Gatsby"], Answer: 0)],
            
            // sports & leisure questions
            [Question(Question: "How long in yards is a cricket pitch?", Answers: ["18 yards","24 yards","20 yards","22 yards"], Answer: 3),
             Question(Question: "What activity is pursued by campanologists?", Answers: ["Camping","Bell Ringing","Umpiring","Jump Roping"], Answer: 1),
             Question(Question: "How long is an Olympic rowing course?", Answers: ["2,000m","2,500m","1,500m","3,000m"], Answer: 0),
             Question(Question: "What vegetable is used if a dish is cooked Florentine?", Answers: ["Kale","Avocado","Spinach","Cucumber"], Answer: 2),
             Question(Question: "In which sport is the Vince Lombardi Trophy awarded?", Answers: ["Hockey","American Football","Basketball","Golf"], Answer: 1)]
        ]
        
        // setting a random question
        RandomQuestion()
        
        // setting timer for answering questions
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(myClock), userInfo: nil, repeats:true)
        myTimerLabel.text = String(seconds)
    }
    
    // setting player controller in destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is ViewController {
            let vc = segue.destination as? ViewController
            vc?.playerController = playerController
        }
        if segue.destination is ThirdViewController {
            let vc = segue.destination as? ThirdViewController
            vc?.playerController = playerController
        }
    }
    
    @IBAction func Btn1(_ sender: Any) {
        answerAttempted(number: 0)
    }
    
    @IBAction func Btn2(_ sender: Any) {
        answerAttempted(number: 1)
    }
    
    @IBAction func Btn3(_ sender: Any) {
        answerAttempted(number: 2)
    }
    
    @IBAction func Btn4(_ sender: Any) {
        answerAttempted(number: 3)
    }
    
    // creating a clock function used by the timer
    func myClock() {
        
        seconds=seconds-1
        myTimerLabel.text = String(seconds)
        
        // when timer reaches 0 change label text
        if (seconds == 0) {
            myTimerLabel.text = "TIME IS UP!"
            
            // invalidate timer
            timer.invalidate()
            // set new timer to transition back to question set view controller
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(infoTimeOut), userInfo: nil, repeats:true)
        }
    }
    
    // function used to transition to different view controllers
    func infoTimeOut() {
        
        if playerAnswer {
            self.performSegue(withIdentifier: "gameSegue", sender: self)
        }
        else {
            playerController.changePlayer()
            self.performSegue(withIdentifier: "playerSelectSegue", sender: self)
        }
        timer.invalidate()
    }
    
    // loads questions that have already been used from memory
    func updateQuestionsUsed() {
        
        questionUsed = UserDefaults.standard.array(forKey: "QuestionsUsed") as? [[Bool]] ?? [[Bool]]()
        
        // if nothing is found in memory then the default will be called (all questions available)
        if questionUsed.isEmpty {
            questionUsed = [[false, false, false, false, false], [false, false, false, false, false], [false, false, false, false, false], [false, false, false, false, false]]
        }
    }
    
    // update round
    func updateRound() {
        
        playerController.incrementRound()
        
        // depending on which round the player is in, they will get 1 or 2 attempts to answer the question
        if (playerController.activePlayer?.round)! > 1 {
            attemptsRemaining = 1
        } else {
            attemptsRemaining = 2
        }
    }
    
    // update label text depending on attempts remaining
    func updateAttemptLabel() {
        
        attemptLabel.text = "Attempts Remaining: \(attemptsRemaining)"
    }
    
    // generates random question
    func RandomQuestion() {
        
        if questions[questionSet].count > 0 {
            // generate a random question from the chosen question set and checking if it has been used before
            // repeats this process until a question is found that hasn't been used
            repeat {
                QNumber = Int(arc4random_uniform(UInt32(questions[questionSet].count)))
            } while questionUsed[questionSet][QNumber] == true
            
            // updating question used array
            questionUsed[questionSet][QNumber] = true
            
            // updates question label depending on which question has been picked
            QLabel.text = questions[questionSet][QNumber].Question
            
            // setting answer number
            AnswerNumber = questions[questionSet][QNumber].Answer
            
            // updating button text with relevant answers
            for i in 0..<(Buttons.count-1) {
                Buttons[i].setTitle(questions[questionSet][QNumber].Answers[i], for: .normal)
            }
            // saving questions used to memory
            UserDefaults.standard.set(questionUsed, forKey: "QuestionsUsed")
        }
    }
    
    // function called when an answer button is pressed
    func answerAttempted(number: Int) {
        
        attemptsRemaining -= 1
        updateAttemptLabel()
        
        // if the player answers correctly
        if AnswerNumber == number {
            
            // update label text
            infoLabel.text = ("CORRECT!")
            playerAnswer = true
            infoLabel.isHidden = false
            
            // disabling all buttons once a selection has been made
            for button in Buttons {
                button.isEnabled = false
            }
            
            // updating score
            updateScore()
            
            // invalidates timer
            timer.invalidate()
            
            // set new timer to transition back to question set view controller
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(infoTimeOut), userInfo: nil, repeats:true)
        } else {
            // if the player has another chance to answer, update label text
            if attemptsRemaining == 1 {
                infoLabel.text = ("TRY AGAIN!")
            } else {
                infoLabel.text = ("INCORRECT!")
                playerAnswer = false
                infoLabel.isHidden = false
                
                // disabling all buttons once a selection has been made
                for button in Buttons {
                    button.isEnabled = false
                }
                
                // invalidates timer
                timer.invalidate()
                
                // set new timer to transition back to question set view controller
                timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(infoTimeOut), userInfo: nil, repeats:true)
            }
        }
    }
    
    // calculate players score
    func updateScore() {
        
        if seconds >= 10 {
            playerController.updateScore(score: 3)
        } else if seconds >= 5 {
            playerController.updateScore(score: 2)
        } else {
            playerController.updateScore(score: 1)
        }
    }
    
    // updating the colour of each button depending on the chosen theme
    func updateColour() {
    
        for button in Buttons { 
            button.backgroundColor = getColour()
        }
    }
}
