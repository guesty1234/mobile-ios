//
//  RegistrationSuccessViewController.swift
//  CovidSafe
//
//  Copyright © 2020 Australian Government. All rights reserved.
//

import UIKit
import SafariServices

class RegistrationSuccessViewController: UIViewController {
    @IBOutlet weak var pointOneLabel: UILabel!
    @IBOutlet weak var pointTwoLabel: UILabel!
    @IBOutlet weak var pointThreeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pointFourTextView: UITextView!
    
    var reauthenticating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 18.0
        let labelAtt: [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.preferredFont(forTextStyle: .body)
        ]
        let titleText = reauthenticating ? "jwt_success".localizedString(comment: "Title when JWT renewed") : "permission_success_headline".localizedString(comment: "Title when not refreshing JWT toek")
        titleLabel.text = titleText
        let pointOneText = NSAttributedString(string: NSLocalizedString("OS2b_Item1", comment: "Keep phone on you when you leave home"),
                                                     attributes: labelAtt)
        pointOneLabel.attributedText = pointOneText
        
        let pointTwoText = NSAttributedString(string: NSLocalizedString("OS2b_Item2", comment: "Keep bluetooth turned on"),
                                                     attributes: labelAtt)
        pointTwoLabel.attributedText = pointTwoText
        
        let pointThreeText = NSMutableAttributedString(string: NSLocalizedString("OS2b_Item3", comment: "COVIDSafe does NOT send pairing requests"),
                                                     attributes: labelAtt)
        if let learnMoreRange = pointThreeText.string.range(of: NSLocalizedString("OS2b_Item3Underline", comment: "Text that should be underlined from PointThree")) {
            let nsRange = NSRange(learnMoreRange, in: pointThreeText.string)
            pointThreeText.addAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.covidSafeColor], range: nsRange)
            pointThreeLabel.attributedText = pointThreeText
        }

        pointFourTextView.addLink("\(URLHelper.geLocationPermissionsURL())", enclosedIn: "*")
        
        guard let currentVersion = (Bundle.main.version as NSString?)?.integerValue else {
            return
        }
        UserDefaults.standard.set(currentVersion, forKey: "latestPolicyUpdateVersionShown")
    }
    
    @IBAction func learnMoreTapped(_ sender: Any) {
        guard let url = URL(string: "\(URLHelper.getHelpURL())#bluetooth-pairing-request") else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    
    @IBAction func continueBtnTapped(_ sender: UIButton) {
        if reauthenticating {
            dismiss(animated: true, completion: nil)
        } else {
            let homeVC = HomeViewController(nibName: "HomeView", bundle: nil)
            let tabVC = MainTabBarViewController()
            self.navigationController?.setViewControllers([tabVC], animated: true)
        }
    }
}
