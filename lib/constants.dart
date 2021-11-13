import 'package:flutter/material.dart';

const String appName = "Tasawq";
const String androidLink = 'https://play.google.com/store/apps/details?id=';
final String packageName = 'com.the.tasawq';

/// Light Theme color
const ContainerBackgroundColorLite = Color(0xFFFFFCE6);
const primary = Color(0xFF506AD4);
const secondaryColor = Color(0xFFF2CC39);
const kItemFocusColorLight = Color(0xFFC2B8AD);
const kItemColor = Color(0xFFA3CDD9);
const shadowColorLight = Color(0xFFEFF2F6);
const ContainerBackgroundColor = Color(0xFFFBFDFF);
const kBackgroundScaffold = Color(0xFFFDFDFF);

/// Dark Theme color

const kBackgroundScaffoldDark = Color(0xFF101112);
const primaryDark = Color(0xFF000000);
const kItemFocusColorDark = Color(0xFF58555A);
const shadowColorDark = Color(0xFF7F7F7F);
const ContainerBackgroundColorDark = Color(0xFF666669);
const secondaryColorDark = Color(0xFF5E270E);
const kColorBtmBarIcon = Color(0xFFAC8F7D);

const kButtonColor = Color(0xFF121010);
const kTextColorH2 = Color(0xFF101112);
const kTextColorH6 = Color(0xFF9DA0AD);

const kColorMeMessage = Color(0xFFECFBF3);
const kColorMessage = Color(0xFFFCF1EA);

const kTextFieldDecoration = InputDecoration(
    contentPadding:
        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: const OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: const BorderSide(color: shadowColorDark, width: 1.0),
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide:
          const BorderSide(color: ContainerBackgroundColorDark, width: 2.0),
      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
    ));

class BackgroundCustomColor extends CustomPainter {
  BackgroundCustomColor(this.context);
  final context;
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();
    Path mainBack = Path();
    mainBack.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Theme.of(context).scaffoldBackgroundColor;
    canvas.drawPath(mainBack, paint);
    Path line = Path();
    line.moveTo(width, height * 0.2);
//اول شي بنقلو لهي الاحداثيات
    line.quadraticBezierTo(width * 0.6, height * 0.2, width * 0.5, 0);
    //برسم شكل بيضوي
    line.lineTo(width, 0);
    //باخد القلم ليعبي الجزء الفارغ جرب امسحا شان تفهم تكمل الباقي
    paint.color = Theme.of(context).shadowColor;
    canvas.drawPath(line, paint);

    line.moveTo(0, height * 0.35);
    line.quadraticBezierTo(width * 0.4, height * 0.6, width, height * 0.5);
    line.lineTo(width, height * 0.35);
    line.quadraticBezierTo(width * 0.45, height * 0.35, 0, 0);
    canvas.drawPath(line, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class BackgroundAppbarColor extends CustomPainter {
  BackgroundAppbarColor(this.context);
  final context;
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();
    Path line = Path();
    line.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Theme.of(context).shadowColor;
    line.moveTo(0, 0);
    line.lineTo(0, height);
    line.lineTo(width * 0.5, height);
    line.quadraticBezierTo(width * 0.46, height * 0.4, width * 0.47, 0);
    line.lineTo(0, 0);
    canvas.drawPath(line, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
