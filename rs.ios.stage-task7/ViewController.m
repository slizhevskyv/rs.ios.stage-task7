//
//  ViewController.m
//  rs.ios.stage-task7
//
//  Created by Vladislav Slizhevsky on 7/3/21.
//

#import "ViewController.h"
#import "FormTextField.h"
#import "UIButton+SetBackgroundColor.h"
#import "SecureView.h"
#import "Credentials.h"

@interface ViewController() <UITextFieldDelegate, SecureViewDelegate>

@property (nonatomic, strong) FormTextField *loginTextField;
@property (nonatomic, strong) FormTextField *passwordTextField;
@property (nonatomic, strong) UIButton *authButton;
@property (nonatomic, strong) SecureView *secureView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupAuthorizationForm];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)setupAuthorizationForm {
    // MARK: UI Setup
    // RSSchool logo
    UILabel *logo = [[UILabel alloc] init];
    NSAttributedString *logoText = [[NSAttributedString alloc] initWithString:@"RSSchool" attributes:@{
        NSFontAttributeName: [UIFont fontWithName:@"SFProDisplay-Bold" size:36.0],
    }];
    [logo setAttributedText:logoText];
    [logo setTextAlignment:NSTextAlignmentCenter];
    [logo setNumberOfLines:1];
    
    // Form text fields
    self.loginTextField = [self createFormTextFieldWithPlaceholder:@"Login"];
    [self.loginTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.passwordTextField = [self createFormTextFieldWithPlaceholder:@"Password"];
    self.passwordTextField.secureTextEntry = YES;
    
    self.loginTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    // Authorize button
    self.authButton = [[UIButton alloc] init];
    self.authButton.layer.borderColor = [UIColor colorNamed:@"LightBlue"].CGColor;
    self.authButton.layer.borderWidth = 2;
    self.authButton.layer.cornerRadius = 10;
    self.authButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    self.authButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.authButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    self.authButton.titleLabel.font = [UIFont fontWithName:@"SF Pro Text" size:20];
    // to crop background image for highlighted state
    self.authButton.layer.masksToBounds = YES;
    
    [self.authButton setTitle:@"Authorize" forState:UIControlStateNormal];
    [self.authButton setTitleColor:[UIColor colorNamed:@"LightBlue"] forState:UIControlStateNormal];
    [self.authButton setImage:[UIImage imageNamed:@"person"] forState:UIControlStateNormal];
    
    [self.authButton setImage:[UIImage imageNamed:@"person-filled"] forState:UIControlStateHighlighted];
    [self.authButton setTitleColor:[[UIColor colorNamed:@"LightBlue"] colorWithAlphaComponent:0.4] forState:UIControlStateHighlighted];
    [self.authButton setBackgroundColor:[[UIColor colorNamed:@"LightBlue"] colorWithAlphaComponent:0.2] forState:UIControlStateHighlighted];
    [self.authButton setTitleColor:[[UIColor colorNamed:@"LightBlue"] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];

    [self.authButton addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
    [self.authButton addTarget:self action:@selector(handleAuthorization:) forControlEvents:UIControlEventTouchUpInside];
    
    // Secure View
    self.secureView = [[SecureView alloc] initWithItems:@[@1, @2, @3] andPasscode:CredentialsPasscode];
    self.secureView.delegate = self;
    
    // Add UI items
    [self.view addSubview:logo];
    [self.view addSubview:self.loginTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.authButton];
    [self.view addSubview:self.secureView];
    
    
    // MARK: Constraints
    // Logo
    logo.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [logo.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:80],
        [logo.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [logo.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
    
    // Text Fields
    self.loginTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.loginTextField.topAnchor constraintEqualToAnchor:logo.bottomAnchor constant:80],
        [self.loginTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:36],
        [self.loginTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-36],
        [self.passwordTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:36],
        [self.passwordTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-36],
        [self.passwordTextField.topAnchor constraintEqualToAnchor:self.loginTextField.bottomAnchor constant:30],
        [self.loginTextField.heightAnchor constraintEqualToConstant:30],
        [self.passwordTextField.heightAnchor constraintEqualToConstant:30],
    ]];
    
    // Authorize button
    self.authButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.authButton.topAnchor constraintEqualToAnchor:self.passwordTextField.bottomAnchor constant:60],
        [self.authButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-110],
        [self.authButton.heightAnchor constraintEqualToConstant:42],
        [self.authButton.widthAnchor constraintEqualToConstant:156],
    ]];
    
    // Secure view
    [NSLayoutConstraint activateConstraints:@[
        [self.secureView.topAnchor constraintEqualToAnchor:self.authButton.bottomAnchor constant:67],
        [self.secureView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.secureView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-50],
    ]];
}

- (FormTextField *)createFormTextFieldWithPlaceholder:(NSString *)placeholder {
    FormTextField *textField = [[FormTextField alloc] init];
    [textField setPlaceholder:placeholder];
    textField.layer.borderWidth = 1.5;
    textField.layer.borderColor = [UIColor colorNamed:@"CoralBlack"].CGColor;
    textField.layer.cornerRadius = 5;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{
        NSFontAttributeName: [UIFont fontWithName:@"SFProDisplay-Regular" size:16]
    }];
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    return textField;
}

- (void)handleAuthorization:(UIButton *)sender {
    NSString *loginValue = self.loginTextField.text;
    NSString *passwordValue = self.passwordTextField.text;
    
    [self validateFormWith:loginValue and:passwordValue];
    
}

-(void)validateFormWith:(NSString *)loginValue and:(NSString *)passwordValue {
    BOOL isLoginValueValid = [loginValue isEqualToString:CredentialsLogin];
    BOOL isPasswordValueValid = [passwordValue isEqualToString:CredentialsPassword];
    
    CGColorRef errorBorderColor = [UIColor colorNamed:@"VenetianRed"].CGColor;
    CGColorRef successBorderColor = [UIColor colorNamed:@"TurquoiseGreen"].CGColor;
    
    if (!isLoginValueValid) {
        self.loginTextField.layer.borderColor = errorBorderColor;
    } else {
        self.loginTextField.layer.borderColor = successBorderColor;
    }
    
    if (!isPasswordValueValid) {
        self.passwordTextField.layer.borderColor = errorBorderColor;
    } else {
        self.passwordTextField.layer.borderColor = successBorderColor;
    }
    
    if (isLoginValueValid && isPasswordValueValid) {
        self.loginTextField.enabled = NO;
        self.passwordTextField.enabled = NO;
        self.authButton.enabled = NO;
        
        self.secureView.hidden = NO;
    }
    
}

-(void)reset {
    self.loginTextField.layer.borderColor = [UIColor colorNamed:@"CoralBlack"].CGColor;
    self.loginTextField.text = @"";
    self.loginTextField.enabled = YES;
    
    self.passwordTextField.layer.borderColor = [UIColor colorNamed:@"CoralBlack"].CGColor;
    self.passwordTextField.text = @"";
    self.passwordTextField.enabled = YES;
    
    self.authButton.enabled = YES;
    
    [self.secureView reset];
}


// MARK: UITextFieldDelegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    textField.layer.borderColor = [UIColor colorNamed:@"CoralBlack"].CGColor;
    
    if (textField == self.loginTextField) {
        NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z0-9]*$" options:0 error:nil];
        NSUInteger numberOFMatches = [regExp numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];

        return numberOFMatches;
    }
    
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (CGColorEqualToColor(textField.layer.borderColor, [UIColor colorNamed:@"VenetianRed"].CGColor)) {
        textField.text = @"";
        textField.layer.borderColor = [UIColor colorNamed:@"CoralBlack"].CGColor;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


// MARK: SecureViewDelegate method
- (void)passcodeValidHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Welcome" message:@"You are successfuly authorized!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *refreshAction = [UIAlertAction actionWithTitle:@"Refresh" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self reset];
    }];
    [alert addAction:refreshAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// MARK: Dismiss keyboard handler
-(void)dismissKeyboard {
    [self.loginTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

// MARK: Observer for button to setup appropriate color when it becomes disabled
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIButton *)button change:(NSDictionary *)change context:(void *)context
{
    if (![change[@"new"] boolValue]) {
        button.layer.borderColor = [[UIColor colorNamed:@"LightBlue"] colorWithAlphaComponent:0.5].CGColor;
    }
}
@end
