//
//  AuthCell.h
//  cyy_task
//
//  Created by zhchen on 16/10/18.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseTableCell.h"
@protocol AuthCellDelegate <NSObject>
@optional
- (void)AuthSelectStartDateDeDelegate:(id)delegate;
- (void)AuthSelectEndDateDeDelegate:(id)delegate;
- (void)AuthSelectAreaDeDelegate:(id)delegate;
- (void)AuthCardPhotoDeDelegate:(id)delegate tag:(NSInteger)tag;
- (void)AuthCardConPhotoDeDelegate:(id)delegate tag:(NSInteger)tag;
- (void)AuthCardPerPhotoDeDelegate:(id)delegate tag:(NSInteger)tag;
- (void)AuthOkDelegate:(id)delegate;

- (void)AuthStatusSelectCityDelegate:(id)delegate;
- (void)AuthCompanySelectDateDelegate:(id)delegate;
// taskrequire
- (void)TaskDetailOpenFileDelegate:(id)delegate tag:(NSInteger)tag;
@end
@interface AuthCell : BaseTableCell
@property (nonatomic, retain) IBOutlet  UITextField *txtField;
@property (nonatomic, retain) IBOutlet UITextView *txtView;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
/*!
 @method
 @brief 返回cell当前高度
 @param 传递cell内容用于计算cell实际高度
 @discussion
 @result 返回高度值
 */
+ (float)getCellHeight:(id)data;

/*!
 @method
 @brief 设置cell内容
 @param 传递cell内容用于设置
 @discussion
 @result
 */
- (void)setCell:(id)model;


/**
 *  app的UI全局设置，包括背景色，top bar背景等
 */
- (void)UIGlobal;
@end
