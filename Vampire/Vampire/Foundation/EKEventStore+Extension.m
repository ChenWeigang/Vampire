//
//  VPEventKit+SaveToCalandar.m
//  Vampire
//
//  Created by Chen Weigang on 12-8-27.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "EKEventStore+Extension.h"

@implementation EKEventStore(Extension)

+(BOOL)saveEventToCalendarTitle:(NSString *)title
                          notes:(NSString *)notes
                      startDate:(NSDate *)startDate
                        endDate:(NSDate *)endDate
{
    EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];
    EKEvent *_event = [EKEvent eventWithEventStore:eventStore];
    _event.title = title;
    _event.notes = notes;
    _event.startDate = startDate;
    _event.endDate = endDate;
    _event.allDay = YES;
    [_event setCalendar:[eventStore defaultCalendarForNewEvents]];
    NSError *err = nil;
    [eventStore saveEvent:_event span:EKSpanThisEvent error:&err];   
    
    return err==nil;
}

@end
