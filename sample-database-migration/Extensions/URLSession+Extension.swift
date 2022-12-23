//
//  URLSession+Extension.swift
//  sample-database-migration
//
//  Created by Ruben Torres on 23/12/22.
//

import Combine
import Foundation

protocol URLSessionType {
    func request(urlString: String, requestType: RequestType) -> AnyPublisher<Data, Error>
}

extension URLSession: URLSessionType {
    func request(
        urlString: String,
        requestType: RequestType
    ) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.unknown)
                }
                guard httpResponse.statusCode == 200 else {
                    let code = URLError.Code(rawValue: httpResponse.statusCode)
                    throw URLError(code)
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}

enum RequestType: String {
    case get = "GET"
}

enum NetworkError: Error, Identifiable {
    var id: Self { self }
    case failLoadData
    case invalidURL
    case withouConnection
}
