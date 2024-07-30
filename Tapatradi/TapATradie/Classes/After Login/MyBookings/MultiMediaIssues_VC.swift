//
//  MultiMediaIssues_VC.swift
//  TapATradie
//
//  Created by Admin on 02/03/23.
//

import UIKit

enum MediaType {
    case Camera
    case Gallry
    case Document
    case Audio
    case Video
}

protocol OpenMediaFile {
    func openMediaFile(type:MediaType)
}

class MultiMediaIssues_VC: UIViewController {

    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var viewGallery: UIView!
    @IBOutlet weak var viewDocument: UIView!
    @IBOutlet weak var viewAudio: UIView!
    @IBOutlet weak var viewVideo: UIView!
    var delegate: OpenMediaFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateScreen()
    }
    
    func updateScreen() {
        viewCamera.MediaPlayerShadow()
        viewGallery.MediaPlayerShadow()
        viewDocument.MediaPlayerShadow()
        viewAudio.MediaPlayerShadow()
        viewVideo.MediaPlayerShadow()
    }
    
    
    @IBAction func actionClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionCamera(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate.openMediaFile(type: .Camera)
        }
    }
    
    @IBAction func actionGallery(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate.openMediaFile(type: .Gallry)
        }
    }
    
    @IBAction func actionDocument(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate.openMediaFile(type: .Document)
        }
    }
    
    @IBAction func actionAudio(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate.openMediaFile(type: .Audio)
        }
    }
    
    @IBAction func actionVideo(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate.openMediaFile(type: .Video)
        }
    }

}

extension UIView {
    
    func MediaPlayerShadow() {
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 1.5
        self.layer.shadowOpacity = 0.5
    }
    
}
