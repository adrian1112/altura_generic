//
//  DetaillOneViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 2/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
//import Highcharts
import Charts
import SQLite



class DetailOneViewController: UIViewController {

    let dbase = DBase();
    var db: Connection!
    
    
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var debView: UIView!
    
    //var chartView: HIChartView!
    //let options = HIOptions()
    //let chart = HIChart()
    
    @IBOutlet weak var widthView1: NSLayoutConstraint!
    @IBOutlet weak var widthView2: NSLayoutConstraint!
    
    @IBOutlet weak var heigthPieView: NSLayoutConstraint!
    
    //var data = PieChartDataEntry(value: 0)
    //var data2 = PieChartDataEntry(value: 0)
    var data = [PieChartDataEntry]()
    
    //datos de pestaña DETALLES
    @IBOutlet weak var cliente: UILabel!
    @IBOutlet weak var uso_comercial: UILabel!
    @IBOutlet weak var ci_ruc: UILabel!
    @IBOutlet weak var direccion: UITextView!
    
    @IBOutlet weak var facturas_vencidas: UILabel!
    @IBOutlet weak var max_fecha_pago: UILabel!
    @IBOutlet weak var deuda_diferido: UILabel!
    
    @IBOutlet weak var tipo_medidor: UILabel!
    @IBOutlet weak var serie_medidor: UILabel!
    @IBOutlet weak var ultimo_consumo: UILabel!
    
    
    @IBOutlet weak var cem_label: UILabel!
    @IBOutlet weak var iva_label: UILabel!
    @IBOutlet weak var interes_label: UILabel!
    @IBOutlet weak var interagua_label: UILabel!
    @IBOutlet weak var trb_label: UILabel!
    
    @IBOutlet weak var saldo: UILabel!
    
    var colors:[UIColor] = []
    var total_deb = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detailController = tabBarController as! DetailsTabBarViewController
        
        let titleView = String(describing: detailController.contrato)
        navigationBar.title = titleView
        let detailAccountItem = detailController.detailtAccountItem
        
        //llenar pestaña DETALLES
        cliente.text = detailAccountItem.cliente
        uso_comercial.text = detailAccountItem.uso_servicio
        ci_ruc.text = detailAccountItem.ci_ruc
        direccion.text = detailAccountItem.direccion
        
        facturas_vencidas.text = detailAccountItem.facturas_vencidas
        max_fecha_pago.text = detailAccountItem.max_fecha_pago
        deuda_diferido.text = detailAccountItem.deuda_diferida
        
        tipo_medidor.text = detailAccountItem.tipo_medidor
        serie_medidor.text = detailAccountItem.serie_medidor
        ultimo_consumo.text = detailAccountItem.consumo
        
        //----------------------
        
        //self.heigthPieView.constant = self.container.bounds.height
        
        //print(self.container.bounds.height)
        
        //pieChart.chartDescription?.text = "Detalle de Deudas"
        print("servicio \(detailAccountItem.servicio)")
        let status = dbase.connect_db()
        if( status.value ){
            print("entra a buscar detalles de cuenta")
            let debs_list = self.dbase.getDetailDebs(service: detailAccountItem.servicio)
            
            for item in debs_list{
                let detail_data = PieChartDataEntry(value: Double(item.valor)!)
                detail_data.label = "\(item.nombre) $\(item.valor)"
                data.append(detail_data)
                
                total_deb = total_deb + Double(item.valor)!
 
            }
        }
        saldo.text = "Saldo $\(total_deb)"
        
        if total_deb == 0.0{
            debView.isHidden = true
        }else{
            debView.isHidden = false
        }
        
        
        colors.append(UIColor(red:103.00/255.00, green:58.00/255.00, blue:183.00/255.00, alpha: 1))
        colors.append(UIColor(red:255.00/255.00, green:152.00/255.00, blue:0.00/255.00, alpha: 1))
        colors.append(UIColor(red:63.00/255.00, green:81.00/255.00, blue:181.00/255.00, alpha: 1))
        colors.append(UIColor(red:33.00/255.00, green:150.00/255.00, blue:243.00/255.00, alpha: 1))
        colors.append(UIColor(red:255.00/255.00, green:193.00/255.00, blue:7.00/255.00, alpha: 1))
        colors.append(UIColor(red:0.00/255.00, green:188.00/255.00, blue:212.00/255.00, alpha: 1))
        colors.append(UIColor(red:205.00/255.00, green:220.00/255.00, blue:57.00/255.00, alpha: 1))
        colors.append(UIColor(red:49.00/255.00, green:27.00/255.00, blue:146.00/255.00, alpha: 1))
        colors.append(UIColor(red:230.00/255.00, green:81.00/255.00, blue:0.00/255.00, alpha: 1))       //#E65100
        colors.append(UIColor(red:26.00/255.00, green:35.00/255.00, blue:126.00/255.00, alpha: 1))      //#1A237E
        colors.append(UIColor(red:21.00/255.00, green:101.00/255.00, blue:192.00/255.00, alpha: 1))     //#1565C0
        colors.append(UIColor(red:255.00/255.00, green:111.00/255.00, blue:0.00/255.00, alpha: 1))      //#FF6F00
        colors.append(UIColor(red:230.00/255.00, green:81.00/255.00, blue:0.00/255.00, alpha: 1))       //#E65100
        colors.append(UIColor(red:26.00/255.00, green:35.00/255.00, blue:126.00/255.00, alpha: 1))      //#1A237E
        colors.append(UIColor(red:21.00/255.00, green:101.00/255.00, blue:192.00/255.00, alpha: 1))     //#1565C0
        colors.append(UIColor(red:255.00/255.00, green:111.00/255.00, blue:0.00/255.00, alpha: 1))      //#FF6F00
        colors.append(UIColor(red:230.00/255.00, green:81.00/255.00, blue:0.00/255.00, alpha: 1))       //#E65100
        colors.append(UIColor(red:26.00/255.00, green:35.00/255.00, blue:126.00/255.00, alpha: 1))      //#1A237E
        colors.append(UIColor(red:21.00/255.00, green:101.00/255.00, blue:192.00/255.00, alpha: 1))     //#1565C0
        colors.append(UIColor(red:255.00/255.00, green:111.00/255.00, blue:0.00/255.00, alpha: 1))      //#FF6F00
        
        /*for i in [1,2,3,4]{
            var detail_data = PieChartDataEntry(value: 25)
            detail_data.label = "label\(i)"
            data.append(detail_data)
        }*/
        
        updateChartData()
        
        //setea los limites del view hichart
        //let bound = CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY, width: self.view.bounds.width, height: self.view.bounds.height-100)
        
        //dataView.isHidden = true
        //print(bound)
        //self.chartView = HIChartView(frame: bound)
        
        //setea el ancho y alto de los view de la secicon detalles
        widthView1.constant = (self.view.bounds.width/2)-12
        widthView2.constant = (self.view.bounds.width/2)-12
        //heigthViewBotton.constant = (self.view.bounds.height/2)-40
        
        
        
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
        dataSet.drawValuesEnabled = false
        let charData = PieChartData(dataSet: dataSet)
        
        dataSet.colors = colors
        
        pieChart.data = charData
        pieChart.drawEntryLabelsEnabled = false
        
        let legend = pieChart.legend
        legend.font = UIFont(name: "Verdana", size: 12.0)!

        
        
        //pieChart.centerText = "Saldo \(total_deb)"
        //pieChart.drawCenterTextEnabled = true
        
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
    
    @IBAction func PayAction(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: nil, message: "Seguro que desea pagar su deuda de manera Online?", preferredStyle: .alert);
        let btn_alert = UIAlertAction(title: "Aceptar", style: .default) { (UIAlertAction) in
            print("pagar deuda")
            //self.dismiss(animated: true, completion: nil)
        }
        let btn_cancel = UIAlertAction(title: "Cancelar", style: .cancel) { (UIAlertAction) in
            
        }
        alert.addAction(btn_alert);
        alert.addAction(btn_cancel);
        self.present(alert, animated: true, completion: nil);
        
    }
    
}
