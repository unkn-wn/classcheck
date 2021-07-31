//
//  dateHeader.swift
//  Class Check
//
//  Created by Leon Yee on 7/17/21.
//  Copyright © 2021 Company. All rights reserved.
//

import JTAppleCalendar
import UIKit

class DateHeader: JTAppleCollectionReusableView {
    
    static let identifier = "month"
    let dateHeader = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func baseUI() {
        dateHeader.textAlignment = .center
        dateHeader.font = .systemFont(ofSize: 20, weight: .medium)
        self.addSubview(dateHeader)
        dateHeader.translatesAutoresizingMaskIntoConstraints = false
        dateHeader.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        dateHeader.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
}
