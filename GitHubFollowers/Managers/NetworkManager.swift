//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 13/8/24.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    let imageCache = NSCache<NSString, UIImage>()

    private let baseUrl = "https://api.github.com"

    private init() {

    }

    // - MARK: With Result Type
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GHError>) -> Void) {
        let endpoint = baseUrl + "/users/\(username)/followers?per_page=100&page=\(page)"

        print("🌎 \(endpoint)")

//        completed(.failure(GHError.unsuccessfulResponse))
//        return

        guard let urlRequest = URL(string: endpoint) else {
            completed(.failure(GHError.invalidUsername))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in

            if error != nil {
                completed(.failure(GHError.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(GHError.unsuccessfulResponse))
                return
            }

            guard let data = data else {
                completed(.failure(GHError.invalidData))
                return
            }

            do {
                let followers = try JSONDecoder().decode([Follower].self, from: data)
                completed(.success(followers))

            } catch {
                completed(.failure(GHError.decodingError))
                return
            }
        }

        task.resume()
    }

    func getUserInfo(for username: String, completed: @escaping (Result<User, GHError>) -> Void) {
        let endpoint = baseUrl + "/users/\(username)"

        print("🌎🔵 \(endpoint)")

        guard let urlRequest = URL(string: endpoint) else {
            completed(.failure(GHError.invalidUsername))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in

            if error != nil {
                completed(.failure(GHError.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(GHError.unsuccessfulResponse))
                return
            }

            guard let data = data else {
                completed(.failure(GHError.invalidData))
                return
            }

            do {
                let user = try JSONDecoder().decode(User.self, from: data)
//                print("⬇️ User info:: \(user)")
                completed(.success(user))

            } catch {
                completed(.failure(GHError.decodingError))
                return
            }
        }

        task.resume()
    }

    func downloadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
//        print("⬇️ Downloading image from url: \(url.description)")

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            if error != nil {
                completion(nil)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil)
                return
            }
            guard let data = data else {
                completion(nil)
                return
            }

            guard let image = UIImage(data: data) else { return }

            imageCache.setObject(image, forKey: NSString(string: url.description))

            completion(image)
        }
        task.resume()
    }

    // - MARK: Without Result Type
    /*func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, GHError?) -> Void) {
        let endpoint = baseUrl + "/users/\(username)/followers?per_page=100&page=\(page)"

        guard let urlRequest = URL(string: endpoint) else {
            completed(nil, GHError.invalidUsername)
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in

            if error != nil {
                completed(nil, GHError.unableToComplete)
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, GHError.unsuccessfulResponse)
                return
            }

            guard let data = data else {
                completed(nil, GHError.invalidData)
                return
            }

            do {
                let followers = try JSONDecoder().decode([Follower].self, from: data)
                completed(followers, nil)

            } catch {
                completed(nil, GHError.decodingError)
                return
            }
        }

        task.resume()
    }
     */
}
