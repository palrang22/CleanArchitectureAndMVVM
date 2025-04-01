//
//  UserListViewController.swift
//  CleanArchitectureAndMVVM
//
//  Created by 김승희 on 4/1/25.
//

import UIKit

class UserListViewController: UIViewController {
    private let viewModel: UserListViewModelProtocol
    
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
