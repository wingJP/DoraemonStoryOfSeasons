//
//  MineralViewController.swift
//  Ranch
//
//  Created by 王剑鹏 on 2020/10/28.
//

import UIKit

class MineralViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initSubButtons()
        // Do any additional setup after loading the view.
    }
    let rootStack = UIStackView()
    
    func initSubButtons() {
        rootStack.axis = .horizontal
        rootStack.distribution = .fillEqually
        for _ in 0..<7 {
            let lineStack = UIStackView()
            lineStack.axis = .vertical
            lineStack.distribution = .fillEqually
            for _ in 0..<7 {
                let button = UIButton(type: .custom)
                button.backgroundColor = UIColor.lightGray
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.white.cgColor
                button.addTarget(self,
                                 action: #selector(buttonAction),
                                 for: .touchUpInside)
                lineStack.addArrangedSubview(button)
            }
            rootStack.addArrangedSubview(lineStack)
        }
        self.view.addSubview(rootStack)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootStack.transform = .identity
        var size = min(view.frame.width, view.frame.height)
        size = size * 0.6
        rootStack.frame = CGRect(x: 0, y: 0, width: size, height: size)
        rootStack.center = view.center
        rootStack.transform = CGAffineTransform.init(rotationAngle: .pi / 4)
    }
    
    @objc func buttonAction(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = !sender.isSelected ? UIColor.lightGray : UIColor.darkGray
    }
    @IBAction func resetAction(_ sender: Any) {
        rootStack.arrangedSubviews.forEach { (stack) in
            guard let sView = stack as? UIStackView else { return }
            sView.arrangedSubviews.forEach { (btn) in
                guard let btn = btn as? UIButton else { return }
                btn.isSelected = true
                self.buttonAction(btn)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
