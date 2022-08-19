//
//  ErrorTypes.swift
//  SurfSummerSchoolProject
//
// Created by Павел Рыжков on 19.08.2022.
//

import Foundation

//MARK: - Possible errors
enum PossibleErrors: Error {

    case unknownError
    case urlWasNotFound
    case urlComponentWasNotCreated
    case parametersIsNotValidJsonObject
    case badRequest([String:String])
    case noNetworkConnection
    case unknownServerError
}
