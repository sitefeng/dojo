//
//  PhotoSearchViewController.m
//  Signal
//
//  Created by Si Te Feng on 9/9/16.
//  Copyright © 2016 Technochimera. All rights reserved.
//

#import <sqlite3.h>

#import "PhotoSearchViewController.h"


@interface PhotoSearchViewController ()

@property (nonatomic, strong) NSTimer *mainTimer;
@end

@implementation PhotoSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSBundle *bundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/CoreTelephony.framework"];
    BOOL success = [bundle load];
    
//    _mainTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerTriggered) userInfo:nil repeats:YES];
    NSLog(@"SMS: %@", [self mostRecentSMS]);
}


- (void)timerTriggered {
    Class CTMessageCenter = NSClassFromString(@"CTMessageCenter");
    id messageCenter = [CTMessageCenter valueForKey: @"sharedMessageCenter"];
    
    SEL allIncomingMessages = NSSelectorFromString(@"allIncomingMessages");
    id allMessages = [messageCenter performSelector:allIncomingMessages];
    
    NSArray *messagesArray = (NSArray *)allMessages;
    
    if (messagesArray.count > 1) {
        NSLog(@"YESS");
    } else {
        NSLog(@"NO");
    }
    
    NSLog(@"All Messages: %@", allMessages);
}


- (NSString *) mostRecentSMS  {
    NSString *text = @"";
    
    sqlite3 *database;
    int dbStatus = sqlite3_open([@"/private/var/mobile/Library/SMS/sms.db" UTF8String], &database);
    
    if(dbStatus == SQLITE_OK) {
        sqlite3_stmt *statement;
        
        // iOS 4 and 5 may require different SQL, as the .db format may change
        const char *sql4 = "SELECT text from message ORDER BY rowid DESC";  // TODO: different for iOS 4.* ???
        const char *sql5 = "SELECT text from message ORDER BY rowid DESC";
        
        NSString *osVersion =[[UIDevice currentDevice] systemVersion];
        if([osVersion hasPrefix:@"5"]) {
            // iOS 5.* -> tested
            sqlite3_prepare_v2(database, sql5, -1, &statement, NULL);
        } else {
            // iOS != 5.* -> untested!!!
            sqlite3_prepare_v2(database, sql4, -1, &statement, NULL);
        }
        
        // Use the while loop if you want more than just the most recent message
        //while (sqlite3_step(statement) == SQLITE_ROW) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            char *content = (char *)sqlite3_column_text(statement, 0);
            text = [NSString stringWithCString: content encoding: NSUTF8StringEncoding];
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(database);
    }
    return text;
}


// Not working
//private func printSMSServiceInfo() {
//    let bundle = NSBundle(path: "/System/Library/PrivateFrameworks/IMCore.framework")
//    let success = bundle?.load()
//    
//    if !success! {
//        print("Bundle load error")
//    }
//    
//    let imService: AnyObject! = NSClassFromString("IMService")
//    let smsService = imService.swift_performSelector(Selector("smsService"), withObject: nil)
//    
//    let allInfo = smsService?.valueForKey("infoForAllPeople")
//    print("all info: \(allInfo)")
//}



@end

