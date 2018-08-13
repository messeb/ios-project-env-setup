import Foundation
@testable import iOSProjectSetup

extension Name {
    static func fake() -> Name {
        return Name(title: "Mr", first: "John", last: "Appleseed")
    }
}
