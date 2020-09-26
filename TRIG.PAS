Program Unit_Circle;

Uses Crt,Graph,grdriver,grfont;

Var
x,y:integer;
numstring:string;
degreestring:string[10];
Degrees,Radians:real;
MaxX,MaxY:integer;
numchoice:char;
exitdg,redraw: boolean;
S: array [1..10] of char;
index:byte;
c,code,error:integer;
pie:boolean;
choice: char;
number: real;
tempstr :string;
negative:boolean;
num1,num2:real;
{--------------------------------------------------------------------------}

Procedure Initialize;

VAR grDriver,grMode: integer;
    Gd, Gm: Integer;
    Size: Word;
    Color: Byte;
Begin
DetectGraph(grDriver,grMode);
initgraph(grdriver,grmode,'');
MaxX:=GetMaxX;
MaxY:=GetMaxY;
sound(1);
nosound;
ClearDevice;
End;
{--------------------------------------------------------------------------}
function TestEsc: boolean;
var choice: char;
begin
 if keypressed then
  begin
  if readkey=#27 then
   begin
   ClearDevice;
   CloseGraph;
   nosound;
   TestEsc:=True;
   end
  else
   TestEsc:=False;
  end
 else
  TestEsc:=False;
end; {TestEsc}
{--------------------------------------------------------------------------}
function readinput(message: string; valid: char; min,max: integer; var outstr: string): boolean;
var
 escape,enter: boolean;
 key: char;

 function TestLength: boolean;

  procedure TestKey;
  var good: boolean;
  begin
  if valid='A' then
   begin
   good:=key in ['A'..'Z','a'..'z',' ','.','-'];
   end
  else
   if valid='1' then
    begin
    good:=key in ['0'..'9','*','/','.'];
    end
   else
    if valid='p' then
     begin
     good:=key in ['0'..'9','*','/','p'];
     end;
  if (length(outstr)=0) and (key='-') then
   good:=true;
  if good then
   begin
   outstr:=outstr+key;
   write(key);
   end;
  end; {TestKey}

 begin
  if key=#27 then
   begin
   escape:=true;
   TestLength:=false;
   end
  else {key<>#27}
   if key=#13 then
    begin
    TestLength:=True;
    if max=0 then {use strict length of min}
     begin
     if length(outstr)=min then
      enter:=True
     else
      begin
      enter:=False; {starts it over}
      writeln;
      writeln('invalid length - must be EXACTLY ',min,' characters long');
      end;
     end
    else {max<>0 and min<>0}
     begin
     if (length(outstr)>=min) and (length(outstr)<=max) then
      enter:=True
     else
      begin
      enter:=false; {starts it over}
      writeln;
      writeln('invalid length - must be from ',min,' to ',max,' characters long');
      end;
     end;
    end
   else {key<>#13}
    begin
    if key=#8 then
     begin
     if length(outstr)>0 then
      begin
      TestLength:=False;
      outstr[0]:=chr(ord(outstr[0])-1);
      write(#8);
      write(#0);
      write(#8);
      end
     else
      TestLength:=False;
     end
    else {key<>#8}
     begin
     TestLength:=False;
     if max=0 then
      begin
      if length(outstr)<=min-1 then
       TestKey;
      end
     else {max<>0}
      begin
      if length(outstr)<=max-1 then
       TestKey;
      end;
     end;
    end;
 end; {TestInput}

begin
 repeat
  enter:=false;
  escape:=false;
  fillchar(outstr,sizeof(outstr),#0);
  outstr[0]:=#0;
  write(message);
  repeat
   key:=readkey;
  until TestLength or escape;
 until enter xor escape;
 readinput:=enter;
 writeln;
end; {readinput}

{--------------------------------------------------------------------------}

Procedure DrawGraph;
Var
 h2,v2,Horizontal,Vertical:integer;
 Arcunit,Arcunit2: integer;

Begin
 exitdg:=false;
 SetColor(8);
 Horizontal:=240;
 h2:=240;
 Vertical:=320;
 v2:=320;
 setlinestyle(0,0,1);
 repeat
   line(0,h2,640,h2);
   Line(0,Horizontal,640,Horizontal);
   Horizontal:=Horizontal+20;
   h2:=h2-20;
 Until Horizontal>480;
line(0,479,640,479);
 if TestEsc then exit;
 Repeat
   line(v2,0,v2,480);
   Line(Vertical,0,Vertical,480);
   Vertical:=Vertical+20;
   v2:=v2-20;
 Until Vertical>640;
line(639,0,639,480);
 if TestEsc then exit;
 Setcolor(3);
 SetLineStyle(0,0,3);
 Line(320,0,320,480);
 Line(0,240,640,240);
 Setcolor(4);
 Arcunit2:=0;
 if TestEsc then exit;
 If redraw = false then
 For Arcunit:=1 to 360 do
   Begin
   Sound(Arcunit+50);
   Delay(10);
   if TestEsc then
    begin
    exitdg:=true;
    exit;
    end
   else
    Arc(320,240,arcunit2,arcunit,200);
   Inc(arcunit2);
   End
 Else
 circle(320,240,200);
 NoSound;
 settextstyle(1,0,3);
 SetFillStyle(1,1);
 if TestEsc then exit;
End;
{---------------------------------------------------------------------}
procedure read_pi_or_degrees_input_from_the_keyboard;
             {There's your meaningful Identifier Nya!!!!}
begin        {Andy, let the user enter a decimal point if radians not in pi}
 repeat
  negative:=false;
  write('Do you want to input degrees or radians? (d/r): ');
  choice:=readkey;
  if choice=#27 then exit;
  writeln(choice);            {input degrees or radian}
  choice:=upcase(choice);
 until choice in ['D','R'];

 if choice='D' then
  begin
  if readinput('Please enter the degree measure: ','1',1,10,tempstr) then
   val(tempstr,radians,code)
  else
   exit;
  radians:=radians*pi/180;
  If radians<0 then
    radians:=radians* -1;
  end
 else
  begin                              {or if you chose radians}
  write('Do you want to enter in terms of г?  Y/N  ');
  choice:=readkey;
  if choice=#27 then exit;
  writeln(choice);

  If upcase(choice)='Y' then     {if you use г}
  Begin
  Writeln('Use p for г.   ( i.e. 2*p/3 )');
  if readinput('Please enter the value of the angle in radians: ','p',1,10,tempstr) then
   for c:=1 to 10 do
    s[c]:=tempstr[c]
  else
   exit;
  index:=1;
  num1:=1;
  num2:=1;
  numstring:='';
  pie:=false;
  repeat
    If s[index] in ['0'..'9'] then
      numstring:=numstring+s[index]
    Else if s[index] in ['*','/'] then
      begin
      If pie=false then
       val(numstring,num1,error);
      end
    Else if s[index]='p' then
      begin
      pie:=true;
      numstring:='';
      end
    else if s[index]='-' then
      negative:=true;

    inc(index);
  until index>length(tempstr);
  If numstring<>'' then
    val(numstring,num2,error);

    radians:=num1*pi/num2;

  If negative=true then
    radians:=radians* -1;
  end

  else
  begin
  if readinput('Please enter the measurement in radians: ','1',1,10,tempstr) then
   val(tempstr,radians,code)
  else
   exit;
  if TestEsc then exit;
  If radians<0 then
    negative:=true;
  end;
  end;
End;

{-----------------------------------------------------------------------}
Procedure Intro;

Begin
 clrscr;
redraw:=false;
Writeln;
Writeln('Unit Circle':45);
Writeln;Writeln;Writeln;
Writeln('Created by:':45);
Writeln('Max Bottiger, Peter Schwartz, and Andrew Wilson':63);
Writeln;
Writeln('Copyright 1996':47);
Writeln;
Writeln;
Writeln;
Writeln;
Writeln('1:  Introduction to trig and a brief tutorial');
Writeln('2:  Convert between radian and degree measues');
Writeln('3:  Reference angles');
Writeln('4:  Sectors, and segments');
Writeln('5:  Quit');
Writeln;
Write('Please enter the number of your choice:  ');
End;

{---------------------------------------------------------------------------}

Procedure Tutorial;
Var
x,y:integer;
count:byte;
Begin
initialize;
settextstyle(1,0,3);
setcolor(7);
outtextxy(10,100,'In its simpelest definition trigonometry is the study');
outtextxy(10,120,'of angles and triangles.  In this and the following');
outtextxy(10,140,'sections we will show you the very basics of trig.');
outtextxy(10,160,'Press ENTER to begin with a tutorial of:');
OutTextXY(250,200,'The Unit Circle.');
if readkey=#27 then exit;
cleardevice;
DrawGraph;
if TestEsc or exitdg then exit;
Bar(0,0,maxx,35);
SetColor(15);
SetTextStyle(1,0,3);
OutTextXY(10,5,'This is the Unit Circle.');
if TestEsc then exit;
Delay(2500);
OutTextXY(287,5,'It has a radius of 1.');
x:=round(320+((cos(pi/4))*200));
y:=round(240-((sin(pi/4))*200));
SetColor(14);
Line(320,240,x,y);
if TestEsc then exit;
Delay(2500);
Bar(0,0,maxx,35);
Line(320,240,520,240);
SetColor(15);
OutTextXY(10,5,'This is standard position.');
if TestEsc then exit;
Delay(2500);
Bar(0,0,maxx,35);
OutTextXY(10,5,'This is the initial side,');
Count:=0;
Repeat
SetColor(3);
Line(320,240,520,240);
Delay(250);
SetColor(14);
Line(320,240,520,240);
Delay(250);
Count:=Count+1;
if TestEsc then exit;
Until Count=10;
Count:=0;
SetColor(15);
OutTextXY(290,5,'and this is the terminal side.');
Repeat
SetColor(0);
Line(320,240,x,y);
Delay(250);
SetColor(14);
Line(320,240,x,y);
Delay(250);
Count:=Count+1;
if TestEsc then exit;
Until Count=10;
Count:=0;
Bar(0,0,maxx,35);
SetColor(15);
OutTextXY(10,5,'This is the intercepted arc.');
Repeat
SetColor(4);
Arc(320,240,0,45,200);
Delay(250);
SetColor(5);
Arc(320,240,0,45,200);
Delay(250);
Count:=Count+1;
if TestEsc then exit;
Until Count=10;
count:=0;
setcolor(15);
Bar(0,0,maxx,35);
outtextxy(10,5,'The measure of the arc is equal to the measure');
if TestEsc then exit;
delay(3000);
Bar(0,0,maxx,35);
outtextxy(10,5,'of the internal angle (in radians) times the radius.');
setcolor(11);
arc(320,240,0,45,50);
outtextxy(380,200,'г/4');
if TestEsc then exit;
delay(3000);
setcolor(11);
outtextxy(400,255,'Radius = 1');
delay(1000);
outtextxy(490,130,'г/4');
if TestEsc then exit;
delay(3500);
cleardevice;
redraw:=true;
setlinestyle(0,0,1);
drawgraph;
if TestEsc or exitdg then exit;
bar(0,0,maxx,35);
x:=round(320+((cos(1))*200));
y:=round(240-((sin(1))*200));
Setcolor(14);
line(320,240,x,y);
line(320,240,520,240);
if TestEsc then exit;
setcolor(5);
arc(320,240,0,round(180/pi),200);
setcolor(15);
outtextxy(380,200,'1 Radian');
outtextxy(10,5,'The radian is the basic');
if TestEsc then exit;
delay(2000);
Bar(0,0,maxx,35);
outtextxy(10,5,'measurement of the unit circle.');
if TestEsc then exit;
delay(2000);
Bar(0,0,maxx,35);
outtextxy(10,5,'1 radian is equal to 180/г degrees');
if TestEsc then exit;
delay(2000);
setcolor(0);
line(320,240,x,y);
setcolor(5);
arc(320,240,0,180,200);
setcolor(14);
line(320,240,120,240);
setcolor(14);
Bar(0,0,maxx,35);
setcolor(15);
outtextxy(10,5,'Therefore г radians');
outtextxy(300,150,'г radians');
setcolor(0);
outtextxy(380,200,'1 Radian');
if TestEsc then exit;
delay(2000);
setcolor(15);
Bar(0,0,maxx,35);
outtextxy(10,5,'equals 180 degrees');
outtextxy(310,200,'180ш');
if TestEsc then exit;
delay(3000);
cleardevice;
setlinestyle(0,0,1);
DrawGraph;
if TestEsc or exitdg then exit;
setcolor(15);
Bar(0,0,maxx,35);
OutTextXY(10,5,'Coterminal angles are angles that have the same');
if TestEsc then exit;
delay(3000);
Bar(0,0,maxx,35);
SetColor(15);
OutTextXY(10,5,'terminal side.');
setcolor(5);
Circle(320,240,200);
Arc(320,240,0,45,190);
if TestEsc then exit;
SetColor(14);
x:=round(320+((cos(pi/4))*200));
y:=round(240-((sin(pi/4))*200));
Line(320,240,520,240);
SetColor(2);
setlinestyle(1,1,3);
Line(320,240,420,240);
setlinestyle(0,0,3);
if TestEsc then exit;
SetColor(14);
Line(320,240,x,y);
SetColor(2);
Line(320,240,x-70,y+70);
SetLineStyle(1,1,3);
SetColor(14);
Line(320,240,x-70,y+70);
SetColor(2);
Arc(320,240,0,45,100);
count:=0;
if TestEsc then exit;
repeat
SetColor(2);
Line(320,240,x-70,y+70);
SetColor(0);
Line(x-70,y+70,x,y);
if TestEsc then exit;
Delay(250);
SetColor(14);
Line(x-70,y+70,x,y);
SetLineStyle(1,1,3);
Line(320,240,x-70,y+70);
if TestEsc then exit;
Delay(250);
SetLineStyle(0,0,3);
inc(count);
until count=6;
setcolor(15);
Bar(0,0,maxx,35);
OutTextXY(10,5,'The measure of the coterminal angle');
delay(3000);
Bar(0,0,maxx,35);
if TestEsc then exit;
SetColor(15);
OutTextXY(10,5,'is а = а + 360kш.');
SetColor(2);
OutTextXY(340,210,'аш');
SetColor(14);
OutTextXY(460,180,'аш + 360kш');
if TestEsc then exit;
Delay(2500);
setlinestyle(0,0,1);
cleardevice;
drawgraph;
if TestEsc or exitdg then exit;
setcolor(15);
bar(0,0,maxx,35);
outtextxy(10,5,'Next we''ll talk about reference angles.');
if TestEsc then exit;
delay(2500);
bar(0,0,maxx,35);
outtextxy(10,5,'A reference angle is the acute angle formed from by');
if TestEsc then exit;
delay(2500);
bar(0,0,maxx,35);
outtextxy(10,5,'an angle in standard position,');
setcolor(14);
line(320,240,520,240);
x:=round(320+((cos(5*pi/4))*200));
y:=round(240-((sin(5*pi/4))*200));
line(320,240,x,y);
setcolor(5);
arc(320,240,0,225,200);
setcolor(15);
outtextxy(170,180,'а');
if TestEsc then exit;
Delay(3000);
outtextxy(390,5,'and the x axis.');
count:=0;
outtextxy(70,340,'а - г');
repeat
setcolor(2);
line(320,240,120,240);
line(320,240,x,y);
arc(320,240,180,225,200);
if TestEsc then exit;
delay(200);
setcolor(3);
line(320,240,120,240);
setcolor(14);
line(320,240,x,y);
setcolor(4);
arc(320,240,180,225,200);
if TestEsc then exit;
delay(200);
inc(count);
until count=10;
{}{}{}{{_______--]}
cleardevice;
drawgraph;
if TestEsc or exitdg then exit;
bar(0,0,maxx,35);
setcolor(15);
outtextxy(10,5,'Until now we have only looked at the length of');
if TestEsc then exit;
delay(3000);
bar(0,0,maxx,35);
outtextxy(10,5,'angles and sides. It is now time to look at areas.');
if TestEsc then exit;
delay(3000);
bar(0,0,maxx,35);
outtextxy(10,5,'The first division of area of a circle is the sector.');
if TestEsc then exit;
delay(3000);
bar(0,0,maxx,35);
outtextxy(10,5,'A sector is the region bounded by a central angle');
if TestEsc then exit;
Delay(3000);
setcolor(14);
line(320,240,520,240);
x:=round(320+((cos(3*pi/4))*200));
y:=round(240-((sin(3*pi/4))*200));
line(320,240,x,y);
SetColor(5);
Arc(320,240,0,135,200);
Count:=0;
if TestEsc then exit;
Delay(250);
Repeat
SetColor(0);
Line(320,240,x,y);
SetColor(3);
Line(320,240,520,240);
if TestEsc then exit;
Delay(250);
SetColor(14);
Line(320,240,x,y);
Line(320,240,520,240);
if TestEsc then exit;
Delay(250);
inc(Count);
Until count=7;
setcolor(15);
bar(0,0,maxx,35);
outtextxy(10,5,'and its intercepted arc.');
Count:=0;
Repeat
SetColor(4);
Arc(320,240,0,135,200);
if TestEsc then exit;
Delay(250);
setcolor(5);
arc(320,240,0,135,200);
if TestEsc then exit;
delay(250);
inc(Count);
Until Count=10;
setcolor(15);
bar(0,0,maxx,35);
outtextxy(10,5,'The area of the sector is equal to');
setfillstyle(1,14);
if TestEsc then exit;
setlinestyle(0,0,1);
setfillstyle(1,10);
pieslice(320,240,0,135,200);
setfillstyle(1,1);
setlinestyle(0,0,3);
setcolor(14);
line(320,240,520,240);
line(320,240,x,y);
setcolor(5);
arc(320,240,0,135,200);
if TestEsc then exit;
delay(1500);
setcolor(15);
setfillstyle(1,1);
if TestEsc then exit;
delay(3000);
bar(0,0,maxx,35);
outtextxy(10,5,'« * the radius squared * the central angle («rэа).');
if TestEsc then exit;
outtextxy(420,250,'Radius = 1');
if TestEsc then exit;
delay(1000);
setcolor(0);
arc(320,240,0,135,50);
outtextxy(400,210,'3г/4');
if TestEsc then exit;
delay(1000);
setcolor(15);
outtextxy(490,80,'Area = 3г/8');
if TestEsc then exit;
delay(3000);
cleardevice;
drawgraph;
if TestEsc or exitdg then exit;
setcolor(15);
bar(0,0,maxx,35);
outtextxy(10,5,'The final topic and the other type of area division');
if TestEsc then exit;
delay(3000);
bar(0,0,maxx,35);
outtextxy(10,5,'of the unit circle is the segment.  A segment is ');
if TestEsc then exit;
delay(3000);
bar(0,0,maxx,35);
outtextxy(10,5,'the region bounded by an arc');
count:=0;
repeat
setcolor(5);
arc(320,240,0,60,200);
if TestEsc then exit;
delay(250);
setcolor(4);
arc(320,240,0,60,200);
if TestEsc then exit;
delay(250);
inc(count);
until count = 6;
setcolor(5);
arc(320,240,0,60,200);
setcolor(15);
outtextxy(380,5,'and that arc''s chord.');
count:=0;
repeat
setcolor(14);
line(520,240,round(320+((cos(pi/3))*200)),round(240-((sin(pi/3))*200)));
if TestEsc then exit;
delay(250);
setcolor(0);
line(520,240,round(320+((cos(pi/3))*200)),round(240-((sin(pi/3))*200)));
if TestEsc then exit;
delay(250);
count:=count+1;
until count = 6;
setcolor(14);
line(520,240,round(320+((cos(pi/3))*200)),round(240-((sin(pi/3))*200)));
setcolor(14);
arc(320,240,0,060,200);
setfillstyle(1,10);
floodfill(500,200,14);
setfillstyle(1,1);
bar(0,0,maxx,35);
setcolor(15);
outtextxy(10,5,'If the arc is a minor arc, its area can be found');
if TestEsc then exit;
delay(3000);
bar(0,0,maxx,35);
setcolor(14);
line(320,240,round(320+((cos(pi/3))*200)),round(240-((sin(pi/3))*200)));
setcolor(15);
outtextxy(10,5,'using the formula «rэ(а-sin а). Where r is the radius');
outtextxy(400,250,'Radius = 1');
if TestEsc then exit;
delay(3000);
bar(0,0,maxx,35);
outtextxy(10,5,'and а is the internal angle in radians.');
arc(320,240,0,60,50);
outtextxy(375,210,'а = г/3');
if TestEsc then exit;
delay(3000);
cleardevice;
SetBKColor(15);
setcolor(3);
settextstyle(1,0,3);
outtextxy(10,120,'What you just read are the basic');
outtextxy(10,140,'characteristics of the unit circle.  The');
outtextxy(10,160,'unit circle provides the basis for more advanced');
outtextxy(10,180,'forms of trigonometry.');
outtextxy(10,240,'The rest of this program will teach you');
outtextxy(10,260,'about some of the other basic trig principles.');
outtextxy(10,280,'Feel free to look at them in any order.');
settextstyle(3,0,1);
setcolor(4);
outtextxy(10,300,'Press ENTER to return to the menu.');
readln;
cleardevice;
CloseGraph;
End;
{--------------------------------------------------------------------------}
procedure Convert;
VAR
bigangle:integer;
circle_distance: integer;
begin
read_pi_or_degrees_input_from_the_keyboard;
initialize;
drawgraph;
  if TestEsc or exitdg then exit;
SetColor(14);
Line(320,240,520,240);
x:=round(320+((cos(radians))*200));
y:=round(240-((sin(radians))*200));
setcolor(14);
line(320,240,x,y);                 {output in terms of г}
setcolor(5);
if TestEsc then exit;
circle_distance:=193;
If negative=false then
    begin
  While radians > 2*pi do
      begin
      circle(320,240,circle_distance);
      circle_distance:=circle_distance-7;
      radians:=radians-2*pi;
      end;
   arc(320,240,0,(round(radians*180/pi)),200);
  end

Else
  begin
  While radians < -2*pi do
      begin
      circle(320,240,circle_distance);
      circle_distance:=circle_distance-7;
      radians:=radians+2*pi;
      end;
   arc(320,240,(360-(round(radians*180/pi))),0,200);
  end;
setcolor(15);
settextstyle(3,0,3);
If upcase(choice) = 'Y' then
  begin
  index:=1;
  numstring:='';
  repeat
     If s[index] in ['1'..'9','p','/','-'] then
       begin
       If s[index] = 'p' then
         numstring:=numstring+'г'
       Else
         numstring:=numstring+s[index];
     end;
     inc(index);
   until index>length(tempstr);
   outtextxy(-50,10,' '+numstring+' radians');
   if TestEsc then exit;
   end
  else
   begin
   str((radians):10:3,numstring);            {output without г }
   outtextxy(-50,10,' '+numstring+' radians');
   end;
  str((radians*180/pi):10:3,numstring);      {output in degrees}
  outtextxy(-40,30,' '+numstring+'ш');
If numchoice='2' then
readkey;
End;
{--------------------------------------------------------------------------}
procedure refrence;
Var
Degrees,RefDeg,SmallDeg:integer;
RefRad:real;
RefRadString,RefDegString:String;
begin
Convert;
Degrees:=Round(Radians*180/pi);
SmallDeg:=Degrees Mod 360;
SetColor(2);
SetLineStyle(1,0,3);
Line(320,240,x,y);
SetLineStyle(0,0,3);
If (SmallDeg>=0) and (SmallDeg<=90) then
 Begin
 RefDeg:=SmallDeg;
 SetLineStyle(1,0,3);
 Line(320,240,520,240);
 SetLineStyle(0,0,3);
 Arc(320,240,0,SmallDeg,75);
 End
Else if (SmallDeg>90) and (SmallDeg<=180) then
 Begin
 RefDeg:=180-SmallDeg;
 Line(320,240,120,240);
 Arc(320,240,SmallDeg,180,75);
 End
Else if (SmallDeg>180) and (SmallDeg<=270) then
 Begin
 RefDeg:=SmallDeg-180;
 Line(320,240,120,240);
 Arc(320,240,180,SmallDeg,75);
 End
Else
 Begin
 RefDeg:=360-SmallDeg;
 SetLineStyle(1,0,3);
 Line(320,240,520,240);
 SetLineStyle(0,0,3);
 Arc(320,240,SmallDeg,360,75);
 End;
RefRad:=RefDeg*pi/180;
str(RefDeg,RefDegString);
str(RefRad:0:4,RefRadString);
SetColor(15);
OutTextXY(20,420,'Reference angle');
OutTextXY(20,450,'in Degrees: ' + RefDegString +'ш');
OutTextXY(440,420,'Reference angle');
OutTextXY(380,450,'in Radians: ' + RefRadString);
Readln;
end;
{--------------------------------------------------------------------------}
procedure sector;
VAR
numchoice:byte;
area:real;
radius:real;
radiusstring:string;
xfill,yfill:integer;

begin
Writeln('1  A Sector');
Writeln('2  A Segment');
Write('Which do you wish to view 1 or 2  ');
readln(numchoice);
Write('Please enter a radius:  ');
readln(radius);
convert;
setfillstyle(1,10);
If numchoice = 1 then
begin
setcolor(14);
setlinestyle(0,0,1);
pieslice(320,240,0,round(radians*(180/pi)),200);
setlinestyle(0,0,3);
area:=0.5*radius*radius*radians;
str(area:0:4,numstring);
setcolor(15);
outtextxy(20,450,'Area = '+ numstring);
setlinestyle(0,0,3);
setcolor(5);
arc(320,240,0,round(radians*(180/pi)),200);
setcolor(14);
line(320,240,520,240);
line(320,240,x,y);
End

Else
begin
setcolor(14);
line(520,240,x,y);
If radians*180/pi <=180 then
begin
arc(320,240,0,round(radians*180/pi),200);
xfill:=round(320+((cos(0.5*radians))*200))-2;
yfill:=round(240-((sin(0.5*radians))*200))+2;
end

Else
begin
arc(320,240,round(radians*180/pi),0,200);
xfill:=round(320+((cos(0.5*(2*pi-radians)))*200))-2;
yfill:=round(240+((sin(0.5*(2*pi-radians)))*200))-2;
end;
floodfill(xfill,yfill,14);
setcolor(9);
area:=0.5*radius*radius*(radians-sin(radians));
str(area:0:4,numstring);
outtextxy(20,50,'Area = '+numstring);
setcolor(5);
arc(320,240,0,round(radians*(180/pi)),200);
end;
setcolor(9);
str(radius:0:2,radiusstring);
outtextxy(330,255,'Radius = '+ radiusstring);
readln;
cleardevice;
end;

{==========================================================================}

Begin
repeat
Intro;
numchoice:=readkey;
Writeln(numchoice);
case numchoice of
 '1': tutorial;
 '2': convert;
 '3': refrence;
 '4': sector;
 end;
closegraph;
until numchoice='5';
End.