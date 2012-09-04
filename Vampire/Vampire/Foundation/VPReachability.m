//
//  VPReachability.m
//  AsiaBriefing_iPhone
//
//  Created by Chen Weigang on 12-8-27.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "VPReachability.h"

BOOL isInternectAvailable(void)
{    
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    //    BOOL connectionRequired= [curReach connectionRequired];
    NSString* statusString= @"";
    switch (netStatus)
    {
        case NotReachable:
        {
            statusString = @"Access Not Available";
            return NO;
        }
            
        case ReachableViaWWAN:
        {
            statusString = @"Reachable WWAN";
            return YES;
        }
        case ReachableViaWiFi:
        {
            statusString= @"Reachable WiFi";
            return YES;
        }
    }
    return NO;
}
