//
//  BookMarkDetailComponent.swift
//  BookMarkFeature
//
//  Created by yongbeomkwak on 10/20/23.
//  Copyright © 2023 com. All rights reserved.
//

import Foundation
import NeedleFoundation
import BookMarkDomainInterface
import BookMarkFeatureInterface
import UIKit
import BaseFeatureInterface

public protocol BookMarkDetailDependency: Dependency {
    
    var bookMarkDomainFactory: any BookMarkDomainFactory { get }
}

public final class BookMarkDetailComponent: Component<BookMarkDetailDependency>, BookMarkDetailFactory {

    
    public func makeView(id: Int, name: String) -> UIViewController {
        BookMarkDetailViewController(viewModel: BookMarkDetailViewModel(id: id,bookMarkGroupName: name, fetchBookMarkDetailUseCase: dependency.bookMarkDomainFactory.fetchBookMarkDetailUseCase, removeBookMarkUseCase: dependency.bookMarkDomainFactory.removeBookMarkUseCase))
    }
}
