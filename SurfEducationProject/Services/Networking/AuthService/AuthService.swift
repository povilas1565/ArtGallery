import Foundation

struct AuthService {

    let dataTask = BaseNetworkTask<AuthRequestModel, AuthResponseModel>(
        inNeedInjectToken: false,
        method: .post,
        path: "auth/login"
    )

    func performLoginRequest(
        credentials: AuthRequestModel,
        _ onResponseWasReceived: @escaping (_ result: Result<AuthResponseModel, Error>) -> Void
    ) {
        dataTask.performRequest(input: credentials, onResponseWasReceived)
    }

}