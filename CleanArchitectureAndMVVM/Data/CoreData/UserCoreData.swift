//
//  UserCoreData.swift
//  CleanArchitectureAndMVVM
//
//  Created by 김승희 on 3/28/25.
//

import Foundation
import CoreData

public protocol UserCoreDataProtocol {
    func getFavoriteUsers() -> Result<[UserListItem], CoredataError>
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoredataError>
    func deleteFavoriteUser(userID: Int) -> Result<Bool, CoredataError>
}


public struct UserCoreData: UserCoreDataProtocol {
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    public func getFavoriteUsers() -> Result<[UserListItem], CoredataError> {
        let fetchRequest: NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
        do {
            let result = try viewContext.fetch(fetchRequest)
            let userList: [UserListItem] = result.compactMap {favoriteUser in
                guard let login = favoriteUser.login, let imageUrlString = favoriteUser.imageURL else { return nil }
                return UserListItem(id: Int(favoriteUser.id), login: login, imageURL: imageUrlString)
            }
            return .success(userList)
        } catch {
            return .failure(.readError(error.localizedDescription))
        }
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoredataError> {
        guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteUser", in: viewContext) else {
            return .failure(.entityNotFound("FavoriteUser"))
        }
        let userObject = NSManagedObject(entity: entity, insertInto: viewContext)
        userObject.setValue(user.id, forKey: "id")
        userObject.setValue(user.imageURL, forKey: "imageURL")
        userObject.setValue(user.login, forKey: "login")
        
        do {
            try viewContext.save()
            return .success(true)
        } catch {
            return .failure(.saveError(error.localizedDescription))
        }
        
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, CoredataError> {
        let fetchRequest: NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", userID)
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            result.forEach { favoriteUser in
                viewContext.delete(favoriteUser)
            }
            try viewContext.save()
            return .success(true)
        } catch {
            return .failure(.deleteError(error.localizedDescription))
        }
    }
}
