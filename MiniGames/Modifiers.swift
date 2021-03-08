//
//  Modifiers.swift
//  Connect-4
//
//  Created by Caleb Wilson on 25/02/2021.
//

import Foundation
import SwiftUI

struct ColumnHeaderButtonConnect4 : ButtonStyle {
    var disabled : Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
                .font(.title)
                .padding(.all)
                .background(Circle().fill(disabled ? Color.clear : Color.green).frame(width: 40, height: 40, alignment: .center))
                .onHover(perform: { hovering in
                    if hovering && !disabled {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                })
    }
}

