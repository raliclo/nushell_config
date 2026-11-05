Installation guide for windows:

# 1. Install scoop
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

# 2. Install winget/msys2 by scoop
```
scoop install git winget msys2
```

# 3. Install swift_tar by scoop
```
scoop bucket add lzfse2 https://github.com/raliclo/lzfse2
scoop install swift_tar
```

# 4. Install and execute nushell
```
winget install nushell
```

# 5. Install nushell config into windows config folder
```
nu
cp config.nu ~\AppData\Roaming\nushell\config.nu
```

# 6 Setup Windows Terminal default and restore configuration

```
Settings > Startup > Default Profile > Choose Nu
Settings > Startup > When Terminal starts > Restore Window layout 
```

# 7 Load fixed terminals with shells.nu
```
nu shells.nu
```
Features :
1. Fast compress and extract command 
2. Quick prev/orig folder command
3. nanoTimeElaspse for process runtime