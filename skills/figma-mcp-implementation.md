---
inclusion: manual
---
# Figma -> Flutter Playbook (ATOZ)

The ONE guide for turning any Figma screen into ATOZ Flutter code without the
recurring problems: RTL misalignment, reversed Row order, wrong/duplicated
assets, and re-creating widgets that already exist.

Read this before EVERY screen. The screenshot is the source of truth, not the
exported HTML/`end` values.

---

## 0. The 3 root causes (and the fix)

1. **RTL misalignment / reversed Row order.** The app is Arabic = RTL. Flutter
 flips direction from the locale automatically. If you hand-map left/right or
 force `textDirection`, you get drift and reversed order.
 FIX: build logically, never force direction, order children by the screenshot.
2. **Wrong / broken images.** Guessing a project icon and force-recoloring a
 multi-colour SVG produces a wrong glyph.
 FIX: use the exact existing asset, or export it from Figma. Recolor only
 single-colour glyphs.
3. **Duplicated widgets.** Building a header/button/field that already exists.
 FIX: search the project first and reuse (see section 3).

---

## 1. RTL rules (MOST IMPORTANT)

The app runs RTL. Therefore:

- NEVER write `textDirection: TextDirection.ltr/rtl` on Row/Column/Text. Let RTL drive it.
- NEVER use `left` / `right`. Use logical sides only:
 - `EdgeInsetsDirectional.only(start:, end:)` (not `EdgeInsets.only(left:, right:)`).
 - `CrossAxisAlignment.start` / `.end`, `MainAxisAlignment.start` / `.end`.
 - `textAlign: TextAlign.start` / `.end`.
- RTL mapping to memorise:
 - `start` = RIGHT, `end` = LEFT.
 - Figma `items-end` / `text-right` (content sits on the RIGHT) => `CrossAxisAlignment.start` + `textAlign: TextAlign.start`.
- Row child order: list children in the SCREENSHOT reading order, RIGHT -> LEFT.
 The first child lands on the RIGHT in RTL. Do NOT force `ltr` to fix order;
 reorder the children instead.

### Worked example: the plan card
Screenshot shows: radio on the LEFT, details in the MIDDLE, wallet on the RIGHT.
Read right -> left = wallet, details, radio. So:
```dart
Row(
 spacing: context.setWidth(12),
 children: [
 AppImage(path: AppIcons.walletCach, width: 40, height: 40, color: AppColors.primary, fit: BoxFit.contain), // RIGHT
 Expanded(
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start, // = right in RTL
 children: [ /* name (textAlign.start), metrics row */ ],
 ),
 ),
 AppRadioDot(isSelected: isSelected), // LEFT
 ],
)
```
No `textDirection`. The radio ends up on the left purely from RTL + order.

---

## 2. Token mapping (ATOZ)

- **Colours**: `AppColors.*` (named hex, e.g. `AppColors.primary` = #E9B824,
 `AppColors.dark2A` = #2A2A2A, `AppColors.grey6C`, `AppColors.grey7C`,
 `AppColors.lightGreyF5`, `AppColors.greyD8`). If a hex is missing, ADD it to
 `app_colors.dart` with a clear name. Never hardcode `Color(0x..)` inline.
- **Sizing**: there is NO AppSpacing. Use extensions on `context`:
 `context.setMinSize(n)` (square / radius / padding), `context.setWidth(n)`,
 `context.setHeight(n)`. Pass RAW Figma px; the extension scales.
- **Typography**: `AppFontStyle.regularXX(context)` / `AppFontStyle.boldXX(context)`
 then `.copyWith(color: ...)`. Sizes available: 10,11,12,13,14,16,17,18,20,24,36.
- **Radius**: `BorderRadius.circular(context.setMinSize(figmaRadius))`. Pill = 52.
- **Icons**: `AppIcons.*` (SVGs in `assets/icons/`). See section 4.

---

## 3. Reuse before you create (search FIRST)

Before building ANY widget, grep `lib/shared/widgets/` and
`lib/app_versions/shared/auth/`. Known ATOZ reusables:

| Need | Use this (do NOT recreate) |
|------|----------------------------|
| Filled button | `CustomPushButton(height: 48, radius: 52)` (yellow default) |
| Outline button | `CustomPushButton(backgroundColor: AppColors.white, border: BorderSide(color: AppColors.primary), radius: 52)` |
| Generic button | `PrimaryButton(text:, isPrimary:, border:)` |
| Brand logo asset | `AppImages.appLogoSv` (renders white on yellow, do NOT recolor) |
| Yellow header w/ back | `AuthHeader(enableBack:, backTitle:, onBack:)` |
| Text field | `CustomTextField` |
| App bar | `lib/shared/widgets/custom_app_bar.dart` |
| Toast | `CustomToast(context:, header:, type:).showBottomToast()` |
| Image (asset / network / svg) | `AppImage(path:, width:, height:, color:, fit:, isNetwork:)` |
| Shimmer / skeleton | `custom_shimmer_*` widgets |
| Empty / error | `custom_empty_widget.dart`, `error_page.dart` |

New reusables built for the subscription section (reuse across roles):
`BrandLogoHeader`, `DualActionBar`, `IconLabel`, `AppRadioDot`, `DiscountPlanCard`.

Rule: if an existing widget is ALMOST right, ADD a parameter to it. Do not fork a copy.

---

## 4. Assets & icons

- Map a Figma icon to an existing file in `assets/icons/` (see `AppIcons`).
- `AppImage`/`SvgPicture` `color:` applies `BlendMode.srcIn` = flattens the WHOLE
 svg to one colour. Use it ONLY for single-colour glyph icons (e.g. calendar,
 arrow). Do NOT recolor logos / illustrations / multi-colour icons.
- If the right icon does NOT exist: export it from Figma with `download_assets`
 into `assets/icons/`, add a const to `AppIcons`, register the path in
 `pubspec.yaml`, then use it. NEVER substitute a visually-wrong icon.
- Network images: `AppImage(path: url, isNetwork: true, fit: BoxFit.cover)`
 (wraps CachedNetworkImage with shimmer + error fallback).

---

## 5. Widget composition (project law)

- One widget = one class. NO private `Widget _buildX()` methods that return widgets.
- Cross-feature reusable => public class in `lib/shared/widgets/`.
- Screen-only layout pieces => private classes (`_Foo`) in the screen file are OK.
- Pass the WHOLE entity/model into a widget (e.g. `DiscountPlanEntity plan`),
 never scattered single fields.
- `const` wherever possible.
- State via Cubit (BaseCubit + BaseState), never `setState` for business logic.

---

## 6. MCP mechanics

- URL `figma.com/design/<fileKey>/..?node-id=1-2` => fileKey `<fileKey>`, nodeId `1:2`.
- Per screen call BOTH: `get_design_context(nodeId, clientFrameworks:"flutter",
 clientLanguages:"dart")` and `get_screenshot(nodeId)`.
- Code Connect prompt => call again with `forceCode: true`.
- Truncated (large node) => `get_metadata(nodeId)` to get child node ids, then
 `get_design_context` per child. Do NOT dump a whole page node.
- The exported HTML uses LTR CSS + `end` everywhere; treat it as data only. The
 SCREENSHOT decides layout/order.

---

## 7. Per-screen workflow

1. Get node id. Call `get_design_context` + `get_screenshot`. READ the screenshot.
2. List needed widgets/assets. SEARCH the project for each (sections 3 & 4).
3. Build with clean RTL (section 1). Order Row children by the screenshot.
4. Map every value to tokens (section 2). No hardcoded colours/sizes.
5. `dart format <files>` then `flutter analyze <files>` => zero issues.
6. Give the user the Figma screenshot link for side-by-side comparison.

## 8. Checklist before "done"

- [ ] Screenshot used as source of truth.
- [ ] No manual `textDirection`; no `left`/`right`; uses start/end + `EdgeInsetsDirectional`.
- [ ] Row children ordered right -> left per screenshot.
- [ ] Reused existing widgets; no duplicates created.
- [ ] Icons correct; no recolored multi-colour SVGs; missing icons exported from Figma.
- [ ] Whole entity passed to widgets; one class per widget.
- [ ] Colours/sizes/typography mapped to AppColors / context.setX / AppFontStyle.
- [ ] `flutter analyze` clean.

---

## 9. Project design-system inventory (reuse map)

App base design size = **375x812** (`SizeProvider` in `app.dart`). RTL is
automatic from locale `ar-EG` (set in `main.dart` via EasyLocalization). No manual
directionality anywhere.

### Figma element -> existing ATOZ widget (REUSE, do not recreate)

| Figma element | Use | File | Default decoration |
|---|---|---|---|
| Filled pill button | `CustomPushButton(height:48, radius:52)` | `shared/widgets/custom_push_container_button.dart` | bg primary, radius 12 (pass 52 for pill), no shadow, label=`regular14` |
| Outline pill button | `CustomPushButton(backgroundColor: white, border: BorderSide(primary), radius:52)` | same | white bg + 1px primary border |
| Full-width button | `PrimaryButton(text:, isPrimary:, border:, fontColor:)` | `shared/widgets/button/primary_button.dart` | width inf, radius 52, margin/padding setMinSize(12), text regular14 |
| Text field / input | `CustomTextFormField` | `shared/widgets/custom_text_field.dart` | radius 14, border greyDC, focus primary, fill white, contentPadding EdgeInsetsDirectional(start12,end4,t12,b12), textAlign.start |
| Icon + readonly field (filter style) | `CustomInputForm(controller:, hintText:, iconPath:)` | `shared/widgets/app_input/custom_input_form.dart` | radius 12, fill lightGreyF5, no border, prefix AppImage 20 tinted grey6C |
| Dropdown selector | `CustomSelectorField<T>(controller:, list:, itemAsString:)` | `shared/widgets/custom_selector_field.dart` | readonly field + showMenu, chevron suffix |
| AppBar (back + title) | `MyCustomAppBar(title:/titleWidget:, trailing:)` | `shared/widgets/custom_app_bar.dart` | transparent, back=arrowForward rotated, title regular16 grey6C |
| Yellow brand header (onboarding) | `AuthHeader(enableBack:, backTitle:, onBack:)` OR `BrandLogoHeader` | `auth/.../auth_header.dart`, `shared/widgets/brand_logo_header.dart` | primary bg, centered `AppImages.appLogoSv` (do NOT recolor) |
| Grey rounded container | `CustomContainer` / `CustomDetailsContainer(title:, child:)` | `shared/widgets/custom_container.dart`, `labels/custom_details_container.dart` | padding 12, radius 12, bg lightGreyF5 |
| List row / settings row | `CustomListTile(title:, leadingIconPath:, trailing:, onTap:)` | `shared/widgets/custom_list_tile.dart` | padding 12, radius 12, bg lightGreyF5, leading svg 24 grey6C, arrow trailing |
| Checkbox (circular) | `CustomCheckBox(isActive:, changeIndex:)` | `shared/widgets/custom_check_box.dart` | 18px circle, active primary+white check, inactive greyD8 border |
| Radio (circular) | `AppRadioDot(isSelected:)` | `shared/widgets/app_radio_dot.dart` | 24px, selected primary ring+dot |
| Switch / toggle | `CustomSwitcher(isActive:, onChanged:)` | `shared/widgets/custom_switcher.dart` | Material switch scaled 0.8, mirrored, active primary |
| Star rating (static) | `StarRating(rating:, iconSize:)` | `shared/widgets/stars_rating.dart` | svg stars, half threshold |
| Rating (bar) | `CustomRattingBar(rating:, size:, color:, padding:)` | `shared/widgets/ratting_bar.dart` | customerReview icon primary |
| Price text | `CurrencyPrice(title:, fontSize:, isWhite:)` | `shared/widgets/labels/currency_price.dart` | price bold + iraq currency light |
| Old/strike price | `StrikeThroughPrice(price:)` | `shared/widgets/labels/strike_through_price.dart` | red strikethrough |
| Title + subtitle block | `MainTittle(title:, subTitle:)` | `shared/widgets/labels/main_tittle.dart` | title regular16 dark2A + subtitle italic light12 |
| Status chip | `OrderStatusLabel(orderStatusType:)` | `shared/widgets/labels/order_status.dart` | radius 4, color from enum, white text |
| Circle avatar | `CustomCircleAvatar(color:, radius:, child:)` | `shared/widgets/labels/circle_avatar.dart` | circle container |
| Image (asset/svg/network) | `AppImage(path:, width:, height:, color:, fit:, isNetwork:)` | `shared/widgets/app_image.dart` | network=CachedNetworkImage+shimmer+errorImage; svg=tint via color; raw px scaled |
| Bottom sheet | `AppBottomSheet<Cubit,State,SuccessState>(cubit:, builder:)` | `shared/widgets/bottom_sheet.dart` | white, top radius 16, drag handle 48x6 greyD8, auto-pop on SuccessState |
| Confirm dialog (2 options) | `CustomTwoOptionDialog(title:, buttonTitle:, onTap:)` | `shared/widgets/custom_two_option_dialog.dart` | radius 4, cancel TextButton + action button |
| Success/error dialog | `CustomDialog(title:, buttonTitle:, onTap:, isAccepted:)` | same file | circle icon badge + PrimaryButton |
| Empty state | `CustomEmptyWidget(title:, imagePath:, enableButton:)` | `shared/widgets/custom_empty_widget.dart` | svg/lottie + title regular16 |
| Error / retry | `ErrorPage(errorMessage:, onPressed:)` | `shared/widgets/error_page.dart` | lottie + retry button |
| Shimmer placeholder | `CustomShimmerContainer(width:, height:)` + `custom_shimmer_*` | `shared/widgets/` | skeleton blocks |
| Toast | `CustomToast(context:, header:, type:).showBottomToast()` | `shared/widgets/custom_toast.dart` | toastification success/error |
| Quantity stepper | `CustomQuantitySelector` | `shared/widgets/custom_quantity_selector.dart` | +/- counter |

New subscription-section reusables (reuse across roles): `IconLabel`,
`DualActionBar`, `DiscountPlanCard` (+ `AppRadioDot`, `BrandLogoHeader`).

### Theme tokens (exact)
- **Colors** `AppColors`: primary `#E9B824`; text grey6C `#6C6C6C`, dark2A `#2A2A2A`,
 grey7C `#7C7C7C`; hints grey92 `#929292`; borders greyDC `#DCDCDC`, greyD8 `#D4D4D8`;
 bg white, lightGreyF5 `#F5F5F5`, beigeE5 `#FCF6E5` (selected); status green00 `#008000`,
 red00 `#FF0000`, red `#E74C3C`. Add a NAMED const if a hex is missing; never inline `Color(0x..)`.
- **Fonts (TWO systems)**:
 - `AppFontStyle.{regular|light|bold}{10..24}(context)` -> responsive (`setMinSize`). USE THIS for new screens.
 - `CustomAppFontStyle.{...}` -> const, fixed px, NO context. WARNING: its `lightXX`
 is 2px smaller than XX (e.g. `light16` = 14px). Only used inside legacy base widgets.
- **Sizing** (`context` extensions, base 375x812): `setWidth` (xScale), `setHeight`
 (yScale), `setSp` (xScale, fonts), `setMinSize` (min scale; radius/padding/square/icons).
 Pass RAW Figma px. No `setRadius` -> use `setMinSize` for radius.

### RTL & decoration (confirmed from existing code)
- App is RTL from locale; framework flips `Directionality`. Existing widgets rely on
 this and use logical layout: `CustomTextFormField` uses `EdgeInsetsDirectional` +
 `textAlign.start`; cards/tiles use plain `Row` + `CrossAxisAlignment.start`;
 `product_item` uses `AlignmentDirectional` for badges.
- Therefore decoration/layout reads RIGHT -> LEFT automatically. Build logically.
- ONLY exception in the codebase: forcing `textDirection`/`textAlign` per-string for
 mixed Arabic+Latin text or numeric input (e.g. `CustomInputForm.isRtl`,
 merchant-name RegExp in `product_item`). Do NOT use this as a general pattern.
 
 ---
 
 ## 10. MCP fidelity rules (MUST — added after real misses)
 
 - ALWAYS read each screen FRESH from the MCP before coding. Call get_design_context on the
  FRAME node (e.g. 1:33604), NOT the parent Section. A Section returns SPARSE data: layer
  names only (every text shows as "Label", every box as "Frame"), with NO fill colours, NO
  real text, and NO icons. Building from a section dump = guessing. Do not do it.
 - If a frame is large/truncated, call get_metadata then get_design_context on each child
  group (e.g. the KPI Cards node) to read the REAL fills + text + icons.
 - ALSO call get_screenshot on the frame and treat the screenshot as the source of truth for
  layout, RTL order, and colours.
 - NEVER invent a value, colour, label, or icon. If the MCP did not return it, STOP and ask
  the user. Filling gaps from imagination is the #1 cause of wrong screens.
 - If you cannot reach the MCP or the data is incomplete, STOP and tell the user EXACTLY what
  is missing (e.g. "node X has no fill", "text shows as Label", "icon export is broken") so
  they can fix it in Figma. Never proceed on guesses.
 - Colours: read the real hex/variable from the frame (e.g. dark KPI cards are #2C323A =
  AppColors.grey3A). Never assume white.
 - Icons: if the exact glyph is not already in assets/icons, do NOT use a broken Figma export
  (exports often return a white background rect + off-canvas paths). Reuse the closest
  existing single-colour glyph and tell the user, or ask them to export a clean isolated SVG.
 
 ## 11. Logic patterns — copy the existing features (do NOT invent architecture)
 
 This app already has the canonical patterns. Mirror them exactly; do not invent new ones.
 
 - Lists with search + filter + sort + pagination => copy lib/app_versions/merchant/orders:
  - Plain Cubit (Cubit<XState>), NOT BaseState/PaginationState. The searchController lives IN
  the cubit and is disposed in close(). Query fields live on the cubit (search, sort,
  startDate, endDate, page, currentIndex).
  - getX({bool isInitial = true}): isInitial resets page=1 and clears the list; otherwise
  page++ and append. Track isPagination + isLoadingMore. States: sealed GetX { Loading,
  Success(data), Error } plus event states (ClearSearch, ShowClearSearch, HideClearSearch,
  ChangeTapBar, Sort, FilterByStartDate, FilterByEndDate, ApplySort(sortBy)).
  - Reuse SearchMain (search field + filter button) and SortedBottomSheet (sort by price/date
  + start/end date) inside AppBottomSheet<Cubit,State,ApplySortState>. Pagination is a
  ScrollController in the screen initState: when pixels >= maxScrollExtent*.9 && isPagination
  && !isLoadingMore && state is! Loading => getX(isInitial:false). Wrap in RefreshIndicator.
 - Home/dashboard => copy lib/app_versions/merchant/home/home_screen.dart: BlocProvider create
  cubit..getX(); RefreshIndicator + ListView; section header + view-all action; Skeletonizer
  (enabled: loading) with X.fake() placeholders; show max 4 preview items then "view all".
 - KPI cards in the subscription section are DARK (AppColors.grey3A) with a CustomCircleAvatar
  (white @ 0.07 alpha) holding a primary-tinted icon + white text — exactly like the
  merchant/home SalesInfo card. Reuse the shared dark KpiCard; never build a white KPI card.
 
 ## 12. Per-screen workflow (updated — supersedes section 7 ordering)
 1. get_design_context(FRAME nodeId) + get_screenshot(FRAME nodeId). If truncated => get_metadata
  then per-child get_design_context for the real fills/text/icons.
 2. Extract the REAL text, colours (hex/variable) and icons. If anything is missing => STOP and
  ask the user; do not invent.
 3. Find the closest existing feature (orders for lists, home for dashboards) and MIRROR its
  logic + REUSE its widgets (SearchMain, SortedBottomSheet, AppBottomSheet, KpiCard, etc.).
 4. Build with the RTL rules (section 1) and map every value to tokens (section 2).
 5. dart format then flutter analyze => zero issues.
 6. Give the user the frame screenshot link for side-by-side comparison.
 
