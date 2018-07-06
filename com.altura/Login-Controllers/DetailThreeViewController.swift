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
    let meses = HIColumn()
    let credits = HICredits()
    let title_c = HITitle()
    let exporting = HIExporting()
    let xAxis = HIXAxis()
    let yAxis = HIYAxis()
    let tooltip = HITooltip()
    let plotOptions = HIPlotOptions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detailController = tabBarController as! DetailsTabBarViewController
        
        let titleView = String(describing: detailController.contrato)
        navigationBar.title = titleView
        
        
        let bound = CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY, width: self.view.bounds.width, height: self.view.bounds.height-100)
        
        //dataView.isHidden = true
        print(bound)
        
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
                
                title_c.text = "Consumo Dólares"
                //let subtitle = HISubtitle()
                //subtitle.text = "Team statistics"
                options.title = title_c
                //options.subtitle = subtitle
                yAxis.min = 0
                yAxis.title = HITitle()
                yAxis.title.text = "$ Dólares"
                options.yAxis = [yAxis]
                meses.data = [12,22,13,55]
                options.series = [meses]
                self.chartView.options = options
                self.view.addSubview(self.chartView)
            }
            else {
                self.view.addSubview(self.chartView)
            }
            
        }else{
            if let viewWithTag = self.view.viewWithTag(1111) {
                print("1111")
                viewWithTag.removeFromSuperview()
                
                title_c.text = "Consumo m3"
                //let subtitle = HISubtitle()
                //subtitle.text = "Team statistics"
                options.title = title_c
                //options.subtitle = subtitle
                yAxis.min = 0
                yAxis.title = HITitle()
                yAxis.title.text = "m3"
                options.yAxis = [yAxis]
                meses.data = [36,22,50,15]
                options.series = [meses]
                self.chartView.options = options
                self.view.addSubview(self.chartView)
            }
            else {
                self.view.addSubview(self.chartView)
            }
        }
    }
    
}
