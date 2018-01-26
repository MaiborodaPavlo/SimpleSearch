//
//  PMSection.m
//  SimpleSearch
//
//  Created by Pavel on 26.01.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import "PMSection.h"

@implementation PMSection

- (instancetype)init
{
    self = [super init];
    if (self) {
        _itemsArray = [NSMutableArray array];
    }
    return self;
}

@end
