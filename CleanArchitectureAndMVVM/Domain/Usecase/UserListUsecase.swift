//
//  UserListUseCase.swift
//  CleanArchitectureAndMVVM
//
//  Created by 김승희 on 1/23/25.
//

import Foundation

public protocol UserListUsecaseProtocol {
    
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> // 유저 리스트 불러오기(원격)
    func getFavoriteUsers() -> Result<[UserListItem], CoredataError> // 전체 리스트
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoredataError> //coredata이므로 async 필요 x
    func deleteFavoriteUser(userID: Int) -> Result<Bool, CoredataError>
    
    // 배열 -> Dictionary [초성: [유저리스트]]
    // 유저리스트 -> 즐겨찾기 포함된 유저인지
    
}

public struct UserListUsecase: UserListUsecaseProtocol {
//    // 이렇게 하면 저수준 의존
//    private let repository: UserListRepository
//    init(repository: UserListRepository)
    
    // 고수준(프로토콜)으로 의존
    private let repository: UserRepositoryProtocol
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        await repository.fetchUser(query: query, page: page)
    }
    
    public func getFavoriteUsers() -> Result<[UserListItem], CoredataError> {
        repository.getFavoriteUsers()
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoredataError> {
        repository.saveFavoriteUser(user: user)
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, CoredataError> {
        repository.deleteFavoriteUser(userID: userID)
    }
    
    
}
