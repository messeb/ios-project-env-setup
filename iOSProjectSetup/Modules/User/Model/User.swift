import Foundation

struct User: Codable {
    let name: Name
    let picture: Picture

    init() {
        name = Name()
        picture = Picture()
    }

    init(name: Name, picture: Picture) {
        self.name = name
        self.picture = picture
    }
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String

    init() {
        title = ""
        first = ""
        last = ""
    }

    init(title: String, first: String, last: String) {
        self.title = title
        self.first = first
        self.last = last
    }
}

struct Picture: Codable {
    let large: URL?
    let medium: URL?
    let thumbnail: URL?

    init() {
        large = nil
        medium = nil
        thumbnail = nil
    }

    init(large: URL, medium: URL, thumbnail: URL) {
        self.large = large
        self.medium = medium
        self.thumbnail = thumbnail
    }
}
