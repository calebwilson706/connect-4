//
//  HangmanGameStatus.swift
//  MiniGames
//
//  Created by Caleb Wilson on 08/03/2021.
//

import Foundation

class HangmanGameStatus : ObservableObject {
    @Published var theWord : String? = nil
    @Published var isLoading : Bool = false
    
    func getWordFromOption(_ option : HangmanOptions, extraString : String){
        
        if extraString == "" && option != .bbl && option != .animal {
            return
        }
        
        let topLevel = "https://api.datamuse.com/words"
        let maximumParameter = "&max=25"
        
        switch option {
        case .rhy:
            makeDatabaseRequest(withUrl: topLevel + "?rel_rhy=\(extraString)" + maximumParameter)
        case .jjb:
            makeDatabaseRequest(withUrl: topLevel + "?rel_jjb=\(extraString)" + maximumParameter)
        case .bbl:
            makeDatabaseRequest(withUrl: topLevel + "?topics=bible,christian" + maximumParameter)
        case .hom:
            makeDatabaseRequest(withUrl: topLevel + "?rel_hom=\(extraString)" + maximumParameter)
        case .animal:
            self.theWord = animalNames.randomElement()
        case .ml:
            makeDatabaseRequest(withUrl: topLevel + "?ml=\(extraString)" + maximumParameter)
        }
    }

}
