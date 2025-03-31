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
        input.query.bind { query in
            //TODO: 상황에 맞춰서 user fetch 또는 get favorite users
        }.disposed(by: disposeBag)
        
        input.saveFavorite.bind { user in
            //TODO: 즐겨찾기 추가
        }.disposed(by: disposeBag)
        
        input .deleteFavorite.bind { userID in
            //TODO: 즐겨찾기 삭제
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
}


public enum TabButtonType {
    case api
    case favorite
}

public enum UserListCelldata {
    case user(user: UserListItem, isFavorite: Bool)
    case header(String)
}
