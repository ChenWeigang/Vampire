//
//  VPEventKit+SaveToCalandar.m
//  Vampire
//
//  Created by Chen Weigang on 12-8-27.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "VPEventKit+SaveToCalandar.h"

@implementation VPEventKit_SaveToCalandar

-(BOOL)saveEventToCalandarStartDate:(NSDate *)startDate
                            endDate:(NSDate *)endDate
                              title:(NSString *)title
                              notes:(NSString *)notes
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEvent *_event = [EKEvent eventWithEventStore:eventStore];
    _event.allDay = YES;
    _event.title = title;
    _event.notes = notes;
    _event.startDate = startDate;
    _event.endDate = endDate;
    [_event setCalendar:[eventStore defaultCalendarForNewEvents]];
    NSError *err = nil;
    [eventStore saveEvent:_event span:EKSpanThisEvent error:&err];   
    
    return err==nil;
}

@end
