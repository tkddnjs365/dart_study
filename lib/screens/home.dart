import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:study_flutter/screens/calculator.dart';

// 앱 테마 설정
class AppTheme {
  // Primary Colors (브랜드 컬러)
  static const Color primaryColor = Color(0xFF6366F1); // 인디고
  static const Color primaryDark = Color(0xFF4F46E5); // 진한 인디고
  static const Color primaryLight = Color(0xFF818CF8); // 연한 인디고

  // Secondary Colors
  static const Color secondaryColor = Color(0xFF06B6D4); // 시안
  static const Color accentColor = Color(0xFFF59E0B); // 앰버

  // Neutral Colors
  static const Color backgroundColor = Color(0xFFFAFAFA); // 배경
  static const Color surfaceColor = Colors.white; // 카드
  static const Color textPrimary = Color(0xFF1F2937); // 진한 텍스트
  static const Color textSecondary = Color(0xFF6B7280); // 연한 텍스트

  // Status Colors
  static const Color successColor = Color(0xFF10B981); // 성공
  static const Color errorColor = Color(0xFFEF4444); // 에러
  static const Color warningColor = Color(0xFFF59E0B); // 경고
}

class AppTypography {
  // Font Sizes
  static const double displayLarge = 32.0; // 메인 타이틀
  static const double displayMedium = 28.0; // 서브 타이틀
  static const double headlineLarge = 24.0; // 헤드라인
  static const double headlineMedium = 20.0; // 서브 헤드라인
  static const double bodyLarge = 16.0; // 본문
  static const double bodyMedium = 14.0; // 작은 본문
  static const double labelLarge = 14.0; // 버튼 텍스트
  static const double labelMedium = 12.0; // 캡션
}

class AppSpacing {
  // Padding & Margin
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
}

// OnBoarding 데이터 모델
class OnBoardingData {
  final String title;
  final String body;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final List<String>? features; // 특징 목록 추가

  const OnBoardingData({
    required this.title,
    required this.body,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.features,
  });
}

// OnBoarding 콘텐츠
class OnBoardingContent {
  static const List<OnBoardingData> data = [
    OnBoardingData(
      title: 'Flutter Study',
      body: 'Flutter Study 용 OnBoarding Content입니다.',
      icon: Icons.flutter_dash,
      iconColor: AppTheme.primaryColor,
      backgroundColor: AppTheme.backgroundColor,
      features: ['feature 1번', 'feature 2번'],
    ),
    OnBoardingData(
      title: '계산기',
      body: '첫 화면은 계산기 입니다.',
      icon: Icons.calculate_rounded,
      iconColor: AppTheme.secondaryColor,
      backgroundColor: AppTheme.backgroundColor,
      features: ['단순 계산 기능'],
    ),
    OnBoardingData(
      title: '시작',
      body: 'Start',
      icon: Icons.start,
      iconColor: AppTheme.accentColor,
      backgroundColor: AppTheme.backgroundColor,
    ),
  ];
}

// Home Widget
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: OnBoardingPage()));
  }
}

// OnBoarding Page Widget
class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: IntroductionScreen(
        pages: _buildPages(),
        showDoneButton: true,
        showNextButton: true,
        showSkipButton: true,
        skip: _buildSkipButton(),
        next: _buildNextButton(),
        done: _buildDoneButton(),
        onDone: () => _navigateToCalculator(context),
        onSkip: () => _navigateToCalculator(context),
        dotsDecorator: _buildDotsDecorator(),
        globalBackgroundColor: AppTheme.backgroundColor,
        animationDuration: 350,
        curve: Curves.easeInOut,
      ),
    );
  }

  // 페이지 빌더
  List<PageViewModel> _buildPages() {
    return OnBoardingContent.data
        .map(
          (data) => PageViewModel(
            titleWidget: _buildTitleWidget(data.title),
            bodyWidget: _buildBodyWidget(data),
            image: _buildImageWidget(data),
            decoration: _buildPageDecoration(),
          ),
        )
        .toList();
  }

  // 제목 위젯 설정
  Widget _buildTitleWidget(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: AppTypography.displayMedium,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // 커스텀 바디 위젯 (특징 목록 포함)
  Widget _buildBodyWidget(OnBoardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          Text(
            data.body,
            style: const TextStyle(
              fontSize: AppTypography.bodyLarge,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          if (data.features != null) ...[
            const SizedBox(height: AppSpacing.lg),
            _buildFeaturesList(data.features!),
          ],
        ],
      ),
    );
  }

  // 특징 목록 위젯 설정
  Widget _buildFeaturesList(List<String> features) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: features
            .map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      feature,
                      style: const TextStyle(
                        fontSize: AppTypography.bodyMedium,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // 이미지 위젯 설정 (아이콘 포함)
  Widget _buildImageWidget(OnBoardingData data) {
    return Container(
      width: 200,
      height: 200,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            data.iconColor.withOpacity(0.1),
            data.iconColor.withOpacity(0.05),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: data.iconColor.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(data.icon, size: 80, color: data.iconColor),
    );
  }

  // 스킵 버튼
  Widget _buildSkipButton() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppTheme.textSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: const Text(
        'Skip',
        style: TextStyle(
          fontSize: AppTypography.labelLarge,
          color: AppTheme.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // 다음 버튼
  Widget _buildNextButton() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryDark],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
    );
  }

  // 완료 버튼
  Widget _buildDoneButton() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryDark],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Text(
        'start',
        style: TextStyle(
          fontSize: AppTypography.labelLarge,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 점 데코레이터
  DotsDecorator _buildDotsDecorator() {
    return DotsDecorator(
      color: AppTheme.textSecondary.withOpacity(0.3),
      activeColor: AppTheme.primaryColor,
      size: const Size(10, 10),
      activeSize: const Size(24, 10),
      spacing: const EdgeInsets.symmetric(horizontal: 4),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  // 페이지 데코레이션
  PageDecoration _buildPageDecoration() {
    return const PageDecoration(
      pageColor: AppTheme.backgroundColor,
      imagePadding: EdgeInsets.only(top: AppSpacing.xxxl),
      contentMargin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
    );
  }

  // 네비게이션
  void _navigateToCalculator(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const CalculatorScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }
}
