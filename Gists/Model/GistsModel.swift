//
//  GistsModel.swift
//  Gists
//
//  Created by Mohammad Assad on 11/03/2022.
//


import Foundation

typealias GistsModel = [GistsModelElement]


// MARK: - GistsModelElement
struct GistsModelElement: Codable {
    let url, forksURL, commitsURL: String
    let id, nodeID: String
    let gitPullURL, gitPushURL: String
    let htmlURL: String
    let files: [String: File]
    let gistsModelPublic: Bool
    let createdAt, updatedAt: String
    let gistsModelDescription: String?
    let comments: Int
    let user: String?
    let commentsURL: String
    let owner: Owner
    let truncated: Bool

    enum CodingKeys: String, CodingKey {
        case url
        case forksURL = "forks_url"
        case commitsURL = "commits_url"
        case id
        case nodeID = "node_id"
        case gitPullURL = "git_pull_url"
        case gitPushURL = "git_push_url"
        case htmlURL = "html_url"
        case files
        case gistsModelPublic = "public"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case gistsModelDescription = "description"
        case comments, user
        case commentsURL = "comments_url"
        case owner, truncated
    }
}

// MARK: - File
struct File: Codable {
    let filename, type: String
    let language: String?
    let rawURL: String
    let size: Int

    enum CodingKeys: String, CodingKey {
        case filename, type, language
        case rawURL = "raw_url"
        case size
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String
    let url, htmlURL, followersURL: String
    let followingURL, gistsURL, starredURL: String
    let subscriptionsURL, organizationsURL, reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    let type: String
    let siteAdmin: Bool

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }
}

