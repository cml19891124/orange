//
//  MineBusinessVIPCell.swift
//  WanchangLawFirms
//
//  Created by lh on 2019/2/27.
//  Copyright © 2019 gaming17. All rights reserved.
//

import UIKit

class MineBusinessVIPCell: BaseCell {
    
    var dataArr: [VipFuncModel] = [VipFuncModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    let imgBtn: UIButton = UIButton()
    let titleLab: UILabel = UILabel.init(kFontM, kTextBlackColor, NSTextAlignment.left)
    let line: UIView = UIView.init(lineColor: kLineGrayColor)
    let lineV: UIView = UIView.init(lineColor: kLineGrayColor)
    
    private lazy var tableView: UITableView = {
        () -> UITableView in
        let temp = UITableView.init(frame: CGRect(), style: .plain, space: 0)
        temp.separatorStyle = .none
        temp.clipsToBounds = false
        temp.delegate = self
        temp.dataSource = self
        temp.register(MBVCell.self, forCellReuseIdentifier: "MBVCell")
        return temp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        imgBtn.setImage(UIImage.init(named: "business_vip_rank"), for: .normal)
        self.titleLab.text = RemindersManager.share.remindTitle(bind: "business_vip_rank")
//        desLab.text = RemindersManager.share.reminders(bind: "business_vip_rank")
        self.addSubview(imgBtn)
        self.addSubview(titleLab)
        self.addSubview(tableView)
        self.addSubview(line)
        self.addSubview(lineV)
        
        _ = imgBtn.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.topSpaceToView(self, kLeftSpaceS)?.widthIs(40)?.heightIs(40)
        _ = titleLab.sd_layout()?.leftSpaceToView(imgBtn, 0)?.topSpaceToView(self, kLeftSpaceS)?.rightSpaceToView(self, kLeftSpaceL)?.heightIs(30)
        _ = tableView.sd_layout()?.leftSpaceToView(imgBtn,15)?.rightEqualToView(titleLab)?.topSpaceToView(titleLab, 0)?.bottomSpaceToView(self, kLeftSpaceS)
        _ = line.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.heightIs(kLineHeight)
        _ = lineV.sd_layout()?.leftSpaceToView(self, kLeftSpaceL)?.rightSpaceToView(self, kLeftSpaceL)?.bottomEqualToView(self)?.heightIs(kLineHeight)
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

extension MineBusinessVIPCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MBVCell", for: indexPath) as! MBVCell
        cell.lab.text = model.content
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataArr[indexPath.row]
        let h = model.content.height(width: kDeviceWidth - kLeftSpaceL * 2 - 40 - 15, font: kFontMS)
        return h
    }
}

