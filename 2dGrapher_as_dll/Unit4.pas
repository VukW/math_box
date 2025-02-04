unit Unit4;

interface
uses math,Graphics,sysutils,Dialogs,StrUtils,Matrix_;//,SLNUVars

 const NOP=21;
 const Numbers='0123456789p';
 const WNumbers='0123456789,';
 Const WMNumbers='0123456789,-';
 Const C_MAXLENGTH_OF_STR=1024;
 Const C_Max_NOP=37;
 Const C_Min_var=58;
 Const C_Min_DataAr=129;
 type Tnvars=array of extended;
type Treal= record
result: extended;
Error: boolean;
end;

type
  Operand=record
  str: string;
  key: char;
  end;

type TDataType=(IndV,D,R);

type TFormulaType=(Surf_ZofXY,Surf_YofXZ,Surf_XofYZ,Surf_Param,Curve_Param,Arr_Points);

Type TDataElement=record
    DT: Tdatatype;
    Data: extended;
    Numb: integer;
  end;

type TDEA= array of TDataElement;

type  TOperAr=array [1..3] of array of SmallInt; //-32768..32767

type TIndVar=record
  Name: string;
  IsIn: boolean;
  Pos: integer;
  end;

type TPoint3d=record
  x,y,z,t: extended;
  IsMathEx: Boolean;
  end;

type TPointsArray=array of array of array of Tpoint3d;
//------------------------------------------------------------------------
//Description of TFunc2d (borders of range of definition) is here
type TPoint2d=record
  x,y: extended;
  IsMathEx: Boolean;
  end;
type TPointsArray2d = array of TPoint2d;

type TFunc2d=record
  t: TIndVar;
  FText: string;
  F_LData: string;
  OperAr: TOperAr;
  DataAr: TDEA;
//  PointsAr: array of TPoint2d;
//  LeftT,RightT: real;
//  NumOfDivPoints: integer;
  IsMathEx: boolean;
  end;
//end of borders description
//------------------------------------------------------------------------
type TDefDType=(YoX,XoY,RoA,Param,AoP);
type TDefDomain = record
      LeftX:extended;
      RightX:extended;
//      RightY: Real;
//      LeftY: Real;
      BorderFunctionUp: TFunc2d;
      BorderFunctionDown: TFunc2d;
      PointsArUp,PointsArDown:TPointsArray2d;
      DefDType: TDefDType;
      LeftXLine,RightXLine: String;
    end;

type TFormula= record
  VarAr: array of TIndVar;
  FLine: String;
  OperAr: TOperAr;
  DataAr: TDEA;
  IsMathEx: boolean;
  //  LeftX,RightX:real;
  //        LeftY,RightY: real;
  //        StepGX,StepGY,stepGZ: real;
  //  NumOfLinesX,NumOfLinesY: integer;
//  LinesHomogenity: boolean;
//  Color: TColor;
//  BorderFunctionUp,BorderFunctionDown: TFunc2d;
//  leftZ,RightZ: real;
  end;
{����. �������� - �������� ���, � ���� �����. � ��� ��������.
x,y,z - ����������, �� ������� �������� (������� ��������).
FLine - ������ ������� (��� ������� �������������).
OperAr - ������ ��������.
DataAr - ������ ������. ��� ��� ������� - ������ �������������� �����.
PointsAr - ������ ����� ����������� ��� ���������.
IsMathEx - � ��� ������ �������?
LeftX,RightX - ������� �� 1� ����������.
NumOfLines X, NumOfLinesY - �������� (���������� ����� ��� ���������).
LinesHomogenity - ������������� �����. ��� true, ������ ���� �����������
BorderFuncs, ��� false, ����������� ������������ ����.
Color - ���� ���������.
BorderFunctions - ��������� ������� (������� ������� �� 2� ����������).
leftZ,RightZ - �������� � ������� �-�� (��� ����������).}
  type TObj=record
  ObjType: TFormulaType;
  FormulaX,FormulaY,FormulaZ: TFormula;
//  CFlaX,CFlaY,CFlaZ: TFunc2d;
Name: string;
    IsMathEx: boolean;
    PointsAr: TPointsArray;
    NumOfLinesY: Integer;
    NumOfLinesX: Integer;
    DefDomain:TDefDomain;
    LinesHomogenity: Boolean;
    Checked: boolean;
//���������: 2012.11.09
//������ TObj �� �������
  DependsOnTime: boolean;
  TimeMin,TimeMax: extended;
  NumOfLinesTime: integer;
//----------------------
  procedure FillPointsArray;
  function FillPointsArrayDefD(Func: TFunc2d): TPointsArray2d;
  end;

TObj2d=record
Funct,Funct1: TFunc2d;
objType: TdefDType;
  Wdth: byte;
  Color: TColor;
  Name: string;
NumOfPoints: integer;
LeftX,RightX: extended;
Checked: boolean;
PointsAr: TPointsArray2d;
LeftXLine,RightXLine: string;
PIntlAr: boolean;
procedure FillPointsArray;
end;
{������� x(u,v), y(u,v), z(u,v)
� x(t),y(t),z(t)}
  function analyseFormula(F: string; vars: string): TFormula;
  function analyseFunc2d(F: string; vars: string): TFunc2d;

function GetOpres(var FDataAr: TDEA; var FOperAr: TOperAr; Vars: Tnvars):TReal;
function StrRep(MainStr,u,v: string): String;
function DataElementToStr(DataEl: TDataType): string;
function StrToDataElement(Str: string): TDataType;
function GetNumericalDerivInPoint(var FDataAr: TDEA; var FOperAr: TOperAr; Vars: Tnvars; i: integer; eps: extended):TReal;
//NB: x=1,2,..; DerivatingOper=0,1,2,..;Oper=0,1,2,..;argn=0|1; RestoringOper=0,1,2,..
function DoesOperationDependOnX(const Formula: TFormula; Oper: integer; x: integer): boolean;
function DoesOperArgDependOnX(const Formula: TFormula; Oper: integer; argn: integer; x: integer): boolean;
function RestoreString(var Formula: TFormula; RestoringOper: integer): string; overload;
function RestoreString(var Formula: TFormula): string; overload;
function GetDeriv(Formula: TFormula; x: integer): TFormula; overload;
function GetDeriv(Formula: TFormula; DerivatingOper: integer; x: integer): TFormula; overload;
function IsFloat(Str: string): boolean;
function VectToNVars(vect: TVect): Tnvars;

  function Fdiv(x,y: extended): Treal;//chislitel i znamenatel
  function Fpower(x,y: extended): Treal;//base and exponent
  function Flog10(x: extended): Treal;
  function Flog2(x: extended): Treal;
  function Fln(x: extended): Treal;
  function Flog(x,y: extended): Treal;//base and X
  function Fasin(x: extended): Treal;
  function Facos(x: extended): Treal;
  function Ftg(x: extended): Treal;
  function Fctg(x: extended): Treal;
  function Fsqrt(x: extended): Treal;

Type TFuncsArray=array of TObj;
Type TFuncs2dArray=array of TObj2d;
var
  Operands: array[1..NOP] of operand;
  IsMathEx: boolean;
  k: integer;
  VarVect: Tnvars;
    implementation

function analyseFunc2d(F: string; vars: string): TFunc2d;
var i,j,k,tempfori: integer;
strout,StrNum: string;
SymbPos1,SymbPos2: integer;
NumOp,NumCl: integer;
ResForRecursion: TFunc2d;

  procedure FillDataM(pos: integer);
  begin
    if F[pos]<#6 then
         if F[pos-1]=Char(C_Min_Var) then
               begin
               if Result.t.IsIn then
                  Result.OperAr[2,i]:=Result.t.Pos
               else
                  begin
                  Result.DataAr[k].DT:=IndV;
                  Result.DataAr[k].Numb:=1;
                  Result.OperAr[2,i]:=k;
                  Result.t.Pos:=k;
                  k:=k+1;
                  Result.t.IsIn:=true;
                  end;
               end
          else
          Result.OperAr[2,i]:=Ord(F[pos-1])-c_min_DataAr;


       if F[pos+1]=Char(C_Min_Var) then
               begin
               if Result.t.IsIn then
                  Result.OperAr[3,i]:=Result.t.Pos
               else
                  begin
                  Result.DataAr[k].DT:=IndV;
                  Result.DataAr[k].Numb:=1;
                  Result.OperAr[3,i]:=k;
                  Result.t.Pos:=k;
                  k:=k+1;
                  Result.t.IsIn:=true;
                  end;
               end
          else
          Result.OperAr[3,i]:=Ord(F[pos+1])-c_min_DataAr;
  end;

  procedure ConCatRes(ResFRec: TFunc2d; var Res: TFunc2d; var ResOpL,ResDtL: integer);
  var i,j,k: integer;
  ResFRecOpL,ResFRecDtL: integer;

  begin
  ResFRecOpL:=Length(ResFRec.OperAr[1]);
  ResFRecDtL:=Length(ResFRec.DataAr);
  for I := 0 to ResFRecOpL - 1 do
    for j := 1 to 3 do
      Res.OperAr[j,ResOpL+i]:=ResFRec.OperAr[j,i];

  j:=0;

  for I := 0 to ResFRecDtL - 1 do
    begin
    if ResFRec.DataAr[i].DT=D then
        begin
        Res.DataAr[ResDtL+j]:=ResFRec.DataAr[i];
        for k := 0 to ResFRecOpL - 1 do
            begin
            if ResFRec.OperAr[2,k]=i then
                Res.OperAr[2,k+ResOpL]:=ResDtL+j;
            if ResFRec.OperAr[3,k]=i then
                Res.OperAr[3,k+ResOpL]:=ResDtL+j;
            end;
        j:=j+1;
        end;
    end;

    if ResFRec.t.IsIn then
      if not Res.t.IsIn then
          begin
          Res.t.IsIn:=true;
          Res.t.Pos:=ResDtL+j;
          Res.DataAr[ResDtL+j]:=ResFRec.DataAr[ResFRec.t.Pos];
          j:=j+1;
          for I := 0 to ResFRecOpL - 1 do
                begin
                if ResFRec.OperAr[2,i]=ResFRec.t.Pos then
                    Res.OperAr[2,i+ResOpL]:=ResDtL+j-1;
                if ResFRec.OperAr[3,i]=ResFRec.t.Pos then
                    Res.OperAr[3,i+ResOpL]:=ResDtL+j-1;
                end;
          end
      else
          for I := 0 to ResFRecOpL - 1 do
                begin
                if ResFRec.OperAr[2,i]=ResFRec.t.Pos then
                    Res.OperAr[2,i+ResOpL]:=Res.t.Pos;
                if ResFRec.OperAr[3,i]=ResFRec.t.Pos then
                    Res.OperAr[3,i+ResOpL]:=Res.t.Pos;
                end;

     for I := 0 to ResFRecDtL-1 do
      begin
      if ResFRec.DataAr[i].DT=R then
          begin
          Res.DataAr[ResDtL+j]:=ResFRec.DataAr[i];
          Res.DataAr[ResDtL+j].Numb:=Res.DataAr[ResDtL+j].Numb+ResOpL;
          for k := 0 to ResFRecOpL - 1 do
            begin
            if ResFRec.OperAr[2,k]=i then
                Res.OperAr[2,k+ResOpL]:=ResDtL+j;
            if ResFRec.OperAr[3,k]=i then
                Res.OperAr[3,k+ResOpL]:=ResDtL+j;
            end;
          j:=j+1;
          end;
      end;

    ResOpL:=ResOpL+ResFRecOpL;
    ResDtL:=ResDtL+j;
  end;

  function IsFloat(str: string): boolean;
  var i,NumOfP: integer;
  begin
  result:=true;
  NumOfP:=0;
  for i := 1 to Length(str) do
    if str[i]=',' then NumOfP:=NumOfP+1;
  if (NumOfP>1) or (str[1]=',') or (str[i]=',') then result:=false;
 end;

begin{����� �� �������� � � ������ ���, � ����� ������, �� ��� �������� �����}
F:=LowerCase(F);
while pos(#32,F)<>0 do delete(F,pos(#32,F),1);
result.FText:=F;
////��������: ������� �� ������ ���� ������
if result.FText='' then
   begin
   result.IsMathEx:=false;
   exit;
   end;
for I := 1 to NOP do
  F:=StringReplace(F,Operands[i].str,Operands[i].key,[rfReplaceAll]);
//F:=StringReplace(F,'pi',FloatToStrF(Pi,ffGeneral,7,5),[rfReplaceAll]);
//F:=StringReplace(F,'pi',Char(128),[rfReplaceAll]);
       Result.F_LData:=F;

Result.t.Name:=vars;
  F:=StringReplace(F,vars,Char(C_Min_Var),[rfReplaceAll]);
//������� ������� � ���� ��� �������

result.IsMathEx:=true;
 Result.t.Pos:=0;
 result.t.IsIn:=false;
 for i:=1 to 3 do SetLength(Result.OperAr[i],0);
 SetLength(Result.DataAr,0);
//�������� �������
   setlength(Result.DataAr,Length(F)+1);
   for  i := 1 to 3 do
     setlength(Result.OperAr[i],Length(F)+1);
{------------------------------------------------------------}
//����� ������ ������ � ,� ������ ����, ����� ��������
//////////////////////////////////////
//������ - ��������.
symbpos1:=0;
symbpos2:=0;
for I := 1 to Length(F) do
  begin
  if F[i]='(' then
      begin
      NumOp:=NumOp+1;
      SymbPos1:=i;
      end;
  if F[i]=')' then
      begin
      NumCl:=NumCl+1;
      SymbPos2:=i;
      end;
  end;
if (NumOp<>NumCl)or(SymbPos1>SymbPos2)or(Pos('(',F)>Pos(')',F)) then
begin
Result.IsMathEx:=false;
exit;
end;
/////////////////////////////////////

k:=0;
tempfori:=0;
SymbPos1:=Pos('(',F);
While SymbPos1<>0 do
    begin
    repeat
    Delete(F,SymbPos1,1);
    Insert(#32,F,SymbPos1);
    SymbPos1:=Pos('(',F);
    SymbPos2:=Pos(')',F);
    Delete(F,SymbPos2,1);
    Insert(#33,F,SymbPos2);
    until (SymbPos2<SymbPos1)or(SymbPos1=0);
    F:=StringReplace(F,#32,'(',[rfReplaceAll]);
    F:=StringReplace(F,#33,')',[rfReplaceAll]);
    SymbPos1:=Pos('(',F);
//                showmessage('SymbPos1='+IntToSTr(SymbPos1)+#13+
//                            'SymbPos2='+IntToStr(SymbPos2));
//������ �� ����� ������� ( � ).
    ResForRecursion:=AnalyseFunc2d(Copy(F,SymbPos1+1,SymbPos2-SymbPos1-1),vars);
if not result.IsMathEx then
exit;
    i:=k;
    ConCatRes(ResForRecursion,Result,tempfori,k);
    Delete(F,SymbPos1,SymbPos2-SymbPos1+1);
    if i<k then
    Insert(Char(c_min_DataAr-1+k),F,SymbPos1)
    else
      begin
          Insert(Char(c_min_DataAr-1+Result.t.Pos+1),F,SymbPos1)
      end;
    SymbPos1:=Pos('(',F);
    end;


                                  {--------------------------}
                                  if F[1]=#2 then
                                  F:='0'+F;
                                  {--------------------------}


{------------------------------------------------------------}
{�������� �� ������� ��� ����� � ���������� �� � DataAr}
i:=1;
while i<=Length(F) do
  begin
   if StrScan(Numbers,F[i])<>nil then
      begin
      if F[i]<>'p' then
      begin
      j:=0;
      repeat
         j:=j+1
      until (StrScan(WNumbers,F[i+j])=nil) or (i+j>length(F));
      StrNum:=Copy(F,i,j);
      if not IsFloat(StrNum) then
        begin
        IsMathEx:=false;
        exit;
        end;
      Result.DataAr[k].Data:=StrToFloat(StrNum);
      Result.DataAr[k].DT:=D;
      Delete(F,i,j);
      Insert(Char(k+c_min_DataAr),F,i);
      k:=k+1;
      end
      else
        if F[i+1]='i' then
          begin
          Result.DataAr[k].Data:=Pi;
          Result.DataAr[k].DT:=D;
          Delete(F,i,2);
          Insert(Char(k+c_min_DataAr),F,i);
          k:=k+1;
          end;
      end;
  i:=i+1;
  end;
{��������� ���������. ������ ������ ������� ���
x^_dataar0_+y^_dataar1_/y}

//////////////////////////////////////////////////////////////
//� ������ ������ ������ ������ ����� ���
//x^_dataar0_+y^_dataar1_/y. ��������:
//1) ����� � ������ �� ���������� ����� ����
//   ������ IndVar ���� _DAr_
//2) ����� ������� �������: ����� �� IndVar ����� ����
//   ������ �������
//3) ����� ���������� �������: ������ �� IndVar ����� ����
//   ������ �������
//4) ����� �� ������� ����� ���� ������ ������� ���� ������ �������
//5) ���� ������ - �� �������, �� �������, �� ���� � �� IndVar, ��
//   �� - ����� ������.
for I := 1 to Length(F) do
  begin
  case F[i] of
  #1..#5: begin
          if (i=1)or(i=length(F)) then
             begin
             IsMathEx:=false;
             exit;
             end
          else
             begin
             if not ((F[i-1]=Char(C_Min_Var))or(F[i-1]>=char(c_min_dataar))) then

                 begin
                 IsMathEx:=false;
                 exit;
                 end;
             if not ((F[i+1]= Char(C_Min_Var))or(F[i+1]>=Char(C_Min_DataAr))or((F[i+1]>=#6)and(F[i+1]<=Char(NOP)))) then
                 begin
                 IsMathEx:=false;
                 exit;
                 end;
             end;
          end;
  Char(C_Min_Var): begin
          if i>1 then
             if F[i-1]>Char(NOP) then
                 begin
                 IsMAthEx:=false;

                 exit;
                 end;
          if i<Length(F) then
             if F[i+1]>#5 then
                 begin
                 IsMAthEx:=false;

                 exit;
                 end;
          end;
#6..Char(NOP):
          begin
          if i=Length(F) then
             begin
             IsMathEx:=false;
             exit;
             end
          else
          if (ord(F[i-1])>=c_min_DataAr)and(F[i-1]<=#191) then

             begin
             IsMathEx:=false;
             exit;
             end
          end;
else
  if not (F[i]>=Char(C_Min_DataAr)) then
             begin
             IsMathEx:=false;
             exit;
             end;
  end;
  end;
///////////////////////////////////////////////////////////////

//�������� �������� �� ���������� ���������.
i:=tempfori;
//������ - �������.
SymbPos1:=pos(#6,F);
for j := 7 to NOP do
   if ((pos(Char(j),F)<SymbPos1)and(Pos(Char(j),F)>0))or(SymbPos1=0) then
   SymbPos1:=pos(Char(j),F);

while (F[SymbPos1+1]>#5)and(F[SymbPos1+1]<=Char(NOP)) do
    SymbPos1:=SymbPos1+1;
tempfori:=Ord(F[SymbPos1]);

   while SymbPos1>0 do
       begin
       Result.OperAr[1,i]:=tempfori;
        FillDataM(SymbPos1);
        Delete(F,SymbPos1,2);
        Result.DataAr[k].DT:=R;
        Result.DataAr[k].Numb:=i;
        Insert(Char(k+c_min_DataAr),F,SymbPos1);
        k:=k+1;
        i:=i+1;

SymbPos1:=pos(#6,F);
for j := 7 to NOP do
   if ((pos(Char(j),F)<SymbPos1)and(Pos(Char(j),F)>0))or(SymbPos1=0) then
   SymbPos1:=pos(Char(j),F);
while (F[SymbPos1+1]>#5)and(F[SymbPos1+1]<=Char(NOP)) do
    SymbPos1:=SymbPos1+1;
tempfori:=Ord(F[SymbPos1]);
       end;

//��� - ���������� � �������
SymbPos1:=pos(#5,F);

   while SymbPos1>0 do
       begin
       Result.OperAr[1,i]:=5;
        FillDataM(SymbPos1);
        Delete(F,SymbPos1-1,3);
        Result.DataAr[k].DT:=R;
        Result.DataAr[k].Numb:=i;
        Insert(Char(k+c_min_DataAr),F,SymbPos1-1);
        k:=k+1;
        i:=i+1;
        SymbPos1:=pos(#5,F);
       end;

//��� - ������������ � �������.
        SymbPos1:=pos(#4,F);
        SymbPos2:=pos(#3,F);
        j:=4;
        if ((SymbPos2<SymbPos1)and(SymbPos2>0))or (SymbPos1=0) then
            begin
            SymbPos1:=SymbPos2;
            j:=3;
            end;
   while SymbPos1>0 do
       begin
       Result.OperAr[1,i]:=j;
        FillDataM(SymbPos1);
        Delete(F,SymbPos1-1,3);
        Result.DataAr[k].DT:=R;
        Result.DataAr[k].Numb:=i;
        Insert(Char(k+c_min_DataAr),F,SymbPos1-1);
        k:=k+1;
        i:=i+1;
        SymbPos1:=pos(#3,F);
        SymbPos2:=pos(#4,F);
        j:=3;
        if ((SymbPos2<SymbPos1)and(SymbPos2>0))or (SymbPos1=0) then
            begin
            SymbPos1:=SymbPos2;
            j:=4;
            end;
       end;

//����� � ���������
        SymbPos1:=pos(#2,F);
        SymbPos2:=pos(#1,F);
        j:=2;
        if ((SymbPos2<SymbPos1)and(SymbPos2>0))or (SymbPos1=0) then
            begin
            SymbPos1:=SymbPos2;
            j:=1;
            end;
   while SymbPos1>0 do
       begin
       Result.OperAr[1,i]:=j;
        FillDataM(SymbPos1);
        Delete(F,SymbPos1-1,3);
        Result.DataAr[k].DT:=R;
        Result.DataAr[k].Numb:=i;
        Insert(Char(k+c_min_DataAr),F,SymbPos1-1);
        k:=k+1;
        i:=i+1;
        SymbPos1:=pos(#1,F);
        SymbPos2:=pos(#2,F);
        j:=1;
        if ((SymbPos2<SymbPos1)and(SymbPos2>0))or (SymbPos1=0) then
            begin
            SymbPos1:=SymbPos2;
            j:=2;
            end;
        end;

if (length(F)=1)and(f[1]=char(C_Min_Var)) then
        begin
        for j := 1 to 3 do
        Result.OperAr[j]:=nil;
        if Result.t.IsIn then
           f[1]:=Char(Result.t.Pos+c_min_DataAr)
        else
           begin
//           if Result.DataAr=nil then
               setlength(Result.DataAr,1);
               Result.DataAr[0].DT:=IndV;
               Result.DataAr[0].Numb:=1;
               Result.t.IsIn:=true;
               Result.t.Pos:=0;
           end;
        end
else
        begin
           for j := 1 to 3 do
           SetLength(Result.OperAr[j],i);
           SetLength(Result.DataAr,k);
        end;
//���. ���������� ��������� ������� - � DataAr � OperAr
end;

  function TObj.FillPointsArrayDefD(Func: TFunc2d): TPointsArray2d;
  var i,j: integer;
      opres: Treal;
      stepT: extended;
      RightT,LeftT: extended;
      NumOfDivPoints: integer;
      VarVect: Tnvars;
  begin
      RightT:=DefDomain.RightX;
      LeftT:=DefDomain.LeftX;

        NumOfDivPoints:=NumOfLinesX;
     setlength(varvect,1);
     SetLength(Result,NumOfDivPoints+1);
       stepT:=(RightT-LeftT)/NumOfDivPoints;

      for i := 0 to NumOfDivPoints do
        begin
        Result[i].x:=LeftT+StepT*i;
{        if Func.t.IsIn then
           Func.DataAr[Func.t.Pos].Data:=Result[i].x;}
           varvect[0]:=Result[i].x;

        //���������� �������� �, ��������� ���� ����
          opres:=GetOpRes(Func.DataAr,Func.OperAr,VarVect);
          if not opres.error then
              Result[i].y:=opres.result;
          Result[i].IsMathEx:=not opres.Error;
        end;//����� for'a
  end;

function analyseFormula(F: string; vars: string): TFormula;
var i,j,k,tempfori: integer;
strout,StrNum: string;
//CheckStr: string;
SymbPos1,SymbPos2: integer;
NumOp,NumCl: integer;
ResForRecursion: TFormula;

  procedure FillDataM(pos: integer);
  var j: integer;
  begin
  j:=0;
    if F[pos]<#6 then
    while j=0 do
       begin
       for j := 0 to Length(result.VarAr) - 1 do
         if F[pos-1]=Char(C_Min_Var+j) then
               begin
               if Result.VarAr[j].IsIn then
                  begin
                  Result.OperAr[2,i]:=Result.VarAr[j].Pos;
                  break;
                  end
               else
                  begin
                  Result.DataAr[k].DT:=IndV;
                  Result.DataAr[k].Numb:=j+1;
                  Result.OperAr[2,i]:=k;
                  Result.VarAr[j].Pos:=k;
                  k:=k+1;
                  Result.VarAr[j].IsIn:=true;
                  break;
                  end;
               end;
         if j<Length(result.VarAr) then break;
         Result.OperAr[2,i]:=Ord(F[pos-1])-C_Min_DataAr;
         j:=1;
         end;
    j:=0;

    while j=0 do
       begin
       for j := 0 to Length(result.VarAr) - 1 do
         if F[pos+1]=Char(C_Min_Var+j) then
               begin
               if Result.VarAr[j].IsIn then
                  begin
                  Result.OperAr[3,i]:=Result.VarAr[j].Pos;
                  break;
                  end
               else
                  begin
                  Result.DataAr[k].DT:=IndV;
                  Result.DataAr[k].Numb:=j+1;
                  Result.OperAr[3,i]:=k;
                  Result.VarAr[j].Pos:=k;
                  k:=k+1;
                  Result.VarAr[j].IsIn:=true;
                  break;
                  end;
               end;
         if j<Length(Result.VarAr) then break;         
         Result.OperAr[3,i]:=Ord(F[pos+1])-C_Min_DataAr;
         j:=1;
         end;

//        Result.OperAr[3,i]:=Ord(F[pos+1])-128;
{       case F[pos-1] of
          'x': begin
               if Result.X.IsIn then
                  Result.OperAr[2,i]:=Result.X.Pos
               else
                  begin
                  Result.DataAr[k].DT:=IndV;
                  Result.DataAr[k].Numb:=1;
                  Result.OperAr[2,i]:=k;
                  Result.X.Pos:=k;
                  k:=k+1;
                  Result.X.IsIn:=true;
                  end;
               end;
          'y': begin
               if Result.y.IsIn then
                  Result.OperAr[2,i]:=Result.Y.Pos
               else
                  begin
                  Result.DataAr[k].DT:=IndV;
                  Result.DataAr[k].Numb:=2;
                  Result.OperAr[2,i]:=k;
                  Result.Y.Pos:=k;
                  k:=k+1;
                  Result.Y.IsIn:=true;
                  end;
               end;
          'z': begin
               if Result.Z.IsIn then
                  Result.OperAr[2,i]:=Result.Z.Pos
               else
                  begin
                  Result.DataAr[k].DT:=IndV;
                  Result.DataAr[k].Numb:=3;
                  Result.OperAr[2,i]:=k;
                  Result.Z.Pos:=k;
                  k:=k+1;
                  Result.Z.IsIn:=true;
                  end;
               end
          else
          Result.OperAr[2,i]:=Ord(F[pos-1])-128;
       end;


       case F[pos+1] of
          'x': begin
               if Result.X.IsIn then
                  Result.OperAr[3,i]:=Result.x.Pos
               else
                  begin
                  Result.DataAr[k].DT:=IndV;
                  Result.DataAr[k].Numb:=1;
                  Result.OperAr[3,i]:=k;
                  Result.X.Pos:=k;
                  k:=k+1;
                  Result.X.IsIn:=true;
                  end;
               end;
          'y': begin
               if Result.Y.Isin then
                  Result.OperAr[3,i]:=Result.Y.Pos
               else
                  begin
                  Result.DataAr[k].DT:=IndV;
                  Result.DataAr[k].Numb:=2;
                  Result.OperAr[3,i]:=k;
                  Result.Y.Pos:=k;
                  k:=k+1;
                  Result.Y.IsIn:=true;
                  end;
               end;
          'z': begin
               if Result.Z.Isin then
                  Result.OperAr[3,i]:=Result.Z.Pos
               else
                  begin
                  Result.DataAr[k].DT:=IndV;
                  Result.DataAr[k].Numb:=3;
                  Result.OperAr[3,i]:=k;
                  Result.Z.Pos:=k;
                  k:=k+1;
                  Result.Z.IsIn:=true;
                  end;
               end;
          else
          Result.OperAr[3,i]:=Ord(F[pos+1])-128;
        end; }
  end;

  procedure ConCatRes(ResFRec: TFormula; var Res: TFormula; var ResOpL,ResDtL: integer);
  var i,j,k,varar_c: integer;
  ResFRecOpL,ResFRecDtL: integer;

  begin
  ResFRecOpL:=Length(ResFRec.OperAr[1]);
  ResFRecDtL:=Length(ResFRec.DataAr);
  for I := 0 to ResFRecOpL - 1 do
    for j := 1 to 3 do
      Res.OperAr[j,ResOpL+i]:=ResFRec.OperAr[j,i];

  j:=0;

  for I := 0 to ResFRecDtL - 1 do
    begin
    if ResFRec.DataAr[i].DT=D then
        begin
        Res.DataAr[ResDtL+j]:=ResFRec.DataAr[i];
        for k := 0 to ResFRecOpL - 1 do
            begin
            if (ResFRec.OperAr[2,k]=i) then //and
//            (ResFRec.OperAr[1,k]>5) and ((ResFRec.OperAr[1,k]<>9)) then
                Res.OperAr[2,k+ResOpL]:=ResDtL+j;
            if ResFRec.OperAr[3,k]=i then
                Res.OperAr[3,k+ResOpL]:=ResDtL+j;
            end;
        j:=j+1;
        end;
    end;
for varar_c := 0 to length(ResFRec.VarAr) - 1 do
    if ResFRec.VarAr[varar_c].IsIn then
      if not Res.VarAr[varar_c].IsIn then
          begin
          Res.VarAr[varar_c].IsIn:=true;
          Res.VarAr[varar_c].Pos:=ResDtL+j;
          Res.DataAr[ResDtL+j]:=ResFRec.DataAr[ResFRec.VarAr[varar_c].Pos];
          j:=j+1;
          for I := 0 to ResFRecOpL - 1 do
                begin
                if (ResFRec.OperAr[2,i]=ResFRec.VarAr[varar_c].Pos ) then //and
//               (ResFRec.OperAr[1,k]>5) and ((ResFRec.OperAr[1,k]<>9)) then
                    Res.OperAr[2,i+ResOpL]:=ResDtL+j-1;
                if ResFRec.OperAr[3,i]=ResFRec.VarAr[varar_c].Pos then
                    Res.OperAr[3,i+ResOpL]:=ResDtL+j-1;
                end;
          end
      else
          for I := 0 to ResFRecOpL - 1 do
                begin
                if (ResFRec.OperAr[2,i]=ResFRec.VarAr[varar_c].Pos ) then //and
//               (ResFRec.OperAr[1,k]>5) and ((ResFRec.OperAr[1,k]<>9)) then
                    Res.OperAr[2,i+ResOpL]:=Res.VarAr[varar_c].Pos;
                if ResFRec.OperAr[3,i]=ResFRec.VarAr[varar_c].Pos then
                    Res.OperAr[3,i+ResOpL]:=Res.VarAr[varar_c].Pos;
                end;

{    if ResFRec.y.IsIn then
      if not Res.y.IsIn then
          begin
          Res.y.IsIn:=true;
          Res.y.Pos:=ResDtL+j;
          Res.DataAr[ResDtL+j]:=ResFRec.DataAr[ResFRec.y.Pos];
          j:=j+1;
          for I := 0 to ResFRecOpL - 1 do
                begin
                if (ResFRec.OperAr[2,i]=ResFRec.y.Pos) then//and
//               (ResFRec.OperAr[1,k]>5) and ((ResFRec.OperAr[1,k]<>9))  then
                    Res.OperAr[2,i+ResOpL]:=ResDtL+j-1;
                if ResFRec.OperAr[3,i]=ResFRec.y.Pos then
                    Res.OperAr[3,i+ResOpL]:=ResDtL+j-1;
                end;
          end
      else
          for I := 0 to ResFRecOpL - 1 do
                begin
                if (ResFRec.OperAr[2,i]=ResFRec.y.Pos) then //and
//               (ResFRec.OperAr[1,k]>5) and ((ResFRec.OperAr[1,k]<>9))  then
                    Res.OperAr[2,i+ResOpL]:=Res.y.Pos;
                if ResFRec.OperAr[3,i]=ResFRec.y.Pos then
                    Res.OperAr[3,i+ResOpL]:=Res.y.Pos;
                end;

    if ResFRec.z.IsIn then
      if not Res.z.IsIn then
          begin
          Res.z.IsIn:=true;
          Res.z.Pos:=ResDtL+j;
          Res.DataAr[ResDtL+j]:=ResFRec.DataAr[ResFRec.z.Pos];
          j:=j+1;
          for I := 0 to ResFRecOpL - 1 do
                begin
                if (ResFRec.OperAr[2,i]=ResFRec.z.Pos) then //and
//               (ResFRec.OperAr[1,k]>5) and ((ResFRec.OperAr[1,k]<>9))  then
                    Res.OperAr[2,i+ResOpL]:=ResDtL+j-1;
                if ResFRec.OperAr[3,i]=ResFRec.z.Pos then
                    Res.OperAr[3,i+ResOpL]:=ResDtL+j-1;
                end;
          end
      else
          for I := 0 to ResFRecOpL - 1 do
                begin
                if (ResFRec.OperAr[2,i]=ResFRec.z.Pos) then //and
//               (ResFRec.OperAr[1,k]>5) and ((ResFRec.OperAr[1,k]<>9))  then
                    Res.OperAr[2,i+ResOpL]:=Res.z.Pos;
                if ResFRec.OperAr[3,i]=ResFRec.z.Pos then
                    Res.OperAr[3,i+ResOpL]:=Res.z.Pos;
                end;  }

    for I := 0 to ResFRecDtL-1 do
      begin
      if ResFRec.DataAr[i].DT=R then
          begin
          Res.DataAr[ResDtL+j]:=ResFRec.DataAr[i];
          Res.DataAr[ResDtL+j].Numb:=Res.DataAr[ResDtL+j].Numb+ResOpL;
          for k := 0 to ResFRecOpL - 1 do
            begin
            if (ResFRec.OperAr[2,k]=i) then //and
//               (ResFRec.OperAr[1,k]>5) and ((ResFRec.OperAr[1,k]<>9)) then
                Res.OperAr[2,k+ResOpL]:=ResDtL+j;
            if ResFRec.OperAr[3,k]=i then
                Res.OperAr[3,k+ResOpL]:=ResDtL+j;
            end;
          j:=j+1;
          end;
      end;

    ResOpL:=ResOpL+ResFRecOpL;
    ResDtL:=ResDtL+j;
  end;

  function IsFloat(str: string): boolean;
  var i,NumOfP: integer;
  begin
  result:=true;
  NumOfP:=0;
  for i := 1 to Length(str) do
    if str[i]=',' then NumOfP:=NumOfP+1;
  if (NumOfP>1) or (str[1]=',') or (str[i]=',') then result:=false;
 end;

  Procedure GetVarAr;
  var i,len,j,k: integer;
  begin
  len:=length(vars);
  setlength(result.VarAr,len);
  j:=1;
  k:=0;
  for i := 2 to len do
      begin
      if vars[i]=' ' then
        begin
        result.VarAr[k].Name:=MidStr(vars,j,i-j);
        Result.VarAr[k].IsIn:=false;
        Result.VarAr[k].Pos:=0;
        j:=i+1;
        k:=k+1;
        end;
      end;
  SetLength(result.VarAr,k);
  end;

begin

F:=LowerCase(F);
while pos(#32,F)<>0 do delete(F,pos(#32,F),1);
//CheckStr:=F;
Result.FLine:=F;
//��������: ������� �� ������ ���� ������
if result.FLine='' then
   begin
   result.IsMathEx:=false;
   exit;
   end;
for I := 1 to NOP do
  F:=StringReplace(F,Operands[i].str,Operands[i].key,[rfReplaceAll]);
//F:=StringReplace(F,'pi',FloatToStrF(Pi,ffGeneral,7,5),[rfReplaceAll]);
//F:=StringReplace(F,'pi',Char(128),[rfReplaceAll]);
 getVarAr;
for I := 0 to Length(Result.VarAr)-1 do
  F:=StringReplace(F,Result.VarAr[i].Name,Char(C_Min_Var+i),[rfReplaceAll]);
//������� ������� � ���� ��� �������

 result.IsMathEx:=true;
 for i:=1 to 3 do SetLength(Result.OperAr[i],0);
 SetLength(Result.DataAr,0);
//�������� �������
   setlength(Result.DataAr,Length(F)+1);
   for  i := 1 to 3 do
     setlength(Result.OperAr[i],Length(F)+1);
{------------------------------------------------------------}
//����� ������ ������ � ,� ������ ����, ����� ��������
//////////////////////////////////////
//������ - ��������.
symbpos1:=0;
symbpos2:=0;
for I := 1 to Length(F) do
  begin
  if F[i]='(' then
      begin
      NumOp:=NumOp+1;
      SymbPos1:=i;
      end;
  if F[i]=')' then
      begin
      NumCl:=NumCl+1;
      SymbPos2:=i;
      end;
  end;
if (NumOp<>NumCl)or(SymbPos1>SymbPos2)or(Pos('(',F)>Pos(')',F)) then
begin
Result.IsMathEx:=false;
exit;
end;
/////////////////////////////////////

k:=0;
tempfori:=0;
SymbPos1:=Pos('(',F);
While SymbPos1<>0 do
    begin
    repeat
    Delete(F,SymbPos1,1);
    Insert(#38,F,SymbPos1);
    SymbPos1:=Pos('(',F);
    SymbPos2:=Pos(')',F);
    Delete(F,SymbPos2,1);
    Insert(#39,F,SymbPos2);
    until (SymbPos2<SymbPos1)or(SymbPos1=0);
    F:=StringReplace(F,#38,'(',[rfReplaceAll]);
    F:=StringReplace(F,#39,')',[rfReplaceAll]);
    SymbPos1:=Pos('(',F);
{                showmessage('SymbPos1='+IntToSTr(SymbPos1)+#13+
                            'SymbPos2='+IntToStr(SymbPos2));}
//������ �� ����� ������� ( � ).
    ResForRecursion:=AnalyseFormula(Copy(F,SymbPos1+1,SymbPos2-SymbPos1-1),vars);
if not ResForRecursion.IsMathEx then
begin
Result.IsMathEx:=false;
exit;
end;
    ConCatRes(ResForRecursion,Result,tempfori,k);
    Delete(F,SymbPos1,SymbPos2-SymbPos1+1);

                   //#######################����� ��������
    if Length(ResForRecursion.FLine)=1 then
        for I := 0 to length(Result.VarAr) do
        begin
        if ResForRecursion.FLine[1]=Char(C_Min_Var+i) then
            begin
            Insert(Char(C_Min_DataAr+Result.VarAr[i].Pos),F,SymbPos1);
            break;
            end;
        Insert(Char(C_Min_DataAr-1+k),F,SymbPos1);
        end
    else
        Insert(Char(C_Min_DataAr-1+k),F,SymbPos1);

{    if Length(ResForRecursion.FLine)=1 then
        case ResForRecursion.FLine[1] of
        'x':Insert(Char(127+Result.x.Pos+1),F,SymbPos1);
        'y':Insert(Char(127+Result.y.Pos+1),F,SymbPos1);
        'z':Insert(Char(127+Result.z.Pos+1),F,SymbPos1);
        else
        Insert(Char(127+k),F,SymbPos1);
        end
    else
        Insert(Char(127+k),F,SymbPos1);}
                   //#######################

    SymbPos1:=Pos('(',F);
    end;


                                  {--------------------------}
                                  if F[1]=#2 then
                                  F:='0'+F;
                                  {--------------------------}


{------------------------------------------------------------}
{�������� �� ������� ��� ����� � ���������� �� � DataAr}
i:=1;
while i<=Length(F) do
  begin
   if StrScan(Numbers,F[i])<>nil then
      begin
      if F[i]<'p' then
      begin
      j:=0;
      repeat
         j:=j+1
      until StrScan(WNumbers,F[i+j])=nil;
      StrNum:=Copy(F,i,j);
      if not IsFloat(StrNum) then
        begin
        Result.IsMathEx:=false;
        exit;
        end;
      Result.DataAr[k].Data:=StrToFloat(StrNum);
      Result.DataAr[k].DT:=D;
      Delete(F,i,j);
      Insert(Char(k+C_Min_DataAr),F,i);
      k:=k+1;
      end
      else
        if F[i+1]='i' then
         begin
         Result.DataAr[k].Data:=Pi;
         Result.DataAr[k].DT:=D;
         Delete(F,i,2);
         Insert(Char(k+C_Min_DataAr),F,i);
         k:=k+1;
         end;
      end;
  i:=i+1;
  end;
{��������� ���������. ������ ������ ������� ���
x^_dataar0_+y^_dataar1_/y}

//////////////////////////////////////////////////////////////
//� ������ ������ ������ ������ ����� ���
//x^_dataar0_+y^_dataar1_/y. ��������:
//1) ����� � ������ �� ���������� ����� ����
//   ������ IndVar ���� _DAr_
//2) ����� ������� �������: ����� �� IndVar ����� ����
//   ������ �������
//3) ����� ���������� �������: ������ �� IndVar ����� ����
//   ������ �������
//4) ����� �� ������� ����� ���� ������ ������� ���� ������ �������
//5) ���� ������ - �� �������, �� �������, �� ���� � �� IndVar, ��
//   �� - ����� ������.
for I := 1 to Length(F) do
  begin
  case F[i] of
  #1..#5: begin
          if (i=1)or(i=length(F)) then
             begin
             Result.IsMathEx:=false;
             exit;
             end
          else
             begin
             if not (F[i-1]>=Char(C_Min_Var)) then
                 begin
                 Result.IsMathEx:=false;
                 exit;
                 end;
             if not ((F[i+1]>=Char(C_Min_Var))or((F[i+1]>=#6)and(F[i+1]<=Char(NOP)))) then
                 begin
                 Result.IsMathEx:=false;
                 exit;
                 end;
             end;
          end;
Char(C_Min_Var)..Char(C_Min_DataAr-1): begin
          if i>1 then
             if F[i-1]>Char(NOP) then
                 begin
                 Result.IsMathEx:=false;
                 exit;
                 end;
          if i<Length(F) then
             if F[i+1]>#5 then
                 begin
                 Result.IsMathEx:=false;
                 exit;
                 end;
          end;
#6..Char(NOP):
          begin
          if i=Length(F) then
             begin
             Result.IsMathEx:=false;
             exit;
             end
          else
          if (F[i-1]>=Char(C_Min_DataAr)) then
             begin
             Result.IsMathEx:=false;
             exit;
             end
          end;
else
  if not (F[i]>=Char(C_Min_DataAr)) then
             begin
             Result.IsMathEx:=false;
             exit;
             end;
  end;
  end;
///////////////////////////////////////////////////////////////

//�������� �������� �� ���������� ���������.
i:=tempfori;
//������ - �������.
SymbPos1:=pos(#6,F);
for j := 7 to NOP do
   if ((pos(Char(j),F)<SymbPos1)and(Pos(Char(j),F)>0))or(SymbPos1=0) then
   SymbPos1:=pos(Char(j),F);

while (F[SymbPos1+1]>#5)and(F[SymbPos1+1]<=Char(NOP)) do
    SymbPos1:=SymbPos1+1;
tempfori:=Ord(F[SymbPos1]);

   while SymbPos1>0 do
       begin
       Result.OperAr[1,i]:=tempfori;
        FillDataM(SymbPos1);
        Delete(F,SymbPos1,2);
        Result.DataAr[k].DT:=R;
        Result.DataAr[k].Numb:=i;
        Insert(Char(k+C_Min_DataAr),F,SymbPos1);
        k:=k+1;
        i:=i+1;

SymbPos1:=pos(#6,F);
for j := 7 to NOP do
   if ((pos(Char(j),F)<SymbPos1)and(Pos(Char(j),F)>0))or(SymbPos1=0) then
   SymbPos1:=pos(Char(j),F);
while (F[SymbPos1+1]>#5)and(F[SymbPos1+1]<=Char(NOP)) do
    SymbPos1:=SymbPos1+1;
tempfori:=Ord(F[SymbPos1]);
       end;

//��� - ���������� � �������
SymbPos1:=pos(#5,F);

   while SymbPos1>0 do
       begin
       Result.OperAr[1,i]:=5;
        FillDataM(SymbPos1);
        Delete(F,SymbPos1-1,3);
        Result.DataAr[k].DT:=R;
        Result.DataAr[k].Numb:=i;
        Insert(Char(k+C_Min_DataAr),F,SymbPos1-1);
        k:=k+1;
        i:=i+1;
        SymbPos1:=pos(#5,F);
       end;

//��� - ������������ � �������.
        SymbPos1:=pos(#4,F);
        SymbPos2:=pos(#3,F);
        j:=4;
        if ((SymbPos2<SymbPos1)and(SymbPos2>0))or (SymbPos1=0) then
            begin
            SymbPos1:=SymbPos2;
            j:=3;
            end;
   while SymbPos1>0 do
       begin
       Result.OperAr[1,i]:=j;
        FillDataM(SymbPos1);
        Delete(F,SymbPos1-1,3);
        Result.DataAr[k].DT:=R;
        Result.DataAr[k].Numb:=i;
        Insert(Char(k+C_Min_DataAr),F,SymbPos1-1);
        k:=k+1;
        i:=i+1;
        SymbPos1:=pos(#3,F);
        SymbPos2:=pos(#4,F);
        j:=3;
        if ((SymbPos2<SymbPos1)and(SymbPos2>0))or (SymbPos1=0) then
            begin
            SymbPos1:=SymbPos2;
            j:=4;
            end;
       end;

//����� � ���������
        SymbPos1:=pos(#2,F);
        SymbPos2:=pos(#1,F);
        j:=2;
        if ((SymbPos2<SymbPos1)and(SymbPos2>0))or (SymbPos1=0) then
            begin
            SymbPos1:=SymbPos2;
            j:=1;
            end;
   while SymbPos1>0 do
       begin
       Result.OperAr[1,i]:=j;
        FillDataM(SymbPos1);
        Delete(F,SymbPos1-1,3);
        Result.DataAr[k].DT:=R;
        Result.DataAr[k].Numb:=i;
        Insert(Char(k+C_Min_DataAr),F,SymbPos1-1);
        k:=k+1;
        i:=i+1;
        SymbPos1:=pos(#1,F);
        SymbPos2:=pos(#2,F);
        j:=1;
        if ((SymbPos2<SymbPos1)and(SymbPos2>0))or (SymbPos1=0) then
            begin
            SymbPos1:=SymbPos2;
            j:=2;
            end;
        end;

if length(F)=1 then
   begin
   for j := 0 to Length(Result.VarAr) - 1 do
      if f[1]=Char(j+C_Min_Var) then
        begin
           Result.DataAr[0].DT:=IndV;
           Result.DataAr[0].Numb:=j+1;
           Result.VarAr[j].IsIn:=true;
           Result.VarAr[j].Pos:=0;
           i:=0;
           k:=1;
        end;
{   case f[1] of
   'x': begin
           Result.DataAr[0].DT:=IndV;
           Result.DataAr[0].Numb:=1;
           Result.x.IsIn:=true;
           Result.x.Pos:=0;
           i:=0;
           k:=1;
        end;
   'y': begin
           Result.DataAr[0].DT:=IndV;
           Result.DataAr[0].Numb:=2;
           Result.y.IsIn:=true;
           Result.y.Pos:=0;
           i:=0;
           k:=1;
        end;
   end;}
   end;


   for j := 1 to 3 do
        SetLength(Result.OperAr[j],i);
   SetLength(Result.DataAr,k);

//���. ���������� ��������� ������� - � DataAr � OperAr
end;

  procedure TObj.FillPointsArray;
var i,j,k: integer;
   StepU,StepV,StepTime: extended;
   opres: Treal;
   UVArr: array of array of TPoint2d;
   stepT: extended;
   LeftY,RightY: extended;
//   VarVect: Tnvars;

  begin
  if ObjType=Curve_Param then
  NumOfLinesY:=0;

  if not DependsOnTime then
     NumOfLinesTime:=0;

  SetLength(PointsAr,NumOfLinesTime+1,NumOfLinesX+1,NumOfLinesY+1);
    SetLength(UVArr,NumOfLinesX+1,NumOfLinesY+1);

  if not (ObjType=Curve_Param) then
     begin
     DefDomain.BorderFunctionDown:=analyseFunc2d(DefDomain.BorderFunctionDown.Ftext,'t');
     DefDomain.BorderFunctionUp:=analyseFunc2d(DefDomain.BorderFunctionUp.Ftext,'t');
     if not ((DefDomain.BorderFunctionUp.IsMathEx and
           DefDomain.BorderFunctionDown.IsMathEx)) then
        begin
        self.IsMathEx:=false;
        exit;
        end;
     DefDomain.PointsArUp:=FillPointsArrayDefD(DefDomain.BorderFunctionUp);
     DefDomain.PointsArDown:=FillPointsArrayDefD(DefDomain.BorderFunctionDown);
     end;

if LinesHomogenity then
    begin
        //����� ��������� � �������� ������� defDomain.BorderFunc
          j:=0;
          while not DefDomain.PointsArUp[j].IsMathEx do
            begin
            j:=j+1;
            if j=NumOfLinesY then
              break;
            end;
          if (j=NumOfLinesY)and(not DefDomain.PointsArUp[j].IsMathEx) then
            begin
            IsMathEx:=false;
            exit;
            end;

          RightY:=DefDomain.PointsArUp[j].y;
          for I := j to NumOfLinesY do
             begin
             if DefDomain.PointsArUp[i].IsMathEx then
                begin
                if DefDomain.POintsArUp[i].y>RightY then
                    RightY:=DefDomain.PointsArUp[i].y;
                end;
             end;
        {----------}
          j:=0;
          while not DefDomain.PointsArDown[j].IsMathEx do
            begin
            j:=j+1;
            if j=NumOfLinesY then
              break;
            end;
          if (j=NumOfLinesY)and(not DefDomain.PointsArDown[j].IsMathEx) then
            begin
            IsMathEx:=false;
            exit;
            end;

          LeftY:=DefDomain.PointsArDown[j].y;
          for I := j to NumOfLinesY do
             begin
             if DefDomain.PointsArDown[i].IsMathEx then
                begin
                if DefDomain.POintsArDown[i].y<LeftY then
                    LeftY:=DefDomain.PointsArDown[i].y;
                end;
             end;
        //----------------------------------------------------------

    end;
  stepU:=(DefDomain.RightX-DefDomain.LeftX)/NumOfLinesX;
  if not (ObjType=curve_param) then
      stepV:=(RightY-LeftY)/NumOfLinesY;

  if DependsOnTime then
      stepTime:=(TimeMax-TimeMin)/NumOfLinesTime;


//���������� ������� UVArr
//UVArr[U,V]. U - �����. ���-�, V - �������.
case ObjType of
surf_ZofXY..Surf_param: begin
//U - x, V - y.
                if LinesHomogenity then
                for i:=0 to NumOfLinesX do
                  for j := 0 to NumOfLinesY do
                    begin
                      UVArr[i,j].x:=DefDomain.LeftX+StepU*i;
                      UVArr[i,j].y:=LeftY+StepV*j;
                    if not((DefDomain.PointsArUp[i].IsMathEx)and
                    (DefDomain.PointsArDown[i].IsMathEx))or
                    ((UVArr[i,j].y>DefDomain.PointsArUp[i].y)or
                    (UVArr[i,j].y<DefDomain.PointsArDown[i].y)) then
                        UVArr[i,j].IsMathEx:=false
                    else
                        UVARr[i,j].IsMathEx:=true;
                    end
                else
                for i:=0 to NumOfLinesX do
                  if (DefDomain.PointsArUp[i].IsMathEx)and
                      (DefDomain.PointsArDown[i].IsMathEx) then
                      begin
                      stepT:=(DefDomain.PointsArUp[i].y-DefDomain.PointsArDown[i].y)/NumOfLinesY;
                      for j := 0 to NumOfLinesY do
                          begin
                              UVArr[i,j].x:=DefDomain.LeftX+StepU*i;
                              UVArr[i,j].y:=DefDomain.PointsArDown[i].y+StepT*j;
                          UVARr[i,j].IsMathEx:=true
                          end;
                      end
                  else
                      UVarr[i,j].IsMathEx:=false;

            end;

Curve_Param: begin
                stepU:=(DefDomain.RightX-DefDomain.LeftX)/NumOfLinesX;
             for i := 0 to NumOfLinesX do
                begin
                UVArr[i,0].x:=DefDomain.LeftX+StepU*i;
                UVArr[i,0].IsMathEx:=true;
                end;
             end;
end;
{��������� �������, �� ������� ����� ������������...}
for k := 0 to NumOfLinesTime do
  begin
  for j := 0 to NumOfLinesY do
      for i := 0 to NumOfLinesX do
      begin
      PointsAr[k,i,j].IsmathEx:=true;
        if UVArr[i,j].IsMathEx then
              begin
//���������� ���������� �
              setlength(varvect,3);
              if ObjType=surf_ZofXY then
                    begin
                    if DefDomain.DefDType=YoX then
                          begin
                          PointsAr[k,i,j].x:=UVArr[i,j].x;
                          PointsAr[k,i,j].y:=UVArr[i,j].y;
                          end
                    else
                          begin

                          PointsAr[k,i,j].x:=UVArr[i,j].y;
                          PointsAr[k,i,j].y:=UVArr[i,j].x;
                          end;
                    VarVect[0]:=PointsAr[k,i,j].x;
                    VarVect[1]:=PointsAr[k,i,j].y;
//                    VarVect[2]:=0;
                    VarVect[2]:=TimeMin+k*StepTime;
                    opres:=GetOpres(FormulaZ.DataAr,FormulaZ.OperAr,VarVect);
                    if not opres.error then
                          PointsAr[k,i,j].z:=opres.result
                    else
                          UVArr[i,j].IsMathEx:=false;
                    end;

              if ObjType=surf_XofYZ then
                    begin
                    if DefDomain.DefDType=YoX then
                          begin
                          PointsAr[k,i,j].y:=UVArr[i,j].x;
                          PointsAr[k,i,j].z:=UVArr[i,j].y;
                          end
                    else
                          begin
                          PointsAr[k,i,j].y:=UVArr[i,j].y;
                          PointsAr[k,i,j].z:=UVArr[i,j].x;
                          end;
 //                   VarVect[0]:=0;
                    VarVect[0]:=PointsAr[k,i,j].y;
                    VarVect[1]:=PointsAr[k,i,j].z;
                    VarVect[2]:=TimeMin+k*StepTime;
                    opres:=GetOpres(FormulaX.DataAr,FormulaX.OperAr,VarVect);
                    if not opres.error then
                          PointsAr[k,i,j].x:=opres.result
                    else
                          UVArr[i,j].IsMathEx:=false;
                    end;

              if ObjType=surf_YofXZ then
                    begin
                    if DefDomain.DefDType=YoX then
                          begin
                          PointsAr[k,i,j].x:=UVArr[i,j].x;
                          PointsAr[k,i,j].z:=UVArr[i,j].y;
                          end
                    else
                          begin
                          PointsAr[k,i,j].x:=UVArr[i,j].y;
                          PointsAr[k,i,j].z:=UVArr[i,j].x;
                          end;
                    VarVect[0]:=PointsAr[k,i,j].x;
//                    VarVect[1]:=0;
                    VarVect[1]:=PointsAr[k,i,j].z;
                    VarVect[2]:=TimeMin+k*StepTime;
                    opres:=GetOpres(FormulaY.DataAr,FormulaY.OperAr,VarVect);
                    if not opres.error then
                          PointsAr[k,i,j].y:=opres.result
                    else
                          UVArr[i,j].IsMathEx:=false;
                    end;

              if objType=surf_param then
                    begin
                    if DefDomain.DefDType=YoX then
                          begin
                          VarVect[0]:=UVArr[i,j].x;
                          VarVect[1]:=UVArr[i,j].y;
 //                         VarVect[2]:=0;
                          VarVect[2]:=TimeMin+k*StepTime;
                          end
                    else
                          begin
                          VarVect[0]:=UVArr[i,j].y;
                          VarVect[1]:=UVArr[i,j].x;
 //                         VarVect[2]:=0;
                          VarVect[2]:=TimeMin+k*StepTime;
                          end;

                          opres:=GetOpres(FormulaX.DataAr,FormulaX.OperAr,VarVect);
                          if not opres.error then
                               begin
                               PointsAr[k,i,j].X:=opres.result;
                               opres:=GetOpres(FormulaY.DataAr,FormulaY.OperAr,VarVect);
                               if not opres.error then
                                    begin
                                    PointsAr[k,i,j].Y:=opres.result;
                                    opres:=GetOpres(FormulaZ.DataAr,FormulaZ.OperAr,VarVect);
                                    if not opres.error then
                                         PointsAr[k,i,j].Z:=opres.result
                                    else
                                         UVArr[i,j].IsMathEx:=false;
                                    end
                               else
                                    UVArr[i,j].IsMathEx:=false;
                               end
                          else
                          UVArr[i,j].IsMathEx:=false;
                    end;

              if ObjType=curve_Param then
                    begin
                    VarVect[0]:=UVArr[i,j].x;
                    VarVect[1]:=TimeMin+k*StepTime;
//                    VarVect[1]:=0;
                    VarVect[2]:=0;
                    opres:=GetOpres(FormulaX.DataAr,FormulaX.OperAr,VarVect);
                    if not opres.error then
                          begin
                          PointsAr[k,i,j].X:=opres.result;
                          opres:=GetOpres(FormulaY.DataAr,FormulaY.OperAr,VarVect);
                          if not opres.error then
                               begin
                               PointsAr[k,i,j].Y:=opres.result;
                               opres:=GetOpres(FormulaZ.DataAr,FormulaZ.OperAr,VarVect);
                               if not opres.error then
                                    PointsAr[k,i,j].Z:=opres.result
                               else
                                    UVArr[i,j].IsMathEx:=false;
                               end
                          else
                               UVArr[i,j].IsMathEx:=false;
                          end
                    else
                          UVArr[i,j].IsMathEx:=false;
                    end;

              end;
//        IsMathEx:=true;
//        opres.error:=false;
        //���������� �������� �, ��������� ���� ����
//        opres:=GetOpres();
      if not UVArr[i,j].IsMathEx then
              PointsAr[k,i,j].IsMathEx:=false;
      end;//����� for-for-if'a
  end;//����� ����� �� k(�����)
end;

  procedure TObj2d.FillPointsArray;
  var i,j: integer;
      opres: Treal;
      stepT: extended;
      varvect: Tnvars;
      TempArr: TPointsArray2d;
  begin
     SetLength(PointsAr,NumOfPoints+1);
     setlength(varvect,1);//�������� ��� RoA, XoY, Param
       stepT:=(RightX-LeftX)/NumOfPoints;
     setlength(TempArr,NumOfPoints+1);
      for i := 0 to NumOfPoints do
        begin
        TempArr[i].x:=LeftX+StepT*i;
{        if Funct.t.IsIn then
           Funct.DataAr[Funct.t.Pos].Data:=PointsAr[i].x;}
        //���������� �������� �, ��������� ���� ����
          VarVect[0]:=TempArr[i].x;
          opres:=GetOpRes(Funct.DataAr,Funct.OperAr,VarVect);
          if not opres.error then
              TempArr[i].y:=opres.result;
          TempArr[i].IsMathEx:= not opres.Error;
        case ObjType of
          YoX: begin
               PointsAr[i]:=TempArr[i];
               end;
          XoY: begin
               PointsAr[i].x:=TempArr[i].y;
               PointsAr[i].y:=TempArr[i].x;
               PointsAr[i].IsMathEx:=TempArr[i].IsMathEx;
               end;
          RoA: begin
               PointsAr[i].x:=TempArr[i].y*cos(TempArr[i].x);
               PointsAr[i].y:=TempArr[i].y*sin(TempArr[i].x);
               PointsAr[i].IsMathEx:=TempArr[i].IsMathEx;
               end;
          Param: begin
               PointsAr[i].x:=TempArr[i].y;
               PointsAr[i].IsMathEx:=TempArr[i].IsMathEx;
                 VarVect[0]:=TempArr[i].x;
                 opres:=GetOpRes(Funct1.DataAr,Funct1.OperAr,VarVect);
                 if not opres.error then
                     PointsAr[i].y:=opres.result;
                 PointsAr[i].IsMathEx:= (not opres.Error)and(PointsAr[i].IsMathEx);
               end;
        end;
        end;//����� for'a
  end;

   function GetOpres(var FDataAr: TDEA; var FOperAr: TOperAr; Vars: Tnvars):TReal;
   var i,j,k: integer;
   IsMathEx: boolean;
   begin
   for k := 0 to length(vars) - 1 do
      begin
      for i := 0 to length(FDataAr) - 1 do
        if (FDataAr[i].DT=IndV) and (FDataAr[i].Numb=k+1) then
           begin
           FDataAr[i].Data:=Vars[k];
           break;
           end;
      end;
   result.error:=false;
   IsMathEx:=true;
           k:=0;
        while k<=Length(FDataAr)-1 do
          begin
              if FDataAr[k].DT=R then
                  begin
                    case FOperAr[1,FDataAr[k].Numb] of
                       1:  result.result:=
                           FDataAr[FOperAr[2,FDataAr[k].Numb]].Data+
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data;
                       2:  result.result:=
                           FDataAr[FOperAr[2,FDataAr[k].Numb]].Data-
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data;
                       3:  result.result:=
                           FDataAr[FOperAr[2,FDataAr[k].Numb]].Data*
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data;
                       4:  result:=Fdiv  (
                           FDataAr[FOperAr[2,FDataAr[k].Numb]].Data,
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
                       5:  result:=FPower(
                           FDataAr[FOperAr[2,FDataAr[k].Numb]].Data,
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
                       6:  result:=FLog10(
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
                       7:  result:=Flog2 (
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
                       8:  result:=Fln   (
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
                       9:  result:=Flog  (
                           FDataAr[FOperAr[2,FDataAr[k].Numb]].Data,
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
                       10: result:=Fasin (
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
                       11: result:=Facos (
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
                       12:  result.result:=sin  (
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
                       13: result.result:=cos   (
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
                       14: result:=Fctg  (
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
                       15: result.result:=arctan(
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
                       16: result:=Ftg   (
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
                       17: result:=Fsqrt (
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
                       18: result.result:=abs   (
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
                       19: result.result:=sign  (
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
                       20: result.result:= Exp  (
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
                       21: result.result:=ceil  (
                           FDataAr[FOperAr[3,FDataAr[k].Numb]].Data);
//���������� �������� ��������...
                    end;
                  if result.Error then
                     begin
                     IsMathEx:=false;
                     end
                  else
                  FDataAr[k].Data:=result.result;
                  end;//����� if'a
          k:=k+1;
          if not IsMathEx then break;
          end;//����� while'�
          if IsMathEx then
              result.result:=FDataAr[k-1].Data; //��������� = �������� � ��������� ������ ������
          result.error:=not IsMathEx;
   end;

function GetNumericalDerivInPoint(var FDataAr: TDEA; var FOperAr: TOperAr; Vars: Tnvars; i: integer; eps: extended):TReal;
var j,k: integer;
opres,opres1: TReal;
begin
opres:=GetOpres(FDataAr,FOperAr,Vars);
//eps:=0.00000000001;//�� ������ ������. � �� ���� ��. 1e-13
 if opres.Error then
     begin
     result.error:=true;
     exit;
     end
 else
     begin
     setlength(varvect,length(vars));
     for k := 0 to length(vars) - 1 do
         varvect[k]:=vars[k];
     for k := 0 to 100 do//��� extended ������������ �� 308 ��������
     begin
        varvect[i]:=vars[i]+eps;//����� delta x
        opres1:=GetOpRes(FDataAr,FOperAr,varvect);
        if opres1.Error then
           eps:=eps/10
        else
           break;
     end;
     if opres1.Error then
        begin
        result.error:=true;
        exit;
        end;
     result.result:=(opres1.result-opres.result)/eps;
     result.error:=false;
     end;
end;

function GetDeriv(Formula: TFormula; x: integer): TFormula; overload;
var data: extended;
vars: string;
  i: Integer;
begin
if Length(Formula.OperAr[1])>0 then
   begin
   result:=GetDeriv(Formula,length(Formula.OperAr[1])-1,x);
{   vars:='';
   for i := 0 to length(formula.VarAr)-1 do
     vars:=vars+formula.VarAr[i].Name+' ';
   result:=AnalyseFormula(restorestring(result),vars);}
   if length(result.OperAr[1])=length(formula.OperAr[1]) then
       begin
       for i := 1 to 3 do
          setlength(result.OperAr[i],0);
       result.DataAr[0]:=result.DataAr[length(result.DataAr)-1];
       setlength(result.DataAr,1);
       end;

   end
else
   begin
   if length(Formula.DataAr)>0 then
      begin
      setlength(result.DataAr,1);
      result.DataAr[0].DT:=D;
      case Formula.DataAr[length(Formula.DataAr)-1].DT of
      IndV:  begin
             if Formula.DataAr[length(Formula.DataAr)-1].Numb=x then
                 data:=1
             else
                 data:=0;
             end;
      D:     begin
             data:=0;
             end;
      end;
      result.DataAr[0].Data:=data;
      end;//if DataAr is empty, then result should be empty too
   end;
   result.FLine:=RestoreString(result);
end;

function GetDeriv(Formula: TFormula; DerivatingOper: integer; x: integer): TFormula; overload;
var ADependonX,BDependonX: boolean;
aIndex,bIndex,daIndex,dbIndex: integer;
aTYpe,bTYpe: TDataType;
ctypeA,ctypeB: char;

    procedure AddDerivCode(var ResultFormula: TFormula;Rx: integer; x: integer; bType:TDataType; bIndex: integer;
                                                       dbIndex: integer = -1;
                                                       aType: TDataTYpe = IndV;
                                                       aIndex: integer = -1;
                                                       daIndex: integer = -1;
                                                       ctypeB: char = #0;
                                                       ctypeA: char = #0);
    var lo, ld,y: integer; //length_operar, length_dataar,X_position

        procedure AddtoFormula(var ResultFormula: TFormula; AddDataType: array of TDataType;
                                                  AddDataData: array of extended;
                                                  AddDataNumb: array of integer;
                                                  AddOperAr1: array of integer;
                                                  AddOperAr2: array of integer;
                                                  AddOperAr3: array of integer);
        var i,l,oldl: integer;
        begin
        l:=length(AddDataType);
        oldl:=length(ResultFormula.DataAr);
        setlength(ResultFormula.DataAr,oldl+l);
        for i := 0 to l-1 do
           begin
           ResultFormula.DataAr[oldl+i].DT:=AddDataType[i];
           ResultFormula.DataAr[oldl+i].Data:=AddDataData[i];
           ResultFormula.DataAr[oldl+i].Numb:=AddDataNumb[i];
           end;

        l:=length(AddOperAr1);
        oldl:=length(ResultFormula.OperAr[1]);
        for i := 1 to 3 do
          setlength(ResultFormula.OperAr[i],oldl+l);
        for i := 0 to l-1 do
           begin
           ResultFormula.OperAr[1,oldl+i]:=AddOperAr1[i];
           ResultFormula.OperAr[2,oldl+i]:=AddOperAr2[i];
           ResultFormula.OperAr[3,oldl+i]:=AddOperAr3[i];
           end;

        end;


    begin

    lo:=length(ResultFormula.OperAr[1])-1;
    ld:=length(ResultFormula.DataAr)-1;
    y:=ResultFormula.VarAr[x-1].Pos;
    case Rx of
    1:  begin   //+
        case aType of
          IndV: begin
                case bType of
                  IndV:  begin //x+x     : 2
                         AddToFormula(ResultFormula, [D],
                                                     [2],
                                                     [0],
                                                     [],[],[]);
                         end;
                  D:     begin//x+c      : 1
                         AddToFormula(ResultFormula, [D],
                                                     [1],
                                                     [0],
                                                     [],[],[]);
                         end;
                  R:     begin//x+f      : 0+f'
                         AddToFormula(ResultFormula, [D,R],
                                                     [1,0],
                                                     [0,lo+1],
                                                     [1]
                                                     ,[ld+1]
                                                     ,[dbIndex]);
                         end;
                end;

                end;
          D:    begin
                case bType of
                  IndV:  begin//c+x      : 1
                         AddToFormula(ResultFormula, [D],
                                                     [1],
                                                     [0],
                                                     [],[],[]);
                         end;
                  D:     begin//c+c      : 0
                         AddToFormula(ResultFormula, [D],
                                                     [0],
                                                     [0],
                                                     [],[],[]);
                         end;
                  R:     begin//c+f      : 0+f'
                         AddToFormula(ResultFormula, [D,R],
                                                     [0,0],
                                                     [0,lo+1],
                                                     [1]
                                                     ,[ld+1]
                                                     ,[dbIndex]);
                         end;
                end;

                end;
          R:    begin
                case bType of
                  IndV:  begin//f+x      : f'+1
                         AddToFormula(ResultFormula, [D,R],
                                                     [1,0],
                                                     [0,lo+1],
                                                     [1]
                                                     ,[ld+1]
                                                     ,[daIndex]);
                         end;
                  D:     begin//f+c      : f'+0
                         AddToFormula(ResultFormula, [D,R],
                                                     [0,0],
                                                     [0,lo+1],
                                                     [1]
                                                     ,[daIndex]
                                                     ,[ld+1]);
                         end;
                  R:     begin//f+f      : a'+b'
                         AddToFormula(ResultFormula, [R],
                                                     [0],
                                                     [lo+1],
                                                     [1]
                                                     ,[daIndex]
                                                     ,[dbIndex]);
                         end;
                end;
                end;
        end;
        end;
    2:  begin
        case aType of
          IndV: begin
                case bType of
                  IndV:  begin //x-x     : 0
                         AddToFormula(ResultFormula, [D],
                                                     [0],
                                                     [0],
                                                     [],[],[]);
                         end;
                  D:     begin//x-c      : 1
                         AddToFormula(ResultFormula, [D],
                                                     [1],
                                                     [0],
                                                     [],[],[]);
                         end;
                  R:     begin//x-f      : 1-f'
                         AddToFormula(ResultFormula, [D,R],
                                                     [1,0],
                                                     [0,lo+1],
                                                     [2]
                                                     ,[ld+1]
                                                     ,[dbIndex]);
                         end;
                end;

                end;
          D:    begin
                case bType of
                  IndV:  begin//c-x      : -1
                         AddToFormula(ResultFormula, [D],
                                                     [-1],
                                                     [0],
                                                     [],[],[]);
                         end;
                  D:     begin//c-c      : 0
                         AddToFormula(ResultFormula, [D],
                                                     [0],
                                                     [0],
                                                     [],[],[]);
                         end;
                  R:     begin//c-f      : 0-f'
                         AddToFormula(ResultFormula, [D,R],
                                                     [0,0],
                                                     [0,lo+1],
                                                     [2]
                                                     ,[ld+1]
                                                     ,[dbIndex]);
                         end;
                end;

                end;
          R:    begin
                case bType of
                  IndV:  begin//f-x      : f'-1
                         AddToFormula(ResultFormula, [D,R],
                                                     [1,0],
                                                     [0,lo+1],
                                                     [2]
                                                     ,[daIndex]
                                                     ,[ld+1]);
                         end;
                  D:     begin//f-c       : f'+0
                         AddToFormula(ResultFormula, [D,R],
                                                     [0,0],
                                                     [0,lo+1],
                                                     [1]
                                                     ,[daIndex]
                                                     ,[ld+1]);
                         end;
                  R:     begin//f-f       : f'-g'
                         AddToFormula(ResultFormula, [R],
                                                     [0],
                                                     [lo+1],
                                                     [2]
                                                     ,[daIndex]
                                                     ,[dbIndex]);
                         end;
                end;
                end;
        end;
        end;
    3:  begin
        case aType of
          IndV: begin
                case bType of
                  IndV:  begin //x*x      : 2*x
                         AddToFormula(ResultFormula, [D,R],
                                                     [2,0],
                                                     [0,lo+1],
                                                     [3],[ld+1],[y]);
                         end;
                  D:     begin//x*c       : 0  | 1 | c-0
                         case ctypeB of
                         '0':   AddToFormula(ResultFormula, [D],
                                                     [0],
                                                     [0],
                                                     [],[],[]);
                         '1':   AddToFormula(ResultFormula, [D],
                                                     [1],
                                                     [0],
                                                     [],[],[]);
                         'd':   AddToFormula(ResultFormula, [D,R],
                                                     [0,0],
                                                     [0,lo+1],
                                                     [2],
                                                     [bIndex],
                                                     [ld+1]);
                         end;
                         end;
                  R:     begin//x*f      : f+x*f'
                         AddToFormula(ResultFormula, [R,R],
                                                     [0,0],
                                                     [lo+1,lo+2],
                                                     [3,1]
                                                     ,[y,bindex]
                                                     ,[dbIndex,ld+1]);
                         end;
                end;

                end;
          D:    begin
                case bType of
                  IndV:  begin//c*x      : 0 | 1 | c-0
                         case ctypeA of
                         '0':   AddToFormula(ResultFormula, [D],
                                                     [0],
                                                     [0],
                                                     [],[],[]);
                         '1':   AddToFormula(ResultFormula, [D],
                                                     [1],
                                                     [0],
                                                     [],[],[]);
                         'd':   AddToFormula(ResultFormula, [D,R],
                                                     [0,0],
                                                     [0,lo+1],
                                                     [2],[aIndex],[ld+1]);
                         end;
                         end;
                  D:     begin//c*c         : 0
                         AddToFormula(ResultFormula, [D],
                                                     [0],
                                                     [0],
                                                     [],[],[]);
                         end;
                  R:     begin//c*f        : 0 | 1*f' | c*f'
                         case ctypeA of
                         '0':   AddToFormula(ResultFormula, [D],
                                                     [0],
                                                     [0],
                                                     [],[],[]);
                         '1':   AddToFormula(ResultFormula, [D,R],
                                                     [1,0],
                                                     [0,lo+1],
                                                     [3],[ld+1],[dbIndex]);
                         'd':   AddToFormula(ResultFormula, [R],
                                                     [0],
                                                     [lo+1],
                                                     [3],[aIndex],[dbIndex]);
                         end;
                         end;
                end;

                end;
          R:    begin
                case bType of
                  IndV:  begin//f*x        :f+x*f'
                         AddToFormula(ResultFormula, [R,R],
                                                     [0,0],
                                                     [lo+1,lo+2],
                                                     [3,1]
                                                     ,[y,aIndex]
                                                     ,[daIndex,ld+1]);
                         end;
                  D:     begin//f*c        : 0 | 1*f' | f'*c
                         case ctypeB of
                         '0':   AddToFormula(ResultFormula, [D],
                                                     [0],
                                                     [0],
                                                     [],[],[]);
                         '1':   AddToFormula(ResultFormula, [D,R],
                                                     [1,0],
                                                     [0,lo+1],
                                                     [3],[ld+1],[daIndex]);
                         'd':   AddToFormula(ResultFormula, [R],
                                                     [0],
                                                     [lo+1],
                                                     [3],[daIndex],[bIndex]);
                         end;
                         end;
                  R:     begin//f*f       : f'*g+g'*f
                         AddToFormula(ResultFormula, [R,R,R],
                                                     [0,0,0],
                                                     [lo+1,lo+2,lo+3],
                                                     [3,3,1]
                                                     ,[aIndex,daIndex,ld+1]
                                                     ,[dbIndex,bIndex,ld+2]);
                         end;
                end;
                end;
        end;
        end;
    4:  begin
        case aType of
          IndV: begin
                case bType of
                  IndV:  begin //x/x       : 0
                         AddToFormula(ResultFormula, [D],
                                                     [0],
                                                     [0],
                                                     []
                                                     ,[]
                                                     ,[]);
                         end;
                  D:     begin//x/c        : 1/0 | 1 | 1/c
                         case ctypeB of
                         '0':   AddToFormula(ResultFormula, [D,D,R],
                                                     [1,0,0],
                                                     [0,0,lo+1],
                                                     [4],[ld+1],[ld+2]);
                         '1':   AddToFormula(ResultFormula, [D],
                                                     [1],
                                                     [0],
                                                     [],[],[]);
                         'd':   AddToFormula(ResultFormula, [D,R],
                                                     [1,0],
                                                     [0,lo+1],
                                                     [4],[ld+1],[bIndex]);
                         end;
                         end;
                  R:     begin//x/f        : (f-x*f')/f^2
                         AddToFormula(ResultFormula, [D,R,R,R,R],
                                                     [2,0,0,0,0],
                                                     [0,lo+1,lo+2,lo+3,lo+4],
                                                     [3,2,5,4]
                                                     ,[y,bIndex,bIndex,ld+3]
                                                     ,[dbIndex,ld+2,ld+1,ld+4]);
                         end;
                end;

                end;
          D:    begin
                case bType of
                  IndV:  begin//c/x        : 0 | 0-1/x^2 | 0-c/x^2
                         case ctypeA of
                         '0':   AddToFormula(ResultFormula, [D],
                                                     [0],
                                                     [0],
                                                     [],
                                                     [],
                                                     []);
                         '1':   AddToFormula(ResultFormula, [D,D,D,R,R,R],
                                                     [0,1,2,0,0,0],
                                                     [0,0,0,lo+1,lo+2,lo+3],
                                                     [5,4,2],
                                                     [y,ld+2,ld+1],
                                                     [ld+3,ld+4,ld+5]);
                         'd':   AddToFormula(ResultFormula, [D,D,R,R,R],
                                                     [0,2,0,0,0],
                                                     [0,0,lo+1,lo+2,lo+3],
                                                     [5,4,2],
                                                     [y,aIndex,ld+1],
                                                     [ld+2,ld+3,ld+4]);
                         end;
                         end;
                  D:     begin//c/c         : 0
                         AddToFormula(ResultFormula, [D],
                                                     [0],
                                                     [0],
                                                     [],
                                                     [],
                                                     []);
                         end;
                  R:     begin//c/f         : 0 | 0-f'/f^2 | 0-2/f^2*f'
                         case ctypeA of
                         '0':   AddToFormula(ResultFormula, [D],
                                                     [0],
                                                     [0],
                                                     [],
                                                     [],
                                                     []);
                         '1':   AddToFormula(ResultFormula, [D,D,R,R,R],
                                                     [0,2,0,0,0],
                                                     [0,0,lo+1,lo+2,lo+3],
                                                     [5,4,2],
                                                     [bIndex,dbIndex,ld+1],
                                                     [ld+2,ld+3,ld+4]);
                         'd':   AddToFormula(ResultFormula, [D,D,R,R,R,R],
                                                     [0,2,0,0,0,0],
                                                     [0,0,lo+1,lo+2,lo+3,lo+4],
                                                     [5,4,3,2],
                                                     [bIndex,aIndex,ld+4,ld+1],
                                                     [ld+2,ld+3,dbIndex,ld+5]);
                         end;
                         end;
                end;

                end;
          R:    begin
                case bType of
                  IndV:  begin//f/x    : (x*f'-f)/x^2
                         AddToFormula(ResultFormula, [D,R,R,R,R],
                                                     [2,0,0,0,0],
                                                     [0,lo+1,lo+2,lo+3,lo+4],
                                                     [3,2,5,4],
                                                     [y,ld+2,y,ld+3],
                                                     [daIndex,aIndex,ld+1,ld+4]);
                         end;
                  D:     begin//f/c   : f'/0 | f'*1 | f'/c
                         case ctypeB of
                         '0':   AddToFormula(ResultFormula, [D,R],
                                                     [0,0],
                                                     [0,lo+1],
                                                     [4],
                                                     [daIndex],
                                                     [ld+1]);
                         '1':   AddToFormula(ResultFormula, [D,R],
                                                     [1,0],
                                                     [0,lo+1],
                                                     [3],
                                                     [ld+1],
                                                     [daIndex]);
                         'd':   AddToFormula(ResultFormula, [R],
                                                     [0],
                                                     [lo+1],
                                                     [4],
                                                     [daIndex],
                                                     [bIndex]);
                         end;
                         end;
                  R:     begin//f/f   : (f'*g-g'*f)/g^2
                         AddToFormula(ResultFormula, [D,R,R,R,R,R],
                                                     [2,0,0,0,0,0],
                                                     [0,lo+1,lo+2,lo+3,lo+4,lo+5],
                                                     [3,3,2,5,4],
                                                     [daIndex,dbIndex,ld+2,bIndex,ld+4],
                                                     [bIndex,aIndex,ld+3,ld+1,ld+5]);
                         end;
                end;

                end;
        end;
        end;
    5:  begin
        case aType of
          IndV: begin
                case bType of
                  IndV:  begin //x^x       : x^x*(lnx+1)
                         AddToFormula(ResultFormula, [D,R,R,R,R],
                                                     [1,0,0,0,0],
                                                     [0,lo+1,lo+2,lo+3,lo+4],
                                                     [8,1,5,3],
                                                     [0,ld+2,y,ld+4],
                                                     [y,ld+1,y,ld+3]);
                         end;
                  D:     begin//x^c       : 0 | 1 | c*x^(c-1)
                         case ctypeB of
                         '0':   AddToFormula(ResultFormula, [D],
                                                     [0],
                                                     [0],
                                                     [],
                                                     [],
                                                     []);
                         '1':   AddToFormula(ResultFormula, [D],
                                                     [1],
                                                     [0],
                                                     [],
                                                     [],
                                                     []);
                         'd':   AddToFormula(ResultFormula, [D,R,R,R],
                                                     [1,0,0,0],
                                                     [0,lo+1,lo+2,lo+3],
                                                     [2,5,3],
                                                     [bIndex,y,bIndex],
                                                     [ld+1,ld+2,ld+3]);
                         end;
                         end;
                  R:     begin//x^f         : x^f*(f'*lnx+f/x)
                         AddToFormula(ResultFormula, [R,R,R,R,R,R],
                                                     [0,0,0,0,0,0],
                                                     [lo+1,lo+2,lo+3,lo+4,lo+5,lo+6],
                                                     [8,3,4,1,5,3],
                                                     [0,dbIndex,bIndex,ld+2,y,ld+5],
                                                     [y,ld+1,y,ld+3,bIndex,ld+4]);
                         end;
                end;

                end;
          D:    begin
                case bType of
                  IndV:  begin//c^x       : 0 | 1 | lnc*c^x
                         case ctypea of
                         '0':   AddToFormula(ResultFormula, [D],
                                                     [0],
                                                     [0],
                                                     [],
                                                     [],
                                                     []);
                         '1':   AddToFormula(ResultFormula, [D],
                                                     [1],
                                                     [0],
                                                     [],
                                                     [],
                                                     []);
                         'd':   AddToFormula(ResultFormula, [R,R,R],
                                                     [0,0,0],
                                                     [lo+1,lo+2,lo+3],
                                                     [8,5,3],
                                                     [0,aIndex,ld+1],
                                                     [aIndex,y,ld+2]);
                         end;
                         end;
                  D:     begin//c^c             : 0
                         AddToFormula(ResultFormula, [D],
                                                     [0],
                                                     [0],
                                                     [],
                                                     [],
                                                     []);
                         end;
                  R:     begin//c^f            : 0 | 1 | lnc*c^f*f'
                         case ctypea of
                         '0':   AddToFormula(ResultFormula, [D],
                                                     [0],
                                                     [0],
                                                     [],
                                                     [],
                                                     []);
                         '1':   AddToFormula(ResultFormula, [D],
                                                     [1],
                                                     [0],
                                                     [],
                                                     [],
                                                     []);
                         'd':   AddToFormula(ResultFormula, [R,R,R,R],
                                                     [0,0,0,0],
                                                     [lo+1,lo+2,lo+3,lo+4],
                                                     [8,5,3,3],
                                                     [0,aIndex,ld+1,ld+3],
                                                     [aIndex,bIndex,ld+2,dbIndex]);
                         end;
                         end;
                end;

                end;
          R:    begin
                case bType of
                  IndV:  begin//f^x     : f^x*(lnf+x*f'/f)
                         AddToFormula(ResultFormula, [R,R,R,R,R,R],
                                                     [0,0,0,0,0,0],
                                                     [lo+1,lo+2,lo+3,lo+4,lo+5,lo+6],
                                                     [8,3,4,1,5,3],
                                                     [0,y,ld+2,ld+1,aIndex,ld+5],
                                                     [aIndex,daIndex,aIndex,ld+3,y,ld+4]);
                         end;
                  D:     begin//f^c     : 0 | 1*f' | c*f^(c-1)*f'
                         case ctypeB of
                         '0':   AddToFormula(ResultFormula, [D],
                                                     [0],
                                                     [0],
                                                     [],
                                                     [],
                                                     []);
                         '1':   AddToFormula(ResultFormula, [D,R],
                                                     [1,0],
                                                     [0,lo+1],
                                                     [3],
                                                     [ld+1],
                                                     [daIndex]);
                         'd':   AddToFormula(ResultFormula, [D,R,R,R,R],
                                                     [1,0,0,0,0],
                                                     [0,lo+1,lo+2,lo+3,lo+4],
                                                     [2,5,3,3],
                                                     [bIndex,aIndex,bIndex,ld+4],
                                                     [ld+1,ld+2,ld+3,daIndex]);
                         end;
                         end;
                  R:     begin//f^f
                         AddToFormula(ResultFormula, [R,R,R,R,R,R,R],
                                                     [0,0,0,0,0,0,0],
                                                     [lo+1,lo+2,lo+3,lo+4,lo+5,lo+6,lo+7],
                                                     [8,3,3,4,1,5,3],
                                                     [0,dbIndex,bIndex,ld+3,ld+2,aIndex,ld+6],
                                                     [aIndex,ld+1,daIndex,aIndex,ld+4,bIndex,ld+5]);
                         end;
                end;

                end;
        end;
        end;
    6:  begin   //log10 : 1/(x*ln10) | f'/(f*ln10)
        case bType of
          IndV: begin//g(x)
                AddToFormula(ResultFormula, [D,D,R,R,R],
                                            [1,10,0,0,0],
                                            [0,0,lo+1,lo+2,lo+3],
                                            [8,3,4],
                                            [0,y,ld+1],
                                            [ld+2,ld+3,ld+4]);
                end;
          D:    begin//g(c)
                AddToFormula(ResultFormula, [D],
                                            [0],
                                            [0],
                                            [],
                                            [],
                                            []);
                end;
          R:    begin//g(f)
                AddToFormula(ResultFormula, [D,R,R,R],
                                            [10,0,0,0],
                                            [0,lo+1,lo+2,lo+3],
                                            [8,3,4],
                                            [0,bIndex,dbIndex],
                                            [ld+1,ld+2,ld+3]);
                end;
        end;
        end;
    7:  begin    //log2 : 1/(x*ln2) | f'/(f*ln2)
        case bType of
          IndV: begin//g(x)
                AddToFormula(ResultFormula, [D,D,R,R,R],
                                            [1,2,0,0,0],
                                            [0,0,lo+1,lo+2,lo+3],
                                            [8,3,4],
                                            [0,y,ld+1],
                                            [ld+2,ld+3,ld+4]);
                end;
          D:    begin//g(c)
                AddToFormula(ResultFormula, [D],
                                            [0],
                                            [0],
                                            [],
                                            [],
                                            []);
                end;
          R:    begin//g(f)
                AddToFormula(ResultFormula, [D,R,R,R],
                                            [2,0,0,0],
                                            [0,lo+1,lo+2,lo+3],
                                            [8,3,4],
                                            [0,bIndex,dbIndex],
                                            [ld+1,ld+2,ld+3]);
                end;
        end;
        end;
    8:  begin  //lnx : 1/x | f'/f
        case bType of
          IndV: begin//g(x)
                AddToFormula(ResultFormula, [D,R],
                                            [1,0],
                                            [0,lo+1],
                                            [4],
                                            [ld+1],
                                            [y]);
                end;
          D:    begin//g(c)
                AddToFormula(ResultFormula, [D],
                                            [0],
                                            [0],
                                            [],
                                            [],
                                            []);
                end;
          R:    begin//g(f)
                AddToFormula(ResultFormula, [R],
                                            [0],
                                            [lo+1],
                                            [4],
                                            [dbIndex],
                                            [bIndex]);
                end;
        end;
        end;
    9:  begin   //!!! log(a,b). �������!
        case aType of
          IndV: begin
                case bType of
                  IndV:  begin //log(x,x)

                         end;
                  D:     begin//log(x,c)

                         end;
                  R:     begin//log(x,f)

                         end;
                end;

                end;
          D:    begin
                case bType of
                  IndV:  begin//c+x

                         end;
                  D:     begin//c+c

                         end;
                  R:     begin//c+f

                         end;
                end;

                end;
          R:    begin
                case bType of
                  IndV:  begin//f+x

                         end;
                  D:     begin//f+c

                         end;
                  R:     begin//f+f

                         end;
                end;

                end;
        end;
        end;
    10:  begin //!!! asinx:
        case bType of
          IndV: begin//g(x) - 1/sqrt(1-x^2)
                AddToFormula(ResultFormula, [D,D,D,R,R,R,R],
                                            [1,1,2,0,0,0,0],
                                            [0,0,0,lo+1,lo+2,lo+3,lo+4],
                                            [5,2,17,4],
                                            [y,ld+2,0,ld+1],
                                            [ld+3,ld+4,ld+5,ld+6]);
                end;
          D:    begin//g(c) - 0
                AddToFormula(ResultFormula, [D],
                                            [0],
                                            [0],
                                            [],
                                            [],
                                            []);
                end;
          R:    begin//g(f) - f'/sqrt(1-f^2)
                AddToFormula(ResultFormula, [D,D,R,R,R,R],
                                            [1,2,0,0,0,0],
                                            [0,0,lo+1,lo+2,lo+3,lo+4],
                                            [5,2,17,4],
                                            [bIndex,ld+1,0,dbIndex],
                                            [ld+2,ld+3,ld+4,ld+5]);
                end;
        end;
        end;
    11:  begin  //!!! acosx:  -1/sqrt(1-x^2) | 0 | 0-f'/sqrt(1-f^2)
        case bType of
          IndV: begin//g(x)
                AddToFormula(ResultFormula, [D,D,D,R,R,R,R],
                                            [-1,1,2,0,0,0,0],
                                            [0,0,0,lo+1,lo+2,lo+3,lo+4],
                                            [5,2,17,4],
                                            [y,ld+2,0,ld+1],
                                            [ld+3,ld+4,ld+5,ld+6]);
                end;
          D:    begin//g(c)
                AddToFormula(ResultFormula, [D],
                                            [0],
                                            [0],
                                            [],
                                            [],
                                            []);
                end;
          R:    begin//g(f)
                AddToFormula(ResultFormula, [D,D,D,R,R,R,R,R],
                                            [1,2,0,0,0,0,0,0],
                                            [0,0,0,lo+1,lo+2,lo+3,lo+4,lo+5],
                                            [5,2,17,4,2],
                                            [bIndex,ld+1,0,dbIndex,ld+3],
                                            [ld+2,ld+4,ld+5,ld+6,ld+7]);
                end;
        end;
        end;
    12:  begin //sinx: cosx | cosf * f'
        case bType of
          IndV: begin//g(x)
                AddToFormula(ResultFormula, [R],
                                            [0],
                                            [lo+1],
                                            [13],
                                            [0],
                                            [y]);
                end;
          D:    begin//g(c)
                AddToFormula(ResultFormula, [D],
                                            [0],
                                            [0],
                                            [],
                                            [],
                                            []);
                end;
          R:    begin//g(f)
                AddToFormula(ResultFormula, [R,R],
                                            [0,0],
                                            [lo+1,lo+2],
                                            [13,3],
                                            [0,ld+1],
                                            [bIndex,dbIndex]);
                end;
        end;
        end;
    13:  begin  //cosx : 0-sinx | 0-sinf*f'
        case bType of
          IndV: begin//g(x)
                AddToFormula(ResultFormula, [D,R,R],
                                            [0,0,0],
                                            [0,lo+1,lo+2],
                                            [12,2],
                                            [0,ld+1],
                                            [y,ld+2]);
                end;
          D:    begin//g(c)
                AddToFormula(ResultFormula, [D],
                                            [0],
                                            [0],
                                            [],
                                            [],
                                            []);
                end;
          R:    begin//g(f)
                AddToFormula(ResultFormula, [D,R,R,R],
                                            [0,0,0,0],
                                            [0,lo+1,lo+2,lo+3],
                                            [12,3,2],
                                            [0,ld+2,ld+1],
                                            [bIndex,dbIndex,ld+3]);
                end;
        end;
        end;
    14:  begin   //ctgx: 0-1/(sinx)^2 | 0-f'/(sinf)^2
        case bType of
          IndV: begin//g(x)
                AddToFormula(ResultFormula, [D,D,D,R,R,R,R],
                                            [0,1,2,0,0,0,0],
                                            [0,0,0,lo+1,lo+2,lo+3,lo+4],
                                            [12,5,4,2],
                                            [0,ld+4,ld+2,ld+1],
                                            [y,ld+3,ld+5,ld+6]);
                end;
          D:    begin//g(c)
                AddToFormula(ResultFormula, [D],
                                            [0],
                                            [0],
                                            [],
                                            [],
                                            []);
                end;
          R:    begin//g(f)
                AddToFormula(ResultFormula, [D,D,R,R,R,R],
                                            [0,2,0,0,0,0],
                                            [0,0,lo+1,lo+2,lo+3,lo+4],
                                            [12,5,4,2],
                                            [0,ld+3,dbIndex,ld+1],
                                            [bIndex,ld+2,ld+4,ld+5]);
                end;
        end;
        end;
    15:  begin    // atgx: 1/(1+x^2) | 0 | f'/(1+f^2)
        case bType of
          IndV: begin//g(x)
                AddToFormula(ResultFormula, [D,D,D,R,R,R],
                                            [2,1,1,0,0,0],
                                            [0,0,0,lo+1,lo+2,lo+3],
                                            [5,1,4],
                                            [y,ld+2,ld+3],
                                            [ld+1,ld+4,ld+5]);
                end;
          D:    begin//g(c)
                AddToFormula(ResultFormula, [D],
                                            [0],
                                            [0],
                                            [],
                                            [],
                                            []);
                end;
          R:    begin//g(f)
                AddToFormula(ResultFormula, [D,D,R,R,R],
                                            [2,1,0,0,0],
                                            [0,0,lo+1,lo+2,lo+3],
                                            [5,1,4],
                                            [bIndex,ld+2,dbIndex],
                                            [ld+1,ld+3,ld+4]);
                end;
        end;
        end;
    16:  begin    //tgx
        case bType of
          IndV: begin//g(x)
                AddToFormula(ResultFormula, [D,D,R,R,R],
                                            [1,2,0,0,0],
                                            [0,0,lo+1,lo+2,lo+3],
                                            [13,5,4],
                                            [0,ld+3,ld+1],
                                            [y,ld+2,ld+4]);
                end;
          D:    begin//g(c)
                AddToFormula(ResultFormula, [D],
                                            [0],
                                            [0],
                                            [],
                                            [],
                                            []);
                end;
          R:    begin//g(f)
                AddToFormula(ResultFormula, [D,R,R,R],
                                            [2,0,0,0],
                                            [0,lo+1,lo+2,lo+3],
                                            [13,5,4],
                                            [0,ld+2,dbIndex],
                                            [bIndex,ld+1,ld+3]);
                end;
        end;
        end;
    17:  begin   //sqrtx  : 1/(2*sqrt(x)) | f'/(2*sqrtf)
        case bType of
          IndV: begin//g(x)
                AddToFormula(ResultFormula, [D,D,R,R,R],
                                            [1,2,0,0,0],
                                            [0,0,lo+1,lo+2,lo+3],
                                            [17,3,4],
                                            [0,ld+2,ld+1],
                                            [y,ld+3,ld+4]);
                end;
          D:    begin//g(c)
                AddToFormula(ResultFormula, [D],
                                            [0],
                                            [0],
                                            [],
                                            [],
                                            []);
                end;
          R:    begin//g(f)
                AddToFormula(ResultFormula, [D,R,R,R],
                                            [2,0,0,0],
                                            [0,lo+1,lo+2,lo+3],
                                            [17,3,4],
                                            [0,ld+1,dbIndex],
                                            [bIndex,ld+2,ld+3]);
                end;
        end;
        end;
    18:  begin   //absx: signx | f'*sign(f)
        case bType of
          IndV: begin//g(x)
                AddToFormula(ResultFormula, [R],
                                            [0],
                                            [lo+1],
                                            [19],
                                            [0],
                                            [y]);
                end;
          D:    begin//g(c)
                AddToFormula(ResultFormula, [D],
                                            [0],
                                            [0],
                                            [],
                                            [],
                                            []);
                end;
          R:    begin//g(f)
                AddToFormula(ResultFormula, [R,R],
                                            [0,0],
                                            [lo+1,lo+2],
                                            [19,3],
                                            [0,dbIndex],
                                            [bIndex,ld+1]);
                end;
        end;
        end;
    19:  begin  //signx : 0 | 0
        case bType of
          IndV: begin//g(x)
                AddToFormula(ResultFormula, [D],
                                            [0],
                                            [0],
                                            [],
                                            [],
                                            []);
                end;
          D:    begin//g(c)
                AddToFormula(ResultFormula, [D],
                                            [0],
                                            [0],
                                            [],
                                            [],
                                            []);
                end;
          R:    begin//g(f)
                AddToFormula(ResultFormula, [D],
                                            [0],
                                            [0],
                                            [],
                                            [],
                                            []);
                end;
        end;
        end;
    20:  begin  //expx: expx | f'*expf
        case bType of
          IndV: begin//g(x)
                AddToFormula(ResultFormula, [R],
                                            [0],
                                            [lo+1],
                                            [20],
                                            [0],
                                            [y]);
                end;
          D:    begin//g(c)
                AddToFormula(ResultFormula, [D],
                                            [0],
                                            [0],
                                            [],
                                            [],
                                            []);
                end;
          R:    begin//g(f)
                AddToFormula(ResultFormula, [R,R],
                                            [0,0],
                                            [lo+1,lo+2],
                                            [20,3],
                                            [0,dbIndex],
                                            [bIndex,ld+1]);
                end;
        end;
        end;
    21:  begin // intx: 0
        case bType of
          IndV: begin//g(x)
                AddToFormula(ResultFormula, [D,R],
                                            [0,0],
                                            [0,lo+1],
                                            [3],
                                            [ld+1],
                                            [dbIndex]);
                end;
          D:    begin//g(c)
                AddToFormula(ResultFormula, [D,R],
                                            [0,0],
                                            [0,lo+1],
                                            [3],
                                            [ld+1],
                                            [dbIndex]);
                end;
          R:    begin//g(f)
                AddToFormula(ResultFormula, [D,R],
                                            [0,0],
                                            [0,lo+1],
                                            [3],
                                            [ld+1],
                                            [dbIndex]);
                end;
        end;
        end;

    end;

    end;

begin
   result:=Formula;

   aIndex:=Formula.OperAr[2,DerivatingOper];
   bIndex:=Formula.OperAr[3,DerivatingOper];

   aType:=D; bType:=D; //������ �� ���������. ��� �� ������ ��������������. ��
                       //������� ����������� ���� ������, �, �� ��������� ������� �������,
                       //������ �� ��������� ���� ���. ����� � ������ ������ ������� ��������
                       //���� ���, ������������ ����-���� ��������...

    ctypeA:='d';
    ctypeB:='d';

   case result.OperAr[1,DerivatingOper] of
   1..5,9: begin //     +-*/^log : 2 args
           ADependonX:=DoesOperArgDependOnX(Formula,DerivatingOper,0,x);
           BDependonX:=DoesOperArgDependOnX(Formula,DerivatingOper,1,x);

           //------------����������� ���� ����� �����
           if (Formula.DataAr[aIndex].DT=IndV)and(Formula.DataAr[aIndex].Numb=x) then
              aType:=IndV;

           if not aDependonX then
              aType:=D;

           if (Formula.DataAr[aIndex].DT=R)and aDependOnX then
              aType:=R;

           //---------------------------
           if (Formula.DataAr[bIndex].DT=IndV)and(Formula.DataAr[bIndex].Numb=x) then
              bType:=IndV;

           if not bDependonX then
              bType:=D;

           if (Formula.DataAr[bIndex].DT=R)and bDependOnX then
              bType:=R;
           //-------------$$$$$$$$$$$$$$$$$$$$$$$$$$$$
           //-------------�������� ��� �������� - ����, �������, ��� ���������
           if not ADependonX then
              if Formula.DataAr[aIndex].DT=D then
                 begin
                 if Formula.DataAr[aIndex].Data=0 then
                    ctypeA:='0';
                 if Formula.DataAr[aIndex].Data=1 then
                    ctypeA:='1';
                 end;//by default=d


           if not BDependonX then
              if Formula.DataAr[bIndex].DT=D then
                 begin
                 if Formula.DataAr[bIndex].Data=0 then
                    ctypeB:='0';
                 if Formula.DataAr[bIndex].Data=1 then
                    ctypeB:='1';
                 end;//by default=d
           //-------------$$$$$$$$$$$$$$$$$$$$$$$$$$$$
           if not ADependonX then  //���� ����� ���������, �� ��������� DataAr ������ 0 - ����������� �����������������
              begin
              SetLength(result.DataAr,length(result.DataAr)+1);
              daIndex:=length(result.DataAr)-1;
              result.DataAr[daIndex].DT:=D;
              result.DataAr[daIndex].Data:=0;
              end
           else
              begin
              if aType=IndV then
                  begin// ���� ����� ��� �, �� ��������� DataAr ������ 1 - ����������� ����-�
                  SetLength(result.DataAr,length(result.DataAr)+1);
                  daIndex:=length(result.DataAr)-1;
                  result.DataAr[daIndex].DT:=D;
                  result.DataAr[daIndex].Data:=1;
                  end
              else // ���� ����� ����� f(x), �� ��������
                  begin
                  result:=GetDeriv(result,result.DataAr[aIndex].Numb,x);
                  daIndex:=length(result.DataAr)-1;
                  end;
              end;

           if not BDependonX then  //���� ������ ���������, �� ��������� DataAr ������ 0 - ����������� �����������������
              begin
              SetLength(result.DataAr,length(result.DataAr)+1);
              dbIndex:=length(result.DataAr)-1;
              result.DataAr[dbIndex].DT:=D;
              result.DataAr[dbIndex].Data:=0;
              end
           else
              begin
              if (Formula.DataAr[bIndex].DT=IndV)and(Formula.DataAr[bIndex].Numb=x) then
                  begin// ���� ������ ��� �, �� ��������� DataAr ������ 1 - ����������� ����-�
                  SetLength(result.DataAr,length(result.DataAr)+1);
                  dbIndex:=length(result.DataAr)-1;
                  result.DataAr[dbIndex].DT:=D;
                  result.DataAr[dbIndex].Data:=1;
                  end
              else // ���� ������ ����� f(x), �� ��������
                  begin
                  result:=GetDeriv(result,result.DataAr[bIndex].Numb,x);
                  dbIndex:=length(result.DataAr)-1;
                  end;
              end;

           AddDerivCode(result, Formula.OperAr[1,DerivatingOper],x,bType,bIndex, dbIndex,
                                                         aType,aIndex,daIndex,
                                                         ctypeB,ctypeA);
           end;
   else    begin //     function of 1 arg
           BDependonX:=DoesOperArgDependOnX(Formula,DerivatingOper,1,x);

           //------------����������� ���� ����� �����
           if (Formula.DataAr[bIndex].DT=IndV)and(Formula.DataAr[bIndex].Numb=x) then
              bType:=IndV;

           if not bDependonX then
              bType:=D;

           if (Formula.DataAr[bIndex].DT=R)and bDependOnX then
              bType:=R;
           //-------------$$$$$$$$$$$$$$$$$$$$$$$$$$$$
           //-------------�������� ��� �������� - ����, �������, ��� ���������

           if not BDependonX then
              if Formula.DataAr[bIndex].DT=D then
                 begin
                 if Formula.DataAr[bIndex].Data=0 then
                    ctypeB:='0';
                 if Formula.DataAr[bIndex].Data=1 then
                    ctypeB:='1';
                 end;//by default=d
           //-------------$$$$$$$$$$$$$$$$$$$$$$$$$$$$

           if not BDependonX then  //���� ������ ���������, �� ��������� DataAr ������ 0 - ����������� �����������������
              begin
              SetLength(result.DataAr,length(result.DataAr)+1);
              dbIndex:=length(result.DataAr)-1;
              result.DataAr[dbIndex].DT:=D;
              result.DataAr[dbIndex].Data:=0;
              end
           else
              begin
              if (Formula.DataAr[bIndex].DT=IndV)and(Formula.DataAr[bIndex].Numb=x) then
                  begin// ���� ������ ��� �, �� ��������� DataAr ������ 1 - ����������� ����-�
                  SetLength(result.DataAr,length(result.DataAr)+1);
                  dbIndex:=length(result.DataAr)-1;
                  result.DataAr[dbIndex].DT:=D;
                  result.DataAr[dbIndex].Data:=1;
                  end
              else // ���� ������ ����� f(x), �� ��������
                  begin
                  result:=GetDeriv(result,result.DataAr[bIndex].Numb,x);
                  dbIndex:=length(result.DataAr)-1;
                  end;
              end;

           AddDerivCode(result, Formula.OperAr[1,DerivatingOper],x,bType,bIndex, dbIndex);
           end;
   end;
end;

function DoesOperationDependOnX(const Formula: TFormula; Oper: integer; x: integer): boolean;
begin
  result:=false;
  case Formula.OperAr[1,Oper] of
  1..5,9:begin //    +-*/^log : 2 args
         result:=DoesOperArgDependOnX(Formula,Oper,0,x) OR DoesOperArgDependOnX(Formula,Oper,1,x);
         end;
  else         //    function of 1 arg
         result:=DoesOperArgDependOnX(Formula,Oper,1,x);
  end;
end;

function DoesOperArgDependOnX(const Formula: TFormula; Oper: integer; argn: integer; x: integer): boolean;
var argIndex: integer;
begin
   result:=false;
   argIndex:=Formula.OperAr[2+argn,Oper];

   case Formula.DataAr[argIndex].DT of
   IndV:  begin
          result:= Formula.DataAr[argIndex].Numb=x;
          end;
   D:     begin
          result:=false;
          end;
   R:     begin
          result:=DoesOperationDependOnX(Formula,Formula.DataAr[argIndex].Numb,x);
          end;
   end;
end;

function RestoreString(var Formula: TFormula): string; overload;
begin
if length(Formula.OperAr[1])>0 then
  result:=RestoreString(Formula,Length(Formula.OperAr[1])-1)
else
  begin
  if length(Formula.DataAr)>0 then
    begin
    case Formula.DataAr[0].DT of
    IndV:   result:=Formula.VarAr[Formula.DataAr[0].Numb].Name;
    D:      result:=FloatToStr(Formula.DataAr[0].Data);
    end;
    end
  else
    result:='';
  end;
end;

function RestoreString(var Formula: TFormula; RestoringOper: integer): string; overload;
var i,j,k: integer;
abranches,bbranches: boolean; //�������� �� �������� ����� � ������ ���������
astr,bstr: string; //������ ����������
aIndex,bIndex: integer;
begin
abranches:=false; bbranches:=false;
  case Formula.OperAr[1,RestoringOper] of
    1:      // a+b
       begin
           aIndex:=Formula.OperAr[2,RestoringOper];
           bIndex:=Formula.OperAr[3,RestoringOper];
           //$$$    1. left part - a: ����� �� ������?
           //(a)+.. ����� a = ������������� �����
           if Formula.DataAr[aIndex].DT=D then
              if Formula.DataAr[aIndex].Data<0 then
              abranches:=true;

       case Formula.DataAr[aIndex].DT of //���� �����
         IndV: begin  //����������
            astr:=Formula.VarAr[Formula.DataAr[aIndex].Numb-1].Name;
            end;
         D: begin     //������
            astr:=FloatToStr(Formula.DataAr[aIndex].Data);
            end;
         R: Begin    //��������
            astr:=RestoreString(Formula,Formula.DataAr[aIndex].Numb);
            end;
       end;

       if abranches then   //��������� ������ ��� �������������
           astr:='('+astr+')';

           //$$$     2. right part - b: ����� �� ������?
           //..+(b) �������

       case Formula.DataAr[bIndex].DT of //���� ������
         IndV: begin  //����������
            bstr:=Formula.VarAr[Formula.DataAr[bIndex].Numb-1].Name;
            end;
         D: begin     //������
            bstr:=FloatToStr(Formula.DataAr[bIndex].Data);
            end;
         R: Begin    //��������
            bstr:=RestoreString(Formula,Formula.DataAr[bIndex].Numb);
            end;
       end;

       if bbranches then   //��������� ������ ��� �������������
           bstr:='('+bstr+')';

       //$$$$     3. ���������� ������

       result:=astr+'+'+bstr;

       if Formula.DataAr[bIndex].DT=D then
          if Formula.DataAr[bIndex].Data<0 then
              result:=astr+bstr;
       end; {----------------------------------------------------------------}
    2:     // a-b
       begin
           aIndex:=Formula.OperAr[2,RestoringOper];
           bIndex:=Formula.OperAr[3,RestoringOper];
           //$$$    1. left part - a: ����� �� ������?
           //(a)-.. ����� a = ������������� �����
           if Formula.DataAr[aIndex].DT=D then
              if Formula.DataAr[aIndex].Data<0 then
              abranches:=true;

       case Formula.DataAr[aIndex].DT of //���� �����
         IndV: begin  //����������
            astr:=Formula.VarAr[Formula.DataAr[aIndex].Numb-1].Name;
            end;
         D: begin     //������
            astr:=FloatToStr(Formula.DataAr[aIndex].Data);
            end;
         R: Begin    //��������
            astr:=RestoreString(Formula,Formula.DataAr[aIndex].Numb);
            end;
       end;

       if abranches then   //��������� ������ ��� �������������
           astr:='('+astr+')';

           //$$$     2. right part - b: ����� �� ������?
           //..-(b) ����� b = R+ ��� R-
           if Formula.DataAr[bIndex].DT=R then
              if (Formula.OperAr[1,Formula.DataAr[bIndex].Numb]=1) or
                 (Formula.OperAr[1,Formula.DataAr[bIndex].Numb]=2) then
                     bbranches:=true;

       case Formula.DataAr[bIndex].DT of //���� ������
         IndV: begin  //����������
            bstr:=Formula.VarAr[Formula.DataAr[bIndex].Numb-1].Name;
            end;
         D: begin     //������
            bstr:=FloatToStr(Formula.DataAr[bIndex].Data);
            end;
         R: Begin    //��������
            bstr:=RestoreString(Formula,Formula.DataAr[bIndex].Numb);
            end;
       end;

       if bbranches then   //��������� ������ ��� �������������
           bstr:='('+bstr+')';

       //$$$$     3. ���������� ������

       result:=astr+'-'+bstr;

       if Formula.DataAr[bIndex].DT=D then
          if Formula.DataAr[bIndex].Data<0 then
              result:=astr+'+'+FloatToStr(-Formula.DataAr[bIndex].Data);
       end; {----------------------------------------------------------------}

    3..4: //a*b | a/b
       begin
           aIndex:=Formula.OperAr[2,RestoringOper];
           bIndex:=Formula.OperAr[3,RestoringOper];
           //$$$    1. left part - a: ����� �� ������?
           //(a)*.. ����� a = ������������� ����� ��� R+ ��� R-
           if Formula.DataAr[aIndex].DT=D then
              if Formula.DataAr[aIndex].Data<0 then
              abranches:=true;

           if Formula.DataAr[aIndex].DT=R then
              if (Formula.OperAr[1,Formula.DataAr[aIndex].Numb]=1) or
                 (Formula.OperAr[1,Formula.DataAr[aIndex].Numb]=2) then
                     abranches:=true;

       case Formula.DataAr[aIndex].DT of //���� �����
         IndV: begin  //����������
            astr:=Formula.VarAr[Formula.DataAr[aIndex].Numb-1].Name;
            end;
         D: begin     //������
            astr:=FloatToStr(Formula.DataAr[aIndex].Data);
            end;
         R: Begin    //��������
            astr:=RestoreString(Formula,Formula.DataAr[aIndex].Numb);
            end;
       end;

       if abranches then   //��������� ������ ��� �������������
           astr:='('+astr+')';

           //$$$     2. right part - b: ����� �� ������?
           //..*(b) ����� b = ������������� ����� ��� R+ ��� R-
           if Formula.DataAr[bIndex].DT=D then
              if Formula.DataAr[bIndex].Data<0 then
              bbranches:=true;
           if Formula.DataAr[bIndex].DT=R then
              if (Formula.OperAr[1,Formula.DataAr[bIndex].Numb]=1) or
                 (Formula.OperAr[1,Formula.DataAr[bIndex].Numb]=2) or
                 (Formula.OperAr[1,Formula.DataAr[bIndex].Numb]=3) or
                 (Formula.OperAr[1,Formula.DataAr[bIndex].Numb]=4) then
                     bbranches:=true;

       case Formula.DataAr[bIndex].DT of //���� ������
         IndV: begin  //����������
            bstr:=Formula.VarAr[Formula.DataAr[bIndex].Numb-1].Name;
            end;
         D: begin     //������
            bstr:=FloatToStr(Formula.DataAr[bIndex].Data);
            end;
         R: Begin    //��������
            bstr:=RestoreString(Formula,Formula.DataAr[bIndex].Numb);
            end;
       end;

       if bbranches then   //��������� ������ ��� �������������
           bstr:='('+bstr+')';

       //$$$$     3. ���������� ������
       if Formula.OperAr[1,RestoringOper]=3 then
         result:=astr+'*'+bstr
       else
         result:=astr+'/'+bstr;
       end; {----------------------------------------------------------------}

    5:   //a^b
       begin
           aIndex:=Formula.OperAr[2,RestoringOper];
           bIndex:=Formula.OperAr[3,RestoringOper];
           //$$$    1. left part - a: ����� �� ������?
           //(a)^.. ������, ����� a = ��������������� ����� ��� ����������
           abranches:=true;
           if Formula.DataAr[aIndex].DT=D then
              if Formula.DataAr[aIndex].Data>=0 then
              abranches:=false;

           if Formula.DataAr[aIndex].DT=IndV then
              abranches:=false;

       case Formula.DataAr[aIndex].DT of //���� �����
         IndV: begin  //����������
            astr:=Formula.VarAr[Formula.DataAr[aIndex].Numb-1].Name;
            end;
         D: begin     //������
            astr:=FloatToStr(Formula.DataAr[aIndex].Data);
            end;
         R: Begin    //��������
            astr:=RestoreString(Formula,Formula.DataAr[aIndex].Numb);
            end;
       end;

       if abranches then   //��������� ������ ��� �������������
           astr:='('+astr+')';

           //$$$     2. right part - b: ����� �� ������?
           //..^(b) ������, ����� b = ��������������� ����� ��� ����������
           bbranches:=true;
           if Formula.DataAr[bIndex].DT=D then
              if Formula.DataAr[bIndex].Data>=0 then
              bbranches:=false;

           if Formula.DataAr[bIndex].DT=IndV then
              bbranches:=false;

       case Formula.DataAr[bIndex].DT of //���� ������
         IndV: begin  //����������
            bstr:=Formula.VarAr[Formula.DataAr[bIndex].Numb-1].Name;
            end;
         D: begin     //������
            bstr:=FloatToStr(Formula.DataAr[bIndex].Data);
            end;
         R: Begin    //��������
            bstr:=RestoreString(Formula,Formula.DataAr[bIndex].Numb);
            end;
       end;

       if bbranches then   //��������� ������ ��� �������������
           bstr:='('+bstr+')';

       //$$$$     3. ���������� ������
       result:=astr+'^'+bstr;
       end; {----------------------------------------------------------------}
    9:   //log(a,b)
       begin
           aIndex:=Formula.OperAr[2,RestoringOper];
           bIndex:=Formula.OperAr[3,RestoringOper];
           //$$$    1. left part - a: ����� �� ������?
           //log((a),..) ������, ����� a = ��������������� ����� ��� ����������
           abranches:=true;
           if Formula.DataAr[aIndex].DT=D then
              if Formula.DataAr[aIndex].Data>=0 then
              abranches:=false;

           if Formula.DataAr[aIndex].DT=IndV then
              abranches:=false;

       case Formula.DataAr[aIndex].DT of //���� �����
         IndV: begin  //����������
            astr:=Formula.VarAr[Formula.DataAr[aIndex].Numb-1].Name;
            end;
         D: begin     //������
            astr:=FloatToStr(Formula.DataAr[aIndex].Data);
            end;
         R: Begin    //��������
            astr:=RestoreString(Formula,Formula.DataAr[aIndex].Numb);
            end;
       end;

       if abranches then   //��������� ������ ��� �������������
           astr:='('+astr+')';

           //$$$     2. right part - b: ����� �� ������?
           //log(..,(b)) ������, ����� b = ��������������� ����� ��� ����������
           bbranches:=true;
           if Formula.DataAr[bIndex].DT=D then
              if Formula.DataAr[bIndex].Data>=0 then
              bbranches:=false;

           if Formula.DataAr[bIndex].DT=IndV then
              bbranches:=false;

       case Formula.DataAr[bIndex].DT of //���� ������
         IndV: begin  //����������
            bstr:=Formula.VarAr[Formula.DataAr[bIndex].Numb-1].Name;
            end;
         D: begin     //������
            bstr:=FloatToStr(Formula.DataAr[bIndex].Data);
            end;
         R: Begin    //��������
            bstr:=RestoreString(Formula,Formula.DataAr[bIndex].Numb);
            end;
       end;

       if bbranches then   //��������� ������ ��� �������������
           bstr:='('+bstr+')';

       //$$$$     3. ���������� ������
       result:='log('+astr+';'+bstr+')';
       end; {----------------------------------------------------------------}

    6..7:
       begin
           bIndex:=Formula.OperAr[3,RestoringOper];
           //$$$     2. right part - b: ����� �� ������?
           //f(b) ������, ����� b = ��������������� ����� ��� ����������
           bbranches:=true;

           if Formula.DataAr[bIndex].DT=IndV then
              bbranches:=false;

       case Formula.DataAr[bIndex].DT of //���� ������
         IndV: begin  //����������
            bstr:=Formula.VarAr[Formula.DataAr[bIndex].Numb-1].Name;
            end;
         D: begin     //������
            bstr:=FloatToStr(Formula.DataAr[bIndex].Data);
            end;
         R: Begin    //��������
            bstr:=RestoreString(Formula,Formula.DataAr[bIndex].Numb);
            end;
       end;

       if bbranches then   //��������� ������ ��� �������������
           bstr:='('+bstr+')';

       //$$$$     3. ���������� ������
       result:=Operands[Formula.OperAr[1,RestoringOper]].str+bstr;
       end;

    8,10..NOP: //f(a)
       begin
           bIndex:=Formula.OperAr[3,RestoringOper];
           //$$$     2. right part - b: ����� �� ������?
           //f(b) ������, ����� b = ��������������� ����� ��� ����������
           bbranches:=true;
           if Formula.DataAr[bIndex].DT=D then
              if Formula.DataAr[bIndex].Data>=0 then
              bbranches:=false;

           if Formula.DataAr[bIndex].DT=IndV then
              bbranches:=false;

       case Formula.DataAr[bIndex].DT of //���� ������
         IndV: begin  //����������
            bstr:=Formula.VarAr[Formula.DataAr[bIndex].Numb-1].Name;
            end;
         D: begin     //������
            bstr:=FloatToStr(Formula.DataAr[bIndex].Data);
            end;
         R: Begin    //��������
            bstr:=RestoreString(Formula,Formula.DataAr[bIndex].Numb);
            end;
       end;

       if bbranches then   //��������� ������ ��� �������������
           bstr:='('+bstr+')';

       //$$$$     3. ���������� ������
       result:=Operands[Formula.OperAr[1,RestoringOper]].str+bstr;
       end; {----------------------------------------------------------------}

  end;
end;

function DataElementToStr(DataEl: TDataType): string;
begin
  case DataEl of
    IndV: result:='I';
    D: result:='D';
    R: result:='R';
  end;
end;

function StrToDataElement(Str: string): TDataType;
begin
  if (str='i') or (str='I') or (LowerCase(str)='indv') then
    result:=IndV;

  if (str='d') or (str='D') then
    result:=D;

   if (str='r') or (str='R') then
    result:=R;

end;

function StrRep(MainStr,u,v: string): string;
var i: integer;
begin
for I := 1 to NOP do
  MainStr:=StringReplace(MainStr,Operands[i].str,Operands[i].key,[rfReplaceAll]);
  Result:=StringReplace(MainStr,u,v,[rfReplaceAll]);
for I := 1 to NOP do
  Result:=StringReplace(result,Operands[i].key,Operands[i].str,[rfReplaceAll]);
end;

      function IsFloat(Str: string): boolean;
      var NumOfPnt,NumOfMin,counter: integer;
      begin
      result:=false;
      if str='' then exit;
      
      for counter := 1 to Length(Str) do
       if strscan(WMNumbers,Str[counter])=nil then
           exit;
      NumOfPnt:=0;
      NumOfMin:=0;
        for counter := 1 to Length(Str) do
          Case Str[counter] of
             ',': NumOfPnt:=NumOfPnt+1;
             '-': NumOfMin:=NumOfMin+1;
          End;
      if str[1]<>'-' then
      begin
          if (NumOfMin=0)and(NumOfPnt<2)and(Str[1]<>',') then result:=true;
      end
      else
          if (NumOfMin=1)and(NumOfPnt<2)and(str[2]<>',')and (length(Str)>1) then result:=true;
      end;

  function VectToNVars(vect: TVect): Tnvars;
  var
  i: integer;
  begin
    setlength(result,length(vect));
    for i := 0 to length(vect)-1 do
      result[i]:=vect[i];
  end;
  function Fdiv(x,y: extended): Treal;
  begin
  if y=0 then
     result.error:=true
  else
     begin
     result.Error:=false;
     result.result:=x/y;
     end;
  end;

  function Fpower(x,y: extended): Treal;
  begin
  if (RoundTo(y,0)<>y) and (x<=0) then
     result.Error:=true
  else
     begin
     result.Error:=false;
     if x=0 then
     result.result:=0
     else
     result.result:=Power(x,y);
     end;
  end;

  function Flog10(x: extended):Treal;
   begin
   if x<=0 then
   result.error:=true
   else
     begin
     result.error:=false;
     result.result:=log10(x);
     end;
   end;

  function Flog2(x: extended): Treal;
  begin
   if x<=0 then
   result.error:=true
   else
     begin
     result.error:=false;
     result.result:=log2(x);
     end;
  end;

  function Fln(x: extended): Treal;
  begin
   if x<=0 then
   result.error:=true
   else
     begin
     result.error:=false;
     result.result:=ln(x);
     end;
  end;

  function Flog(x,y: extended): Treal;
  begin
   if (y<=0)or(x=1)or(x<=0) then
   result.error:=true
   else
     begin
     result.error:=false;
     result.result:=logN(x,y);
     end;
  end;

  function Fasin(x: extended): Treal;
  begin
     if (x>1)or(x<-1) then
   result.error:=true
   else
     begin
     result.error:=false;
     result.result:=arcsin(x);
     end;
  end;

  function Facos(x: extended): Treal;
  begin
     if (x>1)or(x<-1) then
   result.error:=true
   else
     begin
     result.error:=false;
     result.result:=arccos(x);
     end;
  end;

  function Ftg(x: extended): Treal;
  begin
     if cos(x)=0 then
   result.error:=true
   else
     begin
     result.error:=false;
     result.result:=tan(x);
     end;
  end;

  function Fctg(x: extended): Treal;
  begin
     if sin(x)=0 then
   result.error:=true
   else
     begin
     result.error:=false;
     result.result:=cotan(x);
     end;
  end;

  function Fsqrt(x: extended): Treal;
  begin
     if x<0 then
   result.error:=true
   else
     begin
     result.error:=false;
     result.result:=sqrt(x);
     end;
  end;

initialization
Operands[1].str:='+';      Operands[1].key:=#1;
Operands[2].str:='-';      Operands[2].key:=#2;
Operands[3].str:='*';      Operands[3].key:=#3;
Operands[4].str:='/';      Operands[4].key:=#4;
Operands[5].str:='^';      Operands[5].key:=#5;
Operands[6].str:='log10';  Operands[6].key:=#6;
Operands[7].str:='log2';   Operands[7].key:=#7;
Operands[8].str:='ln';     Operands[8].key:=#8;
Operands[9].str:='log';    Operands[9].key:=#9;
Operands[10].str:='asin';  Operands[10].key:=#10;
Operands[11].str:='acos';  Operands[11].key:=#11;
Operands[12].str:='sin';   Operands[12].key:=#12;
Operands[13].str:='cos';   Operands[13].key:=#13;
Operands[14].str:='ctg';   Operands[14].key:=#14;
Operands[15].str:='atg';   Operands[15].key:=#15;
Operands[16].str:='tg';    Operands[16].key:=#16;
Operands[17].str:='sqrt';  Operands[17].key:=#17;
Operands[18].str:='abs';   Operands[18].key:=#18;
Operands[19].str:='sign';  Operands[19].key:=#19;
Operands[20].str:='exp';   Operands[20].key:=#20;
Operands[21].str:='int';   Operands[21].key:=#21;
end.
