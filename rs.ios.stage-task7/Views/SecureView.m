//
//  SecureView.m
//  rs.ios.stage-task7
//
//  Created by Vladislav Slizhevsky on 7/3/21.
//

#import "SecureView.h"
#import "UIButton+SetBackgroundColor.h"

typedef NS_ENUM(NSUInteger, SecureViewStatus) {
    ready,
    error,
    success
};

@interface SecureView ()

@property (nonatomic, strong)NSString* passcode;
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, assign)SecureViewStatus currentStatus;

@end

@implementation SecureView

- (instancetype)initWithItems:(NSArray<NSNumber *> *)items andPasscode:(NSString *)passcode {
    self = [super init];
    if (self) {
        self.items = items;
        self.passcode = passcode;
        self.currentStatus = ready;
    }
    
    [self layoutView];
    
    [self addObserver:self forKeyPath:@"currentStatus" options:NSKeyValueObservingOptionNew context:nil];
    
    return self;
}

-(void)layoutView {
    // MARK: UI Setup
    // Container which will place result field and items
    UIStackView *containerStackView = [[UIStackView alloc] init];
    containerStackView.axis = UILayoutConstraintAxisVertical;
    containerStackView.distribution = UIStackViewDistributionFillEqually;
    
    // Result Field configuration
    self.textView = [[UITextView alloc] init];
    [self.textView setFont:[UIFont fontWithName:@"SF Pro Text" size:18]];
    [self.textView setText:@"_"];
    [self.textView setTextAlignment:NSTextAlignmentCenter];
    self.textView.editable = NO;
    self.textView.selectable = NO;
    [self.textView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];

    // Items configuration
    UIStackView *itemsStackView = [[UIStackView alloc] init];
    itemsStackView.spacing = 20;
    for (NSNumber *item in self.items) {
        UIButton *button = [UIButton new];
        [button setTitle:[item stringValue] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorNamed:@"LightBlue"] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor colorNamed:@"LightBlue"].CGColor;
        button.layer.borderWidth = 1.5;
        button.layer.cornerRadius = 25;
        button.titleLabel.font = [UIFont fontWithName:@"SF Pro Text" size:24];
        [button setBackgroundColor:[[UIColor colorNamed:@"LightBlue"] colorWithAlphaComponent:0.2] forState:UIControlStateHighlighted];
        button.layer.masksToBounds = YES;
        
        [button addTarget:self action:@selector(handleSecureInput:) forControlEvents:UIControlEventTouchUpInside];
        
        [itemsStackView addArrangedSubview:button];
        
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button.widthAnchor constraintEqualToConstant:50].active = YES;
        [button.heightAnchor constraintEqualToConstant:50].active = YES;
    }
    
    
    [containerStackView addArrangedSubview:self.textView];
    [containerStackView addArrangedSubview:itemsStackView];
    
    [self addSubview:containerStackView];
    
    self.layer.cornerRadius = 10;
    
    self.hidden = YES;
    
    // MARK: Constraints
    self.translatesAutoresizingMaskIntoConstraints = NO;
    itemsStackView.translatesAutoresizingMaskIntoConstraints = NO;
    containerStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [containerStackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [containerStackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.textView.widthAnchor constraintEqualToAnchor:containerStackView.widthAnchor],
        [self.widthAnchor constraintEqualToAnchor:containerStackView.widthAnchor constant: 46],
        [self.heightAnchor constraintEqualToAnchor:containerStackView.heightAnchor constant:30]
    ]];
}

-(void)handleSecureInput:(UIButton *)sender {
    NSString *textViewValue = self.textView.text;
    
    if (textViewValue.length < 3) {
        self.currentStatus = ready;
        NSString *num = sender.currentTitle;
        [self.textView setText: [textViewValue containsString:@"_"]
                                ? num
                                : [textViewValue stringByAppendingString:num]];
    }
};

-(void)validateSecureInput:(NSString *)input {
    BOOL isInputValid = [input isEqualToString:self.passcode];
    
    if (!isInputValid) {
        self.currentStatus = error;
        [self.textView setText: @"_"];
        
        return;
    }
    
    [self.delegate passcodeValidHandler];
    self.currentStatus = success;
    
}

-(void) reset {
    self.hidden = YES;
    self.currentStatus = ready;
    self.textView.text = @"_";
}

// MARK: Text view 'text' observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    id newValue = change[@"new"];
    
    if ([keyPath isEqualToString:@"currentStatus"]) {
        switch ([newValue integerValue]) {
            case ready:
                self.layer.borderWidth = 0;
                break;
            case error:
                self.layer.borderColor = [UIColor colorNamed:@"VenetianRed"].CGColor;
                self.layer.borderWidth = 2;
                break;
            case success:
                self.layer.borderColor = [UIColor colorNamed:@"TurquoiseGreen"].CGColor;
                self.layer.borderWidth = 2;
                break;
        }
        
        return;
    }
    
    
    // keyPath == @"text"
    NSString *textFieldNewValue = [NSString stringWithFormat:@"%@", newValue];
    
    if (textFieldNewValue.length == 3) {
        [self validateSecureInput:textFieldNewValue];
    }
}

@end
