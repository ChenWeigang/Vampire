//
//  VPContactListKit.m
//  Quake
//
//  Created by Chen Weigang on 12-5-4.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

//#ifdef VAMPIRE_ADDRESSBOOK

#import "AddressBook+Extension.h"
#import "VPUtil.h"

@implementation VPAddressBook

NSString *ABKeyForFullName = @"fullName";
NSString *ABKeyForEmail = @"email";
NSString *ABKeyForPhone = @"phone";
NSString *ABKeyForPicture = @"picture";


+ (NSString *)getFullName:(ABRecordRef)person
{
    NSString* firstName = [(NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty) autorelease];
    
    firstName = firstName==0?@"":firstName;
    NSString* middleName = [(NSString *)ABRecordCopyValue(person, kABPersonMiddleNameProperty) autorelease];
    middleName = middleName==0?@"":middleName;
    NSString* lastName = [(NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty) autorelease];
    lastName = lastName==0?@"":lastName;
    
    NSString* fullName = [NSString stringWithFormat:@"%@ %@ %@", lastName, middleName, firstName];
    
    return [fullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString *)getPhone:(ABRecordRef)person
{
    CFStringRef phoneNumber, phoneNumberLabel;
    NSString *phone = nil;
    
    CFTypeRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    for (CFIndex i = 0; i <ABMultiValueGetCount(multi); i++) {
        phoneNumberLabel = ABMultiValueCopyLabelAtIndex(multi, i);
        phoneNumber      = ABMultiValueCopyValueAtIndex(multi, i);
        
//        NSLog(@"phoneNumberLabel = %@", (NSString *)phoneNumberLabel);       
        if ([(NSString *)phoneNumberLabel isEqualToString:@"_$!<Mobile>!$_"]) {     
//            NSLog(@"mobile = %@", (NSString *)phoneNumber);       
            phone = [[(NSString *)phoneNumber copy] autorelease];
        }
        
        CFRelease(phoneNumberLabel);
        CFRelease(phoneNumber);
    }
    
    CFRelease(multi);
    
    return phone;
}

+ (NSString *)getEmail:(ABRecordRef)person
{
    CFStringRef emailString;
    NSString *email = nil;
    
    CFTypeRef multi = ABRecordCopyValue(person, kABPersonEmailProperty);
    
    for (CFIndex i = 0; i < MIN(1, ABMultiValueGetCount(multi)); i++) {
        emailString      = ABMultiValueCopyValueAtIndex(multi, i);
        
        /* ... Do something with phoneNumberLabel and phoneNumber. ... */
        NSLog(@"email = %@", (NSString *)emailString);
        email = [[(NSString *)emailString copy] autorelease];
        CFRelease(emailString);
    }
    
    CFRelease(multi);
    
    return email;
}

+ (NSMutableArray *)getAddressBookInfo
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    NSMutableArray *arrayPeople = [NSMutableArray arrayWithCapacity:nPeople];    
    
    
    
    for (int i=0; i<nPeople; i++) {       
        
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);

        
        NSMutableDictionary *dictPerson = [NSMutableDictionary dictionaryWithCapacity:4];
        
        // full name
        NSString *fullName = [VPAddressBook getFullName:person];        
        [dictPerson setObject:fullName forKey:ABKeyForFullName];
        
        // email
        NSString *email = [VPAddressBook getEmail:person];
        if (email!=nil && email!=0) {
            [dictPerson setObject:email forKey:ABKeyForEmail];
        }
        
        // phone
        NSString *phone = [VPAddressBook getPhone:person];
        if (phone!=nil && phone!=0) {            
            [dictPerson setObject:phone forKey:ABKeyForPhone];  
        }      
        
        // picture
        NSData *data = (NSData *)ABPersonCopyImageData(person);
        if (data!=nil) {            
            [dictPerson setObject:data forKey:ABKeyForPicture]; 
        }   
        
        [arrayPeople addObject:dictPerson];
        [data release];
    }
    
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey:ABKeyForFullName ascending:YES];
    arrayPeople = [[[NSMutableArray alloc] initWithArray:[arrayPeople sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]]] autorelease];
     
    CFRelease(allPeople);
    CFRelease(addressBook);
    
    return arrayPeople;
}


+ (NSMutableDictionary *)getAddressBookInfoAToZ
{
    NSMutableArray *addressBooks = [VPAddressBook getAddressBookInfo];
    
    NSMutableDictionary *dictAToZ = [NSMutableDictionary dictionaryWithCapacity:26];
    
    
//    NSArray *AToZlist = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#", nil];
        
//    NSLog(@"addressBooks = %@", addressBooks);
    
    
    for (int i=0; i<[addressBooks count]; i++){
        
        NSDictionary *dictAB = [addressBooks objectAtIndex:i];
        NSString *fullName = [dictAB objectForKey:ABKeyForFullName];
        
        
        
        if (fullName!=nil && ![fullName isEqualToString:@""] && !isFirstLetterNumber(fullName)) {            
            NSString *firstCapChar = [[fullName substringToIndex:1] capitalizedString];
            NSMutableArray *marr = [dictAToZ objectForKey:firstCapChar];   
            
            if (marr==nil) {
                marr = [NSMutableArray arrayWithCapacity:10];
                [dictAToZ setObject:marr forKey:firstCapChar];
            }
            
            [marr addObject:dictAB];            
        }
//        else
//        {
//            NSMutableArray *marr = [dictAToZ objectForKey:@"#"];
//            if (marr==nil) {
//                marr = [NSMutableArray arrayWithCapacity:10];
//                [dictAToZ setObject:marr forKey:@"#"];
//            }
//            [marr addObject:dictAB];
//        }
    }
    
  
//    NSLog(@"dictAToZ = %@", dictAToZ);
    return dictAToZ;
}

@end

//#endif

