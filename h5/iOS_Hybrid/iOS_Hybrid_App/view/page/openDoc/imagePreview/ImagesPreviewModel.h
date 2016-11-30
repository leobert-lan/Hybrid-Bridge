//
//  ImagesPreviewModel.h
//  cyy_task
//
//  Created by Qingyang on 16/11/8.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseModel.h"

@interface ImagesPreviewModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *imgLocalPath;//本地地址
@property (nonatomic,retain) NSString<Optional> *imgPreviewURL;//预览图片地址
@property (nonatomic,retain) NSString<Optional> *imgURL;//原图地址

@property (nonatomic,retain) NSString<Optional> *title;
@property (nonatomic,retain) NSString<Optional> *imgSize;//数据大小
@property (nonatomic,retain) NSString<Optional> *imgSizeString;//数据大小
@property (nonatomic,retain) NSString<Optional> *oid;
@end
