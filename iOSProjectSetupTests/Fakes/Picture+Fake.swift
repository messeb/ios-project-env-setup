import Foundation
@testable import iOSProjectSetup

extension Picture {
    static func fake() -> Picture {
        // Bad fake with external image urls
        // Should be local in test target
        return Picture(large: URL(string: "https://randomuser.me/api/portraits/women/71.jpg")!,
                       medium: URL(string: "https://randomuser.me/api/portraits/med/women/71.jpg")!,
                       thumbnail: URL(string: "https://randomuser.me/api/portraits/thumb/women/71.jpg")!)
    }
}
