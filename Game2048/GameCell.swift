//
//  GameCell.swift
//  Game2048
//
//  Created by Kirill Varlamov on 10/05/2019.
//  Copyright © 2019 Kirill Varlamov. All rights reserved.
//

import UIKit

class GameCell: UIView {
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        backgroundColor = UIColor.value(forKey: "color\(number)") as? UIColor
        numberLabel.textColor = number > 32 ? .white : .black
        let fontSize: CGFloat = UIScreen.main.bounds.size.width > 320 ? 40 : 20
        numberLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .heavy)
        numberLabel.baselineAdjustment = .alignCenters
        numberLabel.adjustsFontSizeToFitWidth = true
        numberLabel.textAlignment = .center
        numberLabel.text = "\(number)"
    }
}
