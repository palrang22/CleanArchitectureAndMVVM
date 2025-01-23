//
//  EntityError.swift
//  CleanArchitectureAndMVVM
//
//  Created by 김승희 on 1/23/25.
//

import Foundation

public enum NetworkError: Error {
    case urlError
    case invalid
    case failToDecode(String)
    case dataNil
    case serverError(Int)
    case requestFailed(String) //특정 이유로 서버요청 실패
    
    public var description: String {
        switch self {
        case .urlError:
            "URL이 올바르지 않습니다."
        case .invalid:
            "응답값이 유효하지 않습니다."
        case .failToDecode(let description):
            "디코딩 에러 \(description)"
        case .dataNil:
            "데이터가 없습니다."
        case .serverError(let statusCode):
            "서버 에러: \(statusCode)"
        case .requestFailed(let messsage):
            "서버 요청 실패: \(messsage)"
        }
    }
}
