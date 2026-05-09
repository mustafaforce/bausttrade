import 'package:flutter/material.dart';

class MetaTypography {
  MetaTypography._();

  static const _fontFamily = 'Montserrat';
  static const _fallback = 'Helvetica, Arial, sans-serif';

  static const heroDisplay = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 64,
    fontWeight: FontWeight.w500,
    height: 1.16,
    letterSpacing: 0,
  );

  static const displayLg = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w500,
    height: 1.17,
    letterSpacing: 0,
  );

  static const headingLg = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w500,
    height: 1.28,
    letterSpacing: 0,
  );

  static const headingMd = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w300,
    height: 1.21,
    letterSpacing: 0,
  );

  static const headingSm = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.25,
    letterSpacing: 0,
  );

  static const subtitleLg = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.44,
    letterSpacing: 0,
  );

  static const subtitleMd = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.44,
    letterSpacing: 0,
  );

  static const bodyMdBold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.50,
    letterSpacing: -0.16,
  );

  static const bodyMd = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    letterSpacing: -0.16,
  );

  static const bodySmBold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.43,
    letterSpacing: -0.14,
  );

  static const bodySm = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: -0.14,
  );

  static const captionBold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: 0,
  );

  static const caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0,
  );

  static const buttonMd = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.43,
    letterSpacing: -0.14,
  );

  static const linkMd = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.50,
    letterSpacing: -0.16,
  );
}
