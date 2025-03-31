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
    
    // 유저리스트 -> 즐겨찾기 포함된 유저인지
    func checkFavoriteState(fetchUsers: [UserListItem], favoriteUsers: [UserListItem]) -> [(user: UserListItem, isFavorite: Bool)]
    
    // 배열 -> Dictionary [초성: [유저리스트]]
    func convertListToDictionary(favoriteUsers: [UserListItem]) -> [String: [UserListItem]]
    
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
    
    public func checkFavoriteState(fetchUsers: [UserListItem], favoriteUsers: [UserListItem]) -> [(user: UserListItem, isFavorite: Bool)] {
        let favoriteSet = Set(favoriteUsers)
        return fetchUsers.map { user in
            if favoriteSet.contains(user){
                return (user: user, isFavorite: true)
            } else {
                return (user: user, isFavorite: false)
            }
        }
    }
    
    public func convertListToDictionary(favoriteUsers: [UserListItem]) -> [String : [UserListItem]] {
        return favoriteUsers.reduce(into: [String: [UserListItem]]()) { dict, user in
            if let firstString = user.login.first {
                let key = String(firstString).uppercased()
                dict[key, default: []].append(user)
            }
        }
    }
}
