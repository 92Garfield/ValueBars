# ValueBars

A World of Warcraft addon that displays customizable status bars for tracking player health, damage absorb shields, and heal absorb effects.

Since the Values are secret, bars or text cannot be hidden when 0 or irrelevant.
I do this by making bars with no background with width of my healthbar and small height.
That way absorbs are visible when present, but do not take up space when not.

## Features

- **Three Bar Types:**
  - **Health Bar** - Tracks your current health
  - **Absorb Damage Bar** - Displays damage absorb shields (Power Word: Shield, etc.)
  - **Absorb Heal Bar** - Shows heal absorb debuffs

- **Slightly Customizable:**
  - Individual enable/disable toggles for each bar
  - Adjustable size (width & height)
  - Configurable position (X/Y coordinates)
  - Custom colors with alpha channel
  - Background opacity control
  - Optional text display showing current values

- **Performance Options:**
  - Configurable update interval (0.01 to 1 second)


### Configuration

Access the options panel via:
- ESC → Interface → AddOns → ValueBars

Each bar can be configured independently with:
- **Enable toggle** - Show/hide the bar
- **Width slider** - 100-500 pixels
- **Height slider** - 10-50 pixels
- **Position X/Y** - Offset from screen center (-1000 to 1000)
- **Bar color** - RGBA color picker
- **Background opacity** - 0.0 (transparent) to 1.0 (opaque)
- **Show text** - Display current value on the bar

### General Settings

- **Enable ValueBars** - Master toggle for all bars
- **Update Interval** - How often bars refresh (0.01-1 second)

## Default Settings

- **Health Bar:** Green, center position (0, 0)
- **Absorb Damage Bar:** Blue, 30 pixels below center (0, -30)
- **Absorb Heal Bar:** Yellow, 60 pixels below center (0, -60)
- **Update Interval:** 0.1 seconds (10 updates per second)
- **Text Display:** Off by default

## Technical Details

- **Update System:** Timer-based with configurable intervals
- **Settings Storage:** AceDB-3.0 for persistent configuration
- **UI Framework:** Ace3 libraries for options integration
- **API Usage:** WoW unit functions (UnitHealth, UnitGetTotalAbsorbs, etc.)

## Libraries Used

- LibStub
- AceAddon-3.0
- AceDB-3.0
- AceConsole-3.0
- AceEvent-3.0
- AceGUI-3.0
- AceConfig-3.0
- LibSharedMedia-3.0

## Author

**Demonperson** (a.k.a. 92Garfield)

## License

This addon is provided as-is for personal use.
