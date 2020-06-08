//
//  ViewController.swift
//  BlackJack
//
//  Created by Harleen Kaur on 6/1/20.
//  Copyright © 2020 Harleen Kaur. All rights reserved.
//

import UIKit

public enum CardSuit: String, CaseIterable{
    case SPADES = "s"
    case HEARTS = "d"
    case DIAMONDS = "h"
    case CLUBS = "c"
}

public enum CardValue: String, CaseIterable{
    case Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9", Ten = "10"
    case Ace = "1", Jack = "J", Queen = "Q", King = "K"
}

public class Card{
    var value: CardValue
    var suit: CardSuit
    var faceUp: Bool
    
    init(_ val: CardValue, _ su: CardSuit) {
        value = val
        suit = su
        faceUp = true
    }
    
    func getValue() -> CardValue {
        return value
    }
    
    func getSuit() -> CardSuit{
        return suit
    }
    
    func isFacedUp() -> Bool{
        return faceUp
    }
    
    func setFaceUp(){
        faceUp = true
    }
    
    func setFaceDown(){
        faceUp = false
    }
    
    func equals(o: Card) -> Bool{
        if (o.getValue() == value) && (o.getSuit() == suit){
            return true
        }
        return false
    }
}

public class BlackJackEngine{
    public let DRAW = 1
    public let LESS_THAN_21 = 2
    public let BUST = 3
    public let BLACKJACK = 4
    public let HAS_21 = 5
    public let DEALER_WON = 6
    public let PLAYER_WON = 7
    public let GAME_IN_PROGRESS = 8
    
    init() {
    }
}

public class BlackJack: BlackJackEngine{
    private var numberOfDecks: Int
    private var accBalance: Int
    private var betAmount: Int
    private var gameDeck = [Card]()
    private var playerDeck = [Card]()
    private var dealerDeck = [Card]()
    private var gameStatus: Int
    
    init(num : Int) {
        numberOfDecks = num
        accBalance = 200
        betAmount = 5
        gameStatus = 0
    }
    
    public func getNumberofDecks() -> Int {
        return self.numberOfDecks
    }
    
    public func createAndShuffleGameDeck(){
        for i in 0..<numberOfDecks{
            for cs in CardSuit.allCases{
                for cv in CardValue.allCases{
                    let c: Card = Card(cv,cs)
                    gameDeck.append(c)
                }
            }
        }
        gameDeck.shuffle()
        
        /*for element in gameDeck{
             print(element.suit)
             print(element.value)
         }*/
    }
    
    public func getGameDeck() -> [Card]{
        var deck = [Card]()
        for i in 0..<gameDeck.count{
            deck.insert(gameDeck[i], at: i)
        }
        return deck
    }
    
    public func deal(){
        gameDeck.removeAll()
        playerDeck.removeAll()
        dealerDeck.removeAll()
        createAndShuffleGameDeck()
        for i in 0..<4{
            if i % 2 == 0{
                let c:Card = gameDeck[0]
                c.setFaceUp()
                playerDeck.append(c)
                gameDeck.remove(at: 0)
            }else{
                let c:Card = gameDeck[0]
                if(i == 1){
                    c.setFaceDown()
                }
                else{
                c.setFaceUp()
                }
                dealerDeck.append(c)
                gameDeck.remove(at: 0)
            }
        }
        /*print("Player Deck")
        for element in playerDeck{
            print(element.getSuit())
            print(element.getValue())
        }
        print("Dealer Deck")
        for element in dealerDeck{
            print(element.getSuit())
            print(element.getValue())
        }*/
        
        gameStatus = GAME_IN_PROGRESS
        accBalance -= betAmount
    }
    
    public func getDealerCards() -> [Card]{
        var deck = [Card]()
        for i in 0..<dealerDeck.count{
            deck.insert(dealerDeck[i], at: i)
        }
        return deck
    }
    
    private func isAce(checkDeck: [Card]) -> Bool{
        var isAceCard:Bool = false
        for i in 0..<checkDeck.count{
            if checkDeck[i].getValue().rawValue == "1"{
                isAceCard = true
            }
        }
        return isAceCard
    }
    
    private func isFace(checkDeck: [Card]) ->Bool{
        var isFaceCard:Bool = false
        for i in 0..<checkDeck.count{
            let check:String = checkDeck[i].getValue().rawValue
            if check == "J" || check == "Q" || check == "K"{
                isFaceCard = true
            }
        }
        return isFaceCard
    }
    
    private func getIntCardValue(value: String) ->Int{
        if value == "J" || value == "Q" || value == "K"{
            return 10
        }
        else{
            return Int(value) ?? 0
        }
    }
    
    public func getDealerCardsTotal() -> [Int]{
        var total:Int = 0
        var dealerCardsTotal = [Int]()
        
        for i in 0..<dealerDeck.count{
            let type:String = dealerDeck[i].getValue().rawValue
            total += getIntCardValue(value: type)
        }
        
        if total > 21{
            return dealerCardsTotal
        }
        
        if (isAce(checkDeck: dealerDeck)){
            if (total + 10) > 21{
                dealerCardsTotal.append(total)
            }
            else{
                dealerCardsTotal.append(total)
                dealerCardsTotal.append(total + 10)
            }
        }
        else{
            dealerCardsTotal.append(total)
        }
        
        return dealerCardsTotal
    }
    
    public func getDealerCardsEvaluation() -> Int{
        let dealerCardsTotal:[Int] = getDealerCardsTotal()
        var dealerCardsEval:Int = 0
        
        if(dealerCardsTotal.count == 0){
            dealerCardsEval = BUST
            return dealerCardsEval
        }
        
        if(dealerCardsTotal.count == 1){
            if(dealerCardsTotal[0] < 21){
                dealerCardsEval = LESS_THAN_21
            }
            if(dealerCardsTotal[0] == 21){
                if(dealerDeck.count == 2 && isAce(checkDeck: dealerDeck) && isFace(checkDeck: dealerDeck)){
                    dealerCardsEval = BLACKJACK
                }
                else{
                    dealerCardsEval = HAS_21
                }
            }
        }
        
        if(dealerCardsTotal.count == 2){
            if(dealerCardsTotal[0] < 21 && dealerCardsTotal[1] < 21){
                dealerCardsEval = LESS_THAN_21
            }
            if(dealerCardsTotal[0] == 21 || dealerCardsTotal[1] == 21){
                if(dealerDeck.count == 2 && isAce(checkDeck: dealerDeck) && isFace(checkDeck: dealerDeck)){
                    dealerCardsEval = BLACKJACK
                }
                else{
                    dealerCardsEval = HAS_21
                }
            }
        }
        return dealerCardsEval
    }
    public func getPlayerCards() ->[Card]{
        var deck = [Card]()
        for i in 0..<playerDeck.count{
                   deck.insert(playerDeck[i], at: i)
        }
      return deck
    }
    
    public func getPlayerCardsTotal()->[Int]{
        var total:Int = 0
        var playerCardsTotal = [Int]()
        
        for i in 0..<playerDeck.count{
            let type:String = playerDeck[i].getValue().rawValue
            total += getIntCardValue(value: type)
        }
        
        if total > 21{
            return playerCardsTotal
        }
        
        if (isAce(checkDeck: playerDeck)){
            if (total + 10) > 21{
                playerCardsTotal.append(total)
            }
            else{
                playerCardsTotal.append(total)
                playerCardsTotal.append(total + 10)
            }
        }
        else{
            playerCardsTotal.append(total)
        }
        
        return playerCardsTotal
    }
    
    public func getPlayerCardsEvaluation() -> Int{
        let playerCardsTotal:[Int] = getPlayerCardsTotal()
        var playerCardsEval:Int = 0
        
        if(playerCardsTotal.count == 0){
            playerCardsEval = BUST
            return playerCardsEval
        }
        
        if(playerCardsTotal.count == 1){
            if(playerCardsTotal[0] < 21){
                playerCardsEval = LESS_THAN_21
            }
            if(playerCardsTotal[0] == 21){
                if(playerDeck.count == 2 && isAce(checkDeck: playerDeck) && isFace(checkDeck: playerDeck)){
                    playerCardsEval = BLACKJACK
                }
                else{
                    playerCardsEval = HAS_21
                }
            }
        }
        
        if(playerCardsTotal.count == 2){
            if(playerCardsTotal[0] < 21 && playerCardsTotal[1] < 21){
                playerCardsEval = LESS_THAN_21
            }
            if(playerCardsTotal[0] == 21 || playerCardsTotal[1] == 21){
                if(playerDeck.count == 2 && isAce(checkDeck: playerDeck) && isFace(checkDeck: playerDeck)){
                    playerCardsEval = BLACKJACK
                }
                else{
                    playerCardsEval = HAS_21
                }
            }
        }
        return playerCardsEval
    }
    
    public func playerHit(){
        let c:Card = gameDeck[0]
        c.setFaceUp()
        playerDeck.append(c)
        gameDeck.remove(at: 0)
        let playerEval:Int = getPlayerCardsEvaluation()
        if(playerEval == BUST){
            gameStatus = DEALER_WON
        }
        else{
            gameStatus = GAME_IN_PROGRESS
        }
    }
    
    private func getMax(cardsTotal:[Int]) -> Int{
        var value:Int = 0
        if(cardsTotal.count == 0){
            return value
        }
        else if(cardsTotal.count == 1){
            value = cardsTotal[0]
        }
        else if cardsTotal.count == 2{
            value = max(cardsTotal[0], cardsTotal[1])
        }
        return value
    }
    
    public func playerStand(){
        var dealerEval:Int = getDealerCardsEvaluation()
        let playerEval:Int = getPlayerCardsEvaluation()
        dealerDeck[0].setFaceUp()
        
        var dealerCardsTotal:[Int] = getDealerCardsTotal()
        let playerCardsTotal:[Int] = getPlayerCardsTotal()
        var value:Int = getMax(cardsTotal: dealerCardsTotal)
        
        while value < 16 && dealerEval != BUST {
            let c:Card = gameDeck[0]
            c.setFaceUp()
            dealerDeck.append(c)
            gameDeck.remove(at: 0)
            
            dealerCardsTotal = getDealerCardsTotal()
            dealerEval = getDealerCardsEvaluation()
            
            value = getMax(cardsTotal: dealerCardsTotal)
            
            if(value == 0){
                dealerEval = BUST
                gameStatus = PLAYER_WON
                break
            }
        }
        
        if(dealerEval == BLACKJACK && (playerEval == LESS_THAN_21 || playerEval == HAS_21)){
            gameStatus = DEALER_WON
        }
        if(dealerEval == BLACKJACK && playerEval == BLACKJACK){
            gameStatus = DRAW
        }
        if(dealerEval == HAS_21 && playerEval == LESS_THAN_21){
            gameStatus = DEALER_WON
        }
        if(playerEval == BLACKJACK && (dealerEval == LESS_THAN_21 || dealerEval == HAS_21)){
            gameStatus = PLAYER_WON
        }
        if(playerEval == HAS_21 && dealerEval == LESS_THAN_21){
            gameStatus = PLAYER_WON
        }
        if(dealerEval == LESS_THAN_21 && playerEval == LESS_THAN_21){
            let playerVal:Int = getMax(cardsTotal: playerCardsTotal)
            let dealerVal:Int = getMax(cardsTotal: dealerCardsTotal)
            
            if(playerVal  > dealerVal){
                gameStatus = PLAYER_WON
            }
            else if(dealerVal > playerVal){
                gameStatus = DEALER_WON
            }
            else if(dealerVal == playerVal){
                gameStatus = DRAW
            }
        }
    }
    
    public func getGameStatus() -> Int{
        return gameStatus
    }
}

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
        
        
        // let newCard = UIImageView()
        //print(dealerCard.count)
        /*
        for i in 0..<dealerCard.count{
            print(i)
            let cs:CardSuit = dealerCard[i].suit
            let cv:CardValue = dealerCard[i].value
            print("\(cv.rawValue)" + "\(cs.rawValue)")
            newCard.image = UIImage(named: "\(cv.rawValue)" + "\(cs.rawValue)")
            dealerCards.distribution = UIStackView.Distribution.fillEqually
            dealerCards.addArrangedSubview(newCard)
        }
        */
        
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

