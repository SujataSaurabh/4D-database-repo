  //GetProposalBeamlinesLink

  //@Sujata Goswami, November 19, 2024

  //QUERY([Proposals];[Proposals]ExpID="ALS-01715")


ARRAY LONGINT($pi_id;0)
ARRAY TEXT($exp_id;0)
ARRAY TEXT($beamline;0)
ARRAY TEXT($propcycle;0)
ARRAY LONGINT($cycle_id;0)
ARRAY LONGINT($shifts_requested;0)
ARRAY LONGINT($shifts_alloc;0)
ARRAY DATE($cycle_end_date;0)
C_LONGINT($count)

  // Get distinct pids from proposals table and extract other required fields from PropBeamlines Table 
Begin SQL
	SELECT DISTINCT(Proposals.PI_ID), Proposals.ExpID, PropBeamlines.Beamline, PropBeamlines.CycleID, PropBeamlines.PropCycle, PropBeamlines.ShiftsRequested, PropBeamlines.ShiftsAlloc from Proposals LEFT OUTER JOIN PropBeamlines ON Proposals.ExpID=PropBeamlines.ExpID WHERE Proposals.PI_ID>0 AND PropBeamlines.CycleID>0 INTO :$pi_id, :$exp_id, :$beamline, :$cycle_id, :$propcycle, :$shifts_requested, :$shifts_alloc 
End SQL

ALERT("NUMBER OF RECORDS "+String(Size of array($pi_id)))  //36651 on Nov. 19, 2024

  //Create a temporary table
Begin SQL
	CREATE TABLE IF NOT EXISTS TempProposalsAndBeamlines(PI_ID INT32, ExpID VARCHAR, Beamline VARCHAR, PropCycle VARCHAR, ShiftsRequested INT32, ShiftsAlloc INT32, CycleID INT32);
End SQL

  // Select all records and delete them to avoid duplication. 
ALL RECORDS([TempProposalsAndBeamlines])
DELETE SELECTION([TempProposalsAndBeamlines])

  // Enter data in the table; For loop  
For ($vIndx;1;Size of array($pi_id))
	CREATE RECORD([TempProposalsAndBeamlines])  // Create record
	[TempProposalsAndBeamlines]PI_ID:=$pi_id{$vIndx}
	[TempProposalsAndBeamlines]ExpID:=$exp_id{$vIndx}
	[TempProposalsAndBeamlines]Beamline:=$beamline{$vIndx}
	[TempProposalsAndBeamlines]PropCycle:=$propcycle{$vIndx}
	[TempProposalsAndBeamlines]ShiftsRequested:=$shifts_requested{$vIndx}
	[TempProposalsAndBeamlines]ShiftsAlloc:=$shifts_alloc{$vIndx}
	[TempProposalsAndBeamlines]CycleID:=$cycle_id{$vIndx}
	SAVE RECORD([TempProposalsAndBeamlines])  // Save record
End for 
ALERT("process complete")


