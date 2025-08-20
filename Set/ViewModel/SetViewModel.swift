//
//  SetViewModel.swift
//  Set
//
//  Created by aviran dabush on 22/09/2022.
//

import SwiftUI

class SetViewModel: ObservableObject {
    
    // Initilize the Game
    init() {
        SetViewModel.createCardArray()
        model = SetViewModel.createGame()
    }
    
    // Initilize Array of cards using the enum
    static var shapes:Array<CardModel.Card>  = []
    
    static func createCardArray() {
        var id = 0
        for color in Values.Colors.allCases {
            for shape in Values.Shapes.allCases {
                for shade in Values.Shades.allCases {
                    for number in Values.Number.allCases {
                        SetViewModel.shapes.append(CardModel.Card(shape: shape, color: color, number: number, shade: shade, id: id))
                        id += 1
                    }
                }
            }
        }
    }
    
    // Create the game
    static func createGame() -> CardModel {
        
        shapes.shuffle()
        
        return CardModel( numberOfCards: shapes.count) { index in
            shapes[index]
        }
    }
    
    // Tell the view there are some changes in the model
    @Published var model: CardModel// = createGame()
    
    var displayCards: Array<CardModel.Card> {
        model.displayedCards
    }
    
    var allCards: Array<CardModel.Card> {
        model.allCards
    }
    
    var matchedCards: Array<CardModel.Card> {
        model.matchedCards
    }

    // Give the View a way to communicate
    func newGame() {
        model = SetViewModel.createGame()
    }
    
    func choose(_ card: CardModel.Card) {
        model.choose(card)
    }
    
    func deal() {
        model.deal()
    }
    
    func getScore() -> Int {
        model.score
    }
}
