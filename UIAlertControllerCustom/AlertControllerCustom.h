//
//  AlertControllerCustom.h
//  cn.zhikao.com
//
//  Created by WJ on 2017/11/17.
//  Copyright © 2017年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// 取消按钮的tag值
#define cancelIndex  (-1)

typedef void (^AlertViewBlock)(NSInteger buttonTag);
@interface AlertControllerCustom : NSObject

+ (AlertControllerCustom *)shareInstance;

/**
 *  创建提示框
 *
 *  @param title        标题
 *  @param message      提示内容
 *  @param cancelTitle  取消按钮(无操作,为nil则只显示一个按钮)
 *  @param titleArray   标题字符串数组(为nil,默认为"确定")
 *  @param vc           VC iOS8及其以后会用到
 *  @param confirm      点击按钮的回调(取消按钮的Index是cancelIndex -1)
 */
- (void)showType:(UIAlertControllerStyle )type title:(NSString *)title
         message:(NSString *)message
     cancelTitle:(NSString *)cancelTitle
      titleArray:(NSArray *)titleArray
  viewController:(UIViewController *)vc
            view:(UIView *)view
         confirm:(AlertViewBlock)confirm;

/**
 *  创建提示框(可变参数版)
 *
 *  @param title        标题
 *  @param message      提示内容
 *  @param cancelTitle  取消按钮(无操作,为nil则只显示一个按钮)
 *  @param vc           VC iOS8及其以后会用到
 *  @param confirm      点击按钮的回调(取消按钮的Index是cancelIndex -1)
 *  @param buttonTitles 按钮(为nil,默认为"确定",传参数时必须以nil结尾，否则会崩溃)
 */
- (void)showType:(UIAlertControllerStyle )type title:(NSString *)title
         message:(NSString *)message
     cancelTitle:(NSString *)cancelTitle
  viewController:(UIViewController *)vc
            view:(UIView *)view
         confirm:(AlertViewBlock)confirm
    buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;


/**
 提示框自动消失
 
 @param message 提示框内消息
 @param vc ViewController
 */
- (void)showAlert:(NSString *)message viewController:(UIViewController *)vc;

@end
