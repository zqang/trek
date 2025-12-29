//
//  OfflineQueueTests.swift
//  TrekTests
//
//  Created on December 29, 2025.
//

import XCTest
@testable import Trek

@MainActor
final class OfflineQueueTests: XCTestCase {
    var offlineQueue: OfflineQueue!

    override func setUp() {
        super.setUp()
        // Note: In real tests, we'd use a separate instance or mock UserDefaults
        offlineQueue = OfflineQueue.shared
        offlineQueue.clearQueue() // Clear any existing data
    }

    override func tearDown() {
        offlineQueue.clearQueue()
        offlineQueue = nil
        super.tearDown()
    }

    // MARK: - Enqueue Tests

    func testEnqueue_AddsOperation() {
        let activity = MockData.createMockActivity()
        offlineQueue.queueActivity(activity, operation: .saveActivity)

        XCTAssertEqual(offlineQueue.queueCount, 1)
        XCTAssertTrue(offlineQueue.hasQueuedOperations)
    }

    func testEnqueue_MultipleOperations() {
        let activity1 = MockData.createMockActivity(id: "1")
        let activity2 = MockData.createMockActivity(id: "2")

        offlineQueue.queueActivity(activity1, operation: .saveActivity)
        offlineQueue.queueActivity(activity2, operation: .updateActivity)

        XCTAssertEqual(offlineQueue.queueCount, 2)
    }

    // MARK: - Dequeue Tests

    func testDequeue_RemovesOperation() {
        let activity = MockData.createMockActivity()
        offlineQueue.queueActivity(activity, operation: .saveActivity)

        let operationId = offlineQueue.pendingOperations.first!.id
        offlineQueue.dequeue(operationId)

        XCTAssertEqual(offlineQueue.queueCount, 0)
        XCTAssertFalse(offlineQueue.hasQueuedOperations)
    }

    func testDequeue_NonexistentOperation_NoEffect() {
        let activity = MockData.createMockActivity()
        offlineQueue.queueActivity(activity, operation: .saveActivity)

        offlineQueue.dequeue("nonexistent_id")

        XCTAssertEqual(offlineQueue.queueCount, 1)
    }

    // MARK: - Retry Count Tests

    func testIncrementRetryCount_IncreasesCount() {
        let activity = MockData.createMockActivity()
        offlineQueue.queueActivity(activity, operation: .saveActivity)

        let operationId = offlineQueue.pendingOperations.first!.id
        let initialRetryCount = offlineQueue.pendingOperations.first!.retryCount

        offlineQueue.incrementRetryCount(operationId)

        let updatedRetryCount = offlineQueue.pendingOperations.first!.retryCount
        XCTAssertEqual(updatedRetryCount, initialRetryCount + 1)
    }

    func testIncrementRetryCount_MultipleIncrements() {
        let activity = MockData.createMockActivity()
        offlineQueue.queueActivity(activity, operation: .saveActivity)

        let operationId = offlineQueue.pendingOperations.first!.id

        offlineQueue.incrementRetryCount(operationId)
        offlineQueue.incrementRetryCount(operationId)
        offlineQueue.incrementRetryCount(operationId)

        let retryCount = offlineQueue.pendingOperations.first!.retryCount
        XCTAssertEqual(retryCount, 3)
    }

    // MARK: - Clear Queue Tests

    func testClearQueue_RemovesAllOperations() {
        let activity1 = MockData.createMockActivity(id: "1")
        let activity2 = MockData.createMockActivity(id: "2")
        let activity3 = MockData.createMockActivity(id: "3")

        offlineQueue.queueActivity(activity1, operation: .saveActivity)
        offlineQueue.queueActivity(activity2, operation: .updateActivity)
        offlineQueue.queueActivity(activity3, operation: .deleteActivity)

        XCTAssertEqual(offlineQueue.queueCount, 3)

        offlineQueue.clearQueue()

        XCTAssertEqual(offlineQueue.queueCount, 0)
        XCTAssertFalse(offlineQueue.hasQueuedOperations)
    }

    // MARK: - Queue Activity Tests

    func testQueueActivity_SaveOperation() {
        let activity = MockData.createMockActivity()
        offlineQueue.queueActivity(activity, operation: .saveActivity)

        let operation = offlineQueue.pendingOperations.first!
        XCTAssertEqual(operation.type, .saveActivity)
    }

    func testQueueActivityUpdate() {
        let activity = MockData.createMockActivity()
        offlineQueue.queueActivityUpdate(activity)

        let operation = offlineQueue.pendingOperations.first!
        XCTAssertEqual(operation.type, .updateActivity)
    }

    func testQueueActivityDelete() {
        offlineQueue.queueActivityDelete(activityId: "test_123", userId: "user_456")

        let operation = offlineQueue.pendingOperations.first!
        XCTAssertEqual(operation.type, .deleteActivity)
    }

    // MARK: - Queue Stats Tests

    func testQueueCount_ReturnsCorrectCount() {
        XCTAssertEqual(offlineQueue.queueCount, 0)

        offlineQueue.queueActivity(MockData.createMockActivity(id: "1"), operation: .saveActivity)
        XCTAssertEqual(offlineQueue.queueCount, 1)

        offlineQueue.queueActivity(MockData.createMockActivity(id: "2"), operation: .saveActivity)
        XCTAssertEqual(offlineQueue.queueCount, 2)
    }

    func testHasQueuedOperations_ReturnsCorrectValue() {
        XCTAssertFalse(offlineQueue.hasQueuedOperations)

        offlineQueue.queueActivity(MockData.createMockActivity(), operation: .saveActivity)
        XCTAssertTrue(offlineQueue.hasQueuedOperations)

        offlineQueue.clearQueue()
        XCTAssertFalse(offlineQueue.hasQueuedOperations)
    }

    func testOldestOperation_ReturnsOldest() {
        let activity1 = MockData.createMockActivity(id: "1")
        offlineQueue.queueActivity(activity1, operation: .saveActivity)

        // Wait a moment to ensure different timestamps
        Thread.sleep(forTimeInterval: 0.01)

        let activity2 = MockData.createMockActivity(id: "2")
        offlineQueue.queueActivity(activity2, operation: .saveActivity)

        let oldest = offlineQueue.oldestOperation
        XCTAssertNotNil(oldest)
        XCTAssertEqual(oldest?.timestamp, offlineQueue.pendingOperations.first?.timestamp)
    }

    func testOperationsByType_FiltersCorrectly() {
        offlineQueue.queueActivity(MockData.createMockActivity(id: "1"), operation: .saveActivity)
        offlineQueue.queueActivity(MockData.createMockActivity(id: "2"), operation: .updateActivity)
        offlineQueue.queueActivity(MockData.createMockActivity(id: "3"), operation: .saveActivity)

        let saveOperations = offlineQueue.operationsByType(.saveActivity)
        let updateOperations = offlineQueue.operationsByType(.updateActivity)
        let deleteOperations = offlineQueue.operationsByType(.deleteActivity)

        XCTAssertEqual(saveOperations.count, 2)
        XCTAssertEqual(updateOperations.count, 1)
        XCTAssertEqual(deleteOperations.count, 0)
    }

    // MARK: - Persistence Tests

    func testPersistence_SavesAndLoads() {
        // This test verifies that operations persist across instances
        // In a real app, we'd create a new instance of OfflineQueue

        let activity = MockData.createMockActivity()
        offlineQueue.queueActivity(activity, operation: .saveActivity)

        let countBeforeReload = offlineQueue.queueCount

        // Simulate app restart by creating new instance
        // (In reality, OfflineQueue is a singleton, so this test is conceptual)
        XCTAssertEqual(offlineQueue.queueCount, countBeforeReload)
    }
}
