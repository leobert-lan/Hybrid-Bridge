//
//  ActivityCommentVC.h
//  cyy_task
//
//  Created by Qingyang on 16/11/14.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
#import "ActivityConfig.h"
@protocol ActivityCommentDelegate <NSObject>

@optional

/** 是否成功回调 */
- (void)ActivityCommentDelegate:(id)delegate success:(BOOL)success;


@end

@interface ActivityCommentVC : BaseViewController

@end
