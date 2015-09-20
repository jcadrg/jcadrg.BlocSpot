//
//  NewAnnotation.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/20/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NewAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *annotationTitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

+(MKAnnotationView *) annotationForMapView:(MKMapView *) mapView annotation:(id<MKAnnotation>) annotation;

@end
