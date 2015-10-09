//
//  POITableViewController.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/20/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class POITableViewController, POI;
@protocol POITableViewControllerDelegate <NSObject>

-(void) didSelectPOI:(POI *) poi;

@end

@interface POITableViewController : UITableViewController

@property (nonatomic, weak) id<POITableViewControllerDelegate> tableDelegate;

@end
