//
//  Utilities.swift
//  MiniGames
//
//  Created by Caleb Wilson on 09/03/2021.
//

import Foundation

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
