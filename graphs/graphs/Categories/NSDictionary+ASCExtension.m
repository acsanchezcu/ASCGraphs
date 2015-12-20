//
//  NSDictionary+ASCExtension.m
//  graphs
//
//  Created by Abel Sánchez Custodio on 20/12/15.
//  Copyright © 2015 acsanchezcu. All rights reserved.
//

#import "NSDictionary+ASCExtension.h"

@implementation NSDictionary (ASCExtension)

- (NSString *)toJSONString
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    
    if (error)
    {
        NSLog(@"%@", error.localizedDescription);
        
        return @"";
    }
    else
    {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (NSArray *)arrayForKey:(NSString *)key
{
    id value = self[key];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if ([value isKindOfClass:[NSArray class]])
    {
        for (id object in (NSArray *)value)
        {
            if ([object isKindOfClass:[NSNumber class]])
            {
                NSString *string = [NSString stringWithFormat:@"%@", object];
                [array addObject:string];
            }
        }
    }
    
    if (array.count > 0)
    {
        return [NSArray arrayWithArray:array];
    }
    else
    {
        if ([value isKindOfClass:[NSArray class]])
        {
            return value;
        }
    }
    
    return nil;
}

- (NSDictionary *)dictionaryForKey:(NSString *)key
{
    id value = self[key];
    
    if ([value isKindOfClass:[NSDictionary class]]) return value;
    
    return nil;
}

- (NSString *)stringForKey:(NSString *)key
{
    id value = self[key];
    
    if ([value isKindOfClass:[NSString class]]) return [value stringByTrimmingCharactersInSet:
                                                        [NSCharacterSet whitespaceCharacterSet]];
    
    if ([value isKindOfClass:[NSNumber class]]) return [NSString stringWithFormat:@"%@", value];
    
    return @"";
}

- (BOOL)boolForKey:(NSString *)key
{
    id value = self[key];
    
    if ([value isKindOfClass:[NSNumber class]]) return [value boolValue];
    
    if ([value isKindOfClass:[NSString class]])
    {
        if ([[value uppercaseString] isEqualToString:@"TRUE"]
            || [value isEqualToString:@"1"]
            || [[value uppercaseString] isEqualToString:@"S"]
            || [[value uppercaseString] isEqualToString:@"Y"]
            || [[value uppercaseString] isEqualToString:@"YES"])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return NO;
}

- (int)intForKey:(NSString *)key
{
    NSInteger value = [self integerForKey:key];
    
    return (int)value;
}

- (float)floatForKey:(NSString *)key
{
    id value = self[key];
    
    if ([value isKindOfClass:[NSNumber class]]) return [value floatValue];
    if ([value isKindOfClass:[NSString class]]) return [value floatValue];
    
    return 0.0;
}

- (NSInteger)integerForKey:(NSString *)key
{
    id value = self[key];
    
    if ([value isKindOfClass:[NSNumber class]]) return [value integerValue];
    if ([value isKindOfClass:[NSString class]]) return [value integerValue];
    
    return 0;
}

@end