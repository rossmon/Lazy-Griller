import UIKit

@objc
protocol TopPanelViewControllerDelegate {
    func settingSelected(menu: String)
}

class TopPanelViewController: UIViewController {
    
    
    @IBOutlet weak var graphButton: UIButton!
    @IBAction func graphButtonPressed(sender: AnyObject) {
        delegate?.settingSelected("graphs")
    }
    
    @IBOutlet weak var tempButton: UIButton!
    @IBAction func tempButtonPressed(sender: AnyObject) {
        delegate?.settingSelected("temps")
    }
    
    @IBOutlet weak var settingButton: UIButton!
    @IBAction func settingButtonPressed(sender: AnyObject) {
        delegate?.settingSelected("settings")
    }
    
    var delegate: TopPanelViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}


