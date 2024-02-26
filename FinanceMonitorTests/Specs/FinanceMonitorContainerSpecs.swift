import Foundation
import Nimble
import Quick
import CombinePlus

@testable import FinanceMonitor

class FinanceMonitorContainerSpecs: QuickSpec {

    private struct Test: Decodable {
        let id: Int
        let message: String
    }

    override func spec() {

        describe("ContainerSpec") {

            var json: String!
            var result: Container<Test>!

            context("when JSON is raw data") {

                beforeEach {
                    json = """
                    {
                        "id" : 1,
                        "message" : "Hello World!"
                    }
                    """
                    result = try! JSONDecoder().decode(
                        Container<Test>.self,
                        from: json.data(using: .utf8)!
                    )
                }

                it("should parse data correctly") {
                    expect(result.data!.id) == 1
                    expect(result.data!.message) == "Hello World!"
                    expect(result.error) == nil
                }
            }

            context("when JSON has `data` field") {

                beforeEach {
                    json = """
                    {
                        "data": {
                            "id" : 1,
                            "message" : "Hello World!"
                        }
                    }
                    """

                    result = try! JSONDecoder().decode(
                        Container<Test>.self,
                        from: json.data(using: .utf8)!
                    )
                }

                it("should parse data correctly") {
                    expect(result.data!.id) == 1
                    expect(result.data!.message) == "Hello World!"
                    expect(result.error) == nil
                }
            }

            context("when JSON has `error` field") {

                beforeEach {
                    json = """
                    {
                        "data": {},
                        "code": 400,
                        "error": {
                            "name" : "Error",
                            "message": "Error message"
                        }
                    }
                    """

                    result = try! JSONDecoder().decode(
                        Container<Test>.self,
                        from: json.data(using: .utf8)!
                    )
                }

                it("should parse data correctly") {
                    let expectedError: APIError = .some(code: 400, error: .init(name: "Error", message: "Error message"))
                    expect(result.data) == nil
                    expect(result.error) == expectedError
                    expect(result.error?.errorDescription) == "400\nError\nError message"
                }
            }

            context("when JSON has `errors` field") {

                context("error has one message") {

                    beforeEach {
                        json = """
                        {
                            "data": {},
                            "code": 400,
                            "errors": [
                                {
                                    "name" : "Error 1",
                                    "message": "Error message 1"
                                },
                                {
                                    "name" : "Error 2",
                                    "message": "Error message 2"
                                }
                            ]
                        }
                        """

                        result = try! JSONDecoder().decode(
                            Container<Test>.self,
                            from: json.data(using: .utf8)!
                        )
                    }

                    it("should parse data correctly") {
                        let expectedError: APIError = .multiple(
                            code: 400,
                            errors: [
                                .init(
                                    name: "Error 1",
                                    messages: ["Error message 1"]
                                ),
                                .init(
                                    name: "Error 2",
                                    messages: ["Error message 2"]
                                ),

                            ]
                        )

                        let expectedErrorMessage =
                        """
                        400

                        Error 1
                        Error message 1

                        Error 2
                        Error message 2
                        """

                        expect(result.data) == nil
                        expect(result.error) == expectedError
                        expect(result.error?.errorDescription) == expectedErrorMessage
                    }
                }

                context("error has several messages") {

                    beforeEach {
                        json = """
                        {
                            "data": {},
                            "code": 400,
                            "errors": [
                                {
                                    "name" : "Error",
                                    "message": [
                                        "Error message 1",
                                        "Error message 2"
                                    ]
                                }
                            ]
                        }
                        """

                        result = try! JSONDecoder().decode(
                            Container<Test>.self,
                            from: json.data(using: .utf8)!
                        )
                    }

                    it("should parse data correctly") {
                        let expectedError: APIError = .multiple(
                            code: 400,
                            errors: [
                                .init(
                                    name: "Error",
                                    messages: ["Error message 1", "Error message 2"]
                                )

                            ]
                        )

                        let expectedErrorMessage = """
                        400

                        Error
                        Error message 1; Error message 2
                        """

                        expect(result.data) == nil
                        expect(result.error) == expectedError
                        expect(result.error?.errorDescription) == expectedErrorMessage
                    }
                }
            }
        }
    }


}
