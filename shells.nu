#!/usr/bin/env nu

def main [] {
    printf "Launching workspace...\n"
    # Detect OS and open configured windows
    if ($nu.os-info.name == "windows") {
        printf "Detected Windows OS. Launching Windows Terminal...\n"
        # Launch 3 distinct windows using Windows Terminal
        wt.exe new-tab --title "LZFSE2" nu -e "cd ~/proj/lzfse2"
        wt.exe new-tab --title "SIFT_TAR" nu -e "cd ~/proj/lzfse2/swift_tar"
        wt.exe new-tab --title "Proj Tab" nu -e "cd ~/proj/nushell_config"
    } else if ($nu.os-info.name == "macos") {
        # Open 3 new Terminal app windows
        printf "Detected macOS. Opening Terminal windows...\n"
        1..3 | each { open Terminal }
    } else {
        # Linux / Fallback (e.g. Alacritty) 
        printf "Detected Linux or other OS. Launching Alacritty windows...\n"
        alacritty --title "Logs" -e nu &
        alacritty --title "Server" -e nu &
        alacritty --title "Client" -e nu &
    }
}