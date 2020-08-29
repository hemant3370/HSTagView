//
//  ViewController.swift
//  HSTagView
//
//  Created by hemant3370 on 08/26/2020.
//  Copyright (c) 2020 hemant3370. All rights reserved.
//

import UIKit
import HSTagView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tags = [" Washington",
                    "Clinton",
                    "Springfield",
                    "Georgetown "]
        let tagView = HSTagListView<String>(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        tagView.allTags = tags
        
        tagView.onTagSelection = { (index) in
            print(tags[index])
        }
        tagView.center = view.center
        view.addSubview(tagView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension String: HSIdentifialble {
    public var identifier: String? {
        return self
    }
}
