import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:study_flutter/screens/calculator.dart';

class OnBoardingConstants {
  // Size
  static const double titleFontSize = 28.0;
  static const double bodyFontSize = 18.0;
  static const double dotSize = 10.0;
  static const double activeDotWidth = 22.0;
  static const double imagePaddingTop = 40.0;
  static const double borderRadius = 24.0;

  // Colors
  static const Color pageBackgroundColor = Colors.orange;
  static const Color dotColor = Colors.cyan;
  static const Color activeDotColor = Colors.red;
  static const Color bodyTextColor = Colors.black;

  // Texts
  static const String firstPageTitle = 'My App';
  static const String firstPageBody =
      'Introduction 테스트용 첫번째 페이지입니다.\n'
      '두번째 줄입니다.';
  static const String secondPageBody = '두번째 테스트화면 입니다.';
  static const String doneText = 'Done';
  static const String skipText = 'Skip';
}

// OnBoarding 데이터 모델
class OnBoardingData {
  final String title;
  final String body;
  final String? imagePath;

  const OnBoardingData({
    required this.title,
    required this.body,
    this.imagePath,
  });
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
class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  // OnBoarding 데이터 생성
  static const List<OnBoardingData> _onBoardingData = [
    OnBoardingData(
      title: OnBoardingConstants.firstPageTitle,
      body: OnBoardingConstants.firstPageBody,
    ),
    OnBoardingData(title: '', body: OnBoardingConstants.secondPageBody),
  ];

  // 페이지 생성
  List<PageViewModel> _buildPages() {
    return _onBoardingData
        .map(
          (data) => PageViewModel(
            title: data.title,
            body: data.body,
            image: data.imagePath != null
                ? Image.asset(data.imagePath!, height: 200)
                : null,
            decoration: OnBoardingStyles.getPageDecoration(),
          ),
        )
        .toList();
  }

  // 네비게이션 생성
  void _navigateToCalculator(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CalculatorScreen()),
    );
  }

  // Dots Decorator
  DotsDecorator _buildDotsDecorator() {
    return const DotsDecorator(
      color: OnBoardingConstants.dotColor,
      size: Size(OnBoardingConstants.dotSize, OnBoardingConstants.dotSize),
      activeSize: Size(
        OnBoardingConstants.activeDotWidth,
        OnBoardingConstants.dotSize,
      ),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(OnBoardingConstants.borderRadius),
        ),
      ),
      activeColor: OnBoardingConstants.activeDotColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: _buildPages(),
      done: const Text(OnBoardingConstants.doneText),
      onDone: () => _navigateToCalculator(context),
      next: const Icon(Icons.arrow_forward),
      showSkipButton: true,
      skip: const Text(OnBoardingConstants.skipText),
      onSkip: () => _navigateToCalculator(context),
      dotsDecorator: _buildDotsDecorator(),
      globalBackgroundColor: OnBoardingConstants.pageBackgroundColor,
    );
  }
}

// OnBoarding 스타일 클래스
class OnBoardingStyles {
  static PageDecoration getPageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: OnBoardingConstants.titleFontSize,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: TextStyle(
        fontSize: OnBoardingConstants.bodyFontSize,
        color: OnBoardingConstants.bodyTextColor,
      ),
      imagePadding: EdgeInsets.only(top: OnBoardingConstants.imagePaddingTop),
      pageColor: OnBoardingConstants.pageBackgroundColor,
    );
  }
}
