//
//  HangmanView.swift
//  MiniGames
//
//  Created by Caleb Wilson on 08/03/2021.
//

import SwiftUI

struct HangmanPickerView: View {
    let optionsWhichRequireTextField : [HangmanOptions] = [.rhy,.jjb,.hom,.ml]
    let optionsToSelect = HangmanOptions.allCases
    
    @State var selectedOverhangingOption = HangmanOptions.rhy
    @State var extraParameterForSpecificQueries = ""
    
    let getWordFromSelected : (HangmanOptions, String) -> Void
    var isLoadingWord : Bool
    
    var body: some View {
        VStack {
            if !isLoadingWord {
                HStack {
                    Picker("", selection: $selectedOverhangingOption){
                        ForEach(optionsToSelect, id : \.self){
                            Text($0.rawValue)
                                .tag($0)
                        }
                    }
                    
                    if (optionsWhichRequireTextField
                            .contains(selectedOverhangingOption)) {
                        TextField("", text: $extraParameterForSpecificQueries)
                    }
                }
                
                Button(action : {
                    extraParameterForSpecificQueries = extraParameterForSpecificQueries.filter({ $0.isLetter })
                    getWordFromSelected(selectedOverhangingOption,extraParameterForSpecificQueries)
                }){
                    Text("continue")
                }
            } else {
               Text("Loading...")
            }
        }.padding(.all)
    }
}

//struct HangmanPickerView_Previews: PreviewProvider {
//    @ObservedObject var game = HangmanGameStatus()
//    static var previews: some View {
//        HangmanPickerView(getWordFromSelected: game.getWordFromOption, isLoadingWord: game.isLoading)
//    }
//}
