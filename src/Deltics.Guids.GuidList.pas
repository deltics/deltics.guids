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

  unit Deltics.Guids.GuidList;


interface

  type
    TGuidList = class
    private
      fCount: Integer;
      fItems: array of TGuid;
      function get_Capacity: Integer;
      function get_Item(const aIndex: Integer): TGuid;
      procedure set_Capacity(const aValue: Integer);
      procedure set_Item(const aIndex: Integer; const aValue: TGuid);
    protected
      procedure IncreaseCapacity;
    public
      procedure Add(const aGuid: TGuid);
      procedure Clear;
      function Contains(const aGuid: TGuid): Boolean;
      procedure Delete(const aGuid: TGuid);
      function IndexOf(const aGuid: TGuid): Integer;
      property Capacity: Integer read get_Capacity write set_Capacity;
      property Count: Integer read fCount;
      property Items[const aIndex: Integer]: TGuid read get_Item write set_Item; default;
    end;



implementation

  uses
  {$ifdef InlineMethods}
    SysUtils,
  {$endif}
    Deltics.Exceptions,
    Deltics.Guids;




{ TGuidList -------------------------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TGuidList.Add(const aGuid: TGuid);
  begin
    if (fCount = Capacity) then
      IncreaseCapacity;

    fItems[fCount] := aGuid;

    Inc(fCount);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TGuidList.Clear;
  begin
    fCount := 0;
    SetLength(fItems, 0);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TGuidList.Contains(const aGuid: TGuid): Boolean;
  begin
    result := (IndexOf(aGuid) <> -1);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TGuidList.Delete(const aGuid: TGuid);
  var
    i: Integer;
  begin
    i := IndexOf(aGuid);

    if i = -1 then
      EXIT;

    while (i < Pred(Count)) do
      fItems[i] := fItems[i + 1];

    Dec(fCount);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TGuidList.get_Capacity: Integer;
  begin
    result := Length(fItems);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TGuidList.get_Item(const aIndex: Integer): TGuid;
  begin
    result := fItems[aIndex];
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TGuidList.IncreaseCapacity;
  var
    i: Integer;
  begin
    case Capacity of
      0     : i := 4;
      1..64 : i := Capacity * 2
    else
      i := Capacity div 4;
    end;

    SetLength(fItems, i);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TGuidList.IndexOf(const aGuid: TGuid): Integer;
  begin
    for result := 0 to Pred(Count) do
      if Guids.AreEqual(aGuid, fItems[result]) then
        EXIT;

    result := -1;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TGuidList.set_Capacity(const aValue: Integer);
  begin
    SetLength(fItems, aValue);
    if (Capacity < fCount) then
      fCount := Capacity;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TGuidList.set_Item(const aIndex: Integer; const aValue: TGuid);
  begin
    fItems[aIndex] := aValue;
  end;








end.
