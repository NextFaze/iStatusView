import XCTest
import UIKit
@testable import iStatusView

final class StatusViewTests: XCTestCase {
    func testCreateAddsStatusViewToParentView() {
        let parentView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let loadingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

        let statusView = StatusView.create(with: loadingView, addTo: parentView)

        XCTAssertTrue(parentView.subviews.contains(statusView))
        XCTAssertTrue(statusView.subviews.contains(loadingView))
        XCTAssertTrue(statusView.loadingView === loadingView)
    }

    func testChangeToLoadingUpdatesVisibleContent() throws {
        let parentView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let statusView = StatusView.create(with: UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40)), addTo: parentView)

        try statusView.changeTo(
            state: .loading,
            title: "Loading",
            message: "Please wait",
            animate: false
        )

        if case .loading = statusView.state {
        } else {
            XCTFail("Expected loading state")
        }

        XCTAssertEqual(statusView.titleLabel.text, "Loading")
        XCTAssertEqual(statusView.messageLabel.text, "Please wait")
    }
}
