//
//  AppDelegate.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/17/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "DataSource.h"

@interface AppDelegate ()<CLLocationManagerDelegate>

@property NSDictionary *dictionary;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor cloudsColor];
    [self.window makeKeyAndVisible];
    
    ViewController *mapVC = [[ViewController alloc]init];
    self.navController = [[UINavigationController alloc] initWithRootViewController:mapVC];
    self.window.rootViewController = self.navController;
    
    if (UIApplicationLaunchOptionsLocationKey)
    {
        self.locationManager = [[CLLocationManager alloc]init];
        
        _locationManager.delegate = self;
        [_locationManager startMonitoringSignificantLocationChanges];
        [[DataSource sharedInstance] addDictionary:[self calculateDistanceFromCurrentLoaction:self.locationManager.location.coordinate.latitude andLongitude:self.locationManager.location.coordinate.longitude]];
        
    }
    
    
    // NOTIFICATION STUFF
    [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
        [application registerUserNotificationSettings:[UIUserNotificationSettings
                                                       settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|
                                                       UIUserNotificationTypeSound categories:nil]];
        
        
    }
    return YES;
}

-(NSDictionary *)calculateDistanceFromCurrentLoaction:(CGFloat )latitude andLongitude:(CGFloat )longitude
{
    
    NSMutableDictionary *tempDic = [NSMutableDictionary new];
    
    for (POI *poi in [DataSource sharedInstance].annotations)
    {
        CGFloat poiLatitude = poi.annotation.latitude;
        CGFloat poiLongitude = poi.annotation.longitude;
        NSLog(@"POI LATITUDE: %f", poiLatitude);
        NSLog(@"POI LONGITUDE: %f", poiLongitude);
        
        CLLocation *desiredLocation = [[CLLocation alloc] initWithLatitude:poiLatitude longitude:poiLongitude];
        NSLog(@"LOCATION LATITUDE: %f",latitude);
        NSLog(@"LOCATION LONGITUDE: %f",longitude);
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        CLLocationDistance distance = [currentLocation distanceFromLocation:desiredLocation];
        
        NSLog(@"DISTANCE %f", distance);
        
        NSNumber *distanceNumber = [NSNumber numberWithFloat:distance];
        [tempDic setObject:distanceNumber forKey:poi.locationName];
    }
    NSLog(@"TEMP DIC: %@", tempDic);
    return tempDic;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSDate *now = [NSDate date];
    NSDictionary   *item = [DataSource sharedInstance].distanceValuesDictionary;
    for (NSString *key in item)
    {
        if ([item[key] integerValue]<=500)
        {
            UILocalNotification *notification = [[UILocalNotification alloc]init];
            notification.repeatInterval = 0;
            [notification setAlertBody:[NSString stringWithFormat:NSLocalizedString(@"You are %i meters from %@, go check it out!!", nil),[item[key] integerValue], key]];
            [notification setFireDate:now];
            [notification setTimeZone:[NSTimeZone  defaultTimeZone]];
            [application setScheduledLocalNotifications:[NSArray arrayWithObject:notification]];
            
        }
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSDate *now = [NSDate date];
    NSDictionary   *item = [DataSource sharedInstance].distanceValuesDictionary;
    if (item)
    {
        for (NSString *key in item)
        {
            if ([item[key] integerValue]<=500)
            {
                UILocalNotification *notification = [[UILocalNotification alloc]init];
                notification.repeatInterval = 0;
                [notification setAlertBody:[NSString stringWithFormat:NSLocalizedString(@"You are %i meters from %@, go check it out!!", nil),[item[key] integerValue], key]];
                [notification setFireDate:now];
                [notification setTimeZone:[NSTimeZone  defaultTimeZone]];
                [application setScheduledLocalNotifications:[NSArray arrayWithObject:notification]];
                
            }
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

