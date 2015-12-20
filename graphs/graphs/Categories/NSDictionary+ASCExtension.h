//
//  NSDictionary+ASCExtension.h
//  graphs
//
//  Created by Abel Sánchez Custodio on 20/12/15.
//  Copyright © 2015 acsanchezcu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ASCExtension)

- (NSString *)toJSONString;
- (NSArray *)arrayForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
- (int)intForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;

@end
