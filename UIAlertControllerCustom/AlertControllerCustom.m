//
//  AlertControllerCustom.m
//  cn.zhikao.com
//
//  Created by WJ on 2017/11/17.
//  Copyright © 2017年 WJ. All rights reserved.
//

#import "AlertControllerCustom.h"

#define RootVC  [[UIApplication sharedApplication] keyWindow].rootViewController
#define UIColorFrom16RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface AlertControllerCustom ()

@property (nonatomic, copy) AlertViewBlock block;

@end

@implementation AlertControllerCustom

#pragma mark - 对外方法
+ (AlertControllerCustom *)shareInstance {
    static AlertControllerCustom *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[self alloc] init];
    });
    return tools;
}

/**
 *  创建提示框
 *
 *  @param title        标题
 *  @param message      提示内容
 *  @param cancelTitle  取消按钮(无操作,为nil则只显示一个按钮)
 *  @param titleArray   标题字符串数组(为nil,默认为"确定")
 *  @param vc           VC
 *  @param confirm      点击确认按钮的回调
 */
- (void)showType:(UIAlertControllerStyle)type title:(NSString *)title
         message:(NSString *)message
     cancelTitle:(NSString *)cancelTitle
      titleArray:(NSArray *)titleArray
  viewController:(UIViewController *)vc
            view:(UIView *)view
         confirm:(AlertViewBlock)confirm {
    //
    if (!vc) vc = RootVC;
    
    if (type == UIAlertControllerStyleAlert) {
        [self p_showAlertController:title
                            message:message
                        cancelTitle:cancelTitle
                         titleArray:titleArray
                     viewController:vc view:view confirm:^(NSInteger buttonTag) {
                     if (confirm)confirm(buttonTag);
                 }];
    } else {
        [self p_showSheetAlertController:title message:message cancelTitle:cancelTitle titleArray:titleArray viewController:vc view:view confirm:^(NSInteger buttonTag) {
            if (confirm)confirm(buttonTag);
        }];
    }
}


/**
 *  创建提示框(可变参数版)
 *
 *  @param title        标题
 *  @param message      提示内容
 *  @param cancelTitle  取消按钮(无操作,为nil则只显示一个按钮)
 *  @param vc           VC
 *  @param confirm      点击按钮的回调
 *  @param buttonTitles 按钮(为nil,默认为"确定",传参数时必须以nil结尾，否则会崩溃)
 */
- (void)showType:(UIAlertControllerStyle)type title:(NSString *)title
         message:(NSString *)message
     cancelTitle:(NSString *)cancelTitle
  viewController:(UIViewController *)vc
            view:(UIView *)view
         confirm:(AlertViewBlock)confirm
    buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    
    // 读取可变参数里面的titles数组
    NSMutableArray *titleArray = [[NSMutableArray alloc] initWithCapacity:0];
    va_list list;
    if(buttonTitles) {
        //1.取得第一个参数的值(即是buttonTitles)
        [titleArray addObject:buttonTitles];
        //2.从第2个参数开始，依此取得所有参数的值
        NSString *otherTitle;
        va_start(list, buttonTitles);
        while ((otherTitle = va_arg(list, NSString*))) {
            [titleArray addObject:otherTitle];
        }
        va_end(list);
    }
    
    if (!vc) vc = RootVC;
    
    if (type == UIAlertControllerStyleAlert) {
        [self p_showAlertController:title
                            message:message
                        cancelTitle:cancelTitle
                         titleArray:titleArray
                     viewController:vc view:view confirm:^(NSInteger buttonTag) {
                         if (confirm)confirm(buttonTag);
                     }];
    } else {
        [self p_showSheetAlertController:title message:message cancelTitle:cancelTitle titleArray:titleArray viewController:vc view:view confirm:^(NSInteger buttonTag) {
            if (confirm)confirm(buttonTag);
        }];
    }
}

- (void)p_showAlertController:(NSString *)title
                      message:(NSString *)message
                  cancelTitle:(NSString *)cancelTitle
                   titleArray:(NSArray *)titleArray
               viewController:(UIViewController *)vc
                         view:(UIView *)view
                      confirm:(AlertViewBlock)confirm {
    
    UIAlertController  *alert = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIPopoverPresentationController *popover =alert.popoverPresentationController;
    popover.sourceView = view;
    popover.sourceRect = view.bounds;
    popover.permittedArrowDirections=UIPopoverArrowDirectionAny;
    
    // 下面两行代码 是修改 title颜色和字体的代码
//    NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f], NSForegroundColorAttributeName:UIColorFrom16RGB(0x000000)}];
//        [alert setValue:attributedMessage forKey:@"attributedTitle"];
    if (cancelTitle) {
        // 取消
        UIAlertAction  *cancelAction = [UIAlertAction actionWithTitle:cancelTitle
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  if (confirm)confirm(cancelIndex);
                                                              }];
        [alert addAction:cancelAction];
    }
    // 确定操作
    if (!titleArray || titleArray.count == 0) {
        UIAlertAction  *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   if (confirm)confirm(0);
                                                               }];
        
        [alert addAction:confirmAction];
    } else {
        
        for (NSInteger i = 0; i<titleArray.count; i++) {
            UIAlertAction  *action = [UIAlertAction actionWithTitle:titleArray[i]
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                if (confirm)confirm(i);
                                                            }];
            // [action setValue:UIColorFrom16RGB(0x00AE08) forKey:@"titleTextColor"]; // 此代码 可以修改按钮颜色
            [alert addAction:action];
        }
    }
    
    [vc presentViewController:alert animated:YES completion:nil];
    
}


// ActionSheet的封装
- (void)p_showSheetAlertController:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                        titleArray:(NSArray *)titleArray
                    viewController:(UIViewController *)vc
                              view:(UIView *)view
                           confirm:(AlertViewBlock)confirm {
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIPopoverPresentationController *popover =sheet.popoverPresentationController;
    popover.sourceView = view;
    popover.sourceRect = view.bounds;
    popover.permittedArrowDirections=UIPopoverArrowDirectionAny;
    
    // 下面两行代码 是修改 title颜色和字体的代码
    NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f], NSForegroundColorAttributeName:UIColorFrom16RGB(0x000000)}];
    [sheet setValue:attributedMessage forKey:@"attributedTitle"];
    if (!cancelTitle) cancelTitle = @"取消";
    
    
    // 取消
    UIAlertAction  *cancelAction = [UIAlertAction actionWithTitle:cancelTitle
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              if (confirm)confirm(cancelIndex);
                                                          }];
    [sheet addAction:cancelAction];
    
    if (titleArray.count > 0) {
        for (NSInteger i = 0; i<titleArray.count; i++) {
            UIAlertAction  *action = [UIAlertAction actionWithTitle:titleArray[i]
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                if (confirm)confirm(i);
                                                            }];
            [sheet addAction:action];
        }
    }
    
    [vc presentViewController:sheet animated:YES completion:nil];
}

- (void)showAlert:(NSString *)message viewController:(UIViewController *)vc{//时间
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:NO];
    [vc presentViewController:alert animated:YES completion:nil];
}

- (void)timerFireMethod:(NSTimer*)theTimer {//弹出框
//    NSLog(@"🍎🍌");
    UIAlertController *alert = (UIAlertController *)[theTimer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = NULL;
}

@end
