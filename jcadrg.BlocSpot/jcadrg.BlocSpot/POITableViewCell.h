//
//  POITableViewCell.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/20/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POI.h"

@interface POITableViewCell : UITableViewCell

+(CGFloat) heightForPOICell:(POI *) point width:(CGFloat) width;

@end
