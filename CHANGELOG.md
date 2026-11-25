## Unreleased

- Fix: alerts are now removed from the overlay after they hide (previously they stayed mounted off-screen).
- Fix: the overlay is looked up on every `show` instead of being cached once, so alerts work after the navigator/overlay is rebuilt. The public top-level `overlayState` variable was removed.
- Fix: swiping to dismiss works during the entrance animation.
- Fix: `actionColor` is now applied to the action button.
- Change: pressing the action dismisses the alert. `actionCallback` is now a `VoidCallback?`.
- Change: default icons are `Icons.info_outline` for `info` and `Icons.error_outline` for `error` (were `error_outline` and `help_outline`).
- Change: `InfoPlus.show` is now a static method (call sites are unchanged).
- Example: the theme toggle now applies to the alert.
- Docs: corrected icon color docs, README install snippet.

## 0.0.1

- : Initial release


