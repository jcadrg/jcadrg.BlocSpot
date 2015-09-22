//
//  POI.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/20/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POI : NSObject

@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, assign) BOOL visitState;

@end
