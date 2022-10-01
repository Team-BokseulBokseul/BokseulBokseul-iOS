//
//  LineChartViewController.swift
//  FreeSubject
//
//  Created by 홍준혁 on 2022/09/07.
//

import Foundation
import UIKit
import QuartzCore
import RealmSwift
import SnapKit


struct DataForChart{
    var Date:Int = 0
    var inputNum:Int = 0
}

class LineChartViewController: UIViewController, LineChartDelegate {

    var label = UILabel()
    var lineChart: LineChart!
    
    var ArrayForNum:[DataForChart] = []
    // createdDate 을 String -> Int 로 변환하고 날짜를 기준으로 오름차순
    // newArrayForChart <- 정제된 데이터 배열
    var newArrayForChart:[DataForChart] = []
    
    lazy var tableView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 16
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        read()
        view.addSubviews(tableView)
        
        view.backgroundColor = .systemBackground
        var views: [String: AnyObject] = [:]
        
        label.text = "9월 누적 통계입니다."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)

        views["label"] = label
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[label]", options: [], metrics: nil, views: views))
        
        // simple arrays
        let data: [CGFloat] = [3, 4, -2, 11, 13, 15]
        
        // simple line with custom x axis labels
        let xLabels: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        
        lineChart = LineChart()
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = true
        lineChart.x.grid.count = 5
        // hi
        lineChart.y.grid.count = 5
        lineChart.x.labels.values = xLabels
        lineChart.y.labels.visible = true
        lineChart.addLine(data)
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        self.view.addSubview(lineChart)

        
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[chart]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))
        
        setSNP()
//        var delta: Int64 = 4 * Int64(NSEC_PER_SEC)
//        var time = dispatch_time(DISPATCH_TIME_NOW, delta)
//
//        dispatch_after(time, dispatch_get_main_queue(), {
//            self.lineChart.clear()
//            self.lineChart.addLine(data2)
//        });
        
//        var scale = LinearScale(domain: [0, 100], range: [0.0, 100.0])
//        var linear = scale.scale()
//        var invert = scale.invert()
//        println(linear(x: 2.5)) // 50
//        println(invert(x: 50)) // 2.5
        
    }
    
    
    func setSNP(){
        tableView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(60)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(300)
        }
    }
    
    private func read() {
        guard let realm = try? Realm() else { return }
        let models = realm.objects(Day.self)
        for model in models {
            let mdl = DataForChart(Date: Int(model.createdDate) ?? 000000, inputNum: model.iconFeeling)
            ArrayForNum += [mdl]
        }
        // createdDate 을 String -> Int 로 변환하고 날짜를 기준으로 오름차순
        // newArrayForChart - 이게 정제된 데이터 배열
        self.newArrayForChart = ArrayForNum.sorted(by:{$0.Date < $1.Date})
        print(newArrayForChart)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    /**
     * Line chart delegate method.
     */
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        label.text = "x: \(x)     y: \(yValues)"
    }
    
    
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }

}
