import Alamofire

protocol UserRepository {
    func fetch(completion: @escaping (User?) -> Void)
}

final class RandomUserAPIClient: UserRepository {

    private let host: URL

    init(host: URL) {
        self.host = host
    }

    func fetch(completion: @escaping (User?) -> Void) {
        let requestURL = host.appendingPathComponent("api")
        Alamofire.request(requestURL).responseData { response in
            guard let data = response.data else {
                completion(nil)
                return
            }

            let userResponse = try? JSONDecoder().decode(UserResponse.self, from: data)
            guard let user = userResponse?.results.first else {
                completion(nil)
                return
            }

            completion(user)
        }
    }
}

extension RandomUserAPIClient {
    convenience init?() {
        guard let host = URL(string: "https://randomuser.me/") else {
            return nil
        }

        self.init(host: host)
    }
}
