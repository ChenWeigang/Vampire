//
//  VPEventKit+SaveToCalandar.h
//  Vampire
//
//  Created by Chen Weigang on 12-8-27.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EKEventStore(Extension)

+(BOOL)saveEventToCalendarTitle:(NSString *)title
                          notes:(NSString *)notes
                      startDate:(NSDate *)startDate
                        endDate:(NSDate *)endDate;


@end
