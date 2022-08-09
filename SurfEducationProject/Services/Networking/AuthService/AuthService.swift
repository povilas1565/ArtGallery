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
        dataTask.performRequest(input: credentials) { result in
            if case let .success(responseModel) = result {
                do {
                    try dataTask.tokenStorage.set(newToken: TokenContainer(token: responseModel.token, receivingDate: .now))
                } catch {
                    // TODO: - Handle error if token not was received from server
                }
            }

            onResponseWasReceived(result)
        }
    }

}