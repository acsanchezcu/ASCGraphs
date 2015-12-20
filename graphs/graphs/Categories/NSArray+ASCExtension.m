//
//  NSArray+ASCExtension.m
//  graphs
//
//  Created by Abel Sánchez Custodio on 20/12/15.
//  Copyright © 2015 acsanchezcu. All rights reserved.
//

#import "NSArray+ASCExtension.h"

@implementation NSArray (ASCExtension)

+ (instancetype)arrayWithJSON:(NSString *)json
{
    NSError* error = nil;
    
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

- (NSString *)toJSONString
{
    NSString* json = nil;
    
    NSError* error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return (error ? nil : json);
}

@end
