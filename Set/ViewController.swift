//
//  ViewController.swift
//  Set
//
//  Created by Niko Neufeld on 6/29/19.
//  Copyright © 2019 Niko Neufeld. All rights reserved.
//

import UIKit
extension UIButton {
    var isVisible: Bool {
        get {
            return self.alpha > 0.0
        }
        set {
            self.alpha = newValue ? 1.0 : 0.0
        }
    }
    var isClicked: Bool {
        get {
            return self.backgroundColor == UIColor.white ? false : true
        }
        set {
            self.backgroundColor = newValue ? UIColor.yellow : UIColor.white
        }
    }
    var isPartOfMatch: Bool {
        get {
            return self.isSelected
        }
        set {
            self.isSelected = newValue
        }
    }
}

class ViewController: UIViewController {
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var game = Game(numOfCardsVisible: 12)
    var buttonToCard = [UIButton:Card]()
    var selectedButtons = Set<UIButton>()
    @IBAction func cardTouched(_ sender: UIButton) {
        if selectedButtons.count == 3 && selectedButtons.contains(sender) {
            var _card = selectedButtons.map {buttonToCard[$0]!}
            if Card.isAMatch(a: _card[0], b: _card[1], c: _card[2]) {
                game.removeCards(_card)
                selectedButtons.forEach {$0.isClicked = false; $0.isVisible = false;$0.isPartOfMatch = true;}
                if game.stackEmpty{dealButton.isEnabled = false; return}
                dealButton.isEnabled = true
                let newCards = game.dealNewCards()
                for card in newCards {
                    placeCard(card)
                    print("arghhhh")
                }
                score += 5
                selectedButtons.removeAll()
            }
            return
        }
        if !sender.isVisible {
            return
        }
        if selectedButtons.contains(sender){
            print("Aahaha")
            score -= 1
            // user clicks previously selected item - unselect
            sender.isClicked = false
            selectedButtons.remove(sender)
            return
        }
        if selectedButtons.count < 3 {
            sender.isClicked = true
            sender.isPartOfMatch = false
            selectedButtons.insert(sender)
            if selectedButtons.count == 3 {
                var _card = selectedButtons.map {buttonToCard[$0]!}
                if Card.isAMatch(a: _card[0], b: _card[1], c: _card[2]) {
                    selectedButtons.forEach {
                        $0.isSelected = false
                        $0.isPartOfMatch = true
                    }
                    if game.stackEmpty{dealButton.isEnabled = false; return}
                    dealButton.isEnabled = true
                }
            }
            return
        }
        /*
        var _card = [Card]()
        var i = 0
        for button in selectedButtons {
            _card[i] = buttonToCard[button]!
            i += 1
        }
        */
        var _card = selectedButtons.map {buttonToCard[$0]!}
        if Card.isAMatch(a: _card[0], b: _card[1], c: _card[2]) {
            game.removeCards(_card)
            selectedButtons.forEach {$0.isClicked = false; $0.isVisible = false;$0.isPartOfMatch = true;}
            if game.stackEmpty{dealButton.isEnabled = false; return}
            dealButton.isEnabled = true
            let newCards = game.dealNewCards()
            for card in newCards {
                placeCard(card)
                print("arghhhh")
            }
            score += 5
        } else {
            selectedButtons.forEach {$0.isClicked = false}
            score -= 5
        }
        selectedButtons.removeAll()
        selectedButtons.insert(sender)
        sender.isClicked = true
    }
    
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    @IBAction func deal(_ sender: UIButton) {
        if selectedButtons.count == 3 {
            var _card = selectedButtons.map {buttonToCard[$0]!}
            if Card.isAMatch(a: _card[0], b: _card[1], c: _card[2]) {
                game.removeCards(_card)
                selectedButtons.forEach {$0.isClicked = false; $0.isVisible = false; $0.isPartOfMatch = true}
                if game.stackEmpty {dealButton.isEnabled = false; return}
                dealButton.isEnabled = true
                let newCards = game.dealNewCards()
                for card in newCards {
                    print("Yay")
                    placeCard(card)
                }
                score += 5
                selectedButtons.removeAll()
                return
            } else {
                selectedButtons.forEach {$0.isClicked = false; $0.isVisible = true}
                let newCards = game.dealNewCards()
                if game.stackEmpty || game.cardsVisible.count == 24 {
                    dealButton.isEnabled = false
                    return
                }
                for card in newCards {
                    placeCard(card)
                    print("arghhhh")
                }
                selectedButtons.removeAll()
                score -= 5
                return

            }
        }
        if game.stackEmpty || game.cardsVisible.count == 24 {
            dealButton.isEnabled = false
            return
        }
        let newCards = game.dealNewCards()
        for card in newCards {
            placeCard(card)
        }
        if game.stackEmpty || game.cardsVisible.count == 24 {
            dealButton.isEnabled = false
            return
        }
        
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    var defaultColor = UIColor.white
    override func viewDidLoad() {
        reset()
        newGame()
    }
    @IBAction func newGame(_ sender: UIButton) {
        reset()
        newGame()
    }
    
    func placeCard(_ card: Card) {
        for button in buttons {
            if !button.isVisible {
                button.setAttributedTitle(stringFor(card), for: UIControl.State.normal)
                button.isVisible = true
                button.isPartOfMatch = false
                buttonToCard[button] = card
                return
            }
        }
    }
    
    func newGame() {
        let cards = game.newGame(12)
        for card in cards {
            placeCard(card)
        }
        score = 0
        
    }
    
    func reset() {
        selectedButtons.removeAll()
        dealButton.isEnabled = true
        dealButton.backgroundColor = .green
        for button in buttons {
            button.isVisible = false
            button.isClicked = false
            button.isPartOfMatch = false
            button.backgroundColor = .white
        }
    }
    
    func stringFor(_ card: Card) -> NSAttributedString {
        var emojis = [Shape.triangle : "▲" , Shape.circle : "●" , Shape.square : "■" ]
        
        var attributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 60.0)]
                //preferredFont(forTextStyle: .body).withSize(60.0)]
        switch card.color {
        case .green:
            attributes = [NSMutableAttributedString.Key.foregroundColor: UIColor.green, NSMutableAttributedString.Key.strokeColor: UIColor.green]
        case .red:
            attributes = [NSMutableAttributedString.Key.foregroundColor: UIColor.red, NSMutableAttributedString.Key.strokeColor: UIColor.red]
        case .blue:
            attributes = [NSMutableAttributedString.Key.foregroundColor: UIColor.blue, NSMutableAttributedString.Key.strokeColor: UIColor.blue]
        }
        switch card.shading {
        case .open:
            attributes[NSMutableAttributedString.Key.foregroundColor] = UIColor.white
            attributes[NSMutableAttributedString.Key.strokeWidth] =  4.0
        case .striped:
        attributes[NSAttributedString.Key.strokeWidth] = 4.0
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.blue
        shadow.shadowBlurRadius = 5
        attributes[.shadow] = shadow

        case .filled:
            break
  //          attributes[NSAttributedString.Key.strokeWidth] = 4.0
         }
        return NSAttributedString(string: (card.amount == 1) ? emojis[card.shape]! : (card.amount == 2) ? emojis[card.shape]! + emojis[card.shape]! : emojis[card.shape]! + emojis[card.shape]! + emojis[card.shape]!, attributes: attributes)
     }


}
