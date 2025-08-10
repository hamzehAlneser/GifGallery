//
//  SearchService.swift
//  GIFGallert
//
//  Created by Hamzeh on 10/08/2025.
//

import Foundation

struct SearchService {
    func searchItems(searchText: String, pageNumber: Int, completion: @escaping (Result<BasePaginationResponse<ItemResponseModel>, CustomErrors>) -> Void) {
        guard let url = generateTrendingURL(searchText: searchText, pageNumber: pageNumber) else {
            completion(.failure(.genralError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data else {
               completion(.failure(.genralError))
               return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(BasePaginationResponse<ItemResponseModel>.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                print(error)
                completion(.failure(.genralError))
            }

        }.resume()
    }
}

//MARK: - Helper Methods
extension SearchService {
    private func generateTrendingURL(searchText: String,pageNumber: Int) -> URL? {
        let offset = (pageNumber * APIConstants.PageSize) - APIConstants.PageSize
        
        let queryItems = [
            URLQueryItem(name: "api_key", value: APIConstants.API_KEY),
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "limit", value: String(APIConstants.PageSize)),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "rating", value: APIConstants.Rating),
            URLQueryItem(name: "country", value: APIConstants.Country)
        ]
        
        let queryString = queryItems
            .compactMap { "\($0.name)=\($0.value ?? "")" }
            .joined(separator: "&")
        
        return URL(string: "\(APIConstants.SearchEndPoint)?\(queryString)") ?? nil
    }
}
