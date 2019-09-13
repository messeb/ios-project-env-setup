import RxSwift
import RxCocoa
import RxTest

/// Scheduler for test cases
extension TestScheduler {
    /**
     Builds testable observer for s specific observable sequence, binds it's results and sets up disposal.

     - parameter source: Observable sequence to observe.
     - returns: Observer that records all events for observable sequence.
     */
    public func record<O: ObservableConvertibleType>(source: O) -> TestableObserver<O.Element> {
        let observer = self.createObserver(O.Element.self)
        let disposable = source.asObservable().bind(to: observer)
        self.scheduleAt(100) {
            disposable.dispose()
        }
        return observer
    }
}

extension TestScheduler {
    /// Creates instance of ´TestScheduler` with the initial clock of 0.
    public convenience init() {
        self.init(initialClock: 0)
    }
}
