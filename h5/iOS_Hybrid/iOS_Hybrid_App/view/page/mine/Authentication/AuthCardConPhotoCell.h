//
//  AuthCardConPhotoCell.h
//  cyy_task
//
//  Created by zhchen on 16/10/8.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "AuthCell.h"

@interface AuthCardConPhotoCell : AuthCell
@property (strong, nonatomic) IBOutlet UIView *vCardConPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *imgCard;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgCardR;

@end
