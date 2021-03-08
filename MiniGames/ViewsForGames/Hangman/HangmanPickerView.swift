//
//  HangmanView.swift
//  MiniGames
//
//  Created by Caleb Wilson on 08/03/2021.
//

import SwiftUI

struct HangmanPickerView: View {
    let optionsWhichRequireTextField : [HangmanOptions] = [.rhy,.jjb,.hom]
    let optionsToSelect = HangmanOptions.allCases
    
    @State var selectedOverhangingOption = HangmanOptions.rhy
    @State var extraParameterForSpecificQueries = ""
    
    let getWordFromSelected : (HangmanOptions, String) -> Void
    var body: some View {
        VStack {
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
                extraParameterForSpecificQueries = extraParameterForSpecificQueries.lowercased()
                getWordFromSelected(selectedOverhangingOption,extraParameterForSpecificQueries)
            }){
                Text("continue")
            }
        }.padding(.all)
    }
}

struct HangmanPickerView_Previews: PreviewProvider {
    static var previews: some View {
        HangmanPickerView(getWordFromSelected: HangmanGameStatus().getWordFromOption)
    }
}
