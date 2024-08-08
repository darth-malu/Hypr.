# 🌌 Hyprland + Waybar

### Table of Contents
1. [Introduction](#introduction)
2. [Screenshots 📷](#-Screenshots)
3. [Music 🎶](#music-)
4. [Terminal Apps💻](#-Tui)
5. [Keyboard Shortcuts ⌨️ ](#Keyboard-Shortcuts)
6. [Config 🧙](#Config-)
7. [Previous rice 🍚](#Previous-Rice-)

## 📝 Introduction
**This is my daily driver Arch build, min-maxed to the max 👻**

### Features ❄️ 

<details>
    <summary><strong>Quality of life mods:</strong></summary>

* Hyprland
    * Adjust gaps_in and gaps_out on the fly.(see [#keyboard-shortcuts](#keyboard-shortcuts))
    * Interactive volume control:
        * System-wide Volume progressbar with current sink icon
        * Switch and indicate current volume sink 
            * eg. switch from speaker to earphones and show current as earphones 
            * (see [#keyboard-shortcuts](#keyboard-shortcuts))
        * Max volume , volume zero & mute notification.
* Waybar:
    * Toggle waybar On/Off
    * updates 
        * script to: 
            * checkupdates 
            * see pacman -Qil of pending updates in verbose less format, or minimal format (awk)
            * backup lvm if needed before updating (Messes with grub-mkconfig, delete snapshot beforegrub update)
            * silent update (default option)
    * Per app (mpd, spotify etc) Volume + progressbar with waybar mpris interaction.
</details>

<details>
    <summary><strong>Quality Of life scripts</strong></summary>
    
[My scripts](.darth/scripts/)
</details>

<details>
    <summary><strong>Perfomance monitoring:</strong></summary>

* custom waybar capsules(click to open drawer):
* Gpu (amd)
    * gpu frequency mhz
    * gpu % use
    * gpu fan rpm
    * gpu temp
* CPU
    * temp, frequency, % use
* memory % use and disk % free + nvme temp.
* network(up/down speed) + weather (wttr.in)
</details>

- Theme: 
    - catppuccin-mocha-red - gtk
    - gruvbox - neovim
- Font: quicksand - waybar, JetBrainsMono Nerd Font - ~waybar
- Cursor: Bibata

***
## 📷 Screenshots

<!-- workspaces -->
<details>
    <summary><strong>Workspaces</strong></summary>

**Empty Workspace + my perf_mon capsules**
![maxi empty](https://github.com/darth-malu/Hypr./raw/hyprmax/.darth/git_screenshots/maxi_empty.png)

**Empty Capsules off**
![mini_empty](https://github.com/darth-malu/Hypr./raw/hyprmax/.darth/git_screenshots/emptyy.png)

</details>

### 💻 Tui
**kitty emptym**
![mini_empty](https://github.com/darth-malu/Hypr./raw/hyprmax/.darth/git_screenshots/term_empt.png)

**pacman + fzf | FastFetch**
![pacfzf](https://github.com/darth-malu/Hypr./raw/hyprmax/.darth/git_screenshots/pacf_fast.png)

**Neovim**
![nvim](https://github.com/darth-malu/Hypr./raw/hyprmax/.darth/git_screenshots/v.png)

**nvim + kitty_windows**
![nvim + Kitty windows](https://github.com/darth-malu/Hypr./raw/hyprmax/.darth/git_screenshots/kitty_v.png)

<!-- Files -->
<details>
    <summary><strong>File Manager</strong></summary>

**Nautilus**
![nauti](https://github.com/darth-malu/Hypr./raw/hyprmax/.darth/git_screenshots/nautilus.png)

**Yazi**
![Yazi](https://github.com/darth-malu/Hypr./raw/hyprmax/.darth/git_screenshots/yazi.png)
</details>

### Music 🎶 

<details>
    <summary><strong>NCMPCPP</strong></summary>

*visualizer view + dunst volume progress*
![ncmpcpp](https://github.com/darth-malu/Hypr./raw/hyprmax/.darth/git_screenshots/volume_nc.png)

*main playlist view*
![ncmpcpp](https://github.com/darth-malu/Hypr./raw/hyprmax/.darth/git_screenshots/ncmpcpp.png)

*playlist-editor view*
![ncmpcpp](https://github.com/darth-malu/Hypr./raw/hyprmax/.darth/git_screenshots/ncmpcpp_1.png)
</details>

<details>
    <summary><strong>Easy Effects</strong></summary>

![easy](https://github.com/darth-malu/Hypr./raw/hyprmax/.darth/git_screenshots/easy.png)
</details>

***

## Keyboard Shortcuts
<details>
    <summary><strong> ⌨️ </strong></summary>

        $sl = SHIFT_L
        $cl = CONTROL_L
        $mod = SUPER
        $al = Alt_L
        $ar = Alt_R
        $sl = SHIFT_L

        # grimblast scrnshot
        PrtSc: Taking Screentshot - entire scrn
            * + $al - current window
            * + $sl - copy area

        # Terminal
        $mod + Enter: Open kitty current workspace
        $mod + $sl + Enter: Open Terminal emptym

        # Hyprland (Numpad)
        
        $mod + KP_ADD(+): Inc. Gaps out
        $mod + KP_Subtract(-): Dec. Gaps out

        $mod + $al + KP_ADD: Inc. Gaps in
        $mod + $al + KP_Subtract: Dec. Gaps in

        $mod + vim-motions (h,k,l,j) / mouse-down/up -> navigate open workspaces
        $sl, $sl -> focuscurrentlast - backandforth active
        $mod + O -> Move to emptym
        $mod + Space/mouse:275 killactive / close focused window

        # Launch app
        $mod + {}:  
            {} = B - Brave
                 F - Firefox 
                 N - Nautilus, 
                 $sl + O - obsidian
                 F1 - Spotify
                 F2 - NCMPCPP
                 I: launch special:nc, launch ncmpcpp if empty
                 E: launch special:Easy, auto-launches Easy Effects on startup

        # Waybar
        $mod + Home: Waybar Reload
        $mod + End: Waybar toggle

see also:
- [workspaces](.config/hypr/hypr-configs/workspaces.conf)
- [Window & App Rules](.config/hypr/hypr-configs/WindowAppRules.conf)
- [keybindings](.config/hypr/hypr-configs/keybindings.conf)
</details>

***
## Config 🧙 
...

***
## Previous Rice 🍚

<details>
    <summary><strong>Dark</strong></summary>

</details>

<details>
    <summary><strong>Light</strong></summary>

</details>



