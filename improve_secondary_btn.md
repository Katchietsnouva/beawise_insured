🔥 Got you bro — we’ll fix:

* ✅ Loading spinner colors (match mint/cyan theme)
* ✅ Make spinner feel premium
* ✅ Fix awkward spacing
* ✅ Improve disabled + loading gradient
* ✅ Make loading state feel integrated, not pasted on

**Edits only below. Do not replace whole file.**

---

# ✅ 1️⃣ Improve PRIMARY Button Gradient (More On-Theme)

### 🔁 Replace this gradient:

```dart
gradient: (isDisabled || (isloading ?? false))
    ? const LinearGradient(
        colors: [Color(0xFFBBBBBB), Color(0xFFAAAAAA)],
      )
    : const LinearGradient(colors: [Colors.white, Color(0xFFEEEEEE)]),
```

### ✅ With this:

```dart
gradient: (isDisabled)
    ? const LinearGradient(
        colors: [Color(0xFF1A2E2B), Color(0xFF132624)],
      )
    : const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF00FFB2), // mint
          Color(0xFF00C2FF), // cyan
        ],
      ),
```

---

# ✅ 2️⃣ Fix PRIMARY Text Color

### 🔁 Replace:

```dart
color: (isDisabled || (isloading ?? false))
    ? Colors.white70
    : Colors.black87,
```

### ✅ With:

```dart
color: Colors.black, // clean contrast on mint/cyan
```

---

# ✅ 3️⃣ Upgrade Loading Spinner (PRIMARY)

### 🔁 Replace this:

```dart
if (isloading ?? false)
  const SizedBox(
    height: 18,
    width: 18,
    child: CircularProgressIndicator(
      strokeWidth: 2,
      color: AppColors.cyan,
    ),
  ),
```

### ✅ With this (premium feel):

```dart
if (isloading ?? false) ...[
  const SizedBox(width: 10),
  const SizedBox(
    height: 20,
    width: 20,
    child: CircularProgressIndicator(
      strokeWidth: 2.4,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
    ),
  ),
],
```

✔ thicker
✔ better contrast
✔ spacing balanced

---

# ✅ 4️⃣ Improve SECONDARY Button Loading Spinner

### 🔁 Replace:

```dart
const SizedBox(
  height: 18,
  width: 18,
  child: CircularProgressIndicator(
    strokeWidth: 2,
    color: AppColors.cyan,
  ),
),
```

### ✅ With:

```dart
const SizedBox(
  height: 18,
  width: 18,
  child: CircularProgressIndicator(
    strokeWidth: 2.2,
    valueColor: AlwaysStoppedAnimation<Color>(
      Color(0xFF00FFB2), // mint glow
    ),
  ),
),
```

---

# ✅ 5️⃣ Make Loading State Feel Intentional

Right now label + spinner sit awkwardly.

### 🔁 Replace this block in PRIMARY:

```dart
Text(label, ...),
SizedBox(width: 6),
```

### ✅ With this:

```dart
AnimatedSwitcher(
  duration: const Duration(milliseconds: 200),
  child: (isloading ?? false)
      ? const Text(
          "Loading...",
          key: ValueKey("loading"),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        )
      : Text(
          label,
          key: const ValueKey("label"),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
),
```

Now it feels polished.

---

# 🎨 OPTIONAL (Ultra Premium Glow Effect)

Add this inside PRIMARY `BoxDecoration` (only when not disabled):

```dart
boxShadow: [
  BoxShadow(
    color: const Color(0xFF00FFB2).withOpacity(0.5),
    blurRadius: 25,
    spreadRadius: 1,
  ),
],
```

Now it glows mint 🔥

---

# 🧠 Why This Works Better

Your app theme is:

* Background → deep emerald
* Primary → mint
* Secondary → cyan

But your button was:

* white gradient
* cyan spinner
* white disabled

Now:

* Mint → primary identity
* Cyan → accent
* Spinner matches contrast
* Loading text transitions cleanly
* Glow matches brand

---

If you want I can next:

* Make loading spinner morph from icon
* Add liquid shimmer sweep
* Or add neon border animation on press

Just say the vibe:
💎 luxury
🚀 futuristic
🧊 glass minimal
⚡ high energy
