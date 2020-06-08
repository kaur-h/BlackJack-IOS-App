//
//  ViewController.swift
//  BlackJack
//
//  Created by Harleen Kaur on 6/1/20.
//  Copyright © 2020 Harleen Kaur. All rights reserved.
//

import UIKit



class ViewController: UIViewController{

    var bj:BlackJack = BlackJack(num: 1)

    @IBOutlet weak var computerCard1: UIImageView!
    @IBOutlet weak var computerCard2: UIImageView!
    
    
    @IBOutlet weak var playerCard1: UIImageView!
    @IBOutlet weak var playerCard2: UIImageView!
    
    
    @IBOutlet weak var gameStatusLabel: UILabel!
    
    @IBOutlet weak var dealerCards: UIStackView!
    @IBOutlet weak var playerCards: UIStackView!
    
    
    
    @IBAction func dealButton(_ sender: Any) {
        
        clearDealerCards()
        clearPlayerCards()
        
        let c1 = UIImageView()
        c1.image = UIImage(named: "cardBack")
        dealerCards.addArrangedSubview(c1)
        
        let c2 = UIImageView()
        c2.image = UIImage(named: "cardBack")
        dealerCards.addArrangedSubview(c2)
        
        let p1 = UIImageView()
        p1.image = UIImage(named: "cardBack")
        playerCards.addArrangedSubview(p1)
        
        let p2 = UIImageView()
        p2.image = UIImage(named: "cardBack")
        playerCards.addArrangedSubview(p2)
        
        bj.deal()
        let dealerCard:[Card] = bj.getDealerCards()
        let playerCard:[Card] = bj.getPlayerCards()
        
        c2.image = UIImage(named: "\(dealerCard[0].value.rawValue)" + "\(dealerCard[0].suit.rawValue)")
        
        p1.image = UIImage(named: "\(playerCard[0].value.rawValue)" + "\(playerCard[0].suit.rawValue)")
        
        p2.image = UIImage(named: "\(playerCard[1].value.rawValue)" + "\(playerCard[1].suit.rawValue)")
        
        gameStatusLabel.adjustsFontSizeToFitWidth = true
        gameStatusLabel.text = "Game in Progress"
                
    }
    
    public func clearPlayerCards(){
        var count:Int = playerCards.arrangedSubviews.count
        while(count > 0){
            playerCards.arrangedSubviews[count - 1].removeFromSuperview()
            count = playerCards.arrangedSubviews.count
        }
    }
    
    public func clearDealerCards(){
        var count:Int = dealerCards.arrangedSubviews.count
        while(count > 0){
            dealerCards.arrangedSubviews[count - 1].removeFromSuperview()
            count = dealerCards.arrangedSubviews.count
        }
    }
    
    public func displayPlayerCards(){
        let playerCard:[Card] = bj.getPlayerCards()
        for i in 0..<playerCard.count{
            //print(i)
            let newCard = UIImageView()
            //print("\(playerCard[i].value.rawValue)" + "\(playerCard[i].suit.rawValue)")
            newCard.image = UIImage(named: "\(playerCard[i].value.rawValue)" + "\(playerCard[i].suit.rawValue)")
            playerCards.addArrangedSubview(newCard)
            playerCards.distribution = UIStackView.Distribution.fillEqually
            playerCards.updateConstraints()
        }
    }
    
    public func displayDealerCards(){
        let dealerCard:[Card] = bj.getDealerCards()
        for i in 0..<dealerCard.count{
            //print(i)
            let newCard = UIImageView()
            //print("\(playerCard[i].value.rawValue)" + "\(playerCard[i].suit.rawValue)")
            newCard.image = UIImage(named: "\(dealerCard[i].value.rawValue)" + "\(dealerCard[i].suit.rawValue)")
            dealerCards.addArrangedSubview(newCard)
            dealerCards.distribution = UIStackView.Distribution.fillEqually
            dealerCards.updateConstraints()
        }
    }
    
    @IBAction func hitButton(_ sender: Any) {
        bj.playerHit()
        clearPlayerCards()
        displayPlayerCards()

        let status:Int = bj.getGameStatus()
        if(status == 6){
            clearDealerCards()
            displayDealerCards()
            gameStatusLabel.textAlignment = .center
            gameStatusLabel.text = "Dealer Won"
        }else{
            gameStatusLabel.text = "Game in Progress"
        }
 
    }
    
    
    @IBAction func standButton(_ sender: Any) {
        bj.playerStand()
        clearDealerCards()
        displayDealerCards()
        let status:Int = bj.getGameStatus()
        if(status == 6){
            gameStatusLabel.textAlignment = .center
            gameStatusLabel.text = "Dealer Won"
        }
        if(status == 7){
            gameStatusLabel.textAlignment = .center
            gameStatusLabel.text = "Player Won"
        }
        if(status == 1){
            gameStatusLabel.textAlignment = .center
            gameStatusLabel.text = "Draw"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}

