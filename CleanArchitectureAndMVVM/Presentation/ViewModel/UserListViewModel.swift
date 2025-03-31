//
//  UserlistViewModel.swift
//  CleanArchitectureAndMVVM
//
//  Created by 김승희 on 3/11/25.
//

import Foundation

import RxCocoa
import RxSwift

protocol UserListViewModelProtocol {
    
}

public final class UserListViewModel: UserListViewModelProtocol {
    private let usecase: UserListUsecaseProtocol
    private let disposeBag = DisposeBag()
    private let error = PublishRelay<String>()
    private let fetchUserList = BehaviorRelay<[UserListItem]>(value: [])
    private let allFavoriteUserList = BehaviorRelay<[UserListItem]>(value: []) // fetchUser 즐겨찾기 여부를 위한 전체 목록
    private let favoriteUserList = BehaviorRelay<[UserListItem]>(value: []) // 목록에 보여줄 리스트
    
    public init(usecase: UserListUsecaseProtocol) {
        self.usecase = usecase
    }
    
    public struct Input {
        let tabButtonType: Observable<TabButtonType>
        let query: Observable<String>
        let saveFavorite: Observable<UserListItem>
        let deleteFavorite: Observable<Int>
        let fetchMore: Observable<Void>
    }
    
    public struct Output {
        let cellData: Observable<[UserListCelldata]>
        let error: Observable<String>
    }
    
    public func transform(input: Input) -> Output {
        input.query.bind { [weak self ] query in
            //TODO: 상황에 맞춰서 user fetch 또는 get favorite users
            guard let isValidate = self?.validateQuery(query: query), isValidate else {
                self?.getFavoriteUser(query: "")
                return
            }
            self?.fetchUser(query: query, page: 0)
            self?.getFavoriteUser(query: query)
        }.disposed(by: disposeBag)
        
        input.saveFavorite
        // 이벤트가 발생했을 때 어떤 값이 필요하면 withLatestFrom 사용 가능
        // user만 있는 곳에 query를 넣어서 같이 사용 가능
            .withLatestFrom(input.query, resultSelector: { users, query in
                return (users, query)
            })
            .bind { [ weak self ] user, query in
            //TODO: 즐겨찾기 추가
            self?.saveFavoriteUser(user: user, query: query)
        }.disposed(by: disposeBag)
        
        input
            .deleteFavorite
        // 이벤트가 발생했을 때 어떤 값이 필요하면 withLatestFrom 사용 가능
        // user만 있는 곳에 query를 넣어서 같이 사용 가능
            .withLatestFrom(input.query, resultSelector: { ($0, $1) })
            .bind { [ weak self ] userID, query in
            //TODO: 즐겨찾기 추가
            self?.deleteFavoriteUser(userID: userID, query: query)
        }.disposed(by: disposeBag)
        
        input .fetchMore.bind {
            
        }.disposed(by: disposeBag)
        
        
        //탭, 유저리스트, 즐겨찾기리스트
        //combineLatest: 그 안에 있는 것들중 하나만 바뀌어도 호출됨
        let cellData: Observable<[UserListCelldata]> = Observable
            .combineLatest(input.tabButtonType,
                           fetchUserList,
                           favoriteUserList).map { tabButtonType,
                fetchUserList,
            favoriteUserList in
            let cellData: [UserListCelldata] = []
            
                //TODO: CellData 생성
            return cellData
        }
        
        
        return Output(cellData: cellData, error: error.asObservable())
        
    }
    
    private func fetchUser(query: String, page: Int) {
        guard let urlAllowedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        Task {
            let result = await usecase.fetchUser(query: query, page: page)
            switch result {
            case let .success(users):
                if page == 0 {
                    // 첫 번째 페이지
                    fetchUserList.accept(users.items)
                } else {
                    // 두 번째 이상의 페이지
                    fetchUserList.accept(fetchUserList.value + users.items)
                }
            case let .failure(error):
                self.error.accept(error.description)
            }
        }
    }
    
    private func getFavoriteUser(query: String) {
        let result = usecase.getFavoriteUsers()
        
        switch result {
        case let .success(users):
            if query.isEmpty {
                // 그게 아니라면 전체 list return
                favoriteUserList.accept(users)
            } else {
                // 검색어가 있을 때 포함된거만 필터링
                let filteredUsers = users.filter { user in
                    user.login.contains(query)
                }
                favoriteUserList.accept(filteredUsers)
            }
            allFavoriteUserList.accept(users) //즐겨찾기 비교용
        case let .failure(error):
            self.error.accept(error.description)
        }
    }
    
    private func saveFavoriteUser(user: UserListItem, query: String) { // 입력값이 있을수도, 없을수도 있음
        let result = usecase.saveFavoriteUser(user: user)
        switch result {
        case let .success(user):
            getFavoriteUser(query: query)
        case let .failure(error):
            self.error.accept(error.description)
        }
    }
    
    private func deleteFavoriteUser(userID: Int, query: String) {
        let result = usecase.deleteFavoriteUser(userID: userID)
        switch result {
        case .success:
            getFavoriteUser(query: query)
        case let .failure(error):
            self.error.accept(error.description)
        }
    }
    
    private func validateQuery(query: String) -> Bool {
        if query.isEmpty {
            return false
        } else {
            return true
        }
    }
}


public enum TabButtonType {
    case api
    case favorite
}

public enum UserListCelldata {
    case user(user: UserListItem, isFavorite: Bool)
    case header(String)
}
