import RxSwift
import RxTest

extension Event {
    /// Creates a _just_ event stream with the given `element` at time 0.
    ///
    /// - Parameters:
    ///     - element: Element to record
    /// - Returns: Given element as _next_ event and a completed event.
    public static func record(just element: Element) -> [Recorded<Event<Element>>] {
        return [
            Recorded.next(0, element),
            Recorded.completed(0)
        ]
    }

    /// Creates a event stream with the given `element` at time 0.
    ///
    /// - Parameters:
    ///     - element: Element to record
    /// - Returns: Given element as _next_ event.
    public static func record(element: Element) -> [Recorded<Event<Element>>] {
        return [
            Recorded.next(0, element)
        ]
    }

    /// Creates a event stream with the given `elements` at time 0.
    ///
    /// - Parameters:
    ///     - elements: Elements to record
    /// - Returns: Given element as _next_ event.
    public static func record(elements: [Element]) -> [Recorded<Event<Element>>] {
        return elements.map {
            Recorded.next(0, $0)
        }
    }
}
