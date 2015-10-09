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









@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) AnnotationView *createAnnotationView;


@property (nonatomic, strong) DataSource *data;


@property (nonatomic, assign) BOOL addAnnotationState;
@property (nonatomic, assign) BOOL ViewState;

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *catArray;


@end


