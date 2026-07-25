enum Gender { male, female }

extension GenderExtension on Gender {
  String get name {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
    }
  }

  String get localizedName => name;
  String get localizedName {
    switch (this) {
      case Gender.male:
        return LocaleKeys.complete_register_gender_male.tr();
      case Gender.female:
        return LocaleKeys.complete_register_gender_female.tr();
    }
  }
}
