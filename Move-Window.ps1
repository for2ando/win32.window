#!/c/WINDOWS/system32/WindowsPowerShell/v1.0/powershell

. q:\work\Get-Window\Get-Window.ps1
#Import-Module q:\work\Get-WindowHandles\Get-WindowHandles.ps1
#Import-Module Get-WindowHandles

Add-Type -AssemblyName System.Windows.Forms

function Move-Window-By-Name([String]$windowName, [Int32]$x, [Int32]$y)
{
    $hWnd = Get-Window-By-Name $windowName
    return Move-Window-To $hWnd $x $y
}


function Move-Window-To([Int32]$hWnd, [Int32]$x, [Int32]$y)
{
    #$rect = New-Object Win32APIs.Window+Rect
    $rect = Get-WindowRect $hWnd
    $width = $rect.Right - $rect.Left
    $height = $rect.Bottom - $rect.Top
    return Move-Window $hWnd $x $y $width $height
}


function Move-Window-To-TopLeft([Int32]$hWnd)
{
    return Move-Window-To $hWnd 0 0 
}


function Move-Window-To-TopRight([Int32]$hWnd)
{
    #$rectDesk = Get-WindowRect (Get-DesktopWindow)
    $rectDesk = [Windows.Forms.SystemInformation]::WorkingArea
    $rectWnd = Get-WindowRectangle $hWnd
    return Move-Window-To $hWnd ($rectDesk.right - $rectWnd.width) 0
}


function Move-Window-To-BottomLeft([Int32]$hWnd)
{
    #$rectDesk = Get-WindowRect (Get-DesktopWindow)
    $rectDesk = [Windows.Forms.SystemInformation]::WorkingArea
    $rectWnd = Get-WindowRectangle $hWnd
    return Move-Window-To $hWnd 0 ($rectDesk.bottom - $rectWnd.height)
}


function Move-Window-To-BottomRight([Int32]$hWnd)
{
    #$rectDesk = Get-WindowRect (Get-DesktopWindow)
    $rectDesk = [Windows.Forms.SystemInformation]::WorkingArea
    $rectWnd = Get-WindowRectangle $hWnd
    return Move-Window-To $hWnd ($rectDesk.right - $rectWnd.width) ($rectDesk.bottom - $rectWnd.height)
}


function Test()
{
#Move-Window-By-Name "cmd" 320 240
#Move-Window-To (Get-ForegroundWindow) 0 0
#Move-Window-To (Get-Window-By-Name "cmd") 0 0
#Move-Window-To-TopRight (Get-Window-By-Name "cmd")
#Move-Window-To-BottomLeft (Get-Window-By-Name "cmd")
#Move-Window-To-BottomRight (Get-TopWindow (Get-DesktopWindow))
#Move-Window-To-TopRight (Get-ForegroundWindow)
#Move-Window-To-TopRight (Get-ActiveWindow)
#Get-TopWindow (Get-DesktopWindow)
#Get-AllWindows-By-GetWindow
#ps|Get-ToplevelWindows
}

# main
if ($args.length -eq 0) {
    Test
    return
}
