//
//  QWBaseCell.m
//  APP
//
//  Created by Yan Qingyang on 15/3/5.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseCell.h"
#import "BaseModel.h"

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}

//static const char *getPropertyValueByAttributeType(objc_property_t property, const char *attributeType){
//    if (attributeType==nil) {
//        return nil;
//    }
//    NSString *at=[attributeType uppercaseString];
//    
//    const char *attributes = property_getAttributes(property);
//    NSString *atts=[NSString stringWithUTF8String:attributes];
//    NSArray *arr=[atts componentsSeparatedByString:@","];
//    for (NSString *ss in arr) {
//        NSString *attName=[ss substringToIndex:1];
//        if ([attName isEqualToString:at]) {
//            return [ss substringFromIndex:1];
//        }
//    }
//    return nil;
//}

#pragma mark basecell
@interface BaseCell ()
{
    UIColor *colorSelected;
    UIView *vBGSelected;
}
@end

@implementation BaseCell

+ (float)getCellHeight:(id)obj{
    return 0;
}

- (void)setCell:(id)data{
    [self assignByModel:data];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self UIGlobal];
}

#pragma mark - 选择背景颜色
- (void)setSelectedBGColor:(UIColor*)aColor{
    colorSelected=aColor;
    self.selectedBackgroundView = nil;
    //    self.selectedBackgroundView = [[UIView alloc]init];
    //    self.selectedBackgroundView.backgroundColor = aColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{

    if (highlighted && colorSelected) {
        vBGSelected=[[UIView alloc]initWithFrame:self.contentView.bounds];
        vBGSelected.backgroundColor=colorSelected;
        [self.contentView addSubview:vBGSelected];
        [self.contentView sendSubviewToBack:vBGSelected];
    }
    else {
        [vBGSelected removeFromSuperview];
        vBGSelected = nil;
    }
}

-  (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    
////    [self UIGlobal];
//}

#pragma mark - 全局UI
- (void)UIGlobal{

    CGRect frm=self.bounds;
    
    

    if (_separatorLine==nil) {
        _separatorLine=[[UIView alloc]init];
    }
    [_separatorLine removeFromSuperview];

    float hh=0.5;
    frm.origin.y=CGRectGetHeight(self.contentView.bounds)-hh;
    frm.size.height=hh;
    _separatorLine.frame=frm;

    [self.contentView addSubview:_separatorLine];
    [self.contentView bringSubviewToFront:_separatorLine];
    
    
    self.contentView.clipsToBounds = NO;
    self.clipsToBounds = YES;
    
    
    _separatorLine.hidden=self.separatorHidden;

}

- (void)setSeparatorMargin:(CGFloat)margin edge:(Enum_Edge)edge{
    [self setObject:_separatorLine margin:margin edge:edge];
}

- (void)setObject:(UIView*)object margin:(CGFloat)margin edge:(Enum_Edge)edge{
    if (object && [object isMemberOfClass:[UIView class]]) {
        object.width=self.contentView.width;
        CGRect frm=object.frame;
        if (edge & EdgeLeft) {
            frm.size.width -= margin;
            frm.origin.x = margin;
        }
        if (edge & EdgeRight) {
            frm.size.width -= margin;
        }
        if (edge & EdgeTop) {
            frm.size.height -= margin;
            frm.origin.y = margin;
        }
        if (edge & EdgeBottom) {
            frm.size.height -= margin;
        }
        
        object.frame=frm;
    }
}
#pragma mark - mod传值
- (void)assignByModel:(id)mod{
    if (![mod isKindOfClass:[BaseModel class]]) {
        return;
    }
    
    Class clazz = [self class];
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(clazz, &propertyCount);
    
    for (int i = 0; i < propertyCount; i++)
    {
        //get property
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        const char* propertyType = getPropertyType(property);
        
        NSString *name=[NSString stringWithUTF8String:propertyName];
        NSString *type=[NSString stringWithUTF8String:propertyType];

        if ([type length] != 1) {
            NSString *nameInstance=[self getProperty:property attributeType:@"V"];
            if (nameInstance==nil) {
                nameInstance=name;
            }
            
            Ivar ivar= class_getInstanceVariable(clazz, [nameInstance UTF8String]);
            id obj = object_getIvar(self, ivar);
            NSString *value =//[mod valueForKey:name];
            [self getValue:name model:mod];
            
            if ([type isEqualToString:@"QYImageView"]) {
                if ([obj respondsToSelector:@selector(setImageURL:)]) {
                    [obj setImageURL:value];
                }
            }
            if ([type isEqualToString:@"QYLabel"]) {
                if ([obj respondsToSelector:@selector(setLabelValue:)]) {
                    [obj setLabelValue:value];
                }
            }
            if ([type isEqualToString:@"QYButton"]) {
                
            }
        }
    }
    free(properties);
    
}

- (NSString*)getValue:(NSString*)key model:(id)mod{
    NSDictionary *dd=[mod toDictionary];
    return [dd objectForKey:key];
}


- (NSString *)getProperty:(objc_property_t)property attributeType:(NSString*)attributeType{
    if (attributeType==nil) {
        return nil;
    }
    NSString *at=[attributeType uppercaseString];
    
    const char *attributes = property_getAttributes(property);
    NSString *atts=[NSString stringWithUTF8String:attributes];
    NSArray *arr=[atts componentsSeparatedByString:@","];
    for (NSString *ss in arr) {
        NSString *attName=[ss substringToIndex:1];
        if ([attName isEqualToString:at]) {
            return [ss substringFromIndex:1];
        }
    }
    return nil;
}

@end
