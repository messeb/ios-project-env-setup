import Foundation
@testable import iOSProjectSetup

extension User {
    static func fake() -> User {
        return User(name: Name.fake(), picture: Picture.fake())
    }
}
