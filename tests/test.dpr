
program test;

{$apptype console}

{$i deltics.inc}

uses
  Deltics.Smoketest,
  Deltics.Guids in '..\src\Deltics.Guids.pas',
  Deltics.Guids.GuidList in '..\src\Deltics.Guids.GuidList.pas',
  Test.GuidTests in 'Test.GuidTests.pas';

begin
  TestRun.Test(TGuidTests);
end.
