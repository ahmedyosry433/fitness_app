# 07 — Strings & Design Tokens (Zero Hardcode Policy)

---

## The Rule

**No Arabic or English string literal anywhere in widget/cubit/page files.**
Every user-visible text must come from `AppStrings`.

---

## AppStrings Usage Table

| Situation | Pattern | Example output |
|-----------|---------|----------------|
| Field label | `AppStrings.fullName` | `الاسم الكامل` |
| Field hint | `AppStrings.inputFormField(AppStrings.fullName)` | `الاسم الكامل...` |
| Validator | `AppStrings.validate(AppStrings.fullName)` | `الرجاء إدخال الاسم الكامل` |
| Button | `AppStrings.next` / `AppStrings.back` / `AppStrings.sendRequest` | `التالي` |
| Toggle password | `AppStrings.show` / `AppStrings.hide` | `اظهار` / `إخفاء` |
| "Login" link | `AppStrings.login` | `تسجيل الدخول` |
| "Already have account" | `AppStrings.alreadyHaveAccount` | `لديك حساب بالفعل؟` |
| Step label | `AppStrings.stepOf(currentStep, totalSteps)` | `خطوة 3/1` |
| Success toast | `AppStrings.merchantRegistrationSuccess` | `تم إرسال طلب التسجيل...` |
| Error toast | `state.registrationState.exception?.toString()` or feature-specific key | varies |

---

## Adding New Strings to AppStrings

File: `lib/core/utils/constants/app_strings.dart`

### Step 1 — Search first
Before adding, search the file for your string concept. These already exist:
`fullName`, `username`, `password`, `phoneNumber`, `storeName`, `address`,
`login`, `show`, `back`, `alreadyHaveAccount`, `errorMassage`, `save`, `edit`,
`cancel`, `logout`, etc.

### Step 2 — Add under a labeled comment block
```dart
// ── {Feature Name} ────────────────────────────────────────────────────────
static String get merchantCreateAccount => 'إنشاء حساب تاجر';
static String get merchantCreateAccountIntro => 'انضم إلى ';
static String get merchantCreateAccountBrand => 'AtoZ';
static String get merchantCreateAccountSubtitle =>
    'وأضف متجرك للوصول إلى آلاف العملاء وتفعيل عروض الخصومات.';
static String stepOf(int current, int total) => 'خطوة $total/$current';
static String get sendRequest => 'إرسال الطلب';
static String get activityType => 'نوع النشاط';
static String get selectActivityType => 'أختر نوع النشاط';
static String get enterStoreAddress => 'أدخل عنوان المتجر';
static String get uploadStoreCoverImage => 'رفع صورة لخلفية المتجر هنا';
static String get uploadStoreLogoImage => 'رفع صورة المتجر هنا';
static String get setupOffer => 'إعداد العرض';
static String get discountPercentageHint => 'نسبة الخصم';
static String get discountRangeError => 'يجب أن تكون النسبة بين 1 و 100';
static String get merchantRegistrationSuccess =>
    'تم إرسال طلب التسجيل بنجاح، سيتم مراجعته قريبًا';
```

---

## Design Tokens

### Colors → `AppColors.*`
```dart
color: AppColors.primary       // #E9B824
color: AppColors.dark2A        // #2A2A2A
color: AppColors.grey7C        // #7C7C7C
color: AppColors.white         // #FFFFFF
color: AppColors.lightGreyF5   // #F5F5F5
```

### Sizes → context extensions
```dart
context.setWidth(16)      // scales with screen width
context.setHeight(24)     // scales with screen height
context.setMinSize(12)    // min(width_scale, height_scale) — for border radius, icon size
```

### Font styles
```dart
// Need context (responsive):
AppFontStyle.regular14(context)
AppFontStyle.bold24(context)

// Static (no context) — use for const or in AppBar:
CustomAppFontStyle.regular14
CustomAppFontStyle.bold24
```

### Icons & Images
```dart
SvgPicture.asset(AppIcons.userAvatar)
SvgPicture.asset(AppImages.appLogoSv)
AppImage(path: AppIcons.percentage, width: 20, height: 20, fit: BoxFit.contain)
```

---

## Anti-patterns to catch before analyze

Run this regex search in the feature folder to find remaining hardcode:
```
'[أ-ي]  → any Arabic inside single quotes
"[أ-ي]  → any Arabic inside double quotes
Color\(0x → inline color
EdgeInsets\.only\(right → not RTL-safe
```
