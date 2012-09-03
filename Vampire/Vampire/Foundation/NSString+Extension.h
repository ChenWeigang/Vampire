//
//  NSStringEx.h
//  AsiaBriefing_iPhone
//
//  Created by Chen Weigang on 11-10-24.
//  Copyright 2011年 Fugu Mobile Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Extension)

- (NSString *)stringByTrimmingWhitespaceAndeNewLine;    // trim space and new line
- (NSString *)stringByRemoveMultableNewLines;           // remove multable lines
- (NSString *)stringByRemoveNewLines;
- (NSString *)stringByRemoveSpacesInString;             // remove multable spaces in string

- (NSString *)stringCapitalizedFirstLetter;
- (NSString *)removeSlashR;
- (NSString *)removeSlashT;

- (NSString *)removeUnicode;//



@end
