import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final String image;
  final int color;
  const MyContainer({
    required this.image,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 250,
            height: 310,
            decoration: BoxDecoration(
              color: Colors.grey
            ),
          ),
          Positioned(
            bottom: 12,
              right: 6,
              child: Container(
                width: 250,
                height: 310,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                      color: Colors.grey,
                      width: 1
                  ),
                ),
                child:
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 10),
                        InteractiveViewer(
                          maxScale: 2,
                          minScale: 0.5,
                          child: Container(
                            width: 250,
                            height: 245,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 1
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(image),
                              ),
                            ),
                          ),
                        ),
                         Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10),
                              ),
                              color: getColorFromInt(color),
                            ),
                          ),
                      ],
                    ),
                ),
                )
              ),

          ]
      ),
    );
  }
  Color getColorFromInt(int colorValue) {
    return Color(0xFF000000 | colorValue); 
  }
}


