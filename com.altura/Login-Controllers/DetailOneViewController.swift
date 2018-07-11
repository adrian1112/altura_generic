//
//  DetaillOneViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 2/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
import Highcharts
import Charts

struct data_pie {
    var name : String
    var y : Double
    
    init(name:String, y:Double) {
        self.name = name
        self.y = y
    }
}

class DetailOneViewController: UIViewController {

    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var pieChart: PieChartView!
    
    //var chartView: HIChartView!
    //let options = HIOptions()
    //let chart = HIChart()
    
    @IBOutlet weak var widthView1: NSLayoutConstraint!
    @IBOutlet weak var widthView2: NSLayoutConstraint!
    @IBOutlet weak var heigthViewBotton: NSLayoutConstraint!
    
    @IBOutlet weak var heigthPieView: NSLayoutConstraint!
    
    //var data = PieChartDataEntry(value: 0)
    //var data2 = PieChartDataEntry(value: 0)
    var data = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detailController = tabBarController as! DetailsTabBarViewController
        
        let titleView = String(describing: detailController.contrato)
        navigationBar.title = titleView
        
        //self.heigthPieView.constant = self.container.bounds.height
        
        //print(self.container.bounds.height)
        
        //pieChart.chartDescription?.text = "Detalle de Deudas"
        
        for i in [1,2,3,4]{
            var detail_data = PieChartDataEntry(value: 25)
            detail_data.label = "label\(i)"
            data.append(detail_data)
        }
        
        updateChartData()
        
        //setea los limites del view hichart
        //let bound = CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY, width: self.view.bounds.width, height: self.view.bounds.height-100)
        
        //dataView.isHidden = true
        //print(bound)
        //self.chartView = HIChartView(frame: bound)
        
        //setea el ancho y alto de los view de la secicon detalles
        widthView1.constant = (self.view.bounds.width/2)-12
        widthView2.constant = (self.view.bounds.width/2)-12
        heigthViewBotton.constant = (self.view.bounds.height/2)-20
        
        
        
        //chart.plotBackgroundColor = HIColor()
        //chart.plotBorderWidth = NSNumber()
        //chart.plotShadow = false
        //chart.type = "pie"
        
        
        
        //let exporting = HIExporting()
        //exporting.enabled = true
        
        //let credits = HICredits()
        //credits.enabled = false
        
        //-----
        //let title = HITitle()
        //title.text = "Detalle de Deudas"
        
        
        //let tooltip = HITooltip()
        //tooltip.headerFormat = "<span style=\"0font-size: 12px\";\">{point.percentage:.2f}%</span>"
        //tooltip.pointFormat = "Valor: <b>{point.y}</b>"
        //tooltip.shared = true
        //tooltip.useHTML = true
        
        //var plotoptions = HIPlotOptions()
        //plotoptions.pie = HIPie()
        //plotoptions.pie.allowPointSelect = true
        //plotoptions.pie.cursor = "pointer"
        //plotoptions.pie.dataLabels = HIDataLabels()
        //plotoptions.pie.dataLabels.enabled = true
        //plotoptions.pie.dataLabels.format = "<b>$ {point.y}</b>"
        //plotoptions.pie.dataLabels.style = HIStyle()
        //plotoptions.pie.dataLabels.style.color = "black"
        //plotoptions.pie.showInLegend = true
        
        //var pie = HIPie()
        //pie.name = "Brands";
        /*pie.data = [
            [
                "name" : "INTERAGUA",
                "y" : 56.33
                
            ],[
                "name" : "CEM",
                "y": 24.03
                
            ],[
                "name" : "INTERES",
                "y": 10.38
                
            ],[
                "name" : "TBR",
                "y": 4.97
                
            ],[
                "name" : "IVA",
                "y": 0.91
                
            ]
        ];
        
        var colors = [HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#7cb5ec"], [1, "rgb(48,105,160)"]]), HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#434348"], [1, "rgb(0,0,0)"]]), HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#90ed7d"], [1, "rgb(68,161,49)"]]), HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#f7a35c"], [1, "rgb(171,87,16)"]]), HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#8085e9"], [1, "rgb(52,57,157)"]]), HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#f15c80"], [1, "rgb(165,16,52)"]]), HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#e4d354"], [1, "rgb(152,135,8)"]]), HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#2b908f"], [1, "rgb(0,68,67)"]]), HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#f45b5b"], [1, "rgb(168,15,15)"]]), HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#91e8e1"], [1, "rgb(69,156,149)"]])]
        
        options.chart = chart
        options.title = title
        options.colors = colors as! [HIColor]
        options.tooltip = tooltip
        options.plotOptions = plotoptions
        options.series = [pie]
        options.exporting = exporting
        options.credits = credits
        
        //chartView.options = options;
        
       //--
        
        self.chartView.options = options
        //self.dataView = self.chartView
        self.view.addSubview(self.chartView)
        // Do any additional setup after loading the view.
        */
    }
    
    func updateChartData(){
        let dataSet = PieChartDataSet(values: self.data, label: nil)
        let charData = PieChartData(dataSet: dataSet)
        
        //let colors = [HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#7cb5ec"], [1, "rgb(48,105,160)"]]), HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#434348"], [1, "rgb(0,0,0)"]]), HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#90ed7d"], [1, "rgb(68,161,49)"]]), HIColor(radialGradient: ["cx": 0.5, "cy": 0.3, "r": 0.7], stops: [[0, "#f7a35c"], [1, "rgb(171,87,16)"]])]
        
        //dataSet.colors = colors as! [NSUIColor]
        
        pieChart.data = charData
        pieChart.centerText = "prueba data"
        pieChart.drawCenterTextEnabled = true
        
    }

    @IBAction func exit(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @IBAction func changeView(_ sender: UISegmentedControl) {
        print( sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0{
            self.dataView.isHidden = true
            self.container.isHidden = false
            //self.chartView.isHidden = false
        }else{
            self.dataView.isHidden = false
            self.container.isHidden = true
            //self.chartView.isHidden = true
        }
    }
}
