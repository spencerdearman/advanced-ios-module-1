//
//  SettingsViewController.m
//  Storybook
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (nonatomic, strong) UISwitch *autoPlaySwitch;
@property (nonatomic, strong) UISwitch *tapToPlaySwitch;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    [self setupUI];
    [self loadPreferences];
}

- (void)setupUI {
    // --- Auto-Play Row ---
    UILabel *autoPlayLabel = [[UILabel alloc] init];
    autoPlayLabel.text = @"Auto-Play on Page Load";
    autoPlayLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    autoPlayLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [autoPlayLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

    self.autoPlaySwitch = [[UISwitch alloc] init];
    self.autoPlaySwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.autoPlaySwitch addTarget:self
                            action:@selector(autoPlayToggled:)
                  forControlEvents:UIControlEventValueChanged];

    UIStackView *autoPlayRow = [[UIStackView alloc] initWithArrangedSubviews:@[autoPlayLabel, self.autoPlaySwitch]];
    autoPlayRow.axis = UILayoutConstraintAxisHorizontal;
    autoPlayRow.alignment = UIStackViewAlignmentCenter;
    autoPlayRow.spacing = 12;
    autoPlayRow.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *autoPlayDesc = [[UILabel alloc] init];
    autoPlayDesc.text = @"Automatically read aloud when each page is displayed.";
    autoPlayDesc.font = [UIFont systemFontOfSize:13];
    autoPlayDesc.textColor = [UIColor secondaryLabelColor];
    autoPlayDesc.numberOfLines = 0;
    autoPlayDesc.translatesAutoresizingMaskIntoConstraints = NO;

    // --- Tap-to-Play Row ---
    UILabel *tapToPlayLabel = [[UILabel alloc] init];
    tapToPlayLabel.text = @"Tap-to-Play Button";
    tapToPlayLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    tapToPlayLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [tapToPlayLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

    self.tapToPlaySwitch = [[UISwitch alloc] init];
    self.tapToPlaySwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tapToPlaySwitch addTarget:self
                             action:@selector(tapToPlayToggled:)
                   forControlEvents:UIControlEventValueChanged];

    UIStackView *tapToPlayRow = [[UIStackView alloc] initWithArrangedSubviews:@[tapToPlayLabel, self.tapToPlaySwitch]];
    tapToPlayRow.axis = UILayoutConstraintAxisHorizontal;
    tapToPlayRow.alignment = UIStackViewAlignmentCenter;
    tapToPlayRow.spacing = 12;
    tapToPlayRow.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *tapToPlayDesc = [[UILabel alloc] init];
    tapToPlayDesc.text = @"Show a button on each page to trigger read-aloud manually.";
    tapToPlayDesc.font = [UIFont systemFontOfSize:13];
    tapToPlayDesc.textColor = [UIColor secondaryLabelColor];
    tapToPlayDesc.numberOfLines = 0;
    tapToPlayDesc.translatesAutoresizingMaskIntoConstraints = NO;

    // --- Separator ---
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor separatorColor];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat scale = self.traitCollection.displayScale;
    [separator.heightAnchor constraintEqualToConstant:1.0 / (scale > 0 ? scale : 1.0)].active = YES;

    // --- Note Label ---
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.text = @"Both options can be enabled at the same time. Changes take effect on the next page displayed.";
    noteLabel.font = [UIFont italicSystemFontOfSize:13];
    noteLabel.textColor = [UIColor tertiaryLabelColor];
    noteLabel.numberOfLines = 0;
    noteLabel.translatesAutoresizingMaskIntoConstraints = NO;

    // --- Main Stack ---
    UIStackView *mainStack = [[UIStackView alloc] initWithArrangedSubviews:@[
        autoPlayRow, autoPlayDesc,
        separator,
        tapToPlayRow, tapToPlayDesc,
        noteLabel
    ]];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 16;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:mainStack];

    [NSLayoutConstraint activateConstraints:@[
        [mainStack.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:30],
        [mainStack.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [mainStack.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20]
    ]];
}

- (void)loadPreferences {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.autoPlaySwitch.on = [defaults boolForKey:@"autoPlayEnabled"];
    self.tapToPlaySwitch.on = [defaults boolForKey:@"tapToPlayEnabled"];
}

- (void)autoPlayToggled:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"autoPlayEnabled"];
}

- (void)tapToPlayToggled:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"tapToPlayEnabled"];
}

@end
