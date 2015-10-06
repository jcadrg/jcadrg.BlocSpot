//
//  POITableViewCell.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/20/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POI.h"
#import "CategoryButton.h"
#import <MapKit/MapKit.h>

@class POITableViewCell;

@protocol POITableViewCellDelegate <NSObject>

-(void) cellDidPressOnButton:(POITableViewCell *) cell;

@end


@interface POITableViewCell : UITableViewCell

@property (nonatomic, strong) id<POITableViewCellDelegate> delegate;
@property (nonatomic, strong) UILabel *locationName;
@property (nonatomic, strong) UILabel *locationNotes;
@property (nonatomic, strong) UILabel *distance;
@property (nonatomic, strong) CategoryButton *categoryButton;
@property (nonatomic, strong) id<MKAnnotation> annotation;


-(id) initForAnnotation:(id<MKAnnotation>) annotation;



@end
