//
//  NSArray+ASCExtension.h
//  graphs
//
//  Created by Abel Sánchez Custodio on 20/12/15.
//  Copyright © 2015 acsanchezcu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ASCExtension)

- (NSString *)toJSONString;
+ (instancetype)arrayWithJSON:(NSString *)json;

@end
