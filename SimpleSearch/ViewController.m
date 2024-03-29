//
//  ViewController.m
//  SimpleSearch
//
//  Created by Pavel on 26.01.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import "ViewController.h"
#import "PMStudent.h"
#import "PMSection.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) NSArray *sectionsArray;
@property (strong, nonatomic) NSMutableArray *studentsArray;

@property (strong, nonatomic) NSOperation *currentOperation;

@end

typedef enum {
    PMScopeBarIndexDate,
    PMScopeBarIndexName,
    PMScopeBarIndexLastName
} PMScopeBarIndex;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Generate random Students
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < arc4random() % 1001; i++) {
        [array addObject: [PMStudent randomStudent]];
    }
    
    // Sorting
    
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        PMStudent *stud1 = obj1;
        PMStudent *stud2 = obj2;
        
        NSCalendar *currentCalendar = [NSCalendar currentCalendar];

        NSInteger month1 = [currentCalendar component: NSCalendarUnitMonth fromDate: stud1.dateOfBirthday] ;
        NSInteger month2 = [currentCalendar component: NSCalendarUnitMonth fromDate: stud2.dateOfBirthday] ;

        if (month1 > month2) {
            return NSOrderedDescending;
        } else if(month1 < month2) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
        
    }];
    
    self.studentsArray = array;
    
    // Generate section
    
    self.sectionsArray = [NSMutableArray array];
    // self.sectionsArray = [self generateSectionsFromArray: self.studentsArray];
    // self.sectionsArray = [self generateSectionsFromArray: self.studentsArray withFilter: self.searchBar.text];
    
    [self generateSectionsInBackgroundFromArray: self.studentsArray withFilter: self.searchBar.text];
    
    for (PMSection *section in self.sectionsArray) {
        [section sortSectionArray];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Help Methods

- (NSArray *) generateSectionsFromArray: (NSArray *) array {

    NSMutableArray *sectionsArray = [NSMutableArray array];
    NSInteger currentMonth = 0;
    
    for (PMStudent *student in array) {
        
        NSInteger month = [student getMonthOfBirthday];
        PMSection *section = nil;
        
        if (month != currentMonth) {
            section = [[PMSection alloc] init];
            section.sectionName = [student getMonthNameOfBirthday];
            currentMonth = month;
            [sectionsArray addObject: section];
            
        } else {
            section = [sectionsArray lastObject];
        }
        [section.itemsArray addObject: student];
    }
    
    return sectionsArray;
}

- (NSArray *) generateSectionsFromArray: (NSArray *) array withFilter: (NSString *) filterString {
    
    NSMutableArray *sectionsArray = [NSMutableArray array];
    NSInteger currentMonth = 0;
    
    for (PMStudent *student in array) {
        
        if ([filterString length] > 0 && ([[student.firstName lowercaseString] rangeOfString: [filterString lowercaseString]].location == NSNotFound && [[student.lastName lowercaseString] rangeOfString: [filterString lowercaseString]].location == NSNotFound)) {
            continue;
        }
        
        NSInteger month = [student getMonthOfBirthday];
        PMSection *section = nil;
        
        if (month != currentMonth) {
            section = [[PMSection alloc] init];
            section.sectionName = [student getMonthNameOfBirthday];
            currentMonth = month;
            [sectionsArray addObject: section];
            
        } else {
            section = [sectionsArray lastObject];
        }
        [section.itemsArray addObject: student];
    }
    
    return sectionsArray;
}

- (NSArray *) generateSectionsFromArrayByName: (NSArray *) array withFilter: (NSString *) filterString {

    NSMutableArray *sectionsArray = [NSMutableArray array];
    NSString *currentLetter = nil;
    
    NSMutableArray *studentsArray = [NSMutableArray arrayWithArray: array];
    
    NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc] initWithKey: @"firstName" ascending: YES];
    NSSortDescriptor *sortDescriptorLastName = [[NSSortDescriptor alloc] initWithKey: @"lastName" ascending: YES];
    
    [studentsArray sortUsingDescriptors: @[sortDescriptorName, sortDescriptorLastName]];

    for (PMStudent *student in studentsArray) {
        
        if ([filterString length] > 0 && ([[student.firstName lowercaseString] rangeOfString: [filterString lowercaseString]].location == NSNotFound && [[student.lastName lowercaseString] rangeOfString: [filterString lowercaseString]].location == NSNotFound)) {
            continue;
        }
        
        NSString *firstLetter = [student.firstName substringToIndex: 1];
        PMSection *section = nil;
        
        if (![currentLetter isEqualToString: firstLetter]) {
            section = [[PMSection alloc] init];
            section.sectionName = firstLetter;
            currentLetter = firstLetter;
            [sectionsArray addObject: section];
        } else {
            section = [sectionsArray lastObject];
        }
        
        [section.itemsArray addObject: student];
    }
    
    return sectionsArray;
}

- (NSArray *) generateSectionsFromArrayByLastName: (NSArray *) array withFilter: (NSString *) filterString {
    
    NSMutableArray *sectionsArray = [NSMutableArray array];
    NSString *currentLetter = nil;
    
    NSMutableArray *studentsArray = [NSMutableArray arrayWithArray: array];
    
    NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc] initWithKey: @"firstName" ascending: YES];
    NSSortDescriptor *sortDescriptorLastName = [[NSSortDescriptor alloc] initWithKey: @"lastName" ascending: YES];
    
    [studentsArray sortUsingDescriptors: @[sortDescriptorLastName, sortDescriptorName]];
    
    for (PMStudent *student in studentsArray) {
        
        if ([filterString length] > 0 && ([[student.firstName lowercaseString] rangeOfString: [filterString lowercaseString]].location == NSNotFound && [[student.lastName lowercaseString] rangeOfString: [filterString lowercaseString]].location == NSNotFound)) {
            continue;
        }
        
        NSString *firstLetter = [student.lastName substringToIndex: 1];
        PMSection *section = nil;
        
        if (![currentLetter isEqualToString: firstLetter]) {
            section = [[PMSection alloc] init];
            section.sectionName = firstLetter;
            currentLetter = firstLetter;
            [sectionsArray addObject: section];
        } else {
            section = [sectionsArray lastObject];
        }
        
        [section.itemsArray addObject: student];
    }
    
    return sectionsArray;
}

- (void) generateSectionsInBackgroundFromArray: (NSArray *) array withFilter: (NSString *) filterString {
    
    [self.currentOperation cancel];
    
    __weak ViewController *weakSelf = self;
    
    self.currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSArray *sectionsArray = nil;
        
        switch (self.searchBar.selectedScopeButtonIndex) {
            case PMScopeBarIndexDate:
                sectionsArray = [weakSelf generateSectionsFromArray: array withFilter: filterString];
                break;
            case PMScopeBarIndexName:
                sectionsArray = [weakSelf generateSectionsFromArrayByName: array withFilter: filterString];
                break;
            case PMScopeBarIndexLastName:
                sectionsArray = [weakSelf generateSectionsFromArrayByLastName: array withFilter: filterString];
                break;
            default:
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.sectionsArray = sectionsArray;
            [weakSelf.tableView reloadData];
            
            self.currentOperation = nil;
        });
    }];
    
    [self.currentOperation start];
}


#pragma mark - UiTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.sectionsArray count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.sectionsArray objectAtIndex: section] sectionName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    PMSection *sec = [self.sectionsArray objectAtIndex: section];
    
    return [sec.itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: identifier];
    }
    
    PMSection *section = [self.sectionsArray objectAtIndex: indexPath.section];
    PMStudent *student = [section.itemsArray objectAtIndex: indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat: @"%@ %@", student.firstName, student.lastName];
    
    static NSDateFormatter *dateFormatter = nil;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"dd/MM/yyyy"];
    }
    
    cell.detailTextLabel.text = [dateFormatter stringFromDate: student.dateOfBirthday];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {

    NSMutableArray *returnArray = [NSMutableArray array];
    NSString *firstLetter = nil;
    
    for (PMSection *section in self.sectionsArray) {
        
        firstLetter = [section.sectionName substringToIndex: 1];
        [returnArray addObject: firstLetter];
    }
    
    return returnArray;
}


#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton: YES animated: YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton: NO animated: YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    [self generateSectionsInBackgroundFromArray: self.studentsArray withFilter: searchText];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    
    [self generateSectionsInBackgroundFromArray: self.studentsArray withFilter: self.searchBar.text];
}











@end
