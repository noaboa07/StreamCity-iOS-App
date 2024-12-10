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

- [✅︎] Users can create an account and/or log in (via FireAuth + FireStore).
- [✅︎] Users can search through a large vareity of different streams from platforms affiliated with StreamCity.
- [✅︎] Users can follow streamers on StreamCity and receive notifications for live streams.
- [✅︎] Users can view a unified feed of recommended (and followed streamers) live streams from all affiliated platforms from the Home Page.
- [✅︎] Users can click on a stream to be redirected to the original streaming platform to watch.
- [✅︎] Users can chat within streams (if supported by the platform).
- [✅︎] Users can customize profile settings including their avatar, profile name, etc.
- [✅︎] User data is saved upon closing the app or logging out (via FireStore)
- [] Users can access a settings page to change for a better user friendly environment (e.g dark mode)

**Optional Nice-to-have Stories:**

- [✅︎] Users can view detailed information about streams and recommended content (e.g Viewer Coumt).
- [] Users can send friend requests with one another and share content to each other
- [] Users post clips and saved highlights from live streams on the community page (perhaps share with friends?)
- [✅︎] Users can engage in a community hub for discussing streams and sharing content.
- [] Users can link their platform accounts to StreamCity (Twitch, YouTube, TikTok, etc.).
- [] Users can access other users profiles via the Community Board to view linked accounts and followed streamers.
- [] Streamers can access a basic dashboard to track their followers and engagement stats.

## 2. Screen Archetypes
**Login/Signup Screen**
Required Feature: Users can create an account or log in to access personalized content.

**Home Feed**
Required Feature: Users can view a feed of live streams from all linked platforms, showing thumbnails and basic stream information.

**Stream Viewer**
Required Feature: Users can be redirected from a selected livestream to watch a stream on its original platform and interact via platform-integrated chat.

**Search Screen**
Required Feature: Users can search for streamers, games, or from various categories to find content of interest.

**Settings Screen**
Required Feature: Users can adjust notification preferences and customize app settings.

**Community Screen**
Optional Feature: Users can interact and engage with other users to converse about streamer-related content.


## 3. Navigation

**Tab Navigation (Tab to Screen)**

Home – A feed displaying live streams from all affiliated platforms.
Search – Search for streamers, games, or specific content.
Community (Optional) – Access trending streams, engage in discussions, and share content.
Profile – Manage personal account, notification preferences, and app settings.

**Flow Navigation (Screen to Screen):**

##### Login/Signup Screen
Login/Signup Screen → Leads to Home Feed.
##### Home Feed
Home Feed → Leads to Stream Viewer (when a stream is selected).
Home Feed → Leads to Search Screen (via button)
##### Search Screen
Search Screen → Leads to Stream Viewer (when a stream is selected).
##### Stream Viewer
Stream Viewer → Leads back to Home Feed 
Stream Viewer → Leads to Streamers Page
#### Profile Viewer
Profile Viewer → Leads to Edit Profile Screen
Profile Viewer → Leads back to Login/Signup Screen (via logout button)
Profile Viewer → Leads to Settings Screen
##### Settings Screen
Settings Screen → Leads back to Profile Screen

## 4. How It Works

* Account Creation & Login: Users sign up or log in to personalize their experience
* Browse the Feed: The Home Feed shows live streams of all recommended or followed content from all affiliated platforms in one place, displaying stream previews, game titles, and streamers.
* Search & Discover: Users can search for specific streamers, games, or categories to find live content they love.
* Watch & Redirect: Clicking on a stream redirects users to the original platform to watch the stream in its native interface.
* Interact: Users can engage with chats (when available) and manage notification preferences to stay posted for stream updates.

## 5. Future Considerations

1. Monetization: Potential revenue through in-app ads, partnerships, or premium features.
2. Technical Specs: Backend implementation with APIs for more live stream data retrieval and platform integration; front-end built using scalable technologies for mobile and future desktop expansion.
3. Security & Privacy: Ensure secure user data management and compliance with data protection regulations (e.g., GDPR).
4. Accessibility: Design with accessibility in mind, ensuring features like screen readers, color contrast adjustments, and easy navigation for all users.

## Progress Updates:

Progress Update 1:

<img style="max-width:300px;" src="StreamCity/Progress Update1.gif">

Progress Update 2:

<img style="max-width:300px;" src="">

GIF(s) created with VEED.io


