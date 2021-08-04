extension Router {

    enum User {

        static func login(email: String, password: String) -> Router {
            return Router(
                path: "/users/sign_in",
                method: .post,
                params: [
                    "email": email,
                    "password": password
                ]
            )
        }

        static func register(email: String, password: String) -> Router {
            return Router(
                path: "/users",
                method: .post,
                params: [
                    "email": email,
                    "password": password,
                    "password_confirmation": password
                ]
            )
        }
    }
}
