//
//  BasePaginationResponse.swift
//  GIFGallert
//
//  Created by Hamzeh on 09/08/2025.
//

struct BasePaginationResponse<T: Decodable>: Decodable {
    let data: [T]
    let pagination: PaginationResponseModel
}
//MARK: - Pagination Model
struct PaginationResponseModel: Decodable {
    let total_count: Int
    let count: Int
    let offset: Int
}
