//
//  PMSection.m
//  SimpleSearch
//
//  Created by Pavel on 26.01.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import "PMSection.h"
#import "PMStudent.h"

@implementation PMSection

- (instancetype)init
{
    self = [super init];
    if (self) {
        _itemsArray = [NSMutableArray array];
    }
    return self;
}

- (void) sortSectionArray {
    
    [self.itemsArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        PMStudent *stud1 = obj1;
        PMStudent *stud2 = obj2;
        
        if ([stud1.firstName isEqualToString: stud2.firstName]) {
            return [stud1.lastName compare: stud2.lastName];
        } else {
            return [stud1.firstName compare: stud2.firstName];
        }
    }];
    
}

@end
