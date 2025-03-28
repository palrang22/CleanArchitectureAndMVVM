//
//  UserRepository.swift
//  CleanArchitectureAndMVVM
//
//  Created by 김승희 on 3/28/25.
//
// 외부 레이어 (ex. 도메인) 에서 데이터에 접근하기 위한 통로

import Foundation

public struct UserRepository: UserRepositoryProtocol {
    private let coreData: UserCoreDataProtocol, network: UserNetworkProtocol
    
    // 데이터, 네트워크 받아서 사용
    init(coreData: UserCoreDataProtocol, network: UserNetworkProtocol) {
        self.coreData = coreData
        self.network = network
    }
    
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        return await network.fetchUser(query: query, page: page)
    }
    
    public func getFavoriteUsers() -> Result<[UserListItem], CoredataError> {
        return coreData.getFavoriteUsers()
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoredataError> {
        return coreData.saveFavoriteUser(user: user)
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, CoredataError> {
        return coreData.deleteFavoriteUser(userID: userID)
    }

}
