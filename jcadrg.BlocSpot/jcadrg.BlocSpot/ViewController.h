//
//  ViewController.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/17/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (weak, nonatomic) MKMapView *mapView;

-(IBAction)zoomIn:(id)sender;
-(IBAction)changeMapType:(id)sender;


@end

