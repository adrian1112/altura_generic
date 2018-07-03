//
//  DetaillThreeViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 2/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
import Highcharts

class DetailThreeViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var chartView: HIChartView!
    let options = HIOptions()
    let chart = HIChart()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detailController = tabBarController as! DetailsTabBarViewController
        
        let titleView = String(describing: detailController.contrato)
        navigationBar.title = titleView
        
        
        let bound = CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY, width: self.view.bounds.width, height: self.view.bounds.height-100)
        
        //dataView.isHidden = true
        print(bound)
        self.chartView = HIChartView(frame: bound)
        
        chart.type = "pie"
        options.chart = chart
        
        //-----
        let title = HITitle()
        title.text = "UEFA Champions League 2016/17"
        
        let subtitle = HISubtitle()
        subtitle.text = "Team statistics"
        options.title = title
        options.subtitle = subtitle
        
        //-----
        let xAxis = HIXAxis()
        xAxis.categories = ["Goals","Assists","Shots On Goal","Shots"]
        options.xAxis = [xAxis]
        
        let yAxis = HIYAxis()
        yAxis.min = 0
        yAxis.title = HITitle()
        yAxis.title.text = "Number"
        options.yAxis = [yAxis]
        
        //-----
        let tooltip = HITooltip()
        tooltip.headerFormat = "<span style=\"0font-size: 15px\";\">{point.key}</span>"
        tooltip.pointFormat = "" + ""
        tooltip.footerFormat = "<table><tbody><tr><td style=\"0color: {series.color}; padding: 0\";\">{series.name}:</td><td style=\"0padding: 0\";\"><b>{point.y}</b></td></tr></tbody></table>"
        tooltip.shared = true
        tooltip.useHTML = true
        options.tooltip = tooltip
        
        //--
        let plotOptions = HIPlotOptions()
        plotOptions.column = HIColumn()
        plotOptions.column.pointPadding = 0.2
        plotOptions.column.borderWidth = 0
        options.plotOptions = plotOptions
        
        options.plotOptions = plotOptions
        
        //--
        let realMadrid = HIColumn()
        realMadrid.name = "Real Madrid"
        realMadrid.data = [36, 31, 93, 236]
        
        let juventus = HIColumn()
        juventus.name = "Juventus"
        juventus.data = [22, 10, 66, 178]
        
        let monaco = HIColumn()
        monaco.name = "Monaco"
        monaco.data = [22, 17, 56, 147]
        
        let atleticoMadrid = HIColumn()
        atleticoMadrid.name = "Atlético Madrid"
        atleticoMadrid.data = [15, 9, 55, 160]
        
        options.series = [realMadrid, juventus, monaco, atleticoMadrid]
        
        //--
        
        self.chartView.options = options
        //self.dataView = self.chartView
        self.view.addSubview(self.chartView)

        // Do any additional setup after loading the view.
    }

    @IBAction func exit(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

}
