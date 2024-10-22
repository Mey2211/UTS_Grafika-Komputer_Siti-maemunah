unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;   // Ubah warna dinding
    Button2: TButton;   // Ubah warna atap
    Button3: TButton;   // Ubah warna pintu
    Button4: TButton;   // Perbesar gambar rumah
    Button5: TButton;   // Geser ke kanan
    Button6: TButton;   // Geser ke kiri
    Button7: TButton;   // Geser ke atas
    Button8: TButton;   // Geser ke bawah
    Button9: TButton;   // Rotasi gambar rumah
    Button10: TButton;  // Perkecil gambar rumah
    Button11: TButton;  // Ubah warna jendela
    Button12: TButton;  // Gambar rumah
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);   // Ubah warna dinding
    procedure Button2Click(Sender: TObject);   // Ubah warna atap
    procedure Button3Click(Sender: TObject);   // Ubah warna pintu
    procedure Button4Click(Sender: TObject);   // Perbesar gambar rumah
    procedure Button5Click(Sender: TObject);   // Geser ke kanan
    procedure Button6Click(Sender: TObject);   // Geser ke kiri
    procedure Button7Click(Sender: TObject);   // Geser ke atas
    procedure Button8Click(Sender: TObject);   // Geser ke bawah
    procedure Button9Click(Sender: TObject);   // Rotasi gambar rumah
    procedure Button10Click(Sender: TObject);  // Perkecil gambar rumah
    procedure Button11Click(Sender: TObject);  // Ubah warna jendela
    procedure Button12Click(Sender: TObject);  // Gambar rumah
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    wallColor, roofColor, doorColor, windowColor: TColor;
    scaleFactor, rotationAngle: Double;
    posX, posY: Integer;
    windowColorToggle: Boolean;
    doorColorToggle: Boolean;
    roofColorToggle: Boolean;
    wallColorToggle: Boolean;

     procedure DrawHouse;
    function RotatePoint(x, y, cx, cy: Integer; angle: Double): TPoint; // Fungsi untuk rotasi titik
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

// Fungsi untuk merotasi titik berdasarkan sudut relatif terhadap pusat rotasi (cx, cy)
function TForm1.RotatePoint(x, y, cx, cy: Integer; angle: Double): TPoint;
var
  radAngle: Double;
  dx, dy: Integer;
  rotatedX, rotatedY: Double;
begin
  radAngle := DegToRad(angle);
  dx := x - cx;
  dy := y - cy;
  rotatedX := cos(radAngle) * dx - sin(radAngle) * dy + cx;
  rotatedY := sin(radAngle) * dx + cos(radAngle) * dy + cy;
  Result := Point(Round(rotatedX), Round(rotatedY));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  wallColor := clYellow;  // Warna dinding awal: kuning
  roofColor := clRed;     // Warna atap awal: merah
  doorColor := clGray;  // Warna pintu awal: oranye
  windowColor := clBlue;  // Warna jendela awal: biru
  scaleFactor := 1.0;
  rotationAngle := 0.0;   // Sudut rotasi awal
  posX := 150;
  posY := 150;
  windowColorToggle := False;
  doorColorToggle := False;
  roofColorToggle := False;
  wallColorToggle := False;
  //klik pada Button12 untuk gambar rumah
end;

procedure TForm1.Label1Click(Sender: TObject);
begin

end;

procedure TForm1.DrawHouse;
var
  w, h, cx, cy: Integer;
  topLeft, topRight, bottomLeft, bottomRight: TPoint;
  roofLeft, roofRight, roofTop: TPoint;
  doorTopLeft, doorBottomRight: TPoint;
  windowLeftCenter, windowRightCenter: TPoint;
  windowLeftTopLeft, windowLeftBottomRight: TPoint;
  windowRightTopLeft, windowRightBottomRight: TPoint;
  windowSize: Integer;

begin
  // Membersihkan area gambar
  Panel1.Canvas.Brush.Color := clWhite;
  Panel1.Canvas.FillRect(Panel1.ClientRect);

  // Menentukan lebar dan tinggi rumah berdasarkan faktor skala
  w := Round(150 * scaleFactor);
  h := Round(70 * scaleFactor);
  cx := posX + w div 7;
  cy := posY + h div 3;

  // Dinding
  topLeft := RotatePoint(posX, posY, cx, cy, rotationAngle);
  topRight := RotatePoint(posX + w, posY, cx, cy, rotationAngle);
  bottomLeft := RotatePoint(posX, posY + h, cx, cy, rotationAngle);
  bottomRight := RotatePoint(posX + w, posY + h, cx, cy, rotationAngle);

  Panel1.Canvas.Brush.Color := wallColor;
  Panel1.Canvas.Pen.Color := clBlack;
  Panel1.Canvas.Polygon([topLeft, topRight, bottomRight, bottomLeft]);

  // Atap
  roofLeft := RotatePoint(posX, posY, cx, cy, rotationAngle);
  roofRight := RotatePoint(posX + w, posY, cx, cy, rotationAngle);
  roofTop := RotatePoint(posX + w div 2, posY - h div 2, cx, cy, rotationAngle);

  Panel1.Canvas.Brush.Color := roofColor;
  Panel1.Canvas.Polygon([roofLeft, roofRight, roofTop]);

  // Pintu
   doorTopLeft := RotatePoint(posX + w div 2 - w div 10, posY + h div 3, cx, cy, rotationAngle);
  doorBottomRight := RotatePoint(posX + w div 2 + w div 10, posY + h, cx, cy, rotationAngle);

  Panel1.Canvas.Brush.Color := doorColor;
  Panel1.Canvas.Rectangle(doorTopLeft.X, doorTopLeft.Y, doorBottomRight.X, doorBottomRight.Y);

  Panel1.Canvas.Brush.Color := doorColor;
  Panel1.Canvas.Rectangle(doorTopLeft.X, doorTopLeft.Y, doorBottomRight.X, doorBottomRight.Y);

  // Jendela kiri
  windowSize := Round(12 * scaleFactor);
  windowLeftCenter := RotatePoint(posX + w div 5, posY + h div 2, cx, cy, rotationAngle);
  windowLeftTopLeft := Point(windowLeftCenter.X - windowSize, windowLeftCenter.Y - windowSize);
  windowLeftBottomRight := Point(windowLeftCenter.X + windowSize, windowLeftCenter.Y + windowSize);

  // Jendela kanan
windowSize := Round(12 * scaleFactor);

windowRightCenter := RotatePoint(posX + 4 * w div 5, posY + h div 2, cx, cy, rotationAngle);
windowRightTopLeft := Point(windowRightCenter.X - windowSize, windowRightCenter.Y - windowSize);
windowRightBottomRight := Point(windowRightCenter.X + windowSize, windowRightCenter.Y + windowSize);

  Panel1.Canvas.Brush.Color := windowColor;
  // Menggambar jendela kiri
  Panel1.Canvas.Ellipse(windowLeftTopLeft.X, windowLeftTopLeft.Y, windowLeftBottomRight.X, windowLeftBottomRight.Y);
  // Menggambar jendela kanan
  Panel1.Canvas.Ellipse(windowRightTopLeft.X, windowRightTopLeft.Y, windowRightBottomRight.X, windowRightBottomRight.Y);
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  DrawHouse;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  // Ubah warna jendela antara biru dan hijau
  if windowColorToggle then
    windowColor := clBlue
  else
    windowColor := clGreen;
  windowColorToggle := not windowColorToggle;
  DrawHouse;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  // Perkecil ukuran rumah
  scaleFactor := scaleFactor - 0.1;
  if scaleFactor < 0.1 then
    scaleFactor := 0.1;  // Mencegah ukuran terlalu kecil
  DrawHouse;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  // Rotasi rumah
  rotationAngle := rotationAngle + 90;
  if rotationAngle >= 360 then
    rotationAngle := rotationAngle - 360;
  DrawHouse;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  // Geser rumah ke bawah
  posY := posY + 10;
  if posY > Panel1.Height then
    posY := -100; // Mengulang posisi
  DrawHouse;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  // Geser rumah ke atas
  posY := posY - 10;
  if posY < -100 then
    posY := Panel1.Height;
  DrawHouse;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  // Geser rumah ke kiri
  posX := posX - 10;
  if posX < -100 then
    posX := Panel1.Width;
  DrawHouse;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  // Geser rumah ke kanan
  posX := posX + 10;
  if posX > Panel1.Width then
    posX := -100;
  DrawHouse;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  // Perbesar ukuran rumah
  scaleFactor := scaleFactor + 0.1;
  DrawHouse;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  // Ubah warna pintu antara abu-abu dan pink
  if doorColorToggle then
    doorColor := clGray
  else
    doorColor := clFuchsia;
  doorColorToggle := not doorColorToggle;
  DrawHouse;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  // Ubah warna atap antara merah dan hijau
  if roofColorToggle then
    roofColor := clRed
  else
    roofColor := clGreen;
  roofColorToggle := not roofColorToggle;
  DrawHouse;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  // Ubah warna dinding antara kuning dan ungu
  if wallColorToggle then
    wallColor := clYellow
  else
    wallColor := clPurple;
  wallColorToggle := not wallColorToggle;
  DrawHouse;
end;

end.

