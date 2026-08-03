---
name: role-card-widget
description: >
  Flutter reusable role selection card widget (`RoleCardWidget`) used in the role selection screen.
  Displays a role option with an animated border/background, selection indicator (SVG circle icons),
  role name text, and a role image. Use this skill when building role/type selection UI with
  animated cards that highlight the selected option.
  Trigger on phrases like "role card", "role selection widget", "بطاقة الدور", "اختيار الدور",
  "animated selection card", "role card widget".
---

# RoleCardWidget

## Location

`lib/app_versions/shared/role_selection/presentation/widgets/role_card_widget.dart`

## Core Concept

A stateless, animated card widget for selecting a user role. Uses `AnimatedContainer` for smooth
visual transitions between selected/unselected states. Follows the project's clean widget rules:
`build()` is concise, colors come from `AppColors`, sizes from `SizeHelper` extensions.

## Widget Signature

```dart
class RoleCardWidget extends StatelessWidget {
  const RoleCardWidget({
    super.key,
    required this.roleModel,   // RoleModel — holds roleName & roleImage
    required this.isSelected,  // bool — drives all visual states
    required this.onTap,       // VoidCallback — tap handler
  });
}
```

## Data Model

```dart
// lib/app_versions/shared/role_selection/data/models/role_model.dart
RoleModel {
  final String roleName;   // displayed text
  final String roleImage;  // asset/network path passed to AppImage
}
```

## Visual States

| Property | Unselected | Selected |
|----------|-----------|----------|
| Background | `AppColors.white` | `AppColors.beigeE5` |
| Border color | `AppColors.greyDC` (60 % opacity) | `AppColors.primary` |
| Border width | `1.5` | `2` |
| Circle icon | `AppIcons.unSelectedCircle` | `AppIcons.selectedCircle` |
| Text color | `AppColors.grey6C` | `AppColors.primary` |
| Font weight | `FontWeightHelper.regular` | `FontWeightHelper.semiBold` |

Animation duration: **200 ms** via `AnimatedContainer`.

## Full Implementation

```dart
import 'package:atoz/app_versions/shared/role_selection/data/models/role_model.dart';
import 'package:atoz/core/extensions/size_helper.dart';
import 'package:atoz/core/utils/theme/app_colors.dart';
import 'package:atoz/core/utils/theme/app_font_styles.dart';
import 'package:atoz/core/utils/theme/app_icons.dart';
import 'package:atoz/shared/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoleCardWidget extends StatelessWidget {
  const RoleCardWidget({
    super.key,
    required this.roleModel,
    required this.isSelected,
    required this.onTap,
  });

  final RoleModel roleModel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: context.setWidth(16),
          vertical: context.setHeight(12),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.setMinSize(20)),
          color: isSelected ? AppColors.beigeE5 : AppColors.white,
          border: Border.all(
            width: isSelected ? 2 : 1.5,
            color: isSelected
                ? AppColors.primary
                : AppColors.greyDC.withValues(alpha: 0.6),
          ),
        ),
        child: Row(
          children: [
            // Selection indicator
            SvgPicture.asset(
              isSelected ? AppIcons.selectedCircle : AppIcons.unSelectedCircle,
              width: context.setMinSize(22),
              height: context.setMinSize(22),
            ),
            SizedBox(width: context.setWidth(12)),
            // Role name
            Expanded(
              child: Text(
                roleModel.roleName,
                style: AppFontStyle.regular20(context).copyWith(
                  color: isSelected ? AppColors.primary : AppColors.grey6C,
                  fontWeight: isSelected
                      ? FontWeightHelper.semiBold
                      : FontWeightHelper.regular,
                ),
              ),
            ),
            // Role image
            SizedBox(
              width: context.setWidth(90),
              height: context.setHeight(80),
              child: AppImage(
                path: roleModel.roleImage,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Key Points

- Always pass `isSelected` from the parent cubit/state — do **not** manage selection state inside the widget.
- `AppImage` handles both asset and network images; pass `roleModel.roleImage` directly.
- Use `SvgPicture.asset` with `AppIcons.selectedCircle` / `AppIcons.unSelectedCircle` for the indicator.
- Sizing uses `context.setWidth()`, `context.setHeight()`, and `context.setMinSize()` from `SizeHelper`.
- Border uses `withValues(alpha: 0.6)` (not deprecated `withOpacity`) for the unselected state.

## Usage Example

```dart
ListView.separated(
  itemCount: roles.length,
  separatorBuilder: (_, __) => SizedBox(height: context.setHeight(12)),
  itemBuilder: (context, index) {
    final role = roles[index];
    return RoleCardWidget(
      roleModel: role,
      isSelected: selectedRole == role,
      onTap: () => cubit.selectRole(role),
    );
  },
)
```

