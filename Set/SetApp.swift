//
//  SetApp.swift
//  Set
//
//  Created by aviran dabush on 22/09/2022.
//

import SwiftUI

@main
struct SetApp: App {
    var body: some Scene {
        let game = SetViewModel()
        
        WindowGroup {
            ContentView(game: game)
        }
    }
}
