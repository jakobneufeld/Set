//
//  OldViewController.swift
//  Set
//
//  Created by Niko Neufeld on 24.08.19.
//  Copyright © 2019 Niko Neufeld. All rights reserved.
//
//
import Foundation
//
//  ViewController.swift
//  Set
//
//  Created by Niko Neufeld on 6/29/19.
//  Copyright © 2019 Niko Neufeld. All rights reserved.
//

import UIKit

class OlDViewController: UIViewController {
    var game = Game(numOfCardsVisible: 12)
    var hasToDelete = false
    var score = 0
    var cardsSelected: [Card] = []
    var buttonsSelected: [UIButton] = []
    
    
    @IBAction func deal(_ sender: UIButton) {
        if game.cardsVisible.count == butttons.count {
            var oldVisiCards = game.cardsVisible
            var cardsToReplace = game.replaceNewCards(amount: 3)
            let cardsToUpdate = game.cardsVisible.filter { a in
                return oldVisiCards.contains(a)
            }
            for i in 0...2 {
                //  game.cardsVisible
            }
            
            updateButtons()
        } else {
            let oldVisibleCards = game.cardsVisible
            for card in game.cardsVisible {
                for button in butttons {
                    if buttonToCard[button] == nil {
                        buttonToCard[button] = card
                        break
                    }
                }
            }
            game.dealNewCards(amount: 3)
            let cardsToUpdate = game.cardsVisible.filter { a in
                return oldVisibleCards.contains(a)
            }
            for i in 0..<cardsToUpdate.count {
                //          let button = buttonCards[cardsToUpdate[i]]
                //    button?.isHidden = false
            }
            
        }
    }
    
    func updateButtons() {
        for button in butttons {
            if let card = buttonToCard[button] {
                button.setAttributedTitle(stringFor(card: card), for: UIControl.State.normal)
                
                // button.setTitle("Bla", for: UIControl.State.normal)
                //let attributes = [NSAttributedString.Key.foregroundColor: UIColor.green]
                //button.setAttributedTitle(NSAttributedString(string: "▲", attributes: attributes), for: UIControl.State.normal)
                //button.setAttributedTitle(stringFor(card: Card(isSelected: false, shading: Shading.striped, color: Color.green, shape: Shape.triangle, amount: 3)), for: .normal)
            } else {
                button.alpha = 100
            }
        }
    }
    
    var cardButtons: [UIButton: Card] = [:]
    @IBAction func cardTouched(_ sender: UIButton) {
        if sender.alpha == 0 {
            return
        }
        cardsSelected.append(buttonToCard[sender]!)
        buttonsSelected.append(sender)
        sender.layer.borderColor = UIColor.yellow.cgColor
        if cardsSelected.contains(buttonToCard[sender]!) {
            let color = sender.backgroundColor?.cgColor
            sender.layer.borderColor = color
            score -= 2
        }
        if cardsSelected.count == 3, buttonsSelected.count == 3{
            let result = Card.isAMatch(a: cardsSelected[0], b: cardsSelected[1], c: cardsSelected[2])
            if result && hasToDelete {
                for button in buttonsSelected{
                    let color = button.backgroundColor
                    button.layer.borderColor = color?.cgColor
                }
                buttonsSelected.removeAll()
                score += 5
                hasToDelete = false
            } else if result && !hasToDelete {
                hasToDelete = true
            } else {
                for button in buttonsSelected{
                    let color = button.backgroundColor
                    button.layer.borderColor = color?.cgColor
                }
                buttonsSelected.removeAll()
                score -= 5
            }
        }
    }
    
    @IBOutlet var butttons: [UIButton]!
    var buttonToCard: [UIButton: Card] = [:]
    var cardToButton: [Card: UIButton] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.dealNewCards(amount: 12)
        for card in game.cardsVisible {
            for button in butttons {
                if buttonToCard[button] == nil {
                    buttonToCard[button] = card
                    break
                }
            }
        }
        
        //        for (button, card) in cardButtons {
        //            buttonToCard[card] = button
        //        }
        updateButtons()
    }
}

func stringFor(card: Card) -> NSAttributedString {
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

extension Dictionary {
    public init(keys: [Key], values: [Value]) {
        precondition(keys.count == values.count)
        
        self.init()
        
        for (index, key) in keys.enumerated() {
            self[key] = values[index]
        }
    }
}
