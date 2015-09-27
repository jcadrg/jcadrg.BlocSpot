//
//  ViewController.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/17/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AnnotationView.h"
#import "DataSource.h"

@class ViewController, POI;

@protocol ViewControllerDelegate <NSObject>

-(void) viewController:(ViewController *) viewController didLongPressOnMap:(MKMapView *)map;

@end



@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) AnnotationView *createAnnotationView;
@property (nonatomic, weak) id<ViewControllerDelegate> delegate;

@property (nonatomic, strong) DataSource *data;
@property (nonatomic, strong) NSArray *diskArray;


@end


