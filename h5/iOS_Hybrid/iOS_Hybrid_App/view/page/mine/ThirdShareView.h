//
//  ThirdShareView.h
//  CloudBox
//
//  Created by zhchen on 16/3/2.
//  Copyright © 2016年 YAN Qingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ThirdShareEnumType) {
    ShareEnumTypeSina = 0,
    ShareEnumTypeQQ = 1,
    ShareEnumTypeWeixin = 2,
    ShareEnumTypeQQZone = 3,
    ShareEnumTypeWexinLine = 4,
    ShareEnumTypeCopy = 5,
};

typedef void (^ShareBlock) (NSInteger obj);
@interface ThirdShareView : UIView
@property (nonatomic, copy) ShareBlock callBackBlock ;//按钮点击事件的回调
@property (strong, nonatomic) IBOutlet UIButton *btnCopy;
@property (strong, nonatomic) IBOutlet UILabel *lblCopy;

+ (ThirdShareView *)instanceWithBtnCopy:(BOOL)btnCopy Block:(ShareBlock)block;
- (void)show;
@end
