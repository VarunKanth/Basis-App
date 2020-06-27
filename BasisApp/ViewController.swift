//
//  ViewController.swift
//  BasisApp
//
//  Created by Varun Kanth on 26/06/20.
//  Copyright © 2020 Varun Kanth. All rights reserved.
//

//Task:
//We have a set of bite-sized content showing a list of cards, similar to Google Primer app. Create an app to have swipe-able cards to read the content. You can find the content at https://git.io/fjaqJ . There should be provisions to:
//1. Fetch the data and display it as swipeable cards.
//2. Swipe the card to move to the next card.
//3. Go back to the previous card. (By swiping also. You can define the swiping gesture for previous card movement)
//4. Restart it from the beginning.
//5. Track the progress of the cards (Say, the current card is #4 out of 10, any indicator mentioning the progress.)
//Please note that every json response starts with a '/' character. You need to parse it accordingly.
//Your code will be judged on the basis of the architecture it follows and a proper separation of concerns.
//Notes:
//- Share the git repo link while submitting.
//- All libraries you can use as per your preferences.
//- Assume whatever you want and specify it accordingly.
//- The code should be properly commented and should be tracked well in git.
//- Follow the best practices - in your code and in git (proper commits & commit messages)
//- A detailed document is needed in README file quoting installation, deployment and working steps.
//- Production-grade code quality is expected, considering all corner cases.
//- Writing Unit and Integration Test for the use cases. (Bonus Point)
//
//Feel free to contact us in case of any queries or doubts.


import UIKit

//Model for the api response
struct BAResult: Codable{
    let data : [BACardData]?
}

struct BACardData: Codable{
    let id: String?
    let text: String?
}

class ViewController: UIViewController {

    @IBOutlet weak var card: UIView!

    @IBOutlet weak var cardProgressBar: UIProgressView!
    
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    var cardDataList : [BACardData] = []
    
    var divisionParam: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCardDataFromURL()
        divisionParam = (view.frame.size.width/2)/0.61
        // Do any additional setup after loading the view.
    }

    @IBAction func moveCard(_ sender: UIPanGestureRecognizer) {
        let cardView = sender.view!
        let translationPoint = sender.translation(in: view)
        cardView.center = CGPoint(x: view.center.x+translationPoint.x, y: view.center.y+translationPoint.y)
        
        let distanceMoved = cardView.center.x - view.center.x
        
        //Tilt your card
        cardView.transform = CGAffineTransform(rotationAngle: distanceMoved/divisionParam)
        
        if sender.state == UIGestureRecognizer.State.ended {
            if cardView.center.x < 20 { // Moved to left
                UIView.animate(withDuration: 0.3, animations: {
                    cardView.center = CGPoint(x: cardView.center.x-200, y: cardView.center.y)
                })
                return
            }
            else if (cardView.center.x > (view.frame.size.width-20)) { // Moved to right
                UIView.animate(withDuration: 0.3, animations: {
                    cardView.center = CGPoint(x: cardView.center.x+200, y: cardView.center.y)
                })
                return
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.resetCardViewToOriginalPosition()
            })
        }
    }
    
    func resetCardViewToOriginalPosition(){
        UIView.animate(withDuration: 0.3) {
            self.card.center = self.view.center
            self.card.transform = .identity
        }
    }
    
    @IBAction func resetCard(_ sender: UIButton) {
        resetCardViewToOriginalPosition()
    }
    
    func getCardDataFromURL(){
        if let url = URL(string: "https://git.io/fjaqJ") {
        
            // Create Request
            let sharedSession = URLSession.shared
            let request = URLRequest(url: url)

            // Create Data Task
            let dataTask = sharedSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if let data = data{
                    let decoder = JSONDecoder()
                    var resultString = String(data: data, encoding: .utf8)
                    resultString?.removeFirst()
                    let data = Data(resultString!.utf8)
                    if let baResultDecoded = try? decoder.decode(BAResult.self, from: data){
                        print(baResultDecoded)
                        if let list = baResultDecoded.data{
                            self.cardDataList = list
                        }
                    }
                }
            })
            dataTask.resume()

        }

    }
    

}


