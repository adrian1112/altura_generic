//
//  DetaillThreeViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 2/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
import Highcharts
import Charts

class DetailThreeViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var barView: BarChartView!
    
    /*var chartView: HIChartView!
    let options = HIOptions()
    let chart = HIChart()
    let meses = HIColumn()
    let credits = HICredits()
    let title_c = HITitle()
    let exporting = HIExporting()
    let xAxis = HIXAxis()
    let yAxis = HIYAxis()
    let tooltip = HITooltip()
    let plotOptions = HIPlotOptions()*/
    
    var data = [BarChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detailController = tabBarController as! DetailsTabBarViewController
        
        let titleView = String(describing: detailController.contrato)
        navigationBar.title = titleView
        
        //barView.delegate = self
        barView.drawBarShadowEnabled = false
        barView.drawValueAboveBarEnabled = false
        
        let xAxis = barView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        //xAxis.valueFormatter = DayAxisValueFormatter(chart: barView)
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = " $"
        leftAxisFormatter.positiveSuffix = " $"
        
        let leftAxis = barView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        
        let rightAxis = barView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        let l = barView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        //        chartView.legend = l
        
        for i in [1,2,3,4]{
            let val = i*20
            let detail = BarChartDataEntry(x: Double(i), y: Double(val))
            data.append(detail)
            
        }
        
       
        updateChartData()
        
        
        //let bound = CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY, width: self.view.bounds.width, height: self.view.bounds.height-100)
        
        //dataView.isHidden = true
        //print(bound)
        
        /*
        //###### CONSUMO EN METRO CUBICOS
        self.chartView = HIChartView(frame: bound)
        
        chart.type = "column"
        options.chart = chart
        title_c.text = "Consumo m3"
        
        //let subtitle = HISubtitle()
        //subtitle.text = "Team statistics"
        options.title = title_c
        //options.subtitle = subtitle
        
        
        credits.enabled = false
        
        
        exporting.enabled = true
        
        //-----
        
        xAxis.categories = ["Enero","Febrero","Marzo","Abril"]
        options.xAxis = [xAxis]
        
        
        yAxis.min = 0
        yAxis.title = HITitle()
        yAxis.title.text = "m3"
        options.yAxis = [yAxis]
        
        
        tooltip.headerFormat = "<span style=\"0font-size: 15px\";\">{point.key}</span>"
        tooltip.pointFormat = "" + ""
        tooltip.footerFormat = "<table><tbody><tr><td style=\"0color: {series.color}; padding: 0\";\">{series.name}:</td><td style=\"0padding: 0\";\"><b>{point.y}</b></td></tr></tbody></table>"
        tooltip.shared = true
        tooltip.useHTML = true
        options.tooltip = tooltip
        
        //--
        
        plotOptions.column = HIColumn()
        plotOptions.column.pointPadding = 0.2
        plotOptions.column.borderWidth = 0
        options.plotOptions = plotOptions
        options.credits = credits
        options.exporting = exporting
        
        options.plotOptions = plotOptions
        
        //--
        
        meses.name = "Consumo"
        meses.data = [36,22,50,15]
        meses.dataLabels = HIDataLabels()
        meses.dataLabels.enabled = true
        meses.dataLabels.rotation = -90;
        meses.dataLabels.color = HIColor(hexValue: "FFFFFF")
        meses.dataLabels.align = "right";
        meses.dataLabels.format = "{point.y}";
        meses.dataLabels.y = 10;
        meses.dataLabels.style = HIStyle()
        meses.dataLabels.style.fontSize = "11px";
        meses.dataLabels.style.fontFamily = "Verdana, sans-serif";
        
        
        
        options.series = [meses]
        
        //--
        
        self.chartView.options = options
        //self.dataView = self.chartView
        self.chartView.tag = 1111
        
        self.view.addSubview(self.chartView)

        */
        
    }
    
    func updateChartData(){
        let dataSet = BarChartDataSet(values: self.data, label: nil)
        let charData = BarChartData(dataSet: dataSet)
        
        //let colors = [HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#7cb5ec"], [1, "rgb(48,105,160)"]]), HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#434348"], [1, "rgb(0,0,0)"]]), HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#90ed7d"], [1, "rgb(68,161,49)"]]), HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#f7a35c"], [1, "rgb(171,87,16)"]])]
        
        //dataSet.colors = colors as! [NSUIColor]
        
        barView.data = charData
        //barView.centerText = "prueba data"
        //barView.drawCenterTextEnabled = true
        
    }

    @IBAction func exit(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @IBAction func changeView(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 1{
            if let viewWithTag = self.view.viewWithTag(1111) {
                print("1111")
                viewWithTag.removeFromSuperview()
                
                //title_c.text = "Consumo Dólares"
                //let subtitle = HISubtitle()
                //subtitle.text = "Team statistics"
                //options.title = title_c
                //options.subtitle = subtitle
                //yAxis.min = 0
                //yAxis.title = HITitle()
                //yAxis.title.text = "$ Dólares"
                //options.yAxis = [yAxis]
                //meses.data = [12,22,13,55]
                //options.series = [meses]
                //self.chartView.options = options
                //self.view.addSubview(self.chartView)
            }
            else {
                //self.view.addSubview(self.chartView)
            }
            
        }else{
            if let viewWithTag = self.view.viewWithTag(1111) {
                print("1111")
                //viewWithTag.removeFromSuperview()
                
                //title_c.text = "Consumo m3"
                //let subtitle = HISubtitle()
                //subtitle.text = "Team statistics"
                //options.title = title_c
                //options.subtitle = subtitle
                //yAxis.min = 0
                //yAxis.title = HITitle()
                //yAxis.title.text = "m3"
                //options.yAxis = [yAxis]
                //meses.data = [36,22,50,15]
                //options.series = [meses]
                //self.chartView.options = options
                //self.view.addSubview(self.chartView)
            }
            else {
                //self.view.addSubview(self.chartView)
            }
        }
    }
    
}
