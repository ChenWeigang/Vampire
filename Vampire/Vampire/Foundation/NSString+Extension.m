//
//  NSStringEx.m
//  AsiaBriefing_iPhone
//
//  Created by Chen Weigang on 11-10-24.
//  Copyright 2011年 Fugu Mobile Limited. All rights reserved.
//

#import "NSString+Extension.h"


@implementation NSString(Extension)

- (NSString *)stringByTrimmingWhitespaceAndeNewLine
{    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByRemoveMultableNewLines
{
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    while ([str rangeOfString:@"\n\n\n"].location!=NSNotFound) { 
        str = [str stringByReplacingOccurrencesOfString:@"\n\n\n" withString:@"\n\n"];
    }    
        
    return str;
}


- (NSString *)stringByRemoveNewLines
{
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    while ([str rangeOfString:@"\n\n"].location!=NSNotFound) { 
        str = [str stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
    }    
    
    return str;
}

- (NSString*)stringByRemoveSpacesInString
{
    NSString *string = [self stringByReplacingOccurrencesOfString:@" +" withString:@" "
                                                        options:NSRegularExpressionSearch
                                                          range:NSMakeRange(0, self.length)];
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringCapitalizedFirstLetter
{
    NSString *string = self;
    if (string!=nil && [string length]>=1) {
        NSString *firstCapChar = [[self substringToIndex:1] capitalizedString];
        self = [NSString stringWithFormat:@"%@%@", firstCapChar, [string substringFromIndex:1]];
    }    
    return self;
}

- (NSString *)removeSlashR
{
    if ([self rangeOfString:@"\r"].location!=NSNotFound) {
        self = [self stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
    }
        
    return self;
}

- (NSString *)removeSlashT
{
    if ([self rangeOfString:@"\t"].location!=NSNotFound) {
        self = [self stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    }
    
    return self;
}

- (NSString *)removeUnicode
{    
    NSMutableString *asciiCharacters = [NSMutableString string];
    for (NSInteger i = 0; i < 256; i++)  {
        [asciiCharacters appendFormat:@"%c", i];
    }
    
    NSCharacterSet *nonAsciiCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:asciiCharacters] invertedSet];
    
    self = [[self componentsSeparatedByCharactersInSet:nonAsciiCharacterSet] componentsJoinedByString:@""];
    
    return self;
}


@end
