//
//  RemoteSearchDatasourceImpl.swift
//  SearchDomainInterface
//
//  Created by 박의서 on 2023/10/23.
//  Copyright © 2023 com. All rights reserved.
//

import Foundation
import BaseDomain
import SearchDomainInterface
import RxSwift

final class RemoteSearchDatasourceImpl: BaseRemoteDataSource<SearchAPI>, RemoteSearchDatasource {
    func fetchPrintShopList(searchText: String, tagIds: [Int]) -> Single<[PrintShopListEntity]> {
        request(.list(searchText: searchText, tagIds: tagIds))
            .map([PrintShopListResponseDto].self)
            .map({$0.map {$0.toDomain()}})
    }
}
