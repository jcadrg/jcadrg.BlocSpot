//
//  CategoryButton.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 10/1/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "CategoryButton.h"

@interface CategoryButton()

@property (nonatomic, strong) NSString *imageName;

@end


@implementation CategoryButton

-(instancetype) init{
    self =[super init];
    
    if (self) {
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        
        self.visitButtonState = VisitButtonSelectedNO;
    }
    
    return self;
}


-(void) setVisitButtonState:(VisitButtonSelected)visitButtonState{
    _visitButtonState = visitButtonState;
    
    NSString *imageName;
    switch (_visitButtonState) {
        case VisitButtonSelectedNO:
            
            imageName = @"hearts_filled";
            
            break;
            
        case VisitButtonSelectedYES:
            
            imageName = @"like";
            
            break;
    }
    
    [self setImage:[self returnImageColoredWithName:imageName].image forState:UIControlStateNormal];
}

-(UIImageView *) returnImageColoredWithName:(NSString *)name{
    
    UIImageView *imageView = [UIImageView new];
    UIImage *image = [UIImage imageNamed:name];
    imageView.frame = CGRectMake(0, 0, self.frame.size.width-10, self.frame.size.height-10);
    imageView.image = image;
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    return imageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
