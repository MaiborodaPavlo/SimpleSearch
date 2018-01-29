//
//  PMSection.h
//  SimpleSearch
//
//  Created by Pavel on 26.01.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMSection : NSObject

@property (strong, nonatomic) NSString *sectionName;
@property (strong, nonatomic) NSMutableArray *itemsArray;

- (void) sortSectionArray;

@end
