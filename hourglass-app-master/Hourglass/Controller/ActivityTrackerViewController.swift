//
//  ActivityTrackerViewController.swift
//  Hourglass
//
//  Created by Caroline Zhou and Tao Ong on 11/30/17.
//  Copyright © 2017 Caroline Zhou and Tao Ong. All rights reserved.
//

import UIKit
import Charts

class ActivityTrackerViewController: UIViewController {

    var pieChartView: PieChartView!
    var barChartView: BarChartView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var view1height: NSLayoutConstraint!
    @IBOutlet weak var view2height: NSLayoutConstraint!
    
    var currView : UIView!

    @IBOutlet weak var chart: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let activities = UserDefaults.standard.value(forKey: "activities") as? Dictionary<String, Double>
        
        
            let names = Array(activities!.keys)
            let times = Array(activities!.values)
            
            self.pieChartView = PieChartView(frame: self.view.bounds)
            pieChartView.tag = 0
            self.view1height.constant = self.view.bounds.height
            self.view1.addSubview(pieChartView!)
            setPieChart(dataPoints: names, values: times)
            
            currView = pieChartView
        
        
//        self.barChartView = BarChartView(frame: self.view.bounds)
//        barChartView.tag = 1
//        self.view2height.constant = self.view.bounds.height
//        self.view2.addSubview(barChartView!)
//        setBarChart(dataPoints: names, values: times)
    }
    
//    @IBAction func switchChart(_ sender: Any) {
//        let activities = UserDefaults.standard.value(forKey: "activities") as? Dictionary<String, Double>
//        let names = ["A", "B", "C"] // Array(activities!.keys)
//        let times = [10987.0, 9876.99, 5678.95] // Array(activities!.values)
//
//        if self.currView == self.pieChartView {
//            if let viewWithTag = self.view.viewWithTag(0) {
//                viewWithTag.removeFromSuperview()
//                self.view.addSubview(barChartView)
//            }
//            self.currView = self.barChartView
//            setBarChart(dataPoints: names, values: times)
//            chart.setTitle("Pie Chart", for: .normal)
//        } else if self.currView == self.barChartView {
//            if let viewWithTag = self.view.viewWithTag(1) {
//                viewWithTag.removeFromSuperview()
//                self.view.addSubview(pieChartView)
//            }
//            self.currView = self.pieChartView
//            setPieChart(dataPoints: names, values: times)
//            chart.setTitle("Bar Chart", for: .normal)
//        }
//    }

    func setPieChart(dataPoints: [String], values: [Double]) {
        
        pieChartView.noDataText = "You need to provide data for the chart."

        var dataEntries: [ChartDataEntry] = []

        for i in 0..<dataPoints.count {
            let dataEntry1 = PieChartDataEntry(value: values[i] / 60, label: dataPoints[i])
            dataEntries.append(dataEntry1)
        }

        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Time Spent (minutes)")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData

        var colors: [UIColor] = []

        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))

            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }

        pieChartDataSet.colors = colors
    }

    func setBarChart(dataPoints: [String], values: [Double]) {

        barChartView.noDataText = "You need to provide data for the chart."

        var dataEntries: [BarChartDataEntry] = []

        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i] / 60)
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Time Spent (minutes)")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData

        // chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        chartDataSet.colors = ChartColorTemplates.colorful()

        barChartView.xAxis.labelPosition = .bottom

        // barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)

        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)

        let ll = ChartLimitLine(limit: 10.0, label: "Target")
        barChartView.rightAxis.addLimitLine(ll)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
