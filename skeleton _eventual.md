insured/
├── android/
├── ios/
├── web/
├── assets/
│   ├── models/
│   │   └── padlock_closed.glb          # 3D model (place your .glb file here)
│   ├── data/
│   │   └── data.json                    # Mock clients & quotes
│   └── fonts/                            # (optional custom fonts)
├── lib/
│   ├── main.dart
│   ├── app_router.dart
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart
│   │   │   └── app_sizes.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── text_styles.dart
│   │   ├── utils/
│   │   │   ├── responsive.dart
│   │   │   └── haptic_helper.dart
│   │   └── widgets/                      # truly global widgets
│   │       ├── insured_button.dart
│   │       ├── glass_card.dart
│   │       ├── animated_orbs.dart
│   │       ├── grain_overlay.dart
│   │       └── page_dots.dart
│   ├── data/
│   │   ├── local/
│   │   │   └── json_helper.dart
│   │   ├── models/
│   │   │   ├── client_model.dart
│   │   │   └── quote_model.dart
│   │   └── repositories/
│   │       ├── client_repository.dart
│   │       └── quote_repository.dart
│   ├── features/
│   │   ├── onboarding/
│   │   │   ├── onboarding_screen.dart
│   │   │   ├── onboarding_page_model.dart
│   │   │   └── widgets/
│   │   │       └── three_d_model_viewer.dart
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── widgets/
│   │   │       └── auth_glass_form.dart
│   │   ├── dashboard/
│   │   │   ├── dashboard_screen.dart
│   │   │   ├── dashboard_desktop.dart
│   │   │   ├── dashboard_mobile.dart
│   │   │   └── widgets/
│   │   │       ├── sidebar.dart
│   │   │       ├── hamburger_drawer.dart
│   │   │       ├── top_header.dart
│   │   │       ├── quick_actions_row.dart
│   │   │       ├── summary_stat_card.dart
│   │   │       ├── client_card.dart
│   │   │       └── status_badge.dart
│   │   ├── clients/
│   │   │   ├── clients_screen.dart
│   │   │   └── client_detail_screen.dart
│   │   └── quotes/
│   │       ├── quotes_screen.dart
│   │       └── quote_detail_screen.dart
│   └── providers/
│       ├── client_provider.dart
│       ├── quote_provider.dart
│       └── auth_provider.dart
├── pubspec.yaml
└── README.md