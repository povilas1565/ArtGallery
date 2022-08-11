//
//  NetworkTask.swift
//  SurfSummerSchoolProject
//
//  Created by Павел Рыжков on 09.08.2022.
//

import Foundation

protocol NetworkTask {

associatedtype Input: Encodable
associatedtype Output: Decodable

var baseURL: URL? { get }
var path: String { get }
var completedURL: URL? { get }
var method: NetworkMethod { get }

func performRequest(input: Input,
       _onResponseWasReceived: @escaping (_result:Result<Output, Error>) -> Void
       )

  }

      extension NetworkTask {

      var completedUrl: URL? {
          baseURL?.appendingPathComponent(path)
          }
}
