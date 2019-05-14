//
//  GameCellView.swift
//  Game2048
//
//  Created by Kirill Varlamov on 10/05/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import UIKit

let fontScaleFactor = UIScreen.main.nativeBounds.width / 640 //Берется ширина самого маленького экрана

class GameCellView: UIView {
    var numberLabel: UILabel
    var number: Int
    var labelOffset: CGFloat = 10
    

    init(frame: CGRect, number: Int) {
        self.numberLabel = UILabel()
        self.number = number
        super.init(frame: frame)
        numberLabel.frame = CGRect(x: labelOffset, y: labelOffset, width: bounds.size.width - labelOffset*2, height: bounds.size.height - labelOffset*2)
        addSubview(numberLabel)
        configureView()
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(number, forKey: "number")
        aCoder.encode(frame, forKey: "frame")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.numberLabel = UILabel()
        self.number = aDecoder.decodeInteger(forKey: "number")
        super.init(frame: aDecoder.decodeCGRect(forKey: "frame"))
        numberLabel.frame = CGRect(x: labelOffset, y: labelOffset, width: bounds.size.width - labelOffset*2, height: bounds.size.height - labelOffset*2)
        addSubview(numberLabel)
        configureView()
    }
    
    func configureView() {
        layer.cornerRadius = 12
        clipsToBounds = true
        if let background = UIColor.value(forKey: "color\(number)") as? UIColor {
            backgroundColor = background
        } else {
            backgroundColor = .color2048
        }
        numberLabel.textColor = number > 32 ? .white : .black
        numberLabel.font = UIFont.systemFont(ofSize: 30*fontScaleFactor, weight: .heavy)
        numberLabel.baselineAdjustment = .alignCenters
        numberLabel.adjustsFontSizeToFitWidth = true
        numberLabel.textAlignment = .center
        numberLabel.text = "\(number)"
    }
}
