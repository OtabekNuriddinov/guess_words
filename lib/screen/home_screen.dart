import 'package:flutter/material.dart';
import 'package:guess_words/core/theme/dimens.dart';
import 'package:guess_words/core/theme/icons.dart';
import 'package:guess_words/core/theme/strings.dart';
import 'package:guess_words/core/theme/text_styles.dart';
import 'package:guess_words/models/charade.dart';
import 'package:guess_words/services/app_service.dart';
import 'package:just_audio/just_audio.dart';
import '../core/widgets/my_image_container.dart';
import '../core/widgets/my_wrap.dart';
import '/core/theme/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AppService appService;
  late Future<void> _dataFuture;
  String animationPath = "assets/animation/well_anim.json";

  late List<GameData> questions;
  GameData? currentQuestion;
  int level = 1;
  int sanoq = 0;
  bool isChecked = false;

  /// kerak bo'ladigan listlar
  List<String?> placedLetters = [];
  List<String> leftLetters = [];
  List<String> rightLetters = [];
  List<Color> leftSpaceColors = [];
  List<Color> rightSpaceColors = [];
  List<Color> middleSpaceColors = [];
  List originalList = [];
  List<String>letters = [];



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
            letters = currentQuestion!.letters;
            List<String> dragLetters = currentQuestion!.word.split("");
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  Stack(children: [
                    MyImageContainer(
                        currentQuestion: currentQuestion,
                        leftLetters: leftLetters,
                        rightLetters: rightLetters),
                    if(isChecked)
                      Align(
                        alignment: const Alignment(0, -0.3),
                        child: SizedBox(
                          width: AppDimens.d310,
                          height: AppDimens.d170,
                          child: Lottie.asset("assets/animation/well_anim.json", fit: BoxFit.cover),
                        ),
                      ),
                  ]),
                  AppDimens.h30,
                  _descriptionContainer(),
                  _optionsContainer(
                    dragLetters,
                    currentQuestion!.word,
                    AppService.getColorFromInt(currentQuestion!.left.color),
                    AppService.getColorFromInt(currentQuestion!.right.color),
                  ),
                  AppDimens.h30,
                  MyWrap(letters: letters),
                ],
              ),
            );
          }),
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
                if (!placedLetters.contains(null)) {
                  if (placedLetters.join("") == word) {
                    isChecked = true;
                    AppService.playWin();
                  } else {
                    AppService.playWrong();
                    replay();
                    letters.shuffle();
                  }
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
                child: Center(
                  child: Text(
                    placedLetters[index] ?? "",
                    style: AppTextStyles.cube,
                  ),
                ),
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
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(onPressed: replay, icon: AppIcons.replay),
        )
      ],
    );
  }

  void replay() {
    setState(() {
      isChecked = false;
      placedLetters = List.filled(originalList.length, null);
      letters.shuffle();
    });
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
