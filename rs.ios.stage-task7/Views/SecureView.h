//
//  SecureView.h
//  rs.ios.stage-task7
//
//  Created by Vladislav Slizhevsky on 7/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SecureViewDelegate <NSObject>

-(void)passcodeValidHandler;

@end

@interface SecureView : UIView

@property (nonatomic, strong) NSArray<NSNumber *> *items;
@property (nonatomic, weak) id <SecureViewDelegate> delegate;

-(instancetype)initWithItems:(NSArray<NSNumber *>*) items andPasscode:(NSString *) passcode;
-(void) reset;

@end

NS_ASSUME_NONNULL_END
