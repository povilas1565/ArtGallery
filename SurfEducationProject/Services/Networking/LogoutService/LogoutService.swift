//
//  LogoutService.swift
//  SurfSummerSchoolProject
//
// Created by Павел Рыжков on 17.08.2022.
//

import Foundation

struct LogoutService {

    let dataTask = BaseNetworkTask<EmptyModel, EmptyModel>(
            inNeedInjectToken: false,
            method: .post,
            path: "auth/logout"
    )

    func performLogoutRequestAndRemoveToken(_ onResponseWasReceived: @escaping (_ result: Result<String, Error>) -> Void
    ) {
        dataTask.performRequest(input: EmptyModel()) { result in
            if case .success(_) = result {
                do {
                    try dataTask.tokenStorage.removeTokenFromContainer()
                    try dataTask.profileStorage.removeProfile()
                    onResponseWasReceived(result)
                } catch {
                    onResponseWasReceived(result)
                }
            }
            onResponseWasReceived(result)
        }
    }

}