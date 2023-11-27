import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  static const Color mainBGColor = Color(0xFF652A78);
  static const Color redColor = Color(0xFFDE3C10);
  static const Color purpleColor = Color(0xFF812ad);
  static const Color cyanColor = Color(0xFF99D5E5);
  static const Color orangeColor = Color(0xffe97a4d);

  static const LinearGradient gradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 154, 92, 175),
      Color.fromARGB(255, 154, 92, 175),
      mainBGColor,
      mainBGColor,
      mainBGColor,
      Color.fromARGB(255, 154, 92, 175),
      Color.fromARGB(255, 154, 92, 175),
    ],
  );
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    Path mainBGPath = Path();
    mainBGPath.addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    paint.color = AppColors.mainBGColor;
    canvas.drawPath(mainBGPath, paint);

    Path cyanPath = Path();
    cyanPath.moveTo(size.width / 2, size.height * 0.75);
    cyanPath.quadraticBezierTo(
        size.width, size.height * 0.75, size.width, size.height * 0.50);
    cyanPath.quadraticBezierTo(
        size.width, size.height * 0.75, size.width, size.height * 1.0);
    cyanPath.lineTo(size.width / 2, size.height * 1.0);
    cyanPath.moveTo(0, size.height * 1.0);
    cyanPath.quadraticBezierTo(
        0, size.height * 0.75, size.width / 2, size.height * 0.75);
    cyanPath.lineTo(size.width / 2, size.height * 1.0);

    cyanPath.close();
    paint.color = AppColors.cyanColor;
    canvas.drawPath(cyanPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final Function(String)? onChanged;
  final AutovalidateMode? autovalidateMode;
  final int? maxLine;
  final String? Function(String?)? validator;
  final Color? color;
  final Color? textColor;
  final Widget? prefix;
  final Widget? suffix;
  final bool? obscure;

  CustomTextField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.onChanged,
    this.autovalidateMode,
    this.validator,
    this.maxLine,
    this.textColor,
    this.color,
    this.obscure,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    AutovalidateMode _autovalidateMode = AutovalidateMode.onUserInteraction;

    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscure ?? false,
      validator: validator,
      autovalidateMode: _autovalidateMode,
      maxLines: maxLine,
      textInputAction: TextInputAction.next,
      controller: controller,
      onChanged: onChanged,
      cursorColor: textColor,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: color ?? Colors.grey[250], // Set the background color
        prefixIcon: prefix,
        suffixIcon: suffix,
        hintText: hintText,
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.blueAccent.withOpacity(.4),
            width: 1.5,
          ),
        ),
        contentPadding:
            const EdgeInsets.only(bottom: 30, left: 15, right: 15, top: 10),
      ),
    );
  }
}

String getTimeOfDay() {
  final currentTime = DateTime.now().hour;

  if (currentTime < 12) {
    return 'Morning 👋';
  } else if (currentTime < 17) {
    return 'Afternoon 👋';
  } else {
    return 'Evening 👋';
  }
}

void nextScreen(GetPageBuilder page) {
  Get.to(page());
}

void nextScreenReplace(GetPageBuilder page) {
  Get.off(page());
}

void LoginSnackBar(String message) {
  Get.snackbar(
    'Success',
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.green.withOpacity(.8),
    colorText: Colors.white,
  );
}

class TextBio extends StatelessWidget {
  final String header;
  final String bio;

  const TextBio({Key? key, required this.header, required this.bio})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$header: ",
          style: headerTextStyle,
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                bio.isNotEmpty ? bio : 'Please fill in your $header',
                style: bodyTextStyle,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

TextStyle headerTextStyle = const TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontSize: 18,
);
TextStyle bodyTextStyle = const TextStyle(fontSize: 17, color: Colors.black54);
