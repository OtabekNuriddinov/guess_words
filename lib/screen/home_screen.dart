import 'package:flutter/material.dart';
import 'package:guess_words/core/theme/dimens.dart';
import 'package:guess_words/core/theme/icons.dart';
import 'package:guess_words/core/theme/strings.dart';
import 'package:guess_words/core/theme/text_styles.dart';
import 'package:guess_words/core/widgets/my_container.dart';
import 'package:guess_words/models/charade.dart';
import 'package:guess_words/services/app_service.dart';
import '../core/widgets/my_wrap.dart';
import '/core/theme/colors.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int level = 1;
  late AppService appService;
  int sanoq = 0;
  late List<GameData> questions;
  late Future<void> _dataFuture;
  GameData? currentQuestion;
  String animationPath = "assets/animation/well_anim.json";

  bool isChecked = false;
  List<String?> placedLetters = [];
  List<String> leftLetters = [];
  List<String> rightLetters = [];
  List<Color> leftSpaceColors = [];
  List<Color> rightSpaceColors = [];
  List<Color> middleSpaceColors = [];
  List originalList = [];

  @override
  void initState() {
    super.initState();
    appService = AppService();
    _dataFuture = _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _appBar(),
      floatingActionButton: _floatingActionButton(),
      body: FutureBuilder<void>(
          future: _dataFuture,
          builder: (context, _) {
            if (appService.items.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            List<String> letters = currentQuestion!.letters;
            List<String> dragLetters = currentQuestion!.word.split("");
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  _imageRow(),
                  SizedBox(height: 30),
                  _descriptionContainer(),
                  _optionsContainer(
                    dragLetters,
                    currentQuestion!.word,
                    AppService.getColorFromInt(currentQuestion!.left.color),
                    AppService.getColorFromInt(currentQuestion!.right.color),
                  ),
                  SizedBox(height: 30),
                  MyWrap(letters: letters),
                ],
              ),
            );
          }),
    );
  }

  Widget _imageRow() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: MyContainer(
              image: currentQuestion!.left.imageUrl,
              color: currentQuestion!.left.color,
              letters: leftLetters,
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: MyContainer(
              image: currentQuestion!.right.imageUrl,
              color: currentQuestion!.right.color,
              letters: rightLetters,
            ),
          )
        ],
      ),
    );
  }

  Container _optionsContainer(List<String> dragLetters, String word,
      Color currentLeft, Color currentRight) {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 15,
            offset: Offset(10, 8),
          ),
        ],
        border: Border(
          bottom: BorderSide(color: Color(0xFF5A6E82), width: 3),
        ),
        color: Color(0xFF8296AA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(dragLetters.length, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: DragTarget<String>(onAcceptWithDetails: (details) {
              setState(() {
                placedLetters[index] = details.data;
                if (placedLetters.join("") == word) {
                  isChecked = true;
                }
              });
            }, onWillAcceptWithDetails: (details) {
              return !placedLetters.contains(details.data);
            }, builder: (context, candidateData, rejectedData) {
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: (index >= leftSpaceColors.length &&
                          index <
                              leftSpaceColors.length + middleSpaceColors.length)
                      ? LinearGradient(
                          colors: [currentLeft, currentRight],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)
                      : null,
                  color: originalList[index],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(children: [
                  Center(
                    child: Text(
                      placedLetters[index] ?? "",
                      style: AppTextStyles.cube,
                    ),
                  ),
                  if (isChecked)
                    Align(
                      alignment: Alignment(0, -0.3),
                      child: SizedBox(
                        width: AppDimens.d310,
                        height: AppDimens.d170,
                        child: Lottie.asset(animationPath, fit: BoxFit.cover),
                      ),
                    )
                ]),
              );
            }),
          );
        }),
      ),
    );
  }

  Container _descriptionContainer() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 15,
            offset: Offset(10, 8),
          ),
        ],
        border: Border(bottom: BorderSide(color: Color(0xFF5A6E82), width: 3)),
        borderRadius: AppDimens.v105,
        color: Color(0xFF8296AA),
      ),
      child: Center(
        child: Text(currentQuestion!.description, style: AppTextStyles.clue),
      ),
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      onPressed: nextQuestion,
      child: Icon(Icons.arrow_forward),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      leading: Padding(
        padding: const EdgeInsets.only(top: 10, left: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppStrings.level, style: AppTextStyles.level),
            Text(level.toString(), style: AppTextStyles.levelCount),
          ],
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 120),
        child: Container(
          width: 130,
          height: 32,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade300),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.monetization_on, color: AppColors.yellow800),
                SizedBox(width: 20),
                Text(currentQuestion?.coin.toString() ?? "0")
              ],
            ),
          ),
        ),
      ),
      actions: [IconButton(onPressed: () {}, icon: AppIcons.menu)],
    );
  }



  Future<void> _loadData() async {
    await appService.initialize();
    if (appService.items.isNotEmpty) {
      setState(() {
        currentQuestion = appService.items.first;
        _initializeLetters();
      });
    }
  }

  void _initializeLetters() {
    if (currentQuestion == null) return;
    leftLetters = currentQuestion!.left.name.split("");
    rightLetters = currentQuestion!.right.name.split("");

    leftSpaceColors = List.generate(currentQuestion!.leftLetter,
            (index) => AppService.getColorFromInt(currentQuestion!.left.color));
    rightSpaceColors = List.generate(currentQuestion!.rightLetter,
            (index) => AppService.getColorFromInt(currentQuestion!.right.color));

    middleSpaceColors = List.generate(
        currentQuestion!.middleLetter, (index) => AppColors.white);

    originalList = [
      ...leftSpaceColors,
      ...middleSpaceColors,
      ...rightSpaceColors
    ];
    placedLetters = List.filled(originalList.length, null);
  }

  void nextQuestion() {
    setState(() {
      if (sanoq < appService.items.length - 1) {
        sanoq++;
        level++;
        currentQuestion = appService.items[sanoq];
        _initializeLetters();
        isChecked = false;
      }
    });
  }

}
