//
//  VPContactListKit.h
//  Quake
//
//  Created by Chen Weigang on 12-5-4.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

//#ifdef VAMPIRE_ADDRESSBOOK

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

const NSString *ABKeyForFullName;
const NSString *ABKeyForEmail;
const NSString *ABKeyForPhone;
const NSString *ABKeyForPicture;


@interface VPAddressBook : NSObject

+ (NSMutableArray *)getAddressBookInfo;
+ (NSMutableDictionary *)getAddressBookInfoAToZ; // A-Z排序

@end


//#endif
