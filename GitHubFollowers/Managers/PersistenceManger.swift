//
//  PersistenceManger.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 30/8/24.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManger {
    static private let defaults = UserDefaults.standard

    enum Keys {
        static let favorites = "favorites"
    }

    static func retrieveFavorites(completed: @escaping (Result<[Follower], GHError>) -> Void) {

        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }

        do {
            let favorites = try JSONDecoder().decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(GHError.unableToRetrieveFavorites))
        }
    }

    private static func saveFavorites(favorites: [Follower]) -> GHError? {
        do {
            let enconder = JSONEncoder()
            let encodedFavorites = try enconder.encode(favorites)
            defaults.setValue(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToSaveFavorites
        }
    }

    static func updateFavoritesList(with follower: Follower, actionType: PersistenceActionType, completed: @escaping (GHError?) -> Void) {
        retrieveFavorites { result in
            switch result {
                case .success(let favorites):
                    var retrievedFavorites = favorites

                    switch actionType {
                        case .add:
                            guard !retrievedFavorites.contains(where: { $0.login == follower.login }) else {
                                completed(.userAlreadyFavorite)
                                return
                            }

                            retrievedFavorites.append(follower)

                        case .remove:
                            retrievedFavorites.removeAll { $0.login == follower.login }
                    }

                    completed(saveFavorites(favorites: retrievedFavorites))

                case .failure(let failure):
                    completed(failure)

            }
        }
    }
}
