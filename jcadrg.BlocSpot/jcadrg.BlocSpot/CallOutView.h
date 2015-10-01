//
//  CallOutView.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/29/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

// 1- Navigation bar
//    1.a- NavigationBar Title [name of the place]
//    1.b- RightBarButtonItem with HeartColoredImage
// 2- Description Label
// 3- Category Label
// 3.5- Create a UIView to Add the three following buttons in order to autoLayout them on the view easier
// 4- Buttons
//    4.a- Directions to place [ gonna link to maps] - Will probably need a delegate to communicate to MapViewController
//    4.b- Share button - Get share action sheet to other Apps - See Blocstagram
//    4.c- Delete Button - Where user should be able to delete POI's
//
//- NavigationBar
//- UIBarButtonItem
//- 2*UILabels - [Description][Category]
//- 3*UIButtons - [Direction][Share][Delete]

@interface CallOutView : MKAnnotationView

@property (nonatomic, retain) UIView *contentView;

@end
