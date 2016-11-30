//
//  QWBaseTableCell.m
//  APP
//
//  Created by Yan Qingyang on 15/2/27.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseTableCell.h"
@interface BaseTableCell ()
{

 
}
@end

@implementation BaseTableCell
/**
 *  获取当前cell高度，需要重写该方法，如果高度固定，直接返回高度值
 *
 *  @param obj cell数据
 *
 *  @return 高度值
 */
+ (float)getCellHeight:(id)obj{
    return 40;
}

/**
 *  无xib调用initWithStyle，需要在此初始化控件
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /**
         *  不在xib的控件在此初始化
         */
        
    }
    return self;
}


/**
 *  对控件颜色，字体，字体大小写在此方法体内
 */
- (void)UIGlobal{
    [super UIGlobal];
    
    self.contentView.backgroundColor=RGBAHex(0xffffff, 0);
    self.separatorLine.backgroundColor = RGBHex(kColorGray206);//RGBAHex(0xdbdbdb, 1);
    
    [self setSelectedBGColor:RGBHex(kColorGray210)];
}

/**
 *  控件加载数据
 *
 *  @param data 来源数据，默认都是已定义model
 */
- (void)setCell:(id)data{
    [super setCell:data];
    
}


@end
