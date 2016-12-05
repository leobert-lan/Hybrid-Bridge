//
//  QYRollingLbl.m
//  跑马灯
//
//  Created by Qingyang on 16/7/29.
//  Copyright © 2016年 QY. All rights reserved.
//

static CGFloat kInternalWidth=5;
static CGFloat kSpeed=0.5;
#import "QYRollingLbl.h"
@interface QYRollingLbl(){
    NSMutableArray *arrLbs,*arrTemp,*arrRolling;
    CGFloat offsetX;
    NSInteger currentIndex;
    NSTimer *_timer;
}
@end

@implementation QYRollingLbl
- (void)initLabels{
    if (self.arrLabels.count==0) {
        return;
    }
    
    arrTemp=nil;
    arrTemp=[[NSMutableArray alloc]initWithCapacity:self.arrLabels.count];
    
    arrLbs=nil;
    arrLbs=[[NSMutableArray alloc]initWithCapacity:self.arrLabels.count];
    
    arrRolling=nil;
    arrRolling=[[NSMutableArray alloc]initWithCapacity:self.arrLabels.count];
    
    //计算总宽度，修正单个宽度
    CGFloat ww=0;
    for (id obj in self.arrLabels) {
        if ([YGLOBAL object:obj isClass:[UILabel class]]) {
            
            //文字长度
            UILabel *lbl=obj;
            [lbl sizeToFit];

            lbl.width = ceil(lbl.width);
            lbl.height=self.height;
            lbl.y=0;
            lbl.x=self.width;
            
            ww+=lbl.width;
            ww+=kInternalWidth;//空格
            [arrTemp addObject:lbl];
            [arrLbs addObject:lbl];
        }
    }
    
    
    if (self.frame.size.width>0) {
        //需要复制批次
        int num=(int)self.frame.size.width/(int)ww+1;
//        DLog(@">>> %f %f 复制x%i",self.frame.size.width,ww,num);
        int i=1;
        while (i-1<num) {
            for (UILabel *lbl in arrTemp) {
                UILabel *nll= [[UILabel alloc]initWithFrame:lbl.frame];
//                nll.x+=i*ww;
                nll.text=lbl.text;
                nll.backgroundColor=lbl.backgroundColor;
                nll.attributedText=lbl.attributedText;
                
                [arrLbs addObject:nll];
            }
            i++;
        }
    }
    
    [arrTemp removeAllObjects];
    arrTemp=nil;
    
    self.clipsToBounds=YES;

}

#pragma Relation - timer
-(void)startTimer{
    //begin
    if(_timer == nil){
        [self beginTimer];
        return;
    }
    
    //resume
    if(_timer && [_timer isValid]){
        [_timer setFireDate:[NSDate date]];
    }
}

-(void)beginTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(rollingAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

//开始
- (void)start{
    [self removeAllSubviews];
    
    currentIndex=0;
    [self initLabels];
    
    if (arrLbs.count==0) {
        return;
    }
    
    //初始值
    for (UILabel *lbl in arrLbs) {
        lbl.x=self.width;
        [self addSubview:lbl];
    }
    
    UILabel *lbl=arrLbs.firstObject;
    lbl.x=self.width;
    [arrRolling addObject:lbl];
    
    //开始
    [self startTimer];
}

//暂停
- (void)pause{
    if(_timer && [_timer isValid]){
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

-(void)rollingAction:(NSTimer *)timer{
    UILabel *lblPre=nil;
    UILabel *lblDel=nil;
    for (UILabel *lbl in arrRolling) {
        lbl.x -= kSpeed;
//        DLog(@">>>%f %f",CGRectGetMaxX(lbl.frame),self.width);
        //第一条已经全部显示，准备加载next
        if (CGRectGetMaxX(lbl.frame)+kInternalWidth <= self.width) {
//            DLog(@"第一条已经全部显示，准备加载next:%@",lbl);
            lblPre=lbl;
        }
        
        if (CGRectGetMaxX(lbl.frame) <= 0) {
            lblDel=lbl;
            
        }
    }
    
    //加载next
    if (lblPre) {
        NSInteger index=[arrLbs indexOfObject:lblPre];
        UILabel *lblNext=nil;
        if (index+1<arrLbs.count) {
            lblNext=[arrLbs objectAtIndex:index+1];
        }
        else if (index+1==arrLbs.count ){
            lblNext= arrLbs.firstObject;  
        }
        
        if (lblNext && lblNext.x>=self.width) {
            lblNext.x=self.width;
            [arrRolling addObject:lblNext];
        }
    }
    
    //滑出界面
    if (lblDel) {
        [arrRolling removeObject:lblDel];
        lblDel.x=self.width;
    }
}

//-(void)timerAction2:(NSTimer *)timer{
//    
//    NSArray *labelArray = [self GetLabelRectArrayAtIndex:currentIndex];//get reseted labelArray
//    CGRect firstRect = [((NSValue *)[labelArray firstObject]) CGRectValue];
//    CGRect lastRect = [((NSValue *)[labelArray lastObject]) CGRectValue];
//    
//    NSInteger sign; //偏移方向
//    sign = (self.orientation == RollingOrientationLeft) ? 1 : -1;
//    offsetX =  offsetX - sign * kSpeed;   //frame.origin.X of first Rect
//    
// 
//    CGFloat nextOffX = offsetX + sign * (((self.orientation == RollingOrientationLeft)? firstRect.size.width : lastRect.size.width) + kInternalWidth);   //frame.origin.X of last Rect
//    
//    
//    NSArray *labelTextArray = [self GetLabelTextArrayAtIndex:currentIndex];
//    
//    if((offsetX > -firstRect.size.width && self.orientation == RollingOrientationLeft) ||
//       (offsetX < self.width && self.orientation == RollingOrientationRight) ){
//        
//        _labels[0].frame = CGRectMake(offsetX, (self.height-firstRect.size.height)/2, firstRect.size.width, firstRect.size.height);
//        _labels[0].text = [labelTextArray firstObject];
//        
//        _labels[1].frame = CGRectMake(nextOffX, (self.height-lastRect.size.height) / 2, lastRect.size.width, lastRect.size.height);
//        _labels[1].text = [labelTextArray lastObject];
//    }
//    else if((offsetX <= -firstRect.size.width  && self.orientation == RollingOrientationLeft) ||
//            (offsetX >= self.width && self.orientation == RollingOrientationRight)){
//        offsetX = _labels[1].frame.origin.x;
//        
//        currentIndex = (currentIndex + 1)  % arrLbs.count;
//    }
//}
//
//-(NSArray *)GetLabelTextArrayAtIndex:(NSInteger)index{
//    NSMutableArray *labelTextArray = [NSMutableArray arrayWithCapacity:2];
//    [labelTextArray removeAllObjects];
//    [labelTextArray addObject:[arrLbs objectAtIndex:index]];
//    [labelTextArray addObject:[arrLbs objectAtIndex:(index + 1) % arrLbs.count]];
//    return labelTextArray;
//}
//
//-(NSArray *)GetLabelRectArrayAtIndex:(NSInteger)index{
//    NSMutableArray *labelRectArray = [NSMutableArray arrayWithCapacity:2];
//    [labelRectArray removeAllObjects];
//    NSValue *firstValue = [_textRectArray objectAtIndex:index];
//    NSValue *lastValue = [_textRectArray objectAtIndex:(index + 1) % arrLbs.count];
//    [labelRectArray addObject:firstValue];
//    [labelRectArray addObject:lastValue];
//    return labelRectArray;
//}


@end
