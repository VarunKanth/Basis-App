//
//  ViewController.swift
//  BasisApp
//
//  Created by Varun Kanth on 26/06/20.
//  Copyright © 2020 Varun Kanth. All rights reserved.
//


import UIKit
import CardsLayout

//Model for the api response
struct BAResult: Codable{
    let data : [BACardData]?
}

struct BACardData: Codable{
    let id: String?
    let text: String?
}

class ViewController: UIViewController {

    @IBOutlet weak var cardProgressBar: UIProgressView!
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    var cardDataList : [BACardData] = []
    
    var divisionParam: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getCardDataFromURL()
    }
    
    func setupCollectionView(){
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        let layout = CardsCollectionViewLayout()
        cardCollectionView.collectionViewLayout = layout
        cardCollectionView.isPagingEnabled = true
        cardCollectionView.showsHorizontalScrollIndicator = false
    }
    
    @IBAction func resetCard(_ sender: UIButton) {
        cardCollectionView.reloadData()
        cardCollectionView.layoutIfNeeded()
        CardsCollectionViewLayout().prepare()
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
                        if let list = baResultDecoded.data{
                            self.cardDataList = list
                            DispatchQueue.main.async {
                                self.cardCollectionView.reloadData()
                            }
                        }
                    }
                }
            })
            dataTask.resume()

        }

    }
    

}

extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardCollectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
        cell.layer.cornerRadius = 7.0
        cell.cardText.text = cardDataList[indexPath.item].text ?? ""
        cell.backgroundColor = UIColor(displayP3Red: 77/255, green: 194/255, blue: 135/255, alpha: 1)
        return cell
    }
    
}


