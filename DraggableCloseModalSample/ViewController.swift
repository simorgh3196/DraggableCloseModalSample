//
//  ViewController.swift
//  DraggableCloseModalSample
//
//  Created by Tomoya Hayakawa on 2017/10/19.
//  Copyright © 2017年 TomoyaHayakawa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupButton()
    }

    func setupButton() {
        button.setTitle("Open Modal", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
    }

    @objc func didTapButton(sender: UIButton) {
        let modalViewController = ModelViewController()
        present(modalViewController, animated: true)
    }
}
