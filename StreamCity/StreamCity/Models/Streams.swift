//
//  Streams.swift
//  StreamCity
//
//  Created by Tamara Russell on 12/9/24.
//

import Foundation
import SwiftUI

// Stream Model
struct Stream: Identifiable {
    let id = UUID()
    let streamerName: String
    let title: String
    let thumbnailURL: String
}

// Mock Stream Data
let mockStreams = [
    Stream(streamerName: "ProGamer123", title: "Climbing the Ranked Ladder", thumbnailURL: "https://via.placeholder.com/300x200"),
    Stream(streamerName: "ArtLover", title: "Digital Painting Live", thumbnailURL: "https://via.placeholder.com/300x200"),
    Stream(streamerName: "MusicFanatic", title: "Guitar Covers and Requests", thumbnailURL: "https://via.placeholder.com/300x200")
]
