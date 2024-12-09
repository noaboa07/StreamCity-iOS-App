# StreamCity

## Overview

### Description
StreamCity is an all-in-one app for live stream enthusiasts. It consolidates live streaming platforms such as Twitch, YouTube Live, and Facebook Gaming into one seamless interface. With features like a unified feed, cross-platform chat, multi-stream view, and personalized notifications, StreamCity simplifies the streaming experience. This app is designed for both casual viewers and dedicated fans, ensuring they never miss a moment of their favorite creators.
When users click on a stream, they are seamlessly redirected to the original streaming platform, allowing them to watch the stream in its native environment.

### App Evaluation
Category: Entertainment, Social
Platform: Primarily designed as a **mobile app** for iOS using SwiftUI in Xcode.
Mobile Compatibility: Built for seamless use on iOS devices, with potential future expansion to desktop platforms.
Story: StreamCity tells the story of simplifying the fragmented live streaming experience and creating a centralized hub for all streaming content.
Market: Gamers, live stream fans, and content creators who follow streams across multiple platforms.
Habit: Designed for daily use, especially during peak live-streaming hours and event streams (e.g., esports tournaments, special live events).
Scope: A robust app with a strong foundational feature set and potential for expansion with features like streamer dashboards, AI-driven recommendations, and more.

## 1. User Stories
**Required Must-have Stories:**

- Users can create an account and log in (via Firebase).
- Users can link accounts from multiple streaming platforms (e.g., Twitch, YouTube, Facebook Gaming).
- Users can follow streamers and receive notifications for live streams.
- Users can view a unified feed of live streams from all linked platforms.
- Users can click on a stream to be redirected to the original streaming platform to watch.
- Users can chat within streams (if supported by the platform).
- Users can customize notification settings for individual streamers or platforms.

**Optional Nice-to-have Stories:**

- Users can view trending streams and recommended content.
- Users can use a multi-stream view to watch multiple streams at once.
- Users can clip and save highlights from live streams.
- Users can engage in a community hub for discussing streams and sharing content.
- Users can use AR or VR features to create immersive viewing experiences.
- Streamers can access a basic dashboard to track their followers and engagement stats.

## 2. Screen Archetypes
**Login/Signup Screen**
Required Feature: Users can create an account or log in to access personalized content.

**Home Feed**
Required Feature: Users can view a feed of live streams from all linked platforms, showing thumbnails and basic stream information.

**Stream Viewer**
Required Feature: Users can watch a stream on its original platform and interact via platform-integrated chat.

**Search Screen**
Required Feature: Users can search for streamers, games, or categories to find content of interest.

**Settings Screen**
Required Feature: Users can manage their linked accounts, adjust notification preferences, and customize app settings.

## 3. Navigation

**Tab Navigation (Tab to Screen)**

Home – A feed displaying live streams from all linked platforms.
Search – Search for streamers, games, or specific content.
Community – Access trending streams, engage in discussions, and share content.
Profile – Manage linked accounts, notification preferences, and app settings.


**Flow Navigation (Screen to Screen):**

##### Login/Signup Screen
Login Screen → Leads to Home Feed.
##### Home Feed
Home Feed → Leads to Stream Viewer (when a stream is selected).
Home Feed → Leads to Search Screen (via search bar)
##### Search Screen
Search Screen → Leads to Stream Viewer (when a stream is selected).
##### Stream Viewer
Stream Viewer → Leads back to Home Feed or Search Screen.
##### Settings Screen
Settings Screen → Accessible from any tab, allowing users to manage their accounts and preferences.

## 4. How It Works

* Account Creation & Login: Users sign up or log in to personalize their experience and manage linked streaming accounts.
* Link Accounts: Connect multiple streaming platform accounts (e.g., Twitch, YouTube Live, Facebook Gaming) to create a unified view of available content.
* Browse the Feed: The Home Feed shows live streams from all linked platforms in one place, displaying stream previews, game titles, and streamers.
* Search & Discover: Users can search for specific streamers, games, or categories to find live content they love.
* Watch & Redirect: Clicking on a stream redirects users to the original platform to watch the stream in its native interface.
* Interact: Users can engage with chats (when available) and manage notification preferences for stream updates.

## 5. Future Considerations

1. Monetization: Potential revenue through in-app ads, partnerships, or premium features.
2. Technical Specs: Backend implementation with APIs for live stream data retrieval and platform integration; front-end built using scalable technologies for mobile and future desktop expansion.
3. Security & Privacy: Ensure secure user data management and compliance with data protection regulations (e.g., GDPR).
4. Accessibility: Design with accessibility in mind, ensuring features like screen readers, color contrast adjustments, and easy navigation for all users.
