//
//  NESingleChoice.m
//  MM_BVD
//
//  Created by Chen Weigang on 12-4-5.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "VPMultipleChoiceView.h"

#define NEQuestionFontSize 18
#define NEAnswerFontSize 18

@implementation VPQuestionView

-(id)initWithFrame:(CGRect)frame question:(NSString *)text
{
    self = [super initWithFrame:frame];
    
    if (self) {
        tvQuestion = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        tvQuestion.text = text;
        tvQuestion.editable = NO;
        tvQuestion.font = [tvQuestion.font fontWithSize:18];
        [self addSubview:tvQuestion];
        
        tvQuestion.frame = CGRectMake(tvQuestion.frame.origin.x, 
                                      tvQuestion.frame.origin.y, 
                                      tvQuestion.contentSize.width, 
                                      tvQuestion.contentSize.height);
        self.frame = CGRectMake(self.frame.origin.x, 
                                self.frame.origin.y, 
                                tvQuestion.frame.size.width, 
                                tvQuestion.frame.size.height);
    }    
    
    return self;
}

@end



@implementation VPAnswerView
@synthesize checked = isChecked;

- (id)initWithFrame:(CGRect)frame
             answer:(NSString *)text
{
    self = [super initWithFrame:frame];
    
    if (self) {        
        imgViewCheckBox = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        [self addSubview:imgViewCheckBox];
        
        labText = [[UILabel alloc] initWithFrame:CGRectMake(0, 
                                                            0, 
                                                            frame.size.width, 
                                                            frame.size.height)];
        labText.numberOfLines = 5;
        labText.text = text;
        [self addSubview:labText];
        
        btnChoiceRect = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        btnChoiceRect.frame = frame;
        [btnChoiceRect addTarget:self action:@selector(pressChoiceView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnChoiceRect];
    }
    
    return self;
}

- (void)dealloc
{
    [btnChoiceRect release];
    [labText release];
    [imgViewCheckBox release];
    
    [super dealloc];
}

- (void)setText:(NSString *)text
{
    labText.text = text;
}

- (void)setCheckImageNameNormal:(NSString *)normal
             imageNameHighLight:(NSString *)highLight
{ 
    if (imgViewCheckBox==nil) {
        imgViewCheckBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:normal] 
                                            highlightedImage:[UIImage imageNamed:highLight]];
        [self addSubview:imgViewCheckBox];        
    }
    else{
        imgViewCheckBox.image = [UIImage imageNamed:normal];
        imgViewCheckBox.highlightedImage = [UIImage imageNamed:highLight];
    }
    
    imgViewCheckBox.highlighted = isChecked;
}

- (void)setCheckFlag:(BOOL)flag
{
    isChecked = flag;    
    imgViewCheckBox.highlighted = isChecked;    
}

- (void)pressChoiceView
{
    isChecked = !isChecked;
    [self setCheckFlag:isChecked];
}

@end


@interface VPMultipleChoice()
- (void)createQuestionView:(NSString *)question;
- (void)createAnswerViews:(NSArray *)answer;
@end

@implementation VPMultipleChoice

- (void)setupWithType:(NEMultpleChoiceType)t
             question:(NSString *)q
              answers:(NSArray *)a
{
    assert(q!=nil && a!=nil);
    
    type = t;
    [self createQuestionView:q];
    [self createAnswerViews:a];
}

- (void)createQuestionView:(NSString *)q
{    
    questionView = [[VPQuestionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)
                                                question:q];    
    [self addSubview:questionView];
}

- (void)createAnswerViews:(NSArray *)a
{
    answerViews = [[NSMutableArray alloc] initWithCapacity:[a count]];
    for (int i=0; i<[a count]; i++) {
        VPAnswerView *av = [[[VPAnswerView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2+i*20, self.frame.size.width, 20) 
                                                                answer:[a objectAtIndex:i]] autorelease];
        [av setCheckImageNameNormal:@"check.png" imageNameHighLight:@"uncheck.png"];
        [answerViews addObject:av];
        
        [self addSubview:av];
    }
}

- (void)setLayoutType:(NEMultipleChoiceLayout)l
{
    layout = l;
}

- (NSArray *)getAnswers
{
    return nil;
}

- (void)dealloc {
    [questionView release];
    [answerViews release];
    
    [super dealloc];
}

@end
