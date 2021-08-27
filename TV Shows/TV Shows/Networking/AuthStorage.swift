//
//  AuthStorage.swift
//  TV Shows
//
//  Created by Infinum on 01.08.2021..
//
import Foundation

class AuthStorage {
    
    static let shared: AuthStorage = .init()
    
    var authInfo: AuthInfo? {
        get { loadAuthInfoIfNeeded() }
        set { cachedAuthInfo = newValue }
    }
    
    private var cachedAuthInfo: AuthInfo?
    
    private init() {}
    
    func storeAuthInfo(_ authInfo: AuthInfo?) {
        cachedAuthInfo = authInfo
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(authInfo) {
            UDM.shared.defaults.set(encoded, forKey: Constants.Storage.authInfoUserDefaultsKey)
        }
        
    }
    
}

private extension AuthStorage {
    
    func loadAuthInfoIfNeeded() -> AuthInfo? {
        guard cachedAuthInfo == nil else {
            return cachedAuthInfo
        }
        
        let savedAuthInfo = UDM.shared.defaults.object(forKey: Constants.Storage.authInfoUserDefaultsKey) as? Data
        let loadedInfo = savedAuthInfo.flatMap { try? JSONDecoder().decode(AuthInfo.self, from: $0) }
        cachedAuthInfo = loadedInfo
        return loadedInfo
    }
}
