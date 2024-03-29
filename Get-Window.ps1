#!/c/WINDOWS/system32/WindowsPowerShell/v1.0/powershell

$WS_OVERLAPPED = 0x00000000L
$WS_TILED = 0x00000000L
$WS_MAXIMIZEBOX = 0x00010000L
$WS_TABSTOP = 0x00010000L
$WS_GROUP = 0x00020000L
$WS_MINIMIZEBOX = 0x00020000L
$WS_SIZEBOX = 0x00040000L
$WS_THICKFRAME = 0x00040000L
$WS_SYSMENU = 0x00080000L
$WS_HSCROLL = 0x00100000L
$WS_VSCROLL = 0x00200000L
$WS_DLGFRAME = 0x00400000L
$WS_BORDER = 0x00800000L
$WS_CAPTION = 0x00C00000L
$WS_MAXIMIZE = 0x01000000L
$WS_CLIPCHILDREN = 0x02000000L
$WS_CLIPSIBLINGS = 0x04000000L
$WS_DISABLED = 0x08000000L
$WS_VISIBLE = 0x10000000L
$WS_ICONIC = 0x20000000L
$WS_MINIMIZE = 0x20000000L
$WS_CHILD = 0x40000000L
$WS_CHILDWINDOW = 0x40000000L
$WS_POPUP = 0x80000000L
$WS_OVERLAPPEDWINDOW = $WS_OVERLAPPED -bor $WS_CAPTION -bor $WS_SYSMENU -bor $WS_THICKFRAME -bor $WS_MINIMIZEBOX -bor $WS_MAXIMIZEBOX
$WS_TILEDWINDOW = $WS_OVERLAPPED -bor $WS_CAPTION -bor $WS_SYSMENU -bor $WS_THICKFRAME -bor $WS_MINIMIZEBOX -bor $WS_MAXIMIZEBOX
$WS_POPUPWINDOW = $WS_POPUP -bor $WS_BORDER -bor $WS_SYSMENU

$WS_EX_LEFT = 0x00000000L
$WS_EX_LTRREADING = 0x00000000L
$WS_EX_RIGHTSCROLLBAR = 0x00000000L
$WS_EX_DLGMODALFRAME = 0x00000001L
$WS_EX_NOPARENTNOTIFY = 0x00000004L
$WS_EX_TOPMOST = 0x00000008L
$WS_EX_ACCEPTFILES = 0x00000010L
$WS_EX_TRANSPARENT = 0x00000020L
$WS_EX_MDICHILD = 0x00000040L
$WS_EX_TOOLWINDOW = 0x00000080L
$WS_EX_WINDOWEDGE = 0x00000100L
$WS_EX_CLIENTEDGE = 0x00000200L
$WS_EX_CONTEXTHELP = 0x00000400L
$WS_EX_RIGHT = 0x00001000L 
$WS_EX_RTLREADING = 0x00002000L
$WS_EX_LEFTSCROLLBAR = 0x00004000L
$WS_EX_CONTROLPARENT = 0x00010000L
$WS_EX_STATICEDGE = 0x00020000L
$WS_EX_APPWINDOW = 0x00040000L
$WS_EX_LAYERED = 0x00080000
$WS_EX_NOINHERITLAYOUT = 0x00100000L
$WS_EX_NOREDIRECTIONBITMAP = 0x00200000L
$WS_EX_LAYOUTRTL = 0x00400000L
$WS_EX_COMPOSITED = 0x02000000L
$WS_EX_NOACTIVATE = 0x08000000L
$WS_EX_OVERLAPPEDWINDOW = $WS_EX_WINDOWEDGE -bor $WS_EX_CLIENTEDGE
$WS_EX_PALETTEWINDOW = $WS_EX_WINDOWEDGE -bor $WS_EX_TOOLWINDOW -bor $WS_EX_TOPMOST

Add-Type -Namespace PInvoke -Name Win32 -ReferencedAssemblies System.Drawing -MemberDefinition @"
    public struct POINT {
        public int X;
        public int Y;
        public POINT(int x, int y) {
            this.X = x;
            this.Y = y;
        }
        public POINT(System.Drawing.Point pt) : this(pt.X, pt.Y) { }
        public static implicit operator System.Drawing.Point(POINT p) {
            return new System.Drawing.Point(p.X, p.Y);
        }
        public static implicit operator POINT(System.Drawing.Point p) {
            return new POINT(p.X, p.Y);
        }
    }
    public struct RECT { public int left,top,right,bottom; }
    public struct WINDOWINFO {
        public uint cbSize;
        public RECT rcWindow;
        public RECT rcClient;
        public uint dwStyle;
        public uint dwExStyle;
        public uint dwWindowStatus;
        public uint cxWindowBorders;
        public uint cyWindowBorders;
        public ushort atomWindowType;
        public ushort wCreatorVersion;
        public WINDOWINFO(bool ?   filler)   :   this()   // Allows automatic initialization of "cbSize" with "new WINDOWINFO(null/true/false)".
        {
            cbSize = (UInt32)(Marshal.SizeOf(typeof( WINDOWINFO )));
        }
    }
    public enum ShowWindowCommands
    {
        Hide = 0,
        Normal = 1,
        ShowMinimized = 2,
        Maximize = 3, // is this the right value?
        ShowMaximized = 3,
        ShowNoActivate = 4,
        Show = 5,
        Minimize = 6,
        ShowMinNoActive = 7,
        ShowNA = 8,
        Restore = 9,
        ShowDefault = 10,
        ForceMinimize = 11
    }
    public struct WINDOWPLACEMENT {
        public int Length;
        public int Flags;
        public ShowWindowCommands ShowCmd;
        public POINT MinPosition;
        public POINT MaxPosition;
        public RECT NormalPosition;
        public static WINDOWPLACEMENT Default {
            get {
                WINDOWPLACEMENT result = new WINDOWPLACEMENT();
                result.Length = Marshal.SizeOf( result );
                return result;
            }
        }    
    }
    public enum GetAncestorFlags {
        GA_PARENT = 1,
        GA_ROOT = 2,
        GA_ROOTOWNER = 3
    }
    [DllImport("user32.dll")] public static extern int MoveWindow(IntPtr hWnd, int x, int y, int nWidth, int nHeight, int bRepaint);
    [DllImport("user32.dll")] public static extern bool GetWindowInfo(IntPtr hwnd, ref WINDOWINFO pwi);
    [DllImport("user32.dll")] public static extern uint GetWindowModuleFileName(IntPtr hwnd, System.Text.StringBuilder lpszFileName, uint cchFileNameMax);
    [DllImport("user32.dll")] public static extern bool GetWindowPlacement(IntPtr hWnd, out WINDOWPLACEMENT lpwndpl);
    [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);
    [DllImport("user32.dll")] public static extern int GetWindowText(IntPtr hWnd, System.Text.StringBuilder lpString, int nMaxCount);
    [DllImport("user32.dll")] public static extern int GetWindowTextLength(IntPtr hWnd);
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
    [DllImport("user32.dll")] public static extern IntPtr GetDesktopWindow();
    [DllImport("user32.dll")] public static extern IntPtr GetActiveWindow();
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern IntPtr GetTopWindow(IntPtr hWnd);
    [DllImport("user32.dll")] public static extern IntPtr GetNextWindow(IntPtr hWnd, int wCmd);
    [DllImport("user32.dll")] public static extern IntPtr GetWindow(IntPtr hWnd, uint uCmd);
    [DllImport("user32.dll", ExactSpelling = true)] public static extern IntPtr GetAncestor(IntPtr hwnd, GetAncestorFlags flags);
    //[DllImport("user32.dll")] public static extern bool EnumWindows(MulticastDelegate lpEnumFunc, IntPtr lParam);
    //public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
    //public delegate bool EnumWindowsProc(IntPtr hWnd, Int32 lParam);
    //[DllImport("user32.dll")] public static extern bool EnumDesktopWindows(IntPtr hDesktop, MulticastDelegate lpfn, IntPtr lParam);
    [DllImport("user32.dll")][return: MarshalAs(UnmanagedType.Bool)] public static extern bool IsWindowVisible(IntPtr hWnd);
    [DllImport("user32.dll", SetLastError=true)]public static extern IntPtr GetThreadDesktop(uint dwThreadId);
    [DllImport("kernel32.dll")] public static extern uint GetCurrentThreadId();
"@


## A PowerShell wrappers for win32 window api
##


function Move-Window([IntPtr]$hWnd, [Int32]$x, [Int32]$y, [Int32]$nWidth, [Int32]$nHeight, [Bool]$bRepaint)
{ 
    return [PInvoke.Win32]::MoveWindow($hWnd, $x, $y, $nWidth, $nHeight, $bRepaint)
}


function Get-WindowInfo([Int32]$hWnd)
{
    #$hrWnd = New-Object System.Runtime.InteropServices.HandleRef(0, $hWnd)
    $info = New-Object PInvoke.Win32+WINDOWINFO
    [PInvoke.Win32]::GetWindowInfo($hWnd, [ref]$info) | Out-Null
    return $info
}


<#
function Get-WindowModuleFileName([Int32]$hWnd)
{
    $hrWnd = New-Object System.Runtime.InteropServices.HandleRef(0, $hWnd)
    [PInvoke.Win32]::GetWindowModuleFileName($hWnd, [ref]$rect) | Out-Null
    return ...
}
#>


function Get-WindowPlacement([Int32]$hWnd)
{
    #$hrWnd = New-Object System.Runtime.InteropServices.HandleRef(0, $hWnd)
    $pl = New-Object PInvoke.Win32+WINDOWPLACEMENT
    [PInvoke.Win32]::GetWindowPlacement($hWnd, [ref]$pl) | Out-Null
    return $pl
    #return New-Object PSObject -Property @{ Flags = $pl.flags; ShowCmd = $pl.showCmd;
    #                                 MinPos = $pl.ptMinPosition; MaxPos = $pl.ptMaxPosition; NormPos =$pl.rcNormalPosition }
}


function Get-WindowRect([Int32]$hWnd)
{
    #$hrWnd = New-Object System.Runtime.InteropServices.HandleRef(0, $hWnd)
    $rect = New-Object PInvoke.Win32+RECT
    [PInvoke.Win32]::GetWindowRect($hWnd, [ref]$rect) | Out-Null
    return $rect
}

function Get-WindowRectangle([Int32]$hWnd)
{
    #$hrWnd = New-Object System.Runtime.InteropServices.HandleRef(0, $hWnd)
    $rect = New-Object PInvoke.Win32+RECT
    [PInvoke.Win32]::GetWindowRect($hWnd, [ref]$rect) | Out-Null
    return New-Object System.Drawing.Rectangle($rect.left, $rect.top, ($rect.right - $rect.left), ($rect.bottom - $rect.top))
}


function Get-WindowText([Int32]$hWnd)
{
    #$hrWnd = New-Object System.Runtime.InteropServices.HandleRef(0, $hWnd)
    $WindowTitleLength = [PInvoke.Win32]::GetWindowTextLength($hWnd) * 2
    $WindowTitleSB = New-Object Text.StringBuilder($WindowTitleLength)
    [PInvoke.Win32]::GetWindowText($hWnd, [Text.StringBuilder]$WindowTitleSB, $WindowTitleSB.Capacity) | Out-Null
    return $WindowTitleSB.ToString()
}


function Get-WindowThreadProcessId([Int32]$hWnd)
{
    #$hrWnd = New-Object System.Runtime.InteropServices.HandleRef(0, $hWnd)
    [UInt32]$ProcessId = 0
    $ThreadId = [PInvoke.Win32]::GetWindowThreadProcessId($hWnd, [ref]$ProcessId)
    return New-Object PSObject -Property @{ ProcessId = $ProcessId; ThreadId = $ThreadId }
}



function Get-DesktopWindow()
{ 
    return [PInvoke.Win32]::GetDesktopWindow()
}


function Get-ActiveWindow()
{ 
    return [PInvoke.Win32]::GetActiveWindow()
}


function Get-ForegroundWindow()
{ 
    return [PInvoke.Win32]::GetForegroundWindow()
}


function Get-TopWindow([Int32]$hWnd)
{ 
    return [PInvoke.Win32]::GetTopWindow($hWnd)
}


function Get-NextWindow([Int32]$hWnd)
{ 
    return [PInvoke.Win32]::GetWindow($hWnd, 2)
}




## get windows with each correspondent process
function Get-MainWindow
{
    ps | Where-Object {$_.mainwindowhandle -ne ""} | select name,mainwindowtitle,mainwindowhandle
}


function Get-MainWindow2
{
    ps | Where-Object {$_.mainwindowtitle -ne ""} | select name,mainwindowhandle
}


## get windows with each correspondent process, and select by window name
function Get-MainWindow-By-Name([String]$windowName)
{
    $proc = @(ps|where {$_.name -eq $windowName})
    $proc0 = $proc[0]
    if ($proc0 -eq $null) { "No " + $windowName + " window." | Write-Warning; return $false }
    return $proc0.mainwindowhandle
}


# a variation
function Get-AllWindows-By-GetWindow
{
    $hDeskWnd = Get-DesktopWindow
    $hWndList = @($hDeskWnd)
    $hCurrWnd = Get-TopWindow $hDeskWnd
    $i = 0
    while ($hCurrWnd -ne 0 -and $hCurrWnd -ne $null) {
        $hWndList += $hCurrWnd
        $hCurrWnd = Get-NextWindow $hCurrWnd
        $i += 1
    }
    return $hWndList
}





function Local:Get-DelegateType
{
            Param
            (
                [OutputType([Type])]
            
                [Parameter( Position = 0)]
                [Type[]]
                $Parameters = (New-Object Type[](0)),
            
                [Parameter( Position = 1 )]
                [Type]
                $ReturnType = [Void]
            )

            $Domain = [AppDomain]::CurrentDomain
            $DynAssembly = New-Object System.Reflection.AssemblyName('ReflectedDelegate')
            $AssemblyBuilder = $Domain.DefineDynamicAssembly($DynAssembly, 'Run')
            $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule('InMemoryModule', $false)

            $TypeBuilder = $ModuleBuilder.DefineType('MyDelegateType',
                                                     'Class, Public, Sealed, AnsiClass, AutoClass',
                                                     [MulticastDelegate])

            $ConstructorBuilder = $TypeBuilder.DefineConstructor('RTSpecialName, HideBySig, Public',
                                                                 'Standard',
                                                                 $Parameters)

            $ConstructorBuilder.SetImplementationFlags('Runtime, Managed')

            $MethodBuilder = $TypeBuilder.DefineMethod('Invoke',
                                                       'Public, HideBySig, NewSlot, Virtual',
                                                       $ReturnType,
                                                       $Parameters)

            $MethodBuilder.SetImplementationFlags('Runtime, Managed')
        
            Write-Output $TypeBuilder.CreateType()
}



#
# Define p/invoke method
#
function Define-PInvokeMethod(
            [string] $methodName,
			[string] $dllName,
			[Type] $returnType,
			[Type[]] $parameterTypes)
{
        $DynAssembly = New-Object System.Reflection.AssemblyName('PInvokeA')
        $AssemblyBuilder = [AppDomain]::CurrentDomain.DefineDynamicAssembly($DynAssembly, 'Run')
        $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule('PInvokeM', $False)
        $TypeBuilder = $ModuleBuilder.DefineType('PInvokeT', 'Public,Class,BeforeFieldInit')

        $TypeBuilder.DefinePInvokeMethod( $methodName,
                                          $dllName,
                                          'Public, Static',
                                          'Standard',
                                          $returnType,
                                          $parameterTypes,
                                          'Winapi',
                                          'Auto' ) | Out-Null

        return $TypeBuilder.CreateType()
}



#
# Define a PowerShell delegate for a callback function
#
function Get-DelegateOfCallback(
            [ScriptBlock] $Action,
			[Type] $returnType,
			[Type[]] $parameterTypes)
{        
        # Create a delegate type with callback function signature
        $DelegateType = Get-DelegateType $parameterTypes $returnType

        # Cast the scriptblock as a delegate created eariler
        return $Action -as $DelegateType
}




## get all toplevel windows
function Enum-Windows
{
        $User32 = Define-PInvokeMethod 'EnumWindows' 'user32.dll' ([Bool]) @([MulticastDelegate], [Int32])
                                         
        # This scriptblock will serve as the callback function "EnumWindowsProc"
        $Action = {
            # Define params in place of $args[0] and $args[1]
            # Note: These parameters need to match the params
            # of EnumWindowsProc.
            Param (
                [IntPtr] $hwnd,
                [Int32] $lParam
            )

            $Global:WindowHandleList += $hwnd

            # Returning true will allow EnumWindows to continue iterating through each window
            $True
        }

        $EnumWindowsProc = Get-DelegateOfCallback $Action ([Bool]) @([IntPtr], [Int32])

        # Store all of the window handles into a global variable.
        # This is only way the callback function (i.e. scriptblock)
        # will be able to communicate objects back to the PowerShell
        # session.
        $Global:WindowHandleList = @()

        # Finally, call EnumWindows
        $User32::EnumWindows($EnumWindowsProc, 0) | Out-Null

        $result = $Global:WindowHandleList
        Remove-Variable -Scope Global -Name WindowHandleList
        return $result
}

## get all toplevel windows on Desktop
function Enum-DesktopWindows([IntPtr] $hDesktop)
{
        #[CmdletBinding()]
        $User32 = Define-PInvokeMethod 'EnumDesktopWindows' 'user32.dll' ([Bool]) @([IntPtr], [MulticastDelegate], [Int32])

        # This scriptblock will serve as the callback function
        $Action = {
            Param (
                [IntPtr] $hwnd,
                [Int32] $lParam
            )

            $Global:WindowHandleList += $hwnd
            $True
        }
        $EnumWindowsProc = Get-DelegateOfCallback $Action ([Bool]) @([IntPtr], [Int32])

        $Global:WindowHandleList = @()
        $User32::EnumDesktopWindows($hDesktop, $EnumWindowsProc, 0) | Out-Null
        $result = $Global:WindowHandleList
        Remove-Variable -Scope Global -Name WindowHandleList
        return $result
}


function Enum-VisibleWindows
{
    return Enum-Windows | ? { [PInvoke.Win32]::IsWindowVisible($_) }
}


function Get-WindowSpec
{
    #[CmdletBinding()]
    Param (
        [Parameter(Position = 0, Mandatory = $True, ValueFromPipeline = $True)]
        [Int32[]]
        $WindowHandleList
    )
    
    BEGIN
    {
        $WindowSpecList = @()
    }
    
    PROCESS
    {
        $WindowHandleList | foreach {
            $hWnd = $_
            $WindowInfo = Get-WindowInfo $hWnd
            $WindowThreadProcessId = Get-WindowThreadProcessId $hWnd
            $WindowPlacement = Get-WindowPlacement $hWnd
            $WindowSpecList += New-Object PSObject -Property @{
                
                Handle = $hWnd
                ProcessId = $WindowThreadProcessId.ProcessId
                ThreadId = $WindowThreadProcessId.ThreadId
                
                Flags = $WindowPlacement.flags
                ShowCmd = $WindowPlacement.showCmd
                MinPos = $WindowPlacement.ptMinPosition
                MaxPos = $WindowPlacement.ptMaxPosition
                NormPos = $WindowPlacement.rcNormalPosition
                
                WindowRect = $WindowInfo.rcWindow
                ClientRect = $WindowInfo.rcClient
                
                IsTabStop = ($WindowInfo.dwStyle -band $WS_TABSTOP) -eq $WS_TABSTOP
                IsGroupHeader = ($WindowInfo.dwStyle -band $WS_GROUP) -eq $WS_GROUP
                HasMaximizeBox = ($WindowInfo.dwStyle -band $WS_MAXIMIZEBOX) -eq $WS_MAXIMIZEBOX
                HasMinimizeBox = ($WindowInfo.dwStyle -band $WS_MINIMIZEBOX) -eq $WS_MINIMIZEBOX
                HasSizingBorder = ($WindowInfo.dwStyle -band $WS_SIZEBOX) -eq $WS_SIZEBOX
                HasSystemMenu = ($WindowInfo.dwStyle -band $WS_SYSMENU) -eq $WS_SYSMENU
                HasHScroll = ($WindowInfo.dwStyle -band $WS_HSCROLL) -eq $WS_HSCROLL
                HasVScroll = ($WindowInfo.dwStyle -band $WS_VSCROLL) -eq $WS_VSCROLL 
                HasDialogFrame = ($WindowInfo.dwStyle -band $WS_DLGFRAME) -eq $WS_DLGFRAME
                HasBorder = ($WindowInfo.dwStyle -band $WS_BORDER) -eq $WS_BORDER
                HasCaption = ($WindowInfo.dwStyle -band $WS_CAPTION) -eq $WS_CAPTION
                MaximizedInit = ($WindowInfo.dwStyle -band $WS_MAXIMIZE) -eq $WS_MAXIMIZE
                ClipChildren = ($WindowInfo.dwStyle -band $WS_CLIPCHILDREN) -eq $WS_CLIPCHILDREN
                ClipSiblings = ($WindowInfo.dwStyle -band $WS_CLIPSIBLINGS) -eq $WS_CLIPSIBLINGS
                IsDisabled = ($WindowInfo.dwStyle -band $WS_DISABLED) -eq $WS_DISABLED
                VisibleInit = ($WindowInfo.dwStyle -band $WS_VISIBLE) -eq $WS_VISIBLE
                MinimizedInit = ($WindowInfo.dwStyle -band $WS_MINIMIZE) -eq $WS_MINIMIZE
                IsChild = ($WindowInfo.dwStyle -band $WS_CHILD) -eq $WS_CHILD
                IsPopup = ($WindowInfo.dwStyle -band $WS_POPUP) -eq $WS_POPUP
                IsOverlapped = ($WindowInfo.dwStyle -band $WS_OVERLAPPEDWINDOW) -eq $WS_OVERLAPPEDWINDOW
                
                HasModalFrame = ($WindowInfo.dwExStyle -band $WS_EX_DLGMODALFRAME) -eq $WS_EX_DLGMODALFRAME
                NoParentNotify = ($WindowInfo.dwExStyle -band $WS_EX_NOPARENTNOTIFY) -eq $WS_EX_NOPARENTNOTIFY
                IsTopmost = ($WindowInfo.dwExStyle -band $WS_EX_TOPMOST) -eq $WS_EX_TOPMOST
                AcceptDragDrop = ($WindowInfo.dwExStyle -band $WS_EX_ACCEPTFILES) -eq $WS_EX_ACCEPTFILES
                IsTransparent = ($WindowInfo.dwExStyle -band $WS_EX_TRANSPARENT) -eq $WS_EX_TRANSPARENT
                IsMDIChild = ($WindowInfo.dwExStyle -band $WS_EX_MDICHILD) -eq $WS_EX_MDICHILD
                IsToolWindow = ($WindowInfo.dwExStyle -band $WS_EX_TOOLWINDOW) -eq $WS_EX_TOOLWINDOW
                HasRaisedBorder = ($WindowInfo.dwExStyle -band $WS_EX_WINDOWEDGE) -eq $WS_EX_WINDOWEDGE
                HasSunkenBorder = ($WindowInfo.dwExStyle -band $WS_EX_CLIENTEDGE) -eq $WS_EX_CLIENTEDGE
                HasHelpBox = ($WindowInfo.dwExStyle -band $WS_EX_CONTEXTHELP) -eq $WS_EX_CONTEXTHELP
                SupportRightAligned = ($WindowInfo.dwExStyle -band $WS_EX_RIGHT) -eq $WS_EX_RIGHT
                SupportRTLReading = ($WindowInfo.dwExStyle -band $WS_EX_RTLREADING) -eq $WS_EX_RTLREADING
                SupportLeftScrollbar = ($WindowInfo.dwExStyle -band $WS_EX_LEFTSCROLLBAR) -eq $WS_EX_LEFTSCROLLBAR
                IsParentOfControls = ($WindowInfo.dwExStyle -band $WS_EX_CONTROLPARENT) -eq $WS_EX_CONTROLPARENT
                HasStaticBorder = ($WindowInfo.dwExStyle -band $WS_EX_STATICEDGE) -eq $WS_EX_STATICEDGE
                IsOnTaskbar = ($WindowInfo.dwExStyle -band $WS_EX_APPWINDOW) -eq $WS_EX_APPWINDOW
                IsLayered = ($WindowInfo.dwExStyle -band $WS_EX_LAYERED) -eq $WS_EX_LAYERED
                NoInheritLayout = ($WindowInfo.dwExStyle -band $WS_EX_NOINHERITLAYOUT) -eq $WS_EX_NOINHERITLAYOUT
                NoRedirectionBitmap = ($WindowInfo.dwExStyle -band $WS_EX_NOREDIRECTIONBITMAP) -eq $WS_EX_NOREDIRECTIONBITMAP
                IsLayoutRTL = ($WindowInfo.dwExStyle -band $WS_EX_LAYOUTRTL) -eq $WS_EX_LAYOUTRTL
                IsComposited = ($WindowInfo.dwExStyle -band $WS_EX_COMPOSITED) -eq $WS_EX_COMPOSITED
                NoActivate = ($WindowInfo.dwExStyle -band $WS_EX_NOACTIVATE) -eq $WS_EX_NOACTIVATE
                IsOverlappedWindow = ($WindowInfo.dwExStyle -band $WS_EX_OVERLAPPEDWINDOW) -eq $WS_EX_OVERLAPPEDWINDOW
                IsPaletteWindow = ($WindowInfo.dwExStyle -band $WS_EX_PALETTEWINDOW) -eq $WS_EX_PALETTEWINDOW
                
                Active = $WindowInfo.dwWindowStatus
                BorderX = $WindowInfo.cxWindowBorders
                BorderY = $WindowInfo.cyWindowBorders
                WindowClass = $WindowInfo.atomWindowType
                CreatorVersion = $WindowInfo.wCreatorVersion
                
                WindowTitle = Get-WindowText $hWnd
                
                RootWindow = [PInvoke.Win32]::GetAncestor($hWnd, [PInvoke.Win32+GetAncestorFlags]::GA_ROOTOWNER)
            }
        }
    }
    
    END
    {    
        return $WindowSpecList
    }
}




Set-Alias lswinps Get-MainWindow
Set-Alias lswinall Get-AllWindows-By-GetWindow
Set-Alias lswin Get-ToplevelWindows

#Get-WindowHandles
#Get-AllWindows

#(Enum-Windows).length #| Get-WindowSpec | select Handle,ProcessId,ThreadId,Flags,ShowCmd,Active,IsOnTaskbar,IsOverlapped,IsChild,IsPopup,WindowClass,WindowTitle | Out-GridView
#$hDesktop = [IntPtr]::Zero
#(Enum-DesktopWindows $hDesktop).length #| Get-WindowSpec | select Handle,ProcessId,ThreadId,Flags,ShowCmd,Active,IsOnTaskbar,IsOverlapped,IsChild,IsPopup,WindowClass,WindowTitle | Out-GridView
#Get-TopWindow (Get-DesktopWindow) | Get-WindowSpec | select Handle,ProcessId,ThreadId,Flags,ShowCmd,Active,IsOnTaskbar,IsOverlapped,IsChild,IsPopup,WindowClass,WindowTitle | Out-GridView
#Enum-Windows | Get-WindowSpec | ? { $_.Handle -eq $_.RootWindow -and $_.VisibleInit -and $_.WindowTitle -ne "" } | select Handle,ProcessId,ThreadId,RootWindow,Flags,ShowCmd,Active,IsOnTaskbar,IsOverlapped,IsChild,IsPopup,WindowClass,WindowTitle | Out-GridView
#Enum-Windows | Get-WindowSpec | ? { $_.IsOnTaskbar } | select Handle,ProcessId,ThreadId,RootWindow,Flags,ShowCmd,Active,IsOnTaskbar,IsOverlapped,IsChild,IsPopup,WindowClass,WindowTitle | Out-GridView
#Enum-Windows | Get-WindowSpec | ? { $_.VisibleInit -and $_.WindowTitle -ne "" } | select Handle,ProcessId,ThreadId,RootWindow,Flags,ShowCmd,Active,IsOnTaskbar,IsOverlapped,IsChild,IsPopup,WindowClass,WindowTitle | Out-GridView
#Enum-Windows | Get-WindowSpec | ? { $True } | select Handle,ProcessId,ThreadId,RootWindow,Flags,ShowCmd,Active,IsOnTaskbar,IsOverlapped,IsChild,IsPopup,WindowClass,WindowTitle | Out-GridView
Enum-VisibleWindows | Get-WindowSpec | ? { $True } | select Handle,ProcessId,ThreadId,RootWindow,Flags,ShowCmd,Active,IsOnTaskbar,IsOverlapped,IsChild,IsPopup,WindowClass,WindowTitle | Out-GridView
