//
//  ViewController.swift
//  Weather app
//
//  Created by Rubens Moura Augusto on 05/07/24.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var customView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        view.backgroundColor = .gray
        
        // always add the custonView on the view before contraint customView
        setHierarchy()
        //create the constraints
        setConstraints()
    }
    
    private func setHierarchy() {
        view.addSubview(customView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            customView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            customView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            customView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }


}

