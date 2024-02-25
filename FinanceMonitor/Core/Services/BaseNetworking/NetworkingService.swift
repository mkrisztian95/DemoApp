import CombinePlus
import Foundation

public protocol NetworkingService {
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, APIError>
}

open class NetworkService<E: Endpoint>: NetworkingService {

    // MARK: - Private properties

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // MARK: - Public interface

    public func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, APIError> {
        do {
            let request = try request(for: endpoint)
            return dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .tryMap { [weak self] data, _ -> T in
                    guard let self else { throw APIError.noData }
                    do {
                        let container = try decoder(for: endpoint).decode(Container<T>.self, from: data)
                        if let error = container.error {
                            throw error
                        } else if let data = container.data {
                            return data
                        } else {
                            throw APIError.noData
                        }
                    } catch {
                        print(error.localizedDescription)
                        throw error
                    }
                }
                .mapToErrorType(APIError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .mapToErrorType(APIError.self)
                .eraseToAnyPublisher()
        }
    }

    private func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), URLError> {
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(URLError.Code(rawValue: 1301))
                }
                return (data, httpResponse)
            }
            .mapError { error in
                error as! URLError // swiftlint:disable:this force_cast
            }
            .eraseToAnyPublisher()
    }

    private func request(for endpoint: Endpoint) throws -> URLRequest {
        guard
            let path = endpoint.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            var components = URLComponents(string: endpoint.host + path) else {
            throw APIError.invalidBaseURL(endpoint.host + endpoint.path)
        }

        components.queryItems = endpoint.queryItems

        guard let url = components.url else {
            throw APIError.invalidBaseURL(endpoint.host + endpoint.path)
        }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers(for: endpoint)
        request.httpBody = endpoint.body.flatMap { body in
            if let body = body as? Data {
                body
            } else {
                try? encoder(for: endpoint).encode(body)
            }
        }
        request.httpMethod = endpoint.method.rawValue

        return request
    }

    open func encoder(for endpoint: Endpoint) -> JSONEncoder {
        encoder
    }

    open func decoder(for endpoint: Endpoint) -> JSONDecoder {
        decoder
    }

    open func headers(for endpoint: Endpoint) -> [String: String]? {
        nil
    }
}
