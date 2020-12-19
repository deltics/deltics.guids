
  unit Test.GuidTests;

interface

  uses
    Deltics.Smoketest;


  type
    TGuidTests = class(TTest)
    private
      procedure FromStringRaisesConvertErrorWith(const aString: String);
    published
      procedure FromStringYieldsNullGuidForEmptyString;
      procedure FromStringWithDefaultFormatGuidString;
      procedure FromStringWithDigitsOnlyFormatGuidString;
      procedure FromStringWithNoBracesFormatGuidString;
      procedure FromStringWithNoHyphensFormatGuidString;
      procedure FromStringWithParenthesesFormatGuidString;
      procedure FromStringWithInvalidString;
      procedure ToStringWithDefaultFormat;
      procedure ToStringWithNoFormatUsesDefaultFormat;
      procedure ToStringWithNoBracesFormat;
      procedure ToStringWithNoHyphensFormat;
      procedure ToStringWithDigitsOnlyFormat;
      procedure ToStringWithParenthesesFormat;
      procedure GuidsAreEqualReturnsTrueForEqualGuids;
      procedure GuidsAreEqualReturnsFalseForNonEqualGuids;
    end;


implementation

  uses
    SysUtils,
    Deltics.Exceptions,
    Deltics.Guids;


{ TGuidTests }

  procedure TGuidTests.FromStringRaisesConvertErrorWith(const aString: String);
  begin
    try
      Guid.FromString(aString);

      Test.FailedToRaiseException;
    except
      Test.RaisedException(EConvertError, '{string} is not a valid Guid', [aString]);
    end;
  end;


  procedure TGuidTests.FromStringYieldsNullGuidForEmptyString;
  begin
    Test('FromString('''')').Assert(Guid.FromString('')).Equals(NullGuid);
  end;


  procedure TGuidTests.FromStringWithDefaultFormatGuidString;
  const
    S         = '{7C49C3A6-A9A3-4850-8B1D-0B386344EC81}';
    G: TGuid  = S;
  begin
    Test('FromString(''{string}'')', [S]).Assert(Guid.FromString(S)).Equals(G);
  end;


  procedure TGuidTests.FromStringWithDigitsOnlyFormatGuidString;
  const
    S         = '7C49C3A6A9A348508B1D0B386344EC81';
    GS        = '{7C49C3A6-A9A3-4850-8B1D-0B386344EC81}';
    G: TGuid  = GS;
  begin
    Test('FromString(''{string}'')', [S]).Assert(Guid.FromString(S)).Equals(G);
  end;


  procedure TGuidTests.FromStringWithNoBracesFormatGuidString;
  const
    S         =  '7C49C3A6-A9A3-4850-8B1D-0B386344EC81';
    GS        = '{7C49C3A6-A9A3-4850-8B1D-0B386344EC81}';
    G: TGuid  = GS;
  begin
    Test('FromString(''{string}'')', [S]).Assert(Guid.FromString(S)).Equals(G);
  end;


  procedure TGuidTests.FromStringWithNoHyphensFormatGuidString;
  const
    S         = '{7C49C3A6A9A348508B1D0B386344EC81}';
    GS        = '{7C49C3A6-A9A3-4850-8B1D-0B386344EC81}';
    G: TGuid  = GS;
  begin
    Test('FromString(''{string}'')', [S]).Assert(Guid.FromString(S)).Equals(G);
  end;


  procedure TGuidTests.FromStringWithParenthesesFormatGuidString;
  const
    S         = '(7C49C3A6-A9A3-4850-8B1D-0B386344EC81)';
    GS        = '{7C49C3A6-A9A3-4850-8B1D-0B386344EC81}';
    G: TGuid  = GS;
  begin
    Test('FromString(''{string}'')', [S]).Assert(Guid.FromString(S)).Equals(G);
  end;


  procedure TGuidTests.FromStringWithInvalidString;
  begin
    FromStringRaisesConvertErrorWith('x');
    FromStringRaisesConvertErrorWith('[7C49C3A6A9A348508B1D0B386344EC81]');
    FromStringRaisesConvertErrorWith('{7C49C3A6-A9A3-4850-8B1D-0B386344EC8120}');
    FromStringRaisesConvertErrorWith('{7C49C3A6-A9A3-4850-8B1D-0B386344EC8G}');
  end;


  procedure TGuidTests.ToStringWithDefaultFormat;
  const
    S        = '{499CF33C-6D03-4575-8C40-2142772F8342}';
    G: TGuid = S;
  begin
    Test('ToString(GUID, gfDefault)').Assert(Guid.ToString(G, gfDefault)).Equals(S);
  end;


  procedure TGuidTests.ToStringWithNoFormatUsesDefaultFormat;
  const
    G: TGuid = '{1E7CD108-40DA-4B1A-BA42-065778D8C3D7}';
  begin
    Test('ToString(GUID)').Assert(Guid.ToString(G)).Equals(Guid.ToString(G, gfDefault));
  end;


  procedure TGuidTests.ToStringWithNoBracesFormat;
  const
    S1       = '{6E59E819-77F4-4EBA-98AC-64B26DE715BC}';
    S2       = '6E59E819-77F4-4EBA-98AC-64B26DE715BC';
    G: TGuid = S1;
  begin
    Test('ToString(GUID, gfNoBraces)').Assert(Guid.ToString(G, gfNoBraces)).Equals(S2);
  end;


  procedure TGuidTests.ToStringWithNoHyphensFormat;
  const
    S1       = '{443BBAB0-69D7-4360-930E-21F0B8EEFF5E}';
    S2       = '{443BBAB069D74360930E21F0B8EEFF5E}';
    G: TGuid = S1;
  begin
    Test('ToString(GUID, gfNoHyphens)').Assert(Guid.ToString(G, gfNoHyphens)).Equals(S2);
  end;


  procedure TGuidTests.ToStringWithDigitsOnlyFormat;
  const
    S1       = '{049CB38F-FFA8-4AB0-BA3B-FE0DD10C9CB7}';
    S2       = '049CB38FFFA84AB0BA3BFE0DD10C9CB7';
    G: TGuid = S1;
  begin
    Test('ToString(GUID, gfDigitsOnly)').Assert(Guid.ToString(G, gfDigitsOnly)).Equals(S2);
  end;


  procedure TGuidTests.ToStringWithParenthesesFormat;
  const
    S1       = '{160E0924-C3BE-4DA8-ABE3-A760548DB8DA}';
    S2       = '(160E0924-C3BE-4DA8-ABE3-A760548DB8DA)';
    G: TGuid = S1;
  begin
    Test('ToString(GUID, gfParentheses)').Assert(Guid.ToString(G, gfParentheses)).Equals(S2);
  end;


  procedure TGuidTests.GuidsAreEqualReturnsTrueForEqualGuids;
  const
    A: TGuid = '{442425BC-CEA4-419A-AE32-B641AD0EB9B7}';
    B: TGuid = '{442425BC-CEA4-419A-AE32-B641AD0EB9B7}';
  begin
    Test('Guids.AreEqual({a}, {b})', [GuidToString(A), GuidToString(B)]).Assert(Guids.AreEqual(A, B));
  end;


  procedure TGuidTests.GuidsAreEqualReturnsFalseForNonEqualGuids;
  const
    A: TGuid = '{442425BC-CEA4-419A-AE32-B641AD0EB9B7}';
    B: TGuid = '{89C7AAC4-4F45-42B4-8F97-443649F4B1A7}';
  begin
    Test('Guids.AreEqual({a}, {b})', [GuidToString(A), GuidToString(B)]).Assert(NOT Guids.AreEqual(A, B));
  end;


end.
