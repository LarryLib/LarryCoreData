//
//  AppDelegate.h
//  LarryCoreData
//
//  Created by hd on 2018/4/16.
//  Copyright © 2018年 LarryTwoFly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

