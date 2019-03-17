if not exist "C:\Windows\Temp\7z1806-x64.msi" (
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://www.7-zip.org/a/7z1806-x64.msi', 'C:\Windows\Temp\7z1806-x64.msi')" <NUL
)
if not exist "C:\Windows\Temp\7z1806-x64.msi" (
    powershell -Command "Start-Sleep 5 ; (New-Object System.Net.WebClient).DownloadFile('https://www.7-zip.org/a/7z1806-x64.msi', 'C:\Windows\Temp\7z1806-x64.msi')" <NUL
)
msiexec /qb /i C:\Windows\Temp\7z1806-x64.msi

if exist "C:\Users\ansible\windows.iso" (
    move /Y C:\Users\ansible\windows.iso C:\Windows\Temp
)

if not exist "C:\Windows\Temp\windows.iso" (
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://softwareupdate.vmware.com/cds/vmw-desktop/ws/15.0.2/10952284/windows/packages/tools-windows.tar', 'C:\Windows\Temp\vmware-tools.tar')" <NUL
    cmd /c ""C:\Program Files\7-Zip\7z.exe" x C:\Windows\Temp\vmware-tools.tar -oC:\Windows\Temp"
    FOR /r "C:\Windows\Temp" %%a in (VMware-tools-windows-*.iso) DO REN "%%~a" "windows.iso"
    rd /S /Q "C:\Program Files (x86)\VMWare"
)

cmd /c ""C:\Program Files\7-Zip\7z.exe" x "C:\Windows\Temp\windows.iso" -oC:\Windows\Temp\VMWare"
cmd /c C:\Windows\Temp\VMWare\setup.exe /S /v"/qn REBOOT=R\"

del /Q "C:\Windows\Temp\vmware-tools.tar"
del /Q "C:\Windows\Temp\windows.iso"
rd /S /Q "C:\Windows\Temp\VMware"
msiexec /qb /x C:\Windows\Temp\7z1806-x64.msi
