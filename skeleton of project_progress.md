lib/
│
├── main.dart
├── skeleton.md
│
├── app_1/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_dimens.dart
│   │   │   └── app_strings.dart
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── text_styles.dart
│   │   │
│   │   ├── utils/
│   │   │   ├── responsive_util.dart
│   │   │   └── validators.dart
│   │   │
│   │   └── widgets/
│   │       ├── glass_card.dart
│   │       ├── glass_input_field.dart
│   │       ├── primary_button.dart
│   │       └── social_button.dart
│   │
│   └── features/
│       └── onboarding/
│           ├── animations/
│           │   └── stagger_animation.dart
│           │
│           ├── screens/
│           │   ├── feature_intro_screen.dart
│           │   ├── sign_up_screen.dart
│           │   └── welcome_screen.dart
│           │
│           └── widgets/
│               ├── feature_card.dart
│               └── progress_indicator.dart
│
├── app_2/
│   ├── app_router.dart
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_sizes.dart
│   │   │   ├── app_strings.dart
│   │   │   ├── url_cosntants.dart
│   │   │   └── url_cosntants.tsx
│   │   │
│   │   ├── services/
│   │   │   ├── api_auth_provider.dart
│   │   │   ├── api_service.dart
│   │   │   └── get_auth.dart
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── text_styles.dart
│   │   │
│   │   ├── utils/
│   │   │   ├── haptic_helper.dart
│   │   │   └── responsive.dart
│   │   │
│   │   └── widgets/
│   │       ├── animated_orbs.dart
│   │       ├── custom_text_Field.dart
│   │       ├── dashboard_shell.dart
│   │       ├── glass_card.dart
│   │       ├── grain_overlay.dart
│   │       ├── insured_button.dart
│   │       ├── page_dots.dart
│   │       └── profile_avatar.dart
│   │
│   ├── data/
│   │   ├── local/
│   │   │   └── json_helper.dart
│   │   │
│   │   ├── models/
│   │   │   ├── client_model.dart
│   │   │   └── quote_model.dart
│   │   │
│   │   └── repositories/
│   │       ├── client_repository.dart
│   │       └── quote_repository.dart
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── otp_screen.dart
│   │   │   ├── sign_up_screen.dart
│   │   │   └── widgets/
│   │   │       └── auth_glass_form.dart
│   │   │
│   │   ├── clients/
│   │   │   ├── add_client_screen.dart
│   │   │   ├── add_client_screen_GEM.dart
│   │   │   ├── add_client_screen_GRO.dart
│   │   │   ├── client_detail_screen.dart
│   │   │   └── clients_screen.dart
│   │   │
│   │   ├── dashboard/
│   │   │   ├── dashboard_desktop.dart
│   │   │   ├── dashboard_mobile.dart
│   │   │   ├── dashboard_screen.dart
│   │   │   └── widgets/
│   │   │       ├── client_card.dart
│   │   │       ├── dashboard_header.dart
│   │   │       ├── hamburger_drawer.dart
│   │   │       ├── quick_actions_row.dart
│   │   │       ├── sidebar.dart
│   │   │       ├── status_badge.dart
│   │   │       ├── summary_stat_card.dart
│   │   │       └── top_header.dart
│   │   │
│   │   ├── onboarding/
│   │   │   ├── onboarding_page_model.dart
│   │   │   ├── onboarding_screen.dart
│   │   │   └── widgets/
│   │   │       └── three_d_model_viewer.dart
│   │   │
│   │   ├── production/
│   │   │   └── production_screen.dart
│   │   │
│   │   ├── profile/
│   │   │   └── profile_screen.dart
│   │   │
│   │   ├── quotes/
│   │   │   ├── quote_detail_screen.dart
│   │   │   └── quotes_screen.dart
│   │   │
│   │   ├── renewals/
│   │   │   └── renewals_screen.dart
│   │   │
│   │   ├── settings/
│   │   │   └── settings_screen.dart
│   │   │
│   │   └── statement/
│   │       └── statement_screen.dart
│   │
│   └── providers/
│       ├── auth_provider.dart
│       ├── client_provider.dart
│       ├── client_view_provider.dart
│       ├── quote_provider.dart
│       └── settings_provider.dart