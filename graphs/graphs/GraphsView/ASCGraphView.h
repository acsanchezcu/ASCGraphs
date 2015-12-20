//
//  ASCGraphView.h
//  graphs
//
//  Created by Abel Sánchez Custodio on 19/12/15.
//  Copyright © 2015 acsanchezcu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSDictionary+ASCExtension.h"
#import "NSArray+ASCExtension.h"
#import "UIColor+ASCExtension.h"


#define kGraphTitle @"kGraphTitle"
#define kGraphValue @"kGraphValue"
#define kGraphColor @"kGraphColor"
#define kGraphMaxValue @"kGraphMaxValue"
#define kGraphDate @"kGraphDate"


typedef enum : NSUInteger {
    ASCGraphViewTypeNone,
    ASCGraphViewTypeHorizontalFatBar,
    ASCGraphViewTypeHorizontalThinBar,
    ASCGraphViewTypeMiddleBar,
    ASCGraphViewTypeHorizontalThinRightAlignmentBar,
    ASCGraphViewTypeHorizontalRightDetailBar,
} ASCGraphViewType;


IB_DESIGNABLE

@interface ASCGraphView : UIView

@property (assign, nonatomic) IBInspectable NSUInteger iGraphViewType;
@property (strong, nonatomic) IBInspectable NSString *sInformation;

@property (assign, nonatomic) ASCGraphViewType graphViewType;

@property (assign, nonatomic) BOOL animated;
@property (assign, nonatomic) BOOL animationDone;
@property (assign, nonatomic) BOOL animationProgress;

@property (strong, nonatomic) NSArray *information;

@property (strong, nonatomic) NSString *defaultInformation;
@property (assign, nonatomic) NSUInteger defaultGraphViewType;

- (void)reloadDataAnimated:(BOOL)animated;

@end
