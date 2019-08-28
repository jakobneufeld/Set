//
//  Card.swift
//  Set
//
//  Created by Niko Neufeld on 6/29/19.
//  Copyright © 2019 Niko Neufeld. All rights reserved.
//

import Foundation
struct Card: Equatable, Hashable {
    /*
     didSet cardsVisible{
     cardsVisible.forEach {
     if $0.isHidden {}
     }
     }
 */
    fileprivate var id: Int
    static var identifierFactory = 0
    static func getId() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    init(isSelected: Bool, shading: Shading, color: Color, shape: Shape, amount: Int ) {
        self.amount = amount
        self.color = color
        self.isSelected = isSelected
        self.shading = shading
        self.shape = shape
        self.id = Card.getId()
    }
    var isSelected = false
    let shading: Shading
    let color: Color
    let shape: Shape
    let amount: Int
}
enum Shading: CaseIterable {
    case open
    case striped
    case filled
}
enum Color: CaseIterable {
    case red
    case blue
    case green
}

enum Shape: CaseIterable {
    case triangle
    case circle
    case square
}
 /// Check if 3 cards matc
extension Card{
   
    
    /// Check if 3 cards match
    static func isAMatch(cards: Set<Card>) -> Bool {
        var _card = [Card]()
        var  i = 0
        for card in cards {
            _card[i] = card
            i = i + 1
        }
        return isAMatch(a: _card[0], b: _card[1], c: _card[2])
    }
    static func isAMatch(a: Card, b: Card, c: Card)  -> Bool {
        let shading: Set = [a.shading, b.shading, c.shading]
        let amount: Set = [a.amount, b.amount, c.amount]
        let color: Set = [a.color, b.color, c.color]
        let shape: Set = [a.shape, b.shape, c.shape]
        if shading.count == 2 {
            return false
        }
        if amount.count == 2 {
            return false
        }
        if shape.count == 2 {
            return false
        }
        if color.count == 2 {
            return false
        }
        return true
  }
}
