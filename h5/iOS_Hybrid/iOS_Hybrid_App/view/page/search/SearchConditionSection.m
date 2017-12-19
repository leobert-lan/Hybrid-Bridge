//
//  SearchConditionSection.m
//  cyy_task
//
//  Created by Qingyang on 16/8/16.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "SearchConditionSection.h"

@implementation SearchConditionSection

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    btnTitle.titleLabel.font=fontSystem(kFontS28);
    [btnTitle setTitleColor:RGBHex(kColorGray201) forState:UIControlStateNormal];
}


- (void)setCell:(CollectionItemTypeModel*)mod{
    model=mod;
    
    [btnTitle setTitle:model.title forState:UIControlStateNormal];
}

-(id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor=[UIColor greenColor];
//        [self createBasicView];
    }
    return self;
    
}

- (IBAction)clickAction:(id)sender{
    DLog(@">>> section:%@",model);
}

+(id)collectionReusableViewForCollectionView:(UICollectionView*)collectionView
                                     fromNib:(UINib*)nib
                                forIndexPath:(NSIndexPath*)indexPath
                                    withKind:(NSString*)kind{
    
    NSString *cellIdentifier = [self cellIdentifier];
    [collectionView registerClass:[self class] forSupplementaryViewOfKind:kind withReuseIdentifier:cellIdentifier];
    [collectionView registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:cellIdentifier];
    SearchConditionSection *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [super applyLayoutAttributes:layoutAttributes];
    
    //
}

+(id)collectionReusableViewForCollectionView:(UICollectionView*)collectionView
                                forIndexPath:(NSIndexPath*)indexPath withKind:(NSString*)kind{
    return [[self class] collectionReusableViewForCollectionView:collectionView
                                                         fromNib:[self nib]
                                                    forIndexPath:indexPath
                                                        withKind:kind];
}

+ (NSString *)nibName {
    return [self cellIdentifier];
}

+ (NSString *)cellIdentifier {
    [NSException raise:NSInternalInconsistencyException format:@"WARNING: YOU MUST OVERRIDE THIS GETTER IN YOUR CUSTOM CELL .M FILE"];
    static NSString* _cellIdentifier = nil;
    _cellIdentifier = NSStringFromClass([self class]);
    return _cellIdentifier;
}

+(UINib*)nib{
    NSBundle * classBundle = [NSBundle bundleForClass:[self class]];
    UINib * nib = [UINib nibWithNibName:[self nibName] bundle:classBundle];
    return nib;
}

@end
