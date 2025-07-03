; -- instance_c_installer.iss --

[Setup]
AppName=instance_c
AppVersion=1.0.0
DefaultDirName={autopf}\instance_c
DefaultGroupName=instance_c
UninstallDisplayIcon={app}\instance_c.exe
OutputBaseFilename=instance_c_Installer
Compression=lzma
SolidCompression=yes
DisableDirPage=no
ArchitecturesInstallIn64BitMode=x64compatible

AllowNoIcons=true

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "C:\Users\mc-three\Desktop\flutter-local-sync-example\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs

[Icons]
Name: "{group}\instance_c"; Filename: "{app}\instance_c.exe"
Name: "{commondesktop}\instance_c"; Filename: "{app}\instance_c.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional icons:"; Flags: unchecked

[Run]
Filename: "{app}\instance_c.exe"; Description: "Launch instance_c"; Flags: nowait postinstall skipifsilent
