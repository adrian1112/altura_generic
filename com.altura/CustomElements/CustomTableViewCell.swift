//
//  CustomTableViewCell.swift
//  com.altura
//
//  Created by adrian aguilar on 11/6/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    var message: String?
    var title: String?
    var img: UIImage?
    
    var customMessageView1 : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    var customMessageView2 : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    var customImageView : UIImageView = {
        var imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(customImageView)
        self.addSubview(customMessageView1)
        self.addSubview(customMessageView2)
        
        customImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0).isActive = true
        //customImageView.rightAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0)
        customImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        customImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        customImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        customImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        customMessageView1.leftAnchor.constraint(equalTo: customImageView.rightAnchor, constant: 0.0).isActive = true
        customMessageView1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        //customMessageView1.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0).isActive = true
        customMessageView1.widthAnchor.constraint(equalToConstant: 100).isActive = true
        customMessageView1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //customMessageView1.bottomAnchor.constraint(equalTo: self.customMessageView2.topAnchor , constant: 0.0).isActive = true
        
        customMessageView2.leftAnchor.constraint(equalTo: customImageView.rightAnchor, constant: 0.0).isActive = true
        customMessageView2.topAnchor.constraint(equalTo: self.customMessageView1.topAnchor, constant: 0.0).isActive = true
        //customMessageView2.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0).isActive = true
        customMessageView2.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant: 0.0).isActive = true
        customMessageView2.widthAnchor.constraint(equalToConstant: 100).isActive = true
        customMessageView2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    
    override func layoutSubviews() {
        if let image = img{
            customImageView.image = image
        }
        
        if let text1 = title{
            customMessageView1.text = text1
        }
        
        if let text2 = title{
            customMessageView2.text = text2
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
