# Admin Mode Implementation
**Date:** 2026-01-13
**Author:** Gemini Agent

## Overview
Added a developer-only "Admin Mode" to facilitate testing by unlocking all game content instantly.

## Changes

### 1. UserProgressNotifier (`lib/presentation/providers/user_progress_provider.dart`)
- Added `unlockAllContent()` method.
- Uses `UserProgressSeed.debugAllUnlocked()` to generate a fully unlocked state.
- Overwrites current user progress with this unlocked state.

### 2. UserProgressSeed (`lib/data/seeds/user_progress_seed.dart`)
- **Updated `debugAllUnlocked`**: Now dynamically fetches all IDs from `EraData.all` and `CountryData.all` instead of using hardcoded lists.
- Ensures that as new eras, countries, or characters are added to the static data, they will be automatically unlocked in Admin Mode.

### 3. SettingsScreen (`lib/presentation/screens/settings/settings_screen.dart`)
- Added a "DEVELOPER" section at the bottom of the settings list.
- Added "Admin Mode (Unlock All)" button.
- Includes a confirmation dialog to prevent accidental data loss.
- Shows a success SnackBar upon activation.

## Usage
1. Go to **Settings**.
2. Scroll to the bottom to find the **DEVELOPER** section.
3. Tap **Admin Mode (Unlock All)**.
4. Confirm the dialog.
5. All content (Regions, Eras, Countries, Characters) will be unlocked and Coins set to 99,999.