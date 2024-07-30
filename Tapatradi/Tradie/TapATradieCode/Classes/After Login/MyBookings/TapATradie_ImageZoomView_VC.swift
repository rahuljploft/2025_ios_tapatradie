//
//  ImageZoomView_VC.swift
//  TapATradie
//
//  Created by Admin on 10/03/23.
//

import UIKit
import ImageScrollView
import SDWebImage

class TapATradie_ImageZoomView_VC: UIViewController {

    var imageURl = ""
    @IBOutlet weak var viewClose: UIView!
    @IBOutlet weak var imgZero: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewClose.layer.cornerRadius = 20
        let img = UIImageView()
        if let url = URL(string: imageURl) {
            imgZero.sd_setImage(with: url,placeholderImage: UIImage(named: ""))
        }
    }
    
    @IBAction func actionDismis(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

}


extension TapATradie_ImageZoomView_VC: ImageScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {
        print("Did change orientation")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming at scale \(scale)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll at offset \(scrollView.contentOffset)")
    }
}
