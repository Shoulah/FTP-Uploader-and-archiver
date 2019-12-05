unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls,
  FileCtrl, Registry, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdFTP, Dateutils, Vcl.ExtCtrls,
  IdAntiFreezeBase, IdAntiFreeze;

type
  TfrMain = class(TForm)
    StatusBar1: TStatusBar;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Edit4: TEdit;
    Button1: TButton;
    Edit5: TEdit;
    GroupBox4: TGroupBox;
    CheckBox1: TCheckBox;
    Button2: TButton;
    IdFTP1: TIdFTP;
    Timer1: TTimer;
    IdAntiFreeze1: TIdAntiFreeze;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    procedure SaveSettings;

    procedure LoadSettings;

    procedure StartProgramWithWindowsStartup(const Start: Boolean);

    function CheckFilesExists(const Directory: string;
      const FilesExtension: string): TStringList;

    procedure ConnectToFTPServer;

    procedure CreateOrOpenDirectoryOnFTPServer;

    procedure UploadFiles(const FilesList: TStringList);

    procedure DeleteLocalFiles(const FilesList: TStringList);

    procedure DoWork;
  public
    { Public declarations }
  end;

var
  frMain: TfrMain;

implementation

{$R *.dfm}

procedure TfrMain.Button1Click(Sender: TObject);
var
  myDirectory: string;
begin
  SelectDirectory('Please select target directory', '', myDirectory);

  if myDirectory[Length(myDirectory)] <> '\' then
  begin
    myDirectory := myDirectory + '\';
  end;

  if myDirectory <> '' then
  begin
    Edit4.Text := myDirectory;
  end;

end;

procedure TfrMain.Button2Click(Sender: TObject);
begin
  SaveSettings;
end;

procedure TfrMain.CheckBox1Click(Sender: TObject);
begin
  StartProgramWithWindowsStartup(CheckBox1.Checked);
end;

function TfrMain.CheckFilesExists(const Directory,
  FilesExtension: string): TStringList;
var
 mySearchRec : TSearchRec;
begin
  Result := TStringList.Create;

  FindFirst(Directory + '*.' + FilesExtension, faAnyFile, mySearchRec);
 repeat
  if mySearchRec.Name <> '' then
    begin
     Result.Add(Directory + mySearchRec.Name);
    end;

 until (FindNext(mySearchRec) <> 0);

 FindClose(mySearchRec);
end;

procedure TfrMain.ConnectToFTPServer;
begin
 IdFTP1.Host := Edit1.Text;
 IdFTP1.Username := Edit2.Text;
 IdFTP1.Password := Edit3.Text;
 try
   IdFTP1.Connect;
 except
  on E: Exception do
   ShowMessage(E.Message);

 end;
end;

procedure TfrMain.CreateOrOpenDirectoryOnFTPServer;
var
 I: Integer;
 myYear: string;
 myMonth :string;
 myDate :string;
 IsDirectoryExists: Boolean;
begin
 if IdFTP1.Connected then
 begin
   myYear := IntToStr(YearOf(Date));

   myMonth := FormatSettings.LongMonthNames[MonthOf(Date)];

   myDate := FormatDateTime('YYYYMMDD', Date);

   IdFTP1.List;
   for I := 0 to IdFTP1.DirectoryListing.Count -1 do
     begin
       if IdFTP1.DirectoryListing.Items[I].FileName =  myYear then
         begin
          IsDirectoryExists := True;
          Break;
         end;
     end;

   if not IsDirectoryExists then
      begin
        IdFTP1.MakeDir(myYear);
      end;

    IsDirectoryExists := False;
    IdFTP1.ChangeDir(myYear);
    IdFTP1.List;

    for I := 0 to IdFTP1.DirectoryListing.Count -1 do
     begin
       if IdFTP1.DirectoryListing.Items[I].FileName =  myMonth then
         begin
          IsDirectoryExists := True;
          Break;
         end;
     end;

   if not IsDirectoryExists then
      begin
        IdFTP1.MakeDir(myMonth);
      end;

    IsDirectoryExists := False;
    IdFTP1.ChangeDir(myMonth);
    IdFTP1.List;

   for I := 0 to IdFTP1.DirectoryListing.Count -1 do
     begin
       if IdFTP1.DirectoryListing.Items[I].FileName =  myDate then
         begin
          IsDirectoryExists := True;
          Break;
         end;
     end;

   if not IsDirectoryExists then
      begin
        IdFTP1.MakeDir(myDate);
      end;


    IdFTP1.ChangeDir(myDate);

 end;
end;

procedure TfrMain.DeleteLocalFiles(const FilesList: TStringList);
var
 I : Integer;
 Attributes : Word;
begin
 for I := 0 to FilesList.Count -1 do
   begin
     Attributes := FileGetAttr(FilesList.Strings[I], True);
     Attributes := Attributes - faReadOnly;
     FileSetAttr(FilesList.Strings[I], Attributes, True);
     DeleteFile(FilesList.Strings[I]);
   end;
end;

procedure TfrMain.DoWork;
var
 myFilesList : TStringList;
begin
 myFilesList := TStringList.Create;
 myFilesList := CheckFilesExists(Edit4.Text, Edit5.Text);

 if myFilesList.Count > 0 then
 begin

   ConnectToFTPServer;
   CreateOrOpenDirectoryOnFTPServer;
   UploadFiles(myFilesList);
   IdFTP1.Disconnect;
   DeleteLocalFiles(myFilesList);

 end;

 myFilesList.Free;

end;

procedure TfrMain.FormCreate(Sender: TObject);
begin
  LoadSettings;

  DoWork;

  Timer1.Enabled := True;
end;

procedure TfrMain.LoadSettings;
var
  myReg: TRegistry;
begin
  myReg := TRegistry.Create;

  try
    myReg.RootKey := HKEY_CURRENT_USER;

    if myReg.OpenKey('\Software\Shoulah\FTP Uplaoder', False) then
    begin
      if myReg.ValueExists('Host Name') then
      begin

        Edit1.Text := myReg.ReadString('Host Name');
      end;

      if myReg.ValueExists('User Name') then
      begin

        Edit2.Text := myReg.ReadString('User Name');
      end;

      if myReg.ValueExists('Password') then
      begin

        Edit3.Text := myReg.ReadString('Password');
      end;

      if myReg.ValueExists('Directory') then
      begin

        Edit4.Text := myReg.ReadString('Directory');
      end;

      if myReg.ValueExists('Files Extension') then
      begin

        Edit5.Text := myReg.ReadString('Files Extension');
      end;
    end;

    myReg.CloseKey;

    if myReg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', False)
    then
    begin
      CheckBox1.Checked := myReg.ValueExists('FTP Uploader');

    end;

    myReg.CloseKey;
  finally
    myReg.Free;
  end;

end;

procedure TfrMain.StartProgramWithWindowsStartup(const Start: Boolean);
var
  myReg: TRegistry;
begin
  myReg := TRegistry.Create;
  try
    myReg.RootKey := HKEY_CURRENT_USER;
    if myReg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', False)
    then
    begin
      if Start then
      begin
        myReg.WriteString('FTP Uploader', '"' + Application.ExeName + '"');
      end
      else
      begin
        if myReg.ValueExists('FTP Uploader') then
        begin
          myReg.DeleteValue('FTP Uploader');
        end;
      end;
    end;
    myReg.CloseKey;
  finally
    myReg.Free;
  end;
end;

procedure TfrMain.Timer1Timer(Sender: TObject);
begin
 Timer1.Enabled := False;

  DoWork;

 Timer1.Enabled := True;

end;

procedure TfrMain.UploadFiles(const FilesList: TStringList);
var
 I : Integer;
begin
if IdFTP1.Connected then
 begin
 for I := 0 to FilesList.Count -1 do
 begin
   IdFTP1.Put(FilesList.Strings[I], ExtractFileName(FilesList.Strings[I]), False, 0);
 end;
 end;

end;

procedure TfrMain.SaveSettings;
var
  myReg: TRegistry;
begin
  myReg := TRegistry.Create;
  try
    // By default, RootKey is set to HKEY_CURRENT_USER when the registry object is created
    myReg.RootKey := HKEY_CURRENT_USER;
    // -- Open key and create it if it not exists
    myReg.OpenKey('\Software\Shoulah\FTP Uplaoder', True);

    myReg.WriteString('Host Name', Edit1.Text);

    myReg.WriteString('User Name', Edit2.Text);

    myReg.WriteString('Password', Edit3.Text);

    myReg.WriteString('Directory', Edit4.Text);

    myReg.WriteString('Files Extension', Edit5.Text);

    myReg.CloseKey;
  finally
    // Destroys myReg object and frees its associated memory, if necessary.
    myReg.Free;
  end;
end;

end.
