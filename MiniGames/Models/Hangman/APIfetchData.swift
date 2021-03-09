//
//  APIfetchData.swift
//  MiniGames
//
//  Created by Caleb Wilson on 08/03/2021.
//

import Foundation

extension HangmanGameStatus {
    func makeDatabaseRequest(withUrl url : String){
        let urlRequest = URLRequest(url: URL(string: url)!)
        self.isLoading = true
        
        URLSession.shared.dataTask(with: urlRequest){ data, response, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let myContent = data else {
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode([WordResponse].self, from: myContent) {
                if let selectedWord = decodedResponse.randomElement() {
                    DispatchQueue.main.async {
                        self.theWord = selectedWord.word
                        self.isLoading = false
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }.resume()
    }
}




struct WordResponse : Codable {
    let word : String
    let score : Int
    let tags : [String]?
    let numSyllables : Int?
}

