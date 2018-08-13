import Foundation
@testable import iOSProjectSetup

final class UserRepositoryFake: UserRepository {
    func fetch(completion: @escaping (User?) -> Void) {
        completion(User.fake())
    }
}
