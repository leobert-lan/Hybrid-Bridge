//
//  BaseCollectionCell.m
//  cyy_task
//
//  Created by Qingyang on 16/8/15.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseCollectionCell.h"

@implementation BaseCollectionCell
+ (CGSize)getCellSize:(id)data{
    return CGSizeZero;
}

- (void)setCell:(id)data{
//    SearchTypeModel
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self UIGlobal];
}

#pragma mark - 全局UI
- (void)UIGlobal{
    //    CGRect frm=self.bounds;
    //
    //    if (_separatorLine==nil) {
    //        _separatorLine=[[UIView alloc]init];
    //    }
    //
    //    frm.origin.y=CGRectGetHeight(self.contentView.bounds)-0.5f;
    //    frm.size.height=.5f;
    //    _separatorLine.frame=frm;
    //
    //    [self.contentView addSubview:_separatorLine];
    //    [self.contentView bringSubviewToFront:_separatorLine];
    //    _separatorLine.hidden=self.separatorHidden;
    //
    self.contentView.clipsToBounds = NO;
    self.clipsToBounds = YES;
    
    
}
@end
