//
//  CategoryButton.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 10/1/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VisitButtonSelected){
    VisitButtonSelectedNO = 0,
    VisitButtonSelectedYES= 1
};

@interface CategoryButton : UIButton

@property (nonatomic, assign) VisitButtonSelected visitButtonState;
@property (nonatomic, strong) UIImageView *alreadyVisitedImageView;

@end
