//
//  UserRepositoryProtocol.swift
//  CleanArchitectureAndMVVM
//
//  Created by 김승희 on 1/23/25.
//

import Foundation

public protocol UserRepositoryProtocol {
    
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> // 유저 리스트 불러오기(원격)
    func getFavoriteUsers() -> Result<[UserListItem], CoredataError> // 전체 리스트
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoredataError> //coredata이므로 async 필요 x
    func deleteFavoriteUser(userID: Int) -> Result<Bool, CoredataError>
    
}
