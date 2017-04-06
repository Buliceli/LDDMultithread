//
//  LDButton.m
//  LDDMultithread
//
//  Created by 李洞洞 on 6/4/17.
//  Copyright © 2017年 Minte. All rights reserved.
//

#import "LDButton.h"

@implementation LDButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)btnClick:(UIButton *)btn
{
    if (self.block) {
        self.block();
    }
}
@end
