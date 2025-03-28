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
    public init(usecase: UserListUsecaseProtocol) {
        self.usecase = usecase
    }
    
    //이벤트(VC) -> 가공 혹은 외부에서 데이터 호출 또는 뷰 데이터(VM)을 전달 -> VC
    
    // 뷰모델의 역할을 명시적으로 나타낼 수 있는 패턴
    public struct Input { // VM에 전달되어야 할 이벤트 Observable 전달
        // 탭, 텍스트필드, 즐겨찾기 추가 or 삭제, 페이지네이션
        
        let tapButtonType: Observable<TapButtonType>
        let query: Observable<String>
        let saveFavorite: Observable<UserListItem>
        let deleteFavorite: Observable<Int>
        let fetchMore: Observable<Void>
        
    }
    
    public struct Output { // VC에 전달할 뷰 데이터
        // cell data(유저 리스트), error
        let cellData:  Observable<[UserListItem]> // 초성
        let error: Observable<String>
    }
    
    public func transform(inputL input) { // VC이벤트 -> VM데이터
        
        input.query.bind { query in
            //TODO: 상황에 맞춰서 user fetch or get favorite users
        }.disposed(by: DisposeBag)
        
        input.saveFavorite.bind { user in
            //TODO: 즐겨찾기 추가
        }.disposed(by: DisposeBag)
        
        input.deleteFavorite.bind { userID in
            //TODO: 즐겨찾기 삭제
        }.disposed(by: <#T##DisposeBag#>)
        
        input.fetchMore.bind {
            //TODO: 다음 페이지 검색
        }
        
        // 탭 : api 유저 or 즐겨찾기 유저

    }
}

public enum TapButtonType {
    case api
    case favorite
}

public enum UserListCellData { // enum 타입이 list 형태로 들어감
    case user(user: UserListItem, isFavorite: Bool)
    case header(String)
}
