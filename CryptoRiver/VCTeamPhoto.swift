
//  Created by Peter Sun on 9/10/22
//  Copyright © 2022 Peter Sun. All rights reserved.
//

import UIKit

class VCTeamPhoto: UIViewController, UIScrollViewDelegate {


    @IBOutlet weak var scrollView: UIScrollView!
    
    var displayImageName = "team"
    var imageView:UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let iv = UIImageView.init(image: TeamPhoto.sharedInstance().getImageWithName("team"))
            self.scrollView.addSubview(iv)
        let size = iv.image!.size
            self.scrollView.contentSize = size
            self.scrollView.minimumZoomScale = 0.1
            self.scrollView.delegate = self

        
        /*if let size = self.imageView?.image?.size{
            self.scrollView.addSubview(self.imageView!)
            self.scrollView.contentSize = size
            self.scrollView.minimumZoomScale = 0.1
            self.scrollView.delegate = self
        }*/
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    


}

