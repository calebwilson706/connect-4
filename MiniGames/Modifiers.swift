//
//  Modifiers.swift
//  Connect-4
//
//  Created by Caleb Wilson on 25/02/2021.
//

import Foundation
import SwiftUI

//connect 4

struct ColumnHeaderButtonConnect4 : ButtonStyle {
    var disabled : Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
                .font(.title)
                .padding(.all)
                .background(Circle().fill(disabled ? Color.clear : Color.green).frame(width: 40, height: 40, alignment: .center))
                .modifier(CursorForButtonStyleMod(disableThisFeature: disabled))
    }
}

//hangman

struct HangmanResetButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .imageScale(.large)
            .buttonStyle(BaseHangmanButtonStyles())
            .modifier(CursorForButtonStyleMod())
    }
}

struct HangmanSelectLetterButtonStyle : ButtonStyle {
    var disabled = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .buttonStyle(BaseHangmanButtonStyles())
            .foregroundColor(disabled ? .gray : .primary)
            .modifier(CursorForButtonStyleMod(disableThisFeature: disabled))
            
    }
}
struct BaseHangmanButtonStyles : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("SourceCodePro-SemiBold", size: 13))
            .background(Color.clear)
           
    }
}

struct CursorForButtonStyleMod : ViewModifier {
    var disableThisFeature = false
    func body(content: Content) -> some View {
        return content.onHover { inside in
            if inside && !disableThisFeature {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        }
    }
}
