
//
//  TabBarModel.swift
//  SurfSummerSchoolProject
//
//  Created by Рыжков Павел on 04.08.2022.
//

import Foundation
import UIKit

private enum TabBarImages {
    static let allPostsTab: UIImage? = ImagesStorage.allPostsTab
    static let favoritePosts: UIImage? = ImagesStorage.favoritePostsTab
    static let profileTab: UIImage? = ImagesStorage.profileTab
}

enum TabBarModel {
    case allPosts
    case favoritePosts
    case profile

    var title: String {
        switch self {
        case .allPosts:
            return "Main"
        case .favoritePosts:
            return "Favourites"
        case .profile:
            return "Profile"
        }
    }
    var image: UIImage? {
        switch self {
        case .allPosts:
            return TabBarImages.allPostsTab
        case .favoritePosts:
            return TabBarImages.favoritePosts
        case .profile:
            return TabBarImages.profileTab
        }
    }

    var selectedImage: UIImage? {
        return image
    }
}

