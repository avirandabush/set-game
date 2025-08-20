//
//  Values.swift
//  Set
//
//  Created by aviran dabush on 25/09/2022.
//

import SwiftUI

struct Values: Equatable {
    enum Colors: CaseIterable {
        case red
        case blue
        case green
    }
    
    enum Shapes: CaseIterable  {
        case recangle
        case circle
        case triangle
    }
    
    enum Shades: Int, CaseIterable  {
        case solid 
        case striped
        case fill
    }
    
    enum Number: CaseIterable  {
        case one
        case two
        case three
    }
}
