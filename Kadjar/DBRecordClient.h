//
//  DBRecordClient.h
//  Kadjar
//
//  Created by Cesar Jacquet on 03/09/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBRecordClient : NSObject

@property NSInteger clientInfoID;
@property (strong, nonatomic) NSString * nom;
@property (strong, nonatomic) NSString * prenom;
@property (strong, nonatomic) NSString * email;
@property (strong, nonatomic) NSString * gsm;
@property (strong, nonatomic) NSString * gameCode;
@property (strong, nonatomic) NSString * prize;

-(id) initWithObject:(NSArray *)obj;

@end
