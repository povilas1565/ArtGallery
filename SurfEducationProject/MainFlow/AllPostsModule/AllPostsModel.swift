//
//  AllPostsModel.swift
//  SurfSummerSchoolProject
//
//  Created by Павел Рыжков on 06.08.2022.
//
import Foundation
import UIKit

final class AllPostsModel {
    static let shared = AllPostsModel.init()
    enum LoadState {
        case idle
        case success
        case error
    }

    var currentState: LoadState = .idle
    var didPostsUpdated: (()->Void)?
    var didPostsFetchErrorHappened: (()->Void)?

    let favoritesStorage = FavoritesStorage.shared
    let pictureService = PicturesService()
    var posts: [PostModel] = []
    var favoritePosts: [PostModel] {
        posts.filter { $0.isFavorite }
    }

    func filteredPosts(searchText: String)->[PostModel] {
        posts.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }

    func loadPosts() {
        pictureService.loadPictures { [weak self] result in
            self?.currentState = .idle
            switch result {
            case .success(let pictures):
                self?.posts = pictures.map { pictureModel in
                    PostModel(
                            imageUrlInString: pictureModel.photoUrl,
                            title: pictureModel.title,
                            isFavorite: self?.favoritesStorage.isPostFavorite(post: pictureModel.title) ?? false,
                            content: pictureModel.content,
                            dateCreation: pictureModel.date
                    )
                }
                self?.currentState = .success
                self?.didPostsUpdated?()

            case .failure(let error):
                self?.currentState = .error
                self?.didPostsFetchErrorHappened?()
                print(error)
            }
        }
    }

    func favoritePost(for post: PostModel) {
        guard let index = posts.firstIndex(where: { $0.title == post.title }) else { return }
        posts[index].isFavorite.toggle()
    }
}

struct PostModel: Equatable {
    let imageUrlInString: String
    let title: String
    var isFavorite: Bool
    let content: String
    let dateCreation: String

    internal init(imageUrlInString: String, title: String, isFavorite: Bool, content: String, dateCreation: Date) {
        self.imageUrlInString = imageUrlInString
        self.title = title
        self.isFavorite = isFavorite
        self.content = content

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.mm.yyyy"

        self.dateCreation = formatter.string(from: dateCreation)
    }

    func createEmptyModel() -> PostModel {
        let emptyModel = PostModel(imageUrlInString: "", title: "", isFavorite: false, content: "", dateCreation: Date())
        return emptyModel
    }
}

