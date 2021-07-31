//
//  dateCell.swift
//  Class Check
//
//  Created by Leon Yee on 7/4/21.
//  Copyright © 2021 Company. All rights reserved.
//

import UIKit
import JTAppleCalendar

class dateCell: JTAppleCell {
    var dateLabel : UILabel = {
        let dateLabel = UILabel()
        dateLabel.text = "sample"
        return dateLabel
    }()
    
    var selectedView : UIView = {
        let selectedView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        selectedView.backgroundColor = UIColor(patternImage: UIImage(named: "pink")!)
        return selectedView
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(selectedView)
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                                    dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                                    dateLabel.heightAnchor.constraint(equalToConstant: 30)])
        NSLayoutConstraint.activate([selectedView.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     selectedView.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     selectedView.widthAnchor.constraint(equalToConstant: 30),
                                     selectedView.heightAnchor.constraint(equalToConstant: 30)])

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
