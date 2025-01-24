//
//  UserSession.swift
//  CleanArchitectureAndMVVM
//
//  Created by 김승희 on 1/23/25.
//

import Foundation
import Alamofire

// 네트워크 호출과 관련한 테스트 코드 MockSession 추상화
// 다음과 같이 해두면, UserSession을 쓰는 곳에서 다른 SessionProtocol 따르는 클래스로 갈아끼워도 오류가 나지 않음

public protocol SessionProtocol {
    func request(_ convertible: URLConvertible,
                 method: HTTPMethod,
                 parameters: Parameters?,
                 headers: HTTPHeaders?) -> DataRequest
}


//Session
class UserSession: SessionProtocol {
    private var session: Session
    init(session: Session) {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = Session(configuration: config)
    }
    
    func request(_ convertible: any URLConvertible,
                 method: HTTPMethod = .get,
                 parameters: Parameters? = nil,
                 headers: HTTPHeaders? = nil) -> DataRequest {
        return session.request(convertible, method: method, parameters: parameters, headers: headers)
    }
}

////구현단
//NetworkManager(session: UserSession())
//
//// 테스트
//NetworkManager(session: MockSession())
