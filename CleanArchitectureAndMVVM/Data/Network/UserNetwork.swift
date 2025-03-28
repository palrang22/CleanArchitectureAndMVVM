//
//  UserNetwork.swift
//  CleanArchitectureAndMVVM
//
//  Created by 김승희 on 3/28/25.
//

public protocol UserNetworkProtocol {
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError>
}

final public class UserNetwork: UserNetworkProtocol {
    
    private let manager: NetworkManagerProtocol
    
    init(manager: NetworkManagerProtocol) {
        self.manager = manager
    }
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        let url = "https://api.github.com/search/users?q=\(query)&page=\(page)"
        return await manager.fetchData(url: url, method: .get, parameters: nil)
    }
}
