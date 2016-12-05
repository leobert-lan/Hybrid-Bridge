//
//  sideMenuModel.h
//  cyy_task
//
//  Created by Qingyang on 16/7/13.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseModel.h"

@interface sideMenuModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *title;
@property (nonatomic,retain) NSString<Optional> *subTitle;
@property (nonatomic,retain) NSString<Optional> *imgNormal;
@property (nonatomic,retain) NSString<Optional> *imgDisabled;
@property (nonatomic,assign) BOOL clickEnabled;
@property (nonatomic,assign) BOOL subTitleEnabled;
@property (nonatomic,assign) int tag;
@end
