//
//  UIColor+ASCExtension.h
//  graphs
//
//  Created by Abel Sánchez Custodio on 20/12/15.
//  Copyright © 2015 acsanchezcu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ASCExtension)

+ (UIColor *) colorWithHex:(unsigned int)hex;
+ (UIColor *) colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha;
+ (UIColor *) randomColor;
+ (UIColor *) colorWithHexString: (NSString *) hexString;

@end
