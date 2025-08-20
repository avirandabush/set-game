//
//  CardModel.swift
//  Set
//
//  Created by aviran dabush on 19/09/2022.
//

import SwiftUI

struct CardModel {
    
    // Init array of cards with cards prop
    private(set) var allCards: Array<CardModel.Card>
    private(set) var displayedCards: Array<CardModel.Card>
    private(set) var choosenCards: [CardModel.Card]
    private(set) var matchedCards: [CardModel.Card]
    var score = 0
    
    init(numberOfCards: Int, createCard: (Int) -> CardModel.Card) {
        allCards = []
        displayedCards = []
        choosenCards = []
        matchedCards = []

        for index in 0..<numberOfCards {
            allCards.append(SetViewModel.shapes[index])
        }
        // Add cards tom displayed
        for index in 0..<12 {
            displayedCards.append(allCards[index])
            allCards.remove(at: index)
        }
    }
    
    // Choose card
    mutating func choose(_ card: Card) {
        // Extract card's index
        if let displayIndex = displayedCards.firstIndex(where: { $0.id == card.id}) {
            // Check if he is alredy clicked
            if let choosenIndex = choosenCards.firstIndex(where: { $0.id == card.id }) {
                // Cancel click
                choosenCards.remove(at: choosenIndex)
                displayedCards[displayIndex].clicked.toggle()
            } else {
                // Add to array
                choosenCards.append(card)
                displayedCards[displayIndex].clicked.toggle()
            }
            
            if choosenCards.count < 3 { return }
            
            let cardOne = choosenCards[0]
            let cardTwo = choosenCards[1]
            let cardThree = choosenCards[2]
            
            // If there is a set
            if thereIsASet(cardOne, cardTwo, cardThree) {
                score += 1
                // Remove cards from pack
                for i in 0..<choosenCards.count {
                    matchedCards.append(choosenCards[i])
                    if let index = displayedCards.firstIndex(where: { $0.id == choosenCards[i].id }) {
                        displayedCards.remove(at: index)
                    }
                }
                choosenCards.removeAll()
                deal()
            } else if choosenCards.count == 4 {
                // Cancel choosen card
                for i in 0..<choosenCards.count {
                    if let choosenIndex = displayedCards.firstIndex(where: { $0.id == choosenCards[i].id }) {
                        // Cancel click
                        displayedCards[choosenIndex].clicked.toggle()
                        displayedCards[choosenIndex].misMatched = false
                    }
                }
                choosenCards.removeAll()
                choosenCards.append(card)
                displayedCards[displayIndex].clicked.toggle()
            } else {
                for i in 0..<choosenCards.count {
                    if let choosenIndex = displayedCards.firstIndex(where: { $0.id == choosenCards[i].id }) {
                        // Cancel click
                        displayedCards[choosenIndex].misMatched = true
                    }
                }
            }
        }
    }
    
    // Check for a set
    func thereIsASet(_ cardOne: CardModel.Card, _ cardTwo: CardModel.Card, _ cardThree: CardModel.Card) -> Bool {
        var set = 0
        
        if (cardOne.number == cardTwo.number && cardOne.number == cardThree.number) ||
            (cardOne.number != cardTwo.number && cardOne.number != cardThree.number && cardTwo.number != cardThree.number) {
            set += 1
        }
        if (cardOne.shape == cardTwo.shape && cardOne.shape == cardThree.shape) ||
            (cardOne.shape != cardTwo.shape && cardOne.shape != cardThree.shape && cardTwo.shape != cardThree.shape) {
            set += 1
        }
        if (cardOne.shade == cardTwo.shade && cardOne.shade == cardThree.shade) ||
            (cardOne.shade != cardTwo.shade && cardOne.shade != cardThree.shade && cardTwo.shade != cardThree.shade) {
            set += 1
        }
        if (cardOne.color == cardTwo.color && cardOne.color == cardThree.color) ||
            (cardOne.color != cardTwo.color && cardOne.color != cardThree.color && cardTwo.color != cardThree.color) {
            set += 1
        }
        
        if set == 4 { return true }
        return false
    }
    
    // Dael cards
    mutating func deal() {
        // Add three more cards tom displayed
        for i in 0...2{
            if !allCards.isEmpty {
                displayedCards.append(allCards[i])
                allCards.remove(at: i)
            }
        }
    }
    
    // Set each card its properties
    struct Card: Identifiable, Equatable{
        var clicked = false
        var misMatched = false
        var faceUp = false
        let id: Int
        var shape: Values.Shapes
        var color: Color
        var number: Values.Number
        var shade: Values.Shades
        var viewShade: Int
        var opacity: Double
        
        init(shape: Values.Shapes, color: Values.Colors, number: Values.Number, shade: Values.Shades, id: Int) {
            self.shape = shape
            self.number = number
            self.id = id
            self.shade = shade
            
            // Convert the color to UI color
            if color == Values.Colors.red {
                self.color = .red
            } else if color == Values.Colors.blue {
                self.color = .blue
            } else {
                self.color = .green
            }
            
            // Convert the shade to int, so it can be used in the view
            if shade == Values.Shades.solid {
                self.viewShade = 5
                self.opacity = 1.0
            } else if shade == Values.Shades.striped {
                self.viewShade = 20
                self.opacity = 0.3
            } else {
                self.viewShade = 20
                self.opacity = 1.0
            }
        }
    }
}
