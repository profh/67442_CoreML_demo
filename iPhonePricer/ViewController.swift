//  ViewController.swift
//  iPhonePricer


import UIKit
import os.log

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
  // MARK: - Outlets & Setup
  @IBOutlet var model: UISegmentedControl!
  @IBOutlet var capacity: UISegmentedControl!
  @IBOutlet var color: UISegmentedControl!
  @IBOutlet var network: UISegmentedControl!
  @IBOutlet var condition: UIPickerView!
  @IBOutlet var iphoneValue: UILabel!
  
  // set up ML model and conditions array for the picker
  let phones = Phones()
  var conditionsArray:[String] = ["New","Mint","Excellent","Good","Acceptable","Fair"]
  

  override func viewDidLoad() {
    super.viewDidLoad()
    // set up the picker view
    self.condition.delegate = self
    self.condition.dataSource = self
    // initially blank out the estimated value
    iphoneValue.text = ""
  }
  
  // MARK: - Calculating Value
  @IBAction func calculateValue(_ sender: Any) {
    // some adjustments had to be made for data to be compatible with model
    let modelValue = Double(model.selectedSegmentIndex) + 1.0
    let colorValue = Double(color.selectedSegmentIndex)
    let networkValue = Double(network.selectedSegmentIndex)
    let capacityValue = (capacity.selectedSegmentIndex == 0 ? 64 : 256)
    let conditionValue = 6 - condition.selectedRow(inComponent: 0)
    
    // If you want to see particular values printed out...
    // os_log("\nModel = %@", String(modelValue))
    // os_log("\nColor = %@", String(colorValue))
    // os_log("\nCapacity = %@", String(capacityValue))
    // os_log("\nNetwork = %@", String(networkValue))
    // os_log("\nCondition = %@", String(conditionValue))
    
    // Almost all the data was from one source (swappa.com) so fixing source value to 0.0
    if let prediction = try? phones.prediction(source: 0.0, network: networkValue, capacity: Double(capacityValue), model: modelValue, condition: Double(conditionValue), color: colorValue) {
      let formatter = NumberFormatter()
      formatter.numberStyle = .currency
      iphoneValue.text = "iPhone value:  " + formatter.string(for: prediction.price)!
    } else {
      iphoneValue.text = "Error"
    }
  }
  
  // MARK: - UIPickerView
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return conditionsArray.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return conditionsArray[row]
  }
  
}

