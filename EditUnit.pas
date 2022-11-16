unit EditUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,
  Vcl.DBCtrls, Vcl.ComCtrls, Data.DB, Data.Win.ADODB, Vcl.Menus,
  System.ImageList, Vcl.ImgList;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    StatusBar1: TStatusBar;
    DBNavigator1: TDBNavigator;
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    ImageList1: TImageList;
    Image1: TImage;
    procedure FormActivate(Sender: TObject);
    procedure DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
    procedure Image1Click(Sender: TObject);
    procedure DBEdit4KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N1Click(Sender: TObject);
    procedure ShowImage(img: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses Jpeg, IniFiles, StrUtils, MainUnit, GlobalUnit;

procedure TForm3.ShowImage(img: string);
begin

  if img = '' then
    img := 'nobody.jpg';
  try

    Form3.Image1.Picture.LoadFromFile(IMG_PATH + '\' + img);
  finally

  end;
end;

procedure TForm3.DBEdit4KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and (Length(DBEdit1.Text) > 0) then
    ShowImage(IMG_PATH + DBEdit1.Text)
  else
    Image1.Visible := false;
end;

procedure TForm3.DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
begin
  case Button of
    nbInsert, nbDelete, nbEdit:
      begin
        DBEdit1.ReadOnly := false;
        DBEdit2.ReadOnly := false;
        DBEdit3.ReadOnly := false;
        Image1.Enabled := True;
        if Button = nbInsert then
          ShowImage('nobody.jpg');
      end;
    nbPost, nbCancel:
      begin
        DBEdit1.ReadOnly := True;
        DBEdit2.ReadOnly := True;
        DBEdit3.ReadOnly := True;
        Image1.Enabled := false;
      end;
  end;
end;

procedure TForm3.FormActivate(Sender: TObject);
begin

  try
    Form3.StatusBar1.Panels[0].Text := ' ������: 1';
  except
    on e: Exception do
    begin
      DBEdit1.Enabled := false;
      DBEdit2.Enabled := false;
      DBNavigator1.Enabled := false;
      MessageDlg('������ ������� � ����� ��: ' + DB_PATH,
        mtError, [mbOk], 0);
    end;
  end;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Form1.ADODataSet1.State = dsEdit then
  begin
    Form1.ADODataSet1.UpdateBatch(arCurrent);
  end;
end;

procedure TForm3.Image1Click(Sender: TObject);
var
  nFileName: string;
begin
  OpenDialog1.FileName := '*.jpg';

  if OpenDialog1.Execute then
  begin

    nFileName := ExtractFileName(OpenDialog1.FileName);

    CopyFile(PChar(OpenDialog1.FileName),
      PChar(IMG_PATH + nFileName), false);
    ShowImage(nFileName);
    Form1.ADODataSet1.FieldValues['Picture'] := nFileName;

  end;

end;

procedure TForm3.N1Click(Sender: TObject);
begin
  Form1.Show();
  Hide();
end;

end.
