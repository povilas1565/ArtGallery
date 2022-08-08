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

