//
//  QWLabel.m
//  APP
//
//  Created by carret on 15/3/5.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "QYLabel.h"

@implementation QYLabel

- (void)setLabelValue:(NSString*)value{

    if (self == nil) {
        return;
    }
    
    self.text= [NSString stringWithFormat:@"%@" ,value];
}

@end
