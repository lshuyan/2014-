//
//  UITextInputUtil.m
//  ChinaBrowser
//
//  Created by David on 14-2-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UITextInputUtil.h"

@implementation UITextInputUtil

/**
 *  设置光标位置
 *
 *  @param input    可输入控件
 *  @param position 光标位置
 */
+ (void)setTextInput:(UIResponder<UITextInput> *)input position:(NSInteger)position
{
    [UITextInputUtil selectTextForInput:input atRange:NSMakeRange(position, 0)];
}

/**
 *  选中某段内容
 *
 *  @param input 可输入控件
 *  @param range 选中范围
 */
+ (void)selectTextForInput:(UIResponder<UITextInput> *)input atRange:(NSRange)range {
    UITextPosition *start = [input positionFromPosition:[input beginningOfDocument]
                                                 offset:range.location];
    UITextPosition *end = [input positionFromPosition:start
                                               offset:range.length];
    [input setSelectedTextRange:[input textRangeFromPosition:start toPosition:end]];
}

/**
 *  得到当前的输入控件的光标位置
 *
 *  @param input 可输入控件
 *
 *  @return NSInteger 光标索引
 */
+ (NSInteger)textPositionOfInput:(UIResponder<UITextInput> *)input
{
    return [input offsetFromPosition:input.beginningOfDocument toPosition:input.selectedTextRange.start];
}

/**
 *  偏移 输入控件中的光标（可循环的）
 *
 *  @param input  可输入控件
 *  @param offset 偏移量
 */
+ (void)textPosition:(UIResponder<UITextInput> *)input offset:(NSInteger)offset
{
    NSInteger indexCurr = [input offsetFromPosition:input.beginningOfDocument toPosition:input.selectedTextRange.start];
    NSInteger toIndex = indexCurr+offset;
    NSInteger indexStart = [input offsetFromPosition:input.beginningOfDocument toPosition:input.beginningOfDocument];
    NSInteger indexEnd = [input offsetFromPosition:input.beginningOfDocument toPosition:input.endOfDocument];
    if (toIndex<indexStart) {
        [input setSelectedTextRange:[input textRangeFromPosition:input.endOfDocument toPosition:input.endOfDocument]];
    }
    else if (toIndex>indexEnd) {
        [input setSelectedTextRange:[input textRangeFromPosition:input.beginningOfDocument toPosition:input.beginningOfDocument]];
    }
    else {
        UITextPosition *start = [input positionFromPosition:[input beginningOfDocument]
                                                     offset:toIndex];
        UITextPosition *end = [input positionFromPosition:start
                                                   offset:0];
        [input setSelectedTextRange:[input textRangeFromPosition:start
                                                      toPosition:end]];
    }
}

/**
 *  得到输入控件中选中的文本内容
 *
 *  @param input 可输入控件
 *
 *  @return NSString 选中的文本内容
 */
+ (NSString *)selectedTextOfInput:(UIResponder<UITextInput> *)input
{
    return [input textInRange:[input markedTextRange]];
}

@end
