//
//  Set.swift
//  Set
//
//  Created by Jakob Neufeld on 6/29/19.
//  Copyright © 2019 Jakob Neufeld. All rights reserved.
//

import Foundation
class Game {
    func removeCards(_ cards: [Card]) {
        cardsRemoved.append(contentsOf: cardsVisible.map {cardsVisible.remove(at: cardsVisible.firstIndex(of: $0)!)})
    }
    @discardableResult
    func newGame(_ num: Int) -> [Card] {
        cards = []
        cardsVisible = []
        cardsRemoved = []
        for shading in Shading.allCases {
            for color in Color.allCases {
                for shape in Shape.allCases {
                    for amount in 1...3 {
                        cards.append(Card(isSelected: false, shading: shading, color: color, shape: shape, amount: amount))
                    }
                }
            }
        }
        shuffle()
        cardsVisible = []
        
    return dealNewCards(amount: num)
        
        
    }
    var numOfVisibleCards: Int {
        return cardsVisible.count
    }
    var numCards: Int {
        return cards.count
    }
    var score = 0
    var cards: [Card] // full deck of not played cards
    var cardsVisible: [Card] // cards which are currently face up in front of the player
    var cardsRemoved: [Card] // cards which have been found and selected correctly and removed from the table
    init(numOfCardsVisible: Int) {
        cardsVisible = []
        cardsRemoved = []
        cards = []
        newGame(12)
    }
    
    func replaceNewCards(amount: Int) -> [Card] {
        var cardsReplace: [Card] = []
        for _ in 1...amount{
            let cardRemoved = cardsVisible.remove(at: Int.random(in: 1..<cardsVisible.count))
            cards.remove(at: cards.firstIndex(of: cardRemoved)!)
            cardsReplace.append(cardRemoved)
        }
        return cardsReplace
    }
    @discardableResult
    func dealNewCards(amount:Int = 3) -> [Card] {
        var removedCards = [Card]()
        guard cards.count >= amount else {
            return []
        }
        for _ in 0..<amount {
            let removedCard = cards.remove(at: Int.random(in: 0..<cards.count))
            cardsVisible.append(removedCard)
            removedCards.append(removedCard)
        }
        return removedCards
    }
    
    func shuffle() {
        for _ in 1...1000 {
            let random1 = Int.random(in: 0..<cards.count)
            let random2 = Int.random(in: 0..<cards.count)
            cards.swapAt(random1, random2)
        }
    }
}
