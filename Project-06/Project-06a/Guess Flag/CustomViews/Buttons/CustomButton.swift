//
//  CustomButton.swift
//  Guess Flag
//
//  Created by Kadirhan Keles on 28.03.2023.
//

import UIKit

class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(imageName: String, tag: Int) {
        self.init(frame: .zero)
        setImage(imageName: imageName)
        self.tag = tag
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        //addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func setImage(imageName: String){
        setImage(UIImage(named: imageName), for: .normal)
    }
    
}
