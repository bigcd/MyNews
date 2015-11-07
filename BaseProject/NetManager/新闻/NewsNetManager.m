//
//  NewsNetManager.m
//  网易新闻
//
//  Created by apple-jd03 on 15/11/5.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "NewsNetManager.h"
//很多具有共同点的东西，可以统一宏定义, 凡是自己写的宏定义 都需要用k开头，这是编码习惯


//把path写到文件头部，使用宏定义形势。 方便后期维护
//把所有路径宏定义封装到DuoWanRequestPath.h文件中
#import "NewsRequestPath.h"
@implementation NewsNetManager
+ (id)getSEWithType:(FirstType)type index:(NSInteger)index completionHandle:(void (^)(id, NSError *))completionHandle{
    NSString *path = nil;
    switch (type) {
        case FirstTypeScience: {
            path = [NSString stringWithFormat:kSciencePath,(long)index];
            return [self GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
                completionHandle([ScienceModel objectWithKeyValues:responseObj],error);
            }];
            break;
        }
        case FirstTypeEconomics: {
            path = [NSString stringWithFormat:kEconomicsPath,(long)index];
            return [self GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
                completionHandle([EconomicsModel objectWithKeyValues:responseObj],error);
            }];
            break;
        }
        default: {
            NSAssert1(NO, @"%s:type类型不正确", __func__);
            break;
        }
    }
    
}
+ (id)getHSYWithType:(SecondType)type index:(NSInteger)index completionHandle:(void (^)(id, NSError *))completionHandle{
    NSString *path = nil;
    switch (type) {
        case SecondTypeHeadLine: {
            path = [NSString stringWithFormat:kHeadLinePath,(long)index];
            return [self GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
                completionHandle([HeadLineModel objectWithKeyValues:responseObj],error);
            }];
            break;
        }
        case SecondTypeSports: {
            path = [NSString stringWithFormat:kSportsPath,(long)index];
            return [self GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
                completionHandle([SportsModel objectWithKeyValues:responseObj],error);
            }];
            break;
        }
        case SecondTypeYuLe: {
            path = [NSString stringWithFormat:kYuLePath,(long)index];
            return [self GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
                completionHandle([YuLeModel objectWithKeyValues:responseObj],error);
            }];
            break;
        }
        default: {
            NSAssert1(NO, @"%s:type类型不正确", __func__);
            break;
        }
    }
}
@end
