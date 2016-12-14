//
//  SleepTimerViewController.swift
//  slumbr
//
//  Created by Michael McDermott on 12/13/16.
//  Copyright © 2016 Mikronesia. All rights reserved.
//

import UIKit

class SleepTimerViewController: UIViewController {
    @IBOutlet weak var dpCountDown: UIDatePicker!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dpCountDown.setValue(UIColor.white, forKey: "textColor")
       // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveView(_ sender: Any) {
        let strCountTime = dpCountDown.countDownDuration
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.sleepTime = Float(strCountTime)
        //dateLabel.text = strDate
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
