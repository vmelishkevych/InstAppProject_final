//
//  LocalDateFormatter.swift
//  InstAppProject
//
//  Created by Torris on 11/19/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

import Foundation

class LocalDateFormatter: DateFormatter {
    
    override init() {
        super.init()
        
        let template = "dd/MM/yyyy hh.mm"
        setLocalizedDateFormatFromTemplate(template)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
