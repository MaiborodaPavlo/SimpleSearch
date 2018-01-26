//
//  PMStudent.m
//  SimpleSearch
//
//  Created by Pavel on 26.01.2018.
//  Copyright © 2018 Pavel Maiboroda. All rights reserved.
//

#import "PMStudent.h"
#import "NSDate+RandomDate.h"

@implementation PMStudent

static NSString *firstNames[] = {@"Абрам", @"Аваз", @"Августин", @"Авраам", @"Агап", @"Агапит", @"Агафон", @"Адам", @"Адриан", @"Азамат", @"Азат", @"Айдар", @"Айрат", @"Акакий", @"Аким", @"Алан", @"Александр", @"Алексей", @"Али", @"Алик", @"Алихан", @"Алмаз", @"Альберт", @"Амир", @"Амирам", @"Анар", @"Анастасий", @"Анатолий", @"Ангел", @"Андрей", @"Анзор", @"Антон", @"Анфим", @"Арам", @"Аристарх", @"Аркадий", @"Арман", @"Армен", @"Арсен", @"Арсений", @"Арслан", @"Артём", @"Артемий", @"Артур", @"Архип", @"Аскар", @"Асхан", @"Ахмет", @"Ашот", @"Сергей"};

static NSString *lastNames[] = {@"Абрамов", @"Авдеев", @"Агафонов", @"Аксёнов", @"Александров", @"Алексеев", @"Андреев", @"Анисимов", @"Антонов", @"Артемьев", @"Архипов", @"Афанасьев", @"Баранов", @"Белов", @"Белозёров", @"Белоусов", @"Беляев", @"Беляков", @"Беспалов", @"Бирюков", @"Блинов", @"Блохин", @"Бобров", @"Бобылёв", @"Богданов", @"Большаков", @"Борисов", @"Брагин", @"Буров", @"Быков", @"Васильев", @"Веселов", @"Виноградов", @"Вишняков", @"Владимиров", @"Власов", @"Волков", @"Воробьёв", @"Воронов", @"Воронцов", @"Гаврилов", @"Галкин", @"Герасимов", @"Голубев", @"Горбачёв", @"Горбунов", @"Гордеев", @"Горшков", @"Григорьев", @"Гришин"};

static int namesCount = 50;

+ (PMStudent *) randomStudent {

    PMStudent *student = [[PMStudent alloc] init];
    
    student.firstName = firstNames[arc4random() % namesCount];
    student.lastName = lastNames[arc4random() % namesCount];
    
    //student.dateOfBirthday = (float)(arc4random() % 1001) / 100;
    
    student.dateOfBirthday = [[NSDate new] randomDateForStudent];
    
    return student;
    
}

- (NSInteger) getMonthOfBirthday {
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    return [currentCalendar component: NSCalendarUnitMonth fromDate: self.dateOfBirthday];

}

- (NSString *) getMonthNameOfBirthday {
    
    switch ([self getMonthOfBirthday]) {
        case 1:
            return @"January";
            break;
        case 2:
            return @"February";
            break;
        case 3:
            return @"March";
            break;
        case 4:
            return @"April";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"June";
            break;
        case 7:
            return @"July";
            break;
        case 8:
            return @"August";
            break;
        case 9:
            return @"September";
            break;
        case 10:
            return @"October";
            break;
        case 11:
            return @"November";
            break;
        case 12:
            return @"December";
            break;
            
        default:
            return @"Error";
            break;
    }
}

@end
