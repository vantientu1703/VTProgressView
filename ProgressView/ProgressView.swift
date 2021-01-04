//
//  ProgressView.swift
//  ProgressView
//
//  Created by Van Tien Tu on 04/01/2021.
//

import UIKit

@IBDesignable
class ProgressView: UIView {
    
    @IBInspectable
    var progress: CGFloat = 0 {
        didSet {
            print("progress = \(self.progress)")
            self.calculateProgress()
        }
    }
    
    @IBInspectable
    var bufferProgress: CGFloat = 0 {
        didSet {
            self.calculateBufferProgress()
        }
    }
    
    @IBInspectable var progressColor: UIColor = .blue {
        didSet {
            self.progressView.backgroundColor = self.progressColor
        }
    }
    
    @IBInspectable var bufferProgressColor: UIColor = .lightText {
        didSet {
            self.bufferProgressView.backgroundColor = self.bufferProgressColor
        }
    }
    
    @IBInspectable var markColor: UIColor = .red {
        didSet {
            self.markView.backgroundColor = self.markColor
        }
    }
    
    private lazy var progressView: UIView = {
        let view = UIView()
        view.backgroundColor = self.progressColor
        return view
    }()
    
    private lazy var bufferProgressView: UIView = {
        let view = UIView()
        view.backgroundColor = self.progressColor
        return view
    }()
    
    private lazy var markView: UIView = {
      let view = UIView()
        view.backgroundColor = self.markColor
        return view
    }()
    
    private let previewWidth: CGFloat = 80
    private let previewHeight: CGFloat = 60
    
    lazy var preView: UIImageView = {
        let view = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: -self.previewHeight - 20), size: CGSize(width: self.previewWidth, height: self.previewHeight)))
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .lightGray
        view.isHidden = true
        return view
    }()
    
    private let defaultWidth: CGFloat = 10
    var didEndChangeValue: ((_ progress: CGFloat) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initCommit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initCommit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initCommit()
    }
    
    private func initCommit() {
        self.backgroundColor = .lightGray
        
        self.layoutIfNeeded()
        let defaultFrame = CGRect(origin: .zero, size: CGSize(width: self.defaultWidth, height: self.frame.height))
        // progress view
        self.progressView.frame = defaultFrame
        // buffer view
        let bufferFrame = CGRect(x: 0, y: 0, width: 0, height: self.frame.height)
        self.bufferProgressView.frame = bufferFrame
        // mark view
        self.markView.frame = CGRect(x: self.progressView.frame.width - self.defaultWidth, y: 0, width: self.defaultWidth, height: self.frame.height)
        
        self.addSubview(self.bufferProgressView)
        self.addSubview(self.progressView)
        self.progressView.addSubview(self.markView)
        
        self.addSubview(self.preView)
    }
    
    private func calculateProgress() {
        var progress = self.progress / CGFloat(100)
        if progress > 1 {
            progress = 1
        } else if progress < 0 {
            progress = 0
        }
        var width = self.frame.width * progress
        if width < self.defaultWidth {
            width = self.defaultWidth
        }
        self.progressView.frame.size.width = width
        self.markView.frame.origin.x = self.progressView.frame.width - self.defaultWidth
    }
    
    private func calculateBufferProgress() {
        self.bufferProgressView.frame.size.width = self.bufferProgress / CGFloat(100) * self.frame.width
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touches.forEach { (t) in
            let point = t.location(in: self)
            self.progress(at: point)
            self.preview(at: point)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        touches.forEach { (t) in
            let point = t.location(in: self)
            self.progress(at: point)
            self.preview(at: point)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touches.forEach { (t) in
            let point = self.markView.frame.origin
            self.progress(at: point)
            self.didEndChangeValue?(self.progress)
            self.preView.isHidden = true
        }
    }
    // re-calculate progress when user moved
    private func progress(at point: CGPoint) {
        let progress = point.x < (self.frame.width - self.defaultWidth) ? point.x : self.frame.width - self.defaultWidth
        self.progress = progress / (self.frame.width - self.defaultWidth) * CGFloat(100)
    }
    
    // preview at progress
    private func preview(at point: CGPoint) {
        self.preView.isHidden = false
        var originX = point.x - self.previewWidth / 2
        if originX < 0 {
            originX = 0
        } else if originX > self.frame.width - self.previewWidth {
            originX = self.frame.width - self.previewWidth
        }
        self.preView.frame.origin.x = originX
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        print("cancelled")
    }
    
    func playerOrientationChanged() {
        self.calculateBufferProgress()
        self.calculateProgress()
    }
}
