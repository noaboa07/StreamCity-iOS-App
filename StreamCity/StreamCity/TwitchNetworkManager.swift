//
//  TwitchNetworkManager.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import Foundation

// Model for parsing the token response
struct TwitchTokenResponse: Codable {
    let access_token: String
    let expires_in: Int
    let token_type: String
}

// Model for parsing the streams response
struct StreamsResponse: Codable {
    let data: [TwitchStream]
}

// Model for a single Twitch stream
struct TwitchStream: Codable {
    let user_name: String
    let title: String
    let thumbnail_url: String
    let viewer_count: Int
    let game_name: String
    let user_logo: String?
}

// Main network manager class
class TwitchNetworkManager {
    static let shared = TwitchNetworkManager()
    private let clientId = "7nsw5ill3xd5p1f5b7fk3ak8mc7q12" // Update your client ID here
    private let clientSecret = "5fdbpor3nlix157s7c04wnqa303g9v" // Update your client secret here
    private let tokenURL = "https://id.twitch.tv/oauth2/token"
    private let streamsURL = "https://api.twitch.tv/helix/streams?first=10"

    private init() {}

    // Function to get an access token
    func getAccessToken(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "\(tokenURL)?client_id=\(clientId)&client_secret=\(clientSecret)&grant_type=client_credentials") else {
            print("Invalid token request URL.")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching token: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            do {
                let tokenResponse = try JSONDecoder().decode(TwitchTokenResponse.self, from: data)
                completion(tokenResponse.access_token)
            } catch {
                print("Error decoding token response: \(error.localizedDescription)")
                completion(nil)
            }
        }

        task.resume()
    }

    // Function to fetch live streams using the access token
    func fetchLiveStreams(accessToken: String, completion: @escaping ([Stream]?) -> Void) {
        guard let url = URL(string: streamsURL) else {
            print("Invalid streams request URL.")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(clientId, forHTTPHeaderField: "Client-ID")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching streams: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            do {
                let twitchStreamsResponse = try JSONDecoder().decode(StreamsResponse.self, from: data)
                let streams = twitchStreamsResponse.data.map { stream in
                    Stream(
                        streamerName: stream.user_name,
                        title: stream.title,
                        thumbnailURL: stream.thumbnail_url,
                        viewerCount: stream.viewer_count,
                        streamCategory: stream.game_name,
                        isLive: true,
                        streamerAvatarURL: stream.user_logo
                    )
                }
                completion(streams)
            } catch {
                print("Error decoding streams response: \(error.localizedDescription)")
                completion(nil)
            }
        }

        task.resume()
    }
}
