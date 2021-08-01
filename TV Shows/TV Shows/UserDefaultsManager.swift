//
//  UserDefaultsManager.swift
//  TV Shows
//
//  Created by Infinum on 01.08.2021..
//

import Foundation

class UDM {
    static let shared = UDM()
    let defaults = UserDefaults(suiteName: "com.infinum.nikola.data")!
}
