part of '../Constants/my_router.dart';

extension EnumExtension on Enum {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
