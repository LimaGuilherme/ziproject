unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Zip, StrUtils,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TFormEasyZip = class(TForm)
    InputFolderImage: TImage;
    OutPutFolderImage: TImage;
    OpenDialog1: TOpenDialog;
    InputPath: TEdit;
    OpenDialog2: TOpenDialog;
    OutputPath: TEdit;
    DisabledCompactImage: TImage;
    InputPathText: TStaticText;
    OutputPathText: TStaticText;
    EnabledCompactImage: TImage;
    CloseImage: TImage;
    procedure InputFolderImageClick(Sender: TObject);
    procedure OutPutFolderImageClick(Sender: TObject);
    procedure InputFolderImageMouseEnter(Sender: TObject);
    procedure InputFolderImageMouseLeave(Sender: TObject);
    procedure OutPutFolderImageMouseLeave(Sender: TObject);
    procedure OutPutFolderImageMouseEnter(Sender: TObject);
    procedure EnabledCompactImageMouseEnter(Sender: TObject);
    procedure EnabledCompactImageMouseLeave(Sender: TObject);
    procedure DisabledCompactImageMouseEnter(Sender: TObject);
    procedure DisabledCompactImageMouseLeave(Sender: TObject);
    procedure CloseImageMouseEnter(Sender: TObject);
    procedure CloseImageMouseLeave(Sender: TObject);
    procedure Image4MouseEnter(Sender: TObject);
    procedure Image4MouseLeave(Sender: TObject);
    procedure EnabledCompactImageClick(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure CloseImageClick(Sender: TObject);
    procedure OutputPathChange(Sender: TObject);
    procedure InputPathChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure CompactMethod(inputDirectory: string; outputDirectory: string; filesFound: TStringList; searchResult: TSearchRec);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormEasyZip: TFormEasyZip;

implementation

{$R *.dfm}

procedure TFormEasyZip.FormCreate(Sender: TObject);
var
  regn: HRGN;
begin
  FormEasyZip.Borderstyle := bsNone;
  regn := CreateRoundRectRgn(0, 0,ClientWidth,ClientHeight,40,40);
  SetWindowRgn(Handle, regn, True);
end;


procedure TFormEasyZip.InputFolderImageClick(Sender: TObject);
begin
with TFileOpenDialog.Create(nil) do
  try
    Options := [fdoPickFolders];
    if Execute then
         InputPath.text:= StringReplace(FileName, '/', '\', [rfReplaceAll]);
         if InputPath.Text = '""' then
          InputPath.Text := ''
  finally
    Free;
  end;
end;

procedure TFormEasyZip.EnabledCompactImageClick(Sender: TObject);
var
  filesFound: TStringList;
  inputDirectory: String;
  outputDirectory: String;
  searchResult : TSearchRec;
  filesWithoutExtension: String;
  I: Integer;
begin
  inputDirectory := InputPath.Text;
  outputDirectory := OutputPath.Text;
  filesFound := TStringList.Create;
  try
    if findfirst(inputDirectory+ '\*', faAnyFile, searchResult) = 0 then
    begin
      repeat
        if (searchResult.Name <> '.') and (searchResult.Name <> '..') then
        begin
          filesWithoutExtension := ChangeFileExt(searchResult.Name, '');
          if not filesFound.Find(filesWithoutExtension, I) Then
            filesFound.Add(filesWithoutExtension);
        end;
      until FindNext(searchResult) <> 0;
    end;
    FindClose(searchResult);
  CompactMethod(inputDirectory, outputDirectory, filesFound, searchResult);
  finally
    FreeAndNil(filesFound);
  end;
end;

procedure TFormEasyZip.OutPutFolderImageClick(Sender: TObject);
begin
with TFileOpenDialog.Create(nil) do
  try
    Options := [fdoPickFolders];
    if Execute then
         OutputPath.text:= StringReplace(FileName, '/', '\', [rfReplaceAll]);
          if OutputPath.Text = '' then
          begin
          OutputPath.Text := '';
          EnabledCompactImage.Visible := False;
          end
          else
          EnabledCompactImage.Visible := True;
  finally
    Free;
  end;
end;

procedure TFormEasyZip.InputPathChange(Sender: TObject);
begin
if InputPath.Text = '' then
  EnabledCompactImage.Visible := False;
end;

procedure TFormEasyZip.OutputPathChange(Sender: TObject);
begin
if OutputPath.Text = '' then
  EnabledCompactImage.Visible := False;
end;

procedure TFormEasyZip.CompactMethod(inputDirectory: string; outputDirectory: string; filesFound: TStringList; searchResult: TSearchRec);
var
  I: Integer;
  ZipFile: TZipFile;
begin
  for I := 0 to filesFound.Count - 1 do
  begin
    ZipFile := TZipFile.Create;
    try
      ZipFile.Open(outputDirectory + '\' + filesFound.Strings[I] + '.zip', zmWrite);
      if findfirst(inputDirectory + '\' + filesFound.Strings[I] + '.*', faAnyFile, searchResult) = 0 then
      begin
        repeat
          ZipFile.add(inputDirectory + '\' + searchResult.Name);
        until (FindNext(searchResult) <> 0);
      end;
      FindClose(searchResult);
    finally
      FreeAndNil(ZipFile);
    end;
  end;
end;

procedure TFormEasyZip.Image5Click(Sender: TObject);
begin
  FormEasyZip.CloseModal;
end;

procedure TFormEasyZip.CloseImageClick(Sender: TObject);
begin
  FormEasyZip.Close;
end;

procedure TFormEasyZip.DisabledCompactImageMouseEnter(Sender: TObject);
begin
 Screen.Cursor := crNo;
end;

procedure TFormEasyZip.InputFolderImageMouseEnter(Sender: TObject);
begin
  Screen.Cursor := crHandpoint;
end;

procedure TFormEasyZip.InputFolderImageMouseLeave(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TFormEasyZip.OutPutFolderImageMouseEnter(Sender: TObject);
begin
  Screen.Cursor := crHandpoint;
end;

procedure TFormEasyZip.OutPutFolderImageMouseLeave(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TFormEasyZip.DisabledCompactImageMouseLeave(Sender: TObject);
begin
 Screen.Cursor := crDefault;
end;

procedure TFormEasyZip.Image4MouseEnter(Sender: TObject);
begin
  Screen.Cursor := crHandpoint;
end;

procedure TFormEasyZip.Image4MouseLeave(Sender: TObject);
begin
 Screen.Cursor := crDefault;
end;

procedure TFormEasyZip.EnabledCompactImageMouseEnter(Sender: TObject);
begin
  Screen.Cursor := crHandpoint;
end;

procedure TFormEasyZip.EnabledCompactImageMouseLeave(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TFormEasyZip.CloseImageMouseEnter(Sender: TObject);
begin
 Screen.Cursor := crHandPoint;
end;

procedure TFormEasyZip.CloseImageMouseLeave(Sender: TObject);
begin
 Screen.Cursor := crDefault;
end;

end.
