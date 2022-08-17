//
//  ProfileStorage.swift
//  SurfSummerSchoolProject
//
// Created by Павел Рыжков on 17.08.2022.
//

import Foundation

protocol ProfileStorage {

    func getProfileInfo() throws -> ProfileModel
    func set(profile: ProfileModel) throws
    func removeProfile() throws

}