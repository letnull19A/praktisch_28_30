unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Data.Win.ADODB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Menus, Vcl.Buttons,
  Vcl.ComCtrls, System.ImageList, Vcl.ImgList;

type
  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    ADOConnection1: TADOConnection;
    ADODataSet1: TADODataSet;
    DataSource1: TDataSource;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N21: TMenuItem;
    Header: TPanel;
    Content: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    BitBtn1: TBitBtn;
    N4: TMenuItem;
    Word1: TMenuItem;
    Excel1: TMenuItem;
    ImageList1: TImageList;
    Panel1: TPanel;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure Excel1Click(Sender: TObject);
    procedure Word1Click(Sender: TObject);
    procedure ADODataSet1AfterScroll(DataSet: TDataSet);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses EditUnit, GlobalUnit, ComObj;

procedure TForm1.ADODataSet1AfterScroll(DataSet: TDataSet);
var
  img: string;
begin
  if Form1.ADODataSet1.RecNo <> -1 then
  begin
    Form3.StatusBar1.Panels[0].Text := ' ������: ' +
      IntToStr(Form1.ADODataSet1.RecNo);

    if Form1.ADODataSet1.FieldValues['Picture'] <> Null then
      img := Form1.ADODataSet1.FieldValues['Picture']
    else
      img := '';

    Form3.ShowImage(img);
  end
  else
    Form3.StatusBar1.Panels[0].Text := ' ����� ������'
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ADODataSet1.Close;
  ADODataSet1.CommandText := 'SELECT * FROM Contacts WHERE Name Like ''%' +
    Edit1.Text + '%''';
  ADODataSet1.Open;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ADODataSet1.Close;
  ADODataSet1.Filtered := False;
  ADODataSet1.CommandText := 'SELECT * FROM contacts ORDER BY name';
  ADODataSet1.Open;
end;

procedure TForm1.DBGrid1TitleClick(Column: TColumn);
begin
  ADODataSet1.Open;

  if ADODataSet1.Sort = Column.FieldName + ' ASC' then
    ADODataSet1.Sort := Column.FieldName + ' DESC'
  else
    ADODataSet1.Sort := Column.FieldName + ' ASC';
end;

procedure TForm1.Excel1Click(Sender: TObject);
var
  Sheet, Column, Row: Variant;
  XLApp: OleVariant;
  index, i, j: integer;
begin

  XLApp := CreateOleObject('Excel.Application');

  XLApp.Visible := true;
  XLApp.Workbooks.Add(-4167);
  XLApp.Workbooks[1].WorkSheets[1].Name := '�����';

  // Column := XLApp.Workbooks[1].WorkSheets.Item[1].Columns;
  // =>
  // Column := XLApp.Workbooks[1].Sheets.Item[1].Columns;

  Column := XLApp.Workbooks[1].Sheets.Item[1].Columns;

  Column.Columns[1].ColumnWidth := 20;
  Column.Columns[2].ColumnWidth := 20;
  Column.Columns[3].ColumnWidth := 20;
  Column.Columns[4].ColumnWidth := 20;
  Column.Columns[5].ColumnWidth := 20;

  Row := XLApp.Workbooks[1].Sheets.Item[1].Rows;

  Row.Rows[2].Font.Bold := true;
  Row.Rows[1].Font.Bold := true;
  Row.Rows[1].Font.Color := clBlue;
  Row.Rows[1].Font.Size := 14;

  Sheet := XLApp.Workbooks[1].Sheets.Item[1];

  Sheet.Cells[1, 2] := '��������';
  Sheet.Cells[2, 1] := '���';
  Sheet.Cells[2, 2] := '�������';
  Sheet.Cells[2, 3] := 'E-Mail';
  Sheet.Cells[2, 4] := '�����������';

  index := 3;
  ADODataSet1.First;

  for i := 1 to ADODataSet1.RecordCount do
  begin
    for j := 1 to DBGrid1.Columns.Count do
      Sheet.Cells[index, j] := DBGrid1.Fields[j - 1].AsString;
    Inc(index);
    ADODataSet1.Next;
  end;

end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  //try
    ADOConnection1.Connected := true;
    ADOConnection1.Open();
    ADODataSet1.Active := true;
  //except
  //  on e: Exception do
  //  begin
  //    DBGrid1.Enabled := False;
  //    MessageDlg('������ ������� � ��! ' + DB_PATH, mtError, [mbok], 0);
  //  end;
  //end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (DBGrid1.EditorMode) then
  begin
    ADODataSet1.UpdateBatch(arCurrent);
  end;
end;

procedure TForm1.N21Click(Sender: TObject);
begin
  Form3.Show();
  Hide();
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Word1Click(Sender: TObject);
var
  doc, varcol: Variant;
  WordApp: OleVariant;
begin

  try
    WordApp := CreateOleObject('Word.Application');
    doc := WordApp.documents.Open(ExtractFilePath(Application.ExeName) + TEMPLATE_PATH);
    WordApp.ActiveDocument.SaveAs(ExtractFilePath(Application.ExeName) + REPORT_PATH);


    for var i := 2 to ADODataSet1.RecordCount + 1 do
    begin
      WordApp.ActiveDocument.Tables.Item(1).Cell(i, 1).Range.Text :=
        ADODataSet1.FieldByName('Name').AsString;
      WordApp.ActiveDocument.Tables.Item(1).Cell(i, 2).Range.Text :=
        ADODataSet1.FieldByName('Phone').AsString;
      WordApp.ActiveDocument.Tables.Item(1).Cell(i, 3).Range.Text :=
        ADODataSet1.FieldByName('E-mail').AsString;
      WordApp.ActiveDocument.Tables.Item(1).Cell(i, 4).Range.Text :=
        ADODataSet1.FieldByName('Picture').AsString;

      ADODataSet1.Next();
    end;

  finally
    WordApp.Visible := true;
    WordApp.Selection.GoTo(-1, unAssigned, unAssigned, 'FIO');
    WordApp.Selection.TypeText('Wolkow Alexej');
    WordApp.Selection.GoTo(-1, unAssigned, unAssigned, 'Date');
    WordApp.Selection.TypeText(FormatDateTime('dddddd', Date));
    WordApp := unAssigned;
  end;
end;

end.
