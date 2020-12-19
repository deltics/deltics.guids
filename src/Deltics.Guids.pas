{
  * MIT LICENSE *

  Copyright © 2008 Jolyon Smith

  Permission is hereby granted, free of charge, to any person obtaining a copy of
   this software and associated documentation files (the "Software"), to deal in
   the Software without restriction, including without limitation the rights to
   use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
   of the Software, and to permit persons to whom the Software is furnished to do
   so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
   copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.


  * GPL and Other Licenses *

  The FSF deem this license to be compatible with version 3 of the GPL.
   Compatability with other licenses should be verified by reference to those
   other license terms.


  * Contact Details *

  Original author : Jolyon Direnko-Smith
  e-mail          : jsmith@deltics.co.nz
  github          : deltics/deltics.rtl
}

{$i deltics.guids.inc}

  unit Deltics.Guids;


interface

  uses
    Deltics.Guids.GuidList;


  type
    TGuidFormat = (
                   gfDefault,
                   gfParentheses,
                   gfNoBraces,
                   gfNoHyphens,
                   gfDigitsOnly
                  );

    Guid = class
      class function ToString(const aGuid: TGuid; const aFormat: TGuidFormat = gfDefault): String; reintroduce;
      class function FromString(const aString: String): TGuid; overload;
      class function FromString(const aString: String; var aGuid: TGuid): Boolean; overload;

      class function IsNull(const aValue: TGuid): Boolean; {$ifdef InlineMethods} inline; {$endif}
      class function New: TGuid; {$ifdef InlineMethods} inline; {$endif}
      class function Null: TGuid; {$ifdef InlineMethods} inline; {$endif}
    end;

    Guids = class
      class function AreEqual(const A, B: TGuid): Boolean; {$ifdef InlineMethods} inline; {$endif}
    end;


    TGuidList = Deltics.Guids.GuidList.TGuidList;



  {$ifdef TypeHelpers}

    GuidHelper = record helper for TGuid
    public
      function Equals(const aGuid: TGuid): Boolean; {$ifdef InlineMethods} inline; {$endif}
      function IsNull(const aGuid: TGuid): Boolean; {$ifdef InlineMethods} inline; {$endif}
      function ToString(const aFormat: TGuidFormat = gfDefault): String; {$ifdef InlineMethods} inline; {$endif}
    end;

  {$endif}


  const
    NullGuid: TGuid = '{00000000-0000-0000-0000-000000000000}';


implementation

  uses
    SysUtils,
    TypInfo,
    Deltics.Exceptions;



  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function Guid.ToString(const aGuid: TGuid;
                               const aFormat: TGuidFormat): String;
  begin
    result := SysUtils.GuidToString(aGuid);

    case aFormat of
      gfDefault     : EXIT;

      gfParentheses : begin
                        result[1]               := '(';
                        result[Length(result)]  := ')';
                      end;

      gfNoBraces    : result := Copy(result, 2, Length(result) - 2);

      gfNoHyphens   : result := StringReplace(result, '-', '', [rfReplaceAll]);

      gfDigitsOnly  : begin
                        result := Copy(result, 2, Length(result) - 2);
                        result := StringReplace(result, '-', '', [rfReplaceAll]);
                      end;
    else
      raise ENotImplemented.Create(self, 'ToString(GUID, ' + GetEnumName(TypeInfo(TGuidFormat), Ord(aFormat)) + ')');
    end;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function Guid.FromString(const aString: String): TGuid;
  begin
    if NOT FromString(aString, result) then
      raise EConvertError.CreateFmt('''%s'' is not a valid Guid', [aString]);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function Guid.FromString(const aString: String;
                                 var   aGuid: TGuid): Boolean;
  var
    s: String;
    src: PChar absolute s;

    function HexByte(MSN: Integer): Byte;
    var
      LSN: Integer;
    begin
      LSN := MSN + 1;

      case src[MSN] of
        '0'..'9':  result := Byte(src[MSN]) - Byte('0');
        'a'..'f':  result := Byte(src[MSN]) - Byte('a') + 10;
        'A'..'F':  result := Byte(src[MSN]) - Byte('A') + 10;
      else
        raise EConvertError.CreateFmt('''%s'' is not a valid Guid', [aString]);
      end;

      case src[LSN] of
        '0'..'9':  result := (Byte(result) shl 4) or (Byte(src[LSN]) - Byte('0'));
        'a'..'f':  result := (Byte(result) shl 4) or ((Byte(src[LSN]) - Byte('a')) + 10);
        'A'..'F':  result := (Byte(result) shl 4) or ((Byte(src[LSN]) - Byte('A')) + 10);
      else
        raise EConvertError.CreateFmt('''%s'' is not a valid Guid', [aString]);
      end;
    end;

  var
    dest: array[0..15] of Byte absolute aGuid;
  begin
    s       := '';
    result  := FALSE;

    case Length(aString) of
       0  : begin
              result  := TRUE;
              aGuid   := NullGuid;
              EXIT;
            end;

      32  : s := Copy(aString, 1, 8)  + '-'
               + Copy(aString, 9, 4) + '-'
               + Copy(aString, 13, 4) + '-'
               + Copy(aString, 17, 4) + '-'
               + Copy(aString, 21, 12);

      34  : if  (aString[1] = '{') and (aString[34] = '}') then
              s := Copy(aString, 2, 8)  + '-'
                 + Copy(aString, 10, 4) + '-'
                 + Copy(aString, 14, 4) + '-'
                 + Copy(aString, 18, 4) + '-'
                 + Copy(aString, 22, 12);

      36  : s := aString;

      38  : if  ((aString[1] = '{') and (aString[38] = '}'))
             or ((aString[1] = '(') and (aString[38] = ')')) then
              s := Copy(aString, 2, 36);
    else
      EXIT;
    end;

    if (s = '') or (s[9] <> '-') or (s[14] <> '-') or (s[19] <> '-') or (s[24] <> '-') then
      EXIT;

    //            1  1 1  1 2  2 2 2 3 3 3
    // 0 2 4 6 -9 1 -4 6 -9 1 -4 6 8 0 2 4
    // ..XX..XX ..XX ..XX ..XX ..XX..XX..XX

    dest[0] := HexByte(6);
    dest[1] := HexByte(4);
    dest[2] := HexByte(2);
    dest[3] := HexByte(0);

    dest[4] := HexByte(11);
    dest[5] := HexByte(9);

    dest[6] := HexByte(16);
    dest[7] := HexByte(14);

    dest[8] := HexByte(19);
    dest[9] := HexByte(21);

    dest[10]  := HexByte(24);
    dest[11]  := HexByte(26);
    dest[12]  := HexByte(28);
    dest[13]  := HexByte(30);
    dest[14]  := HexByte(32);
    dest[15]  := HexByte(34);

    result := TRUE;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function Guid.IsNull(const aValue: TGuid): Boolean;
  begin
    result := CompareMem(@aValue, @NullGuid, sizeof(TGuid));
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function Guid.New: TGuid;
  begin
    CreateGuid(result);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function Guid.Null: TGuid;
  begin
    result := NullGuid;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function Guids.AreEqual(const A, B: TGuid): Boolean;
  begin
    result := CompareMem(@A, @B, sizeof(TGuid));
  end;








{$ifdef TypeHelpers}

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function GuidHelper.Equals(const aGuid: TGuid): Boolean;
  begin
    result := Guids.AreEqual(self, aGuid);
  end;

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function GuidHelper.IsNull(const aGuid: TGuid): Boolean;
  begin
    result := Guid.IsNull(self);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function GuidHelper.ToString(const aFormat: TGuidFormat): String;
  begin
    result := Guid.ToString(self, aFormat);
  end;

{$endif}




end.
