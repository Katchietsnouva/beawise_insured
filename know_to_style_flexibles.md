The error you're seeing is a classic Flutter layout issue:

> **RenderFlex children have non-zero flex but incoming width constraints are unbounded.**

This occurs in a `Row` (horizontal flex) when:

- One or more children use `Expanded` (or `Flexible` with non-zero `flex`)
- The `Row` receives **unbounded width** from its parent (i.e. `maxWidth: Infinity` or very large/no upper limit)
- The `Row` itself tries to shrink-wrap its content (`mainAxisSize: MainAxisSize.min`) while also having children that want to expand into "infinite" remaining space

Flutter can't resolve this conflict: the children want to fill "all remaining space", but there is no finite remaining space to fill.

### Key Clues from Your Error Message

- The problematic `Row` is defined here:  
  `insured_button.dart:327:22`

- It's inside a `_SecondaryButton` widget (which seems custom, probably your variant of an outlined/secondary button).

- The `Row` has `mainAxisSize: min` (shrink-wrap behavior) and `mainAxisAlignment: start`.

- It contains at least one child using `Expanded` (that's the "non-zero flex" part).

- The nearest ancestor giving unbounded width is another `Row` (with `mainAxisSize: max`) inside something called `GlassCard` → `Column` → `ConstrainedBox` → etc.  
  That outer `Row` has constraints `0.0 <= w <= 750.0` (bounded), but somewhere higher up the chain (likely a horizontal scrollable, unconstrained parent, or just loose layout), the inner structures end up with infinite width allowance.

- Height is bounded to ≤38.0 px (probably your button's fixed/tight height).

### Most Likely Cause in Your Code

Inside your `_SecondaryButton` (around line 327), you probably have something like this:

```dart
Row(
  mainAxisSize: MainAxisSize.min,           // ← shrink-wrap
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    // some icon or leading widget
    Expanded(                                 // ← the problem child
      child: Text('Button Label', ...),
    ),
    // maybe trailing icon / suffix
  ],
)
```

Or a similar pattern with `Expanded` / `Flexible(flex: >0)` on one of the children.

This pattern is **very common** in custom buttons that want an icon + text + maybe chevron, where the text takes all available space between icon and trailing widget.

But when the button itself is placed in a context with unbounded width (e.g. inside a `SingleChildScrollView` horizontal, inside a dialog without width constraint, inside another `Row`/`Flex` without tight constraints, or just loose parent), it breaks.

### How to Fix It

Choose **one** of these approaches depending on your desired button behavior:

1. **Recommended for most buttons – Remove Expanded and let text wrap or ellipsis**  
   (simplest & most reliable)

   ```dart
   Row(
     mainAxisSize: MainAxisSize.min,
     children: [
       if (icon != null) icon,
       SizedBox(width: 8),
       Flexible(                    // ← use Flexible instead of Expanded
         child: Text(
           label,
           overflow: TextOverflow.ellipsis,   // prevents overflow
           maxLines: 1,
         ),
       ),
       if (trailing != null) ...[SizedBox(width: 8), trailing],
     ],
   )
   ```

   - `Flexible` (with default `fit: FlexFit.loose`) allows the child to be **smaller** than remaining space.
   - `Expanded` forces it to **take all** remaining space (which requires bounded constraints).

2. **If you really need the text to expand fully** (take all space between icons)

   Give the entire button a bounded width:

   ```dart
   SizedBox(
     width: 200,               // or MediaQuery.of(context).size.width * 0.7, etc.
     child: _SecondaryButton(...),
   )
   ```

   Or wrap the problematic `Row` in `IntrinsicWidth` (expensive, avoid in lists):

   ```dart
   IntrinsicWidth(
     child: Row(
       mainAxisSize: MainAxisSize.min,
       children: [
         Icon(...),
         Expanded(child: Text(...)),
         Icon(...),
       ],
     ),
   )
   ```

3. **If the button is inside a scrollable Row or unconstrained parent**

   Wrap the scrollable part or the parent with bounded constraints, or avoid `Expanded` inside horizontally scrollable areas.

4. **Quick test / debug**

   Temporarily replace `Expanded` with `Flexible` (or remove it and use `SizedBox` / fixed width on text) and hot-reload.  
   If the error disappears → that's the spot.

   Also try temporarily setting `mainAxisSize: MainAxisSize.max` on that `Row` — if it fixes it, the shrink-wrap + expand conflict is confirmed.

### Summary – Most Probable Fix

In `insured_button.dart` around line 327, change `Expanded` → `Flexible` on the text/icon child that is expanding, and add `Text` overflow handling:

```dart
Flexible(
  child: Text(
    'Your Button Text',
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  ),
)
```

This is by far the most common solution for secondary/outline buttons with icon + label + optional trailing.

If that doesn't match your code or the error persists, share the code snippet from `insured_button.dart` around lines ~320–340 (the `_SecondaryButton` build method or the `Row` in question) and I can give a more precise fix.