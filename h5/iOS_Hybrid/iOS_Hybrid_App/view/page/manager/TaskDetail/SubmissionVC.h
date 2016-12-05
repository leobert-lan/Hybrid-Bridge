//
//  SubmissionVC.h
//  cyy_task
//
//  Created by zhchen on 16/8/19.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
#import "QYImage.h"
typedef void(^SubmissionBlock)();
@interface SubmissionVC : BaseViewController
@property (nonatomic,copy)NSString *isMArk;
@property (nonatomic,copy)NSString *taskBn;
@property (nonatomic,copy)SubmissionBlock submissionBlock;
@end
