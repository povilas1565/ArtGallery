//
//  NetworkMethod.swift
//  SurfSummerSchoolProject
//
//  Created by Павел Рыжков on 09.08.2022.
//

import Foundation

protocol NetworkMethod {}
public enum NetworkMethod: String {

case get
cade post
}

extension NetworkMethod {

        var method: String {
             rawValue.uppercased()
        }

 }

