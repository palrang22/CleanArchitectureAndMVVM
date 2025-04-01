//
//  NetworkManager.swift
//  CleanArchitectureAndMVVM
//
//  Created by 김승희 on 1/23/25.
//

import Foundation
import Alamofire


protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(url: String, method: HTTPMethod, parameters: Parameters?) async -> Result<T, NetworkError>
}


public class NetworkManager: NetworkManagerProtocol {
    
    let apiKey = Bundle.main.infoDictionary?["APIKey"] as! String
    
    private let session: SessionProtocol
    init(session: SessionProtocol) {
        self.session = session
    }
    
    private var tokenHeader: HTTPHeaders {
        let tokenHeader = HTTPHeader(name: "Authorization", value: "Bearer \(apiKey)")
        return HTTPHeaders([tokenHeader])
    }
    
    func fetchData<T: Decodable>(url: String, method: HTTPMethod, parameters: Parameters?) async -> Result<T, NetworkError> {
        guard let url = URL(string: url) else {
            return .failure(.urlError)
        }
        
        let result = await session.request(url, method: method, parameters: parameters, headers: tokenHeader).serializingData().response
        
        if let error = result.error { return .failure(.requestFailed(error.localizedDescription))}
        
        guard let data = result.data else { return .failure(.dataNil) }
        guard let response = result.response else { return .failure(.invalidResponse) }
        
        if 200..<400 ~= response.statusCode {
            do {
                let data = try JSONDecoder().decode(T.self, from: data)
                return .success(data)
            } catch {
                return .failure(.failToDecode(error.localizedDescription))
            }
        } else {
            return .failure(.serverError(response.statusCode))
        }
    }
    
}

//// 제네릭
//fetchData() -> User
//fetchData() -> Store
//fetchData() -> Car
