# Authors / 核心作者 : 
# [Ralic Lo (ralic.lo@gmail.com)

$env.Path = ($env.Path | prepend '~\scoop\apps\msys2\current\usr\bin' 
    | prepend '~\scoop\apps\msys2\current\usr\bin\usr\sbin' 
    | prepend '~\scoop\apps\python\current\python.exe'
    | prepend '~\.cargo\bin' 
    | prepend '~\.local\bin' 
)
$env.config.buffer_editor = ["code", "-w"]
# $env.config.buffer_editor = "nano"

# ------------------------------------------------------------------------------
# FUNCTION: compress()
# DESCRIPTION: 最佳壓縮功能。
# ------------------------------------------------------------------------------
def compress [target: string] {
    swift_tar --zstd -cvf $"($target).tar.zst" $target
}

# ------------------------------------------------------------------------------
# FUNCTION: extract()
# DESCRIPTION: 智慧型萬用解壓功能，根據副檔名自動解開常見壓縮檔格式。
# ------------------------------------------------------------------------------
def extract [target: string] {
    swift_tar xvf $target
}

# ==============================================================================
# 🌍 GLOBAL ENVIRONMENTAL VARIABLES / 全域環境變數設定
# ==============================================================================
$env.LC_ALL = "en_US.UTF-8"
$env.LoginDay = (date now | format date "%Y-%m-%d")


# ==============================================================================
# 🚀 0. STARTUP SCRIPT MANAGEMENT (HOISTING) / 啟動腳本生命週期管理
# ==============================================================================

def startup-begin [] {
    print "[Info] Running boot scripts... / 正在執行初始引導腳本..."
}
startup-begin


# ==============================================================================
# 🎨 3. INTERACTIVE PROMPT SETUP (PS1) / 雙行美化提示字元設定
# ==============================================================================
# Nushell 的提示字元通常在 config.nu 中的 $env.PROMPT_COMMAND 定義
# 以下為對應的動態提示字元邏輯範例：

$env.PROMPT_COMMAND = { ||
    let user = (whoami)
    let hostname = (sys host | get hostname)
    let cwd = $env.PWD
    
    $"________________________________________________________________________________\n(ansi cyan)($cwd)(ansi reset) (ansi cyan)@($hostname)(ansi reset) (ansi blue)[($user)](ansi reset)\n=>"
}

# 同步至 sudo 階段變數
$env.SUDO_PS = $env.PROMPT_COMMAND


# ==============================================================================
# 📂 DIRECTORY NAVIGATION ENHANCEMENTS / 目錄導覽功能增強
# ==============================================================================

# 在 Nushell 中，若要覆寫 cd 行為通常建議透過自訂指令或包裝器處理
# 這裡建立一個簡易的 cd 替代指令來記錄上一個路徑
export-env {
    $env.prevfolder = (pwd)
    $env.termfolder = (pwd)
}

def --env mycd [target?: string] {
    $env.prevfolder = (pwd)
    if ($target == null) {
        cd ~
    } else {
        cd $target
    }
    ls
}

# 瞬間返回開啟此終端機視窗時的初始登入目錄
def --env orig [] {
    mycd $env.termfolder
}

# 切換回上一個記錄的目錄
def --env prev [] {
    mycd $env.prevfolder
}

# Color grep command for better visibility of search results
def cgrep [...args: string] {
    grep --color=always ...$args
}

# ==============================================================================
# ⌛測量指令執行時間（奈秒級）
# Example Usage:  nanoTimeElapsed --command { sleep 1sec } 
# date now：
# 取得當前的日期與時間，並回傳一個結構化的日期時間物件（Datetime object），裡面包含了年、月、日、時、分、秒以及微秒/奈秒的詳細資訊。
# | into int：將這個日期時間物件「強制轉型」為整數（Integer）。
# 在 Nushell 中，當你把一個日期時間轉成整數時，它代表的是從 Unix 紀元（1970年1月1日 00:00:00 UTC） 開始到現在所經過的總奈秒數（Nanoseconds）。
# ==============================================================================

def nanoTimeElapsed [--command: closure] {
    let starttime = (date now | into int)
    do $command
    let end_time = (date now | into int)
    # 強制將相減結果轉換並保留為整數
    let elapsed_ns = ($end_time - $starttime) | into int
    print $"==> Process took: ($elapsed_ns) 奈秒/nanoseconds"
}

def ffilter [] {
    lines | str replace --regex --all "['|\"]" "\\'" | str replace --all ' ' '\\ '
}

# ==============================================================================
# 🏁 啟動腳本結尾初始化
# ==============================================================================
def startup-end [] {
    $env.MAKEJOBS = "-j16"
}
startup-end