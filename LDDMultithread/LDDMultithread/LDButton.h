//
//  LDButton.h
//  LDDMultithread
//
//  Created by 李洞洞 on 6/4/17.
//  Copyright © 2017年 Minte. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LDBlock)();
@interface LDButton : UIButton
@property(nonatomic,copy)LDBlock block;
@end
