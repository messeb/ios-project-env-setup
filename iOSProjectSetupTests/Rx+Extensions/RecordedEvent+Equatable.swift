
import RxSwift
import RxTest

/// Need for `expect()` of Quick test framework
extension Recorded: Equatable where Value: Equatable { }

/// Need for `expect()` of Quick test framework
extension Event: Equatable where Element: Equatable { }
