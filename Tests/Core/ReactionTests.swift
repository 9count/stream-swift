//
//  ReactionTests.swift
//  GetStream-iOS Tests
//
//  Created by Alexey Bukhtin on 27/12/2018.
//  Copyright © 2018 Stream.io Inc. All rights reserved.
//

import XCTest
@testable import GetStream

fileprivate struct Comment: ReactionExtraDataProtocol {
    let text: String
}

extension ReactionKind {
    static let like = "like"
    static let comment = "comment"
}

class ReactionTests: TestCase {
    
    func testAdd() {
        client.add(reactionTo: .test1, kindOf: .comment, extraData: Comment(text: "Hello!")) {
            let commentReaction = try! $0.get()
            XCTAssertEqual(commentReaction.kind, .comment)
            XCTAssertEqual(commentReaction.data.text, "Hello!")
            
            self.client.add(reactionTo: .test1, parentReactionId: commentReaction.parentId, kindOf: .like) {
                let likeReaction = try! $0.get()
                XCTAssertEqual(likeReaction.kind, .like)
                XCTAssertEqual(likeReaction.parentId, commentReaction.id)
            }
            
            self.client.add(reactionToParentReaction: commentReaction, kindOf: .like) {
                let likeReaction = try! $0.get()
                XCTAssertEqual(likeReaction.kind, .like)
                XCTAssertEqual(likeReaction.parentId, commentReaction.id)
            }
        }
    }
    
    func testGet() {
        client.get(reactionId: .test1) {
            let reaction = try! $0.get()
            XCTAssertEqual(reaction.kind, .like)
            XCTAssertEqual(reaction.data, ReactionNoExtraData.shared)
        }
        
        client.get(reactionId: .test2, extraDataTypeOf: Comment.self) {
            let reaction = try! $0.get()
            XCTAssertEqual(reaction.kind, .comment)
            XCTAssertEqual(reaction.data.text, "Hello!")
        }
        
        client.get(reactionId: .test2) {
            let reaction = try! $0.get()
            XCTAssertEqual(reaction.kind, .comment)
            XCTAssertEqual(reaction.data, ReactionNoExtraData.shared)
            XCTAssertEqual(reaction.data(typeOf: Comment.self)?.text, "Hello!")
        }
    }
    
    func testUpdate() {
        client.update(reactionId: .test2, extraData: Comment(text: "Hi!")) {
            let commentReaction = try! $0.get()
            XCTAssertEqual(commentReaction.kind, .comment)
            XCTAssertEqual(commentReaction.data.text, "Hi!")
            XCTAssertEqual(commentReaction.data(typeOf: Comment.self)?.text, "Hi!")
            
            let lastLike = commentReaction.latestChildren(kindOf: .like).first!
            XCTAssertEqual(lastLike.kind, .like)
            
            let lastComment = commentReaction.latestChildren(kindOf: .comment, extraDataTypeOf: Comment.self).first!
            XCTAssertEqual(lastComment.kind, .comment)
            XCTAssertEqual(lastComment.data.text, "Hey!")
        }
    }
    
    func testDelete() {
        client.delete(reactionId: .test1) {
            XCTAssertEqual(try! $0.get(), 200)
        }
    }
    
    func testFetchReactions() {
        client.reactions(forUserId: "1") {
            let reactions = try! $0.get()
            XCTAssertEqual(reactions.reactions.count, 3)
        }
        
        client.reactions(forUserId: "1", kindOf: .comment, extraDataTypeOf: Comment.self) {
            let reactions = try! $0.get()
            XCTAssertEqual(reactions.reactions.count, 2)
            XCTAssertEqual(reactions.reactions[0].data.text, "Hey!")
            XCTAssertEqual(reactions.reactions[1].data.text, "Hi!")
        }
        
        client.reactions(forReactionId: "50539e71-d6bf-422d-ad21-c8717df0c325") {
            let reactions = try! $0.get()
            XCTAssertEqual(reactions.reactions.count, 2)
        }
        
        client.reactions(forActivityId: "ce918867-0520-11e9-a11e-0a286b200b2e", withActivityData: true) {
            let reactions = try! $0.get()
            XCTAssertEqual(reactions.reactions.count, 3)
            XCTAssertNotNil(reactions.activity)
        }
    }
}
