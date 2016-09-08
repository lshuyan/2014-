//
//  UITextInputUtil.h
//  ChinaBrowser
//
//  Created by David on 14-2-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//
/*
 输入控件(UITextFiled/UITextView)相关处理：
 1、设置光标位置
 2、标记(选中)某段内容/设置光标位置
 3、得到当前光标位置
 4、偏移当前光标位置:offset<0 向左偏移；offset>0，向右偏移；（可循环的）
 5、得到标记(选中)的文本内容
 */

#import <Foundation/Foundation.h>

@interface UITextInputUtil : NSObject

/**
 *  设置光标位置
 *
 *  @param input    可输入控件
 *  @param position 光标位置
 */
+ (void)setTextInput:(UIResponder<UITextInput> *)input position:(NSInteger)position;

/**
 *  1、标记(选中)某段内容  2、当rang.length = 0时，是设置光标位置；
 *
 *  @param input 可输入控件
 *  @param range 选中范围
 */
+ (void)selectTextForInput:(UIResponder<UITextInput> *)input atRange:(NSRange)range;

/**
 *  得到当前的输入控件的光标位置
 *
 *  @param input 可输入控件
 *
 *  @return NSInteger 光标索引
 */
+ (NSInteger)textPositionOfInput:(UIResponder<UITextInput> *)input;

/**
 *  偏移当前光标位置:offset<0 向左偏移；offset>0，向右偏移；（可循环的）
 *
 *  @param input  可输入控件
 *  @param offset 偏移量
 */
+ (void)textPosition:(UIResponder<UITextInput> *)input offset:(NSInteger)offset;

/**
 *  得到输入控件中选中的文本内容
 *
 *  @param input 可输入控件
 *
 *  @return NSString 选中的文本内容
 */
+ (NSString *)selectedTextOfInput:(UIResponder<UITextInput> *)input;

@end
