//
//  TokenStorage.swift
//  SurfSummerSchoolProject
//
//  Created by Павел Рыжков on 09.08.2022.
//


import Foundation

protocol TokenStorage {

    func getToken() throws -> TokenContainer
    func set(newToken: TokenContainer) throws

}