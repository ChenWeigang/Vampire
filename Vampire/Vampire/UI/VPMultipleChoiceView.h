//
//  NESingleChoiceView.h
//  MM_BVD
//
//  Created by Chen Weigang on 12-4-5.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

// 
// Question view

@interface VPQuestionView : UIView {
    UITextView *tvQuestion;
}

- (id)initWithFrame:(CGRect)frame 
           question:(NSString *)text;

@end


// 
// Answer view

@interface VPAnswerView : UIView {
    UILabel *labText;
    UIImageView *imgViewCheckBox;
    UIButton *btnChoiceRect;
}

@property (nonatomic, assign, getter = isChecked) BOOL checked; 

- (id)initWithFrame:(CGRect)frame
             answer:(NSString *)text;

- (void)setCheckImageNameNormal:(NSString *)imageNameNormal
             imageNameHighLight:(NSString *)imageNameHighLight;

- (void)setText:(NSString *)text;

@end


// 
// enum

typedef enum {
    NEMultipleChoiceSingleAnswer,   // 单选
    NEMultipleChoiceMultipleAnswer  // 多选
}NEMultpleChoiceType;

typedef enum {
    NEMultipleChoiceLayoutPortrait,   // 竖向排列     n行 1列   default
    NEMultipleChoiceLayoutLandscape,  // 横向排列     1行 m列
    NEMultipleChoiceLayoutCustom      // 自定义       n行 m列    
}NEMultipleChoiceLayout;


// 
// Multiple Choice View

@interface VPMultipleChoice : UIView {
    
    VPQuestionView *questionView;
    NSMutableArray *answerViews;
    
    NEMultipleChoiceLayout layout;
    int row;
    int col;

    NEMultpleChoiceType type;
}

- (void)setupWithType:(NEMultpleChoiceType)type
             question:(NSString *)question
              answers:(NSArray *)answers;

- (void)setLayoutType:(NEMultipleChoiceLayout)layoutType;

- (NSArray *)getAnswers;

@end
