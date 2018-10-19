//
//  DismissSegue.swift
//  group3_assignment6
//
//  Created by Evan Shrestha on 10/18/18.
//  Copyright © 2018 Ivy, Connor R. All rights reserved.
//

import UIKit

class DismissSegue: UIStoryboardSegue {
    override func perform() {
        self.source.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
