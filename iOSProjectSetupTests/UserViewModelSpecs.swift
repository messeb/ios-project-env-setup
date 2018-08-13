import XCTest
@testable import iOSProjectSetup
import Quick
import Nimble
import RxSwift
import RxCocoa
import RxBlocking
import RxTest

class UserViewModelSpecs: QuickSpec {
    override func spec() {
        var sut: UserViewModel!
        var repository: UserRepositoryFake!
        var scheduler: TestScheduler!

        beforeEach {
            scheduler = TestScheduler()
            repository = UserRepositoryFake()
            sut = UserPresentableViewModel(repository: repository)
        }

        describe("init") {
            it("sets the default salutation") {
                let expectedEvent = Event.record(element: String.empty)
                let result = scheduler.record(source: sut.outputs.salutation)

                expect(result.events) == expectedEvent
            }

            it("sets the default firstname") {
                let expectedEvent = Event.record(element: String.empty)
                let result = scheduler.record(source: sut.outputs.firstname)

                expect(result.events) == expectedEvent
            }

            it("sets the default lastname") {
                let expectedEvent = Event.record(element: String.empty)
                let result = scheduler.record(source: sut.outputs.lastname)

                expect(result.events) == expectedEvent
            }

            it("sets the default image") {
                let image: UIImage? = nil
                let expectedEvents = Event.record(element: image)
                let result = scheduler.record(source: sut.outputs.image)

                expect(result.events) == expectedEvents
            }
        }

        describe("fetches User") {
            it("sets updated salutation") {
                let expectedEvents = Event.record(elements: [
                    String.empty,
                    User.fake().name.title
                ])
                let result = scheduler.record(source: sut.outputs.salutation)

                sut.inputs.fetch()

                expect(result.events) == expectedEvents
            }

            it("sets updated firstname") {
                let expectedEvents = Event.record(elements: [
                    String.empty,
                    User.fake().name.first
                ])
                let result = scheduler.record(source: sut.outputs.firstname)

                sut.inputs.fetch()

                expect(result.events) == expectedEvents
            }

            it("sets updated lastname") {
                let expectedEvents = Event.record(elements: [
                    String.empty,
                    User.fake().name.last
                ])
                let result = scheduler.record(source: sut.outputs.lastname)

                sut.inputs.fetch()

                expect(result.events) == expectedEvents
            }

            it("sets updated image") {
                let result = scheduler.record(source: sut.outputs.image)
                sut.inputs.fetch()

                expect(result.events.count) == 2
                expect(result.events.last?.value.element).notTo(beNil())
            }
        }
    }
}
