//
//  ContentView.swift
//  Set
//
//  Created by aviran dabush on 22/09/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game: SetViewModel
    @Namespace private var discardNamespace
    @Namespace private var dealingNamespace

    // Revers deck's order
    private func zIndex(of card: CardModel.Card) -> Double {
        -Double(game.allCards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    // Main view
    var body: some View {
        VStack {
            gameHead
            gameBody
            gameDeck
        }
    }
    // Header
    var gameHead: some View {
        HStack {
            Button("New Game") {
                withAnimation {
                    game.newGame()
                }
            }
            Spacer()
            Text("Your Score: \(game.getScore())")
        }
        .padding(4)
        .foregroundColor(.blue)
    }
    // Body
    var gameBody: some View {
        AspectVGrid(items: game.displayCards, aspectRatio: 2/3, content: { card in
            CardView(card: card)
                .matchedGeometryEffect(id: card.id, in: discardNamespace)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: CardConstant.dealDuration)) {
                        game.choose(card)
                    }
                }
                .padding(2)
        })
        
    }
    // Bottom
    var gameDeck: some View {
        HStack {
            VStack {
                Text("deal")
                ZStack {
                    ForEach(game.allCards) { card in
                        CardView(card: card)
                            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                            .zIndex(zIndex(of: card))
                        Color.red.cornerRadius(10)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: CardConstant.dealDuration)) {
                        game.deal()
                    }
                }
                .frame(width: 70, height: 100)
                .foregroundColor(.red)
            }
            Spacer()
            VStack {
                Text("discard")
                ZStack {
                    ForEach(game.matchedCards) { card in
                        CardView(card: card)
                            .matchedGeometryEffect(id: card.id, in: discardNamespace)
                    }
                }
                .frame(width: CardConstant.undealtWidth, height: CardConstant.undealtHeight)
                .foregroundColor(.red)
            }
        }
        .padding(4)
    }
    
    private struct CardConstant {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

// Card content
struct CardView: View {
    let card: CardModel.Card
    
    var body: some View {
        
        GeometryReader{ geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                
                shape.fill().foregroundColor(.white)
                if card.clicked {
                    shape.strokeBorder(.orange, lineWidth: DrawingConstants.lineWidth)
                } else {
                    shape.strokeBorder(.blue, lineWidth: DrawingConstants.lineWidth)
                }
                // Call the shapes creator
                ShapesView(card: card)
                    .font(font(in: geometry.size))
            }
            .rotationEffect(Angle.degrees(card.misMatched ? 360 : 0))
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width,size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 1
        static let fontScale: CGFloat = 0.3
    }
}

// Shape display
struct ShapesView: View {
    let card: CardModel.Card
    
    var body: some View {
        let width = CGFloat(card.viewShade)
        let opacity = card.opacity
        let corners = CGFloat(50)
        
        VStack {
            switch card.shape {
            case Values.Shapes.recangle:
                switch card.number {
                case Values.Number.three:
                    Rectangle().strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                    Rectangle().strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                    Rectangle().strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                case Values.Number.two:
                    Rectangle().strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                    Rectangle().strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                default:
                    Rectangle().strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                }
            case Values.Shapes.circle:
                switch card.number {
                case Values.Number.three:
                    Circle().strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                    Circle().strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                    Circle().strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                case Values.Number.two:
                    Circle().strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                    Circle().strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                default:
                    Circle().strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                }
            case Values.Shapes.triangle:
                switch card.number {
                case Values.Number.three:
                    RoundedRectangle(cornerRadius: corners)
                        .strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                    RoundedRectangle(cornerRadius: corners)
                        .strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                    RoundedRectangle(cornerRadius: corners)
                        .strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                case Values.Number.two:
                    RoundedRectangle(cornerRadius: corners)
                        .strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                    RoundedRectangle(cornerRadius: corners)
                        .strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                default:
                    RoundedRectangle(cornerRadius: corners)
                        .strokeBorder(lineWidth: width)
                        .opacity(opacity).aspectRatio(2/1, contentMode: .fit)
                }
            }
        }
        .foregroundColor(card.color)
    }
}

// Preview canvas
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        let game = SetViewModel()
        ContentView(game: game)
    }
}
