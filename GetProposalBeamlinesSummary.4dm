  //GetProposalBeamlinesSummary

  // @Sujata Goswami, November 19, 2024
ARRAY LONGINT($pi_id;0)
ARRAY TEXT($propcycle;0)
ARRAY LONGINT($cycle_id;0)
ARRAY LONGINT($shifts_requested;0)
ARRAY LONGINT($shifts_alloc;0)
ARRAY DATE($cycle_end_date;0)

Begin SQL
	SELECT PI_ID, CycleID, SUM(ShiftsRequested), SUM(ShiftsAlloc) from TempProposalsAndBeamlines GROUP BY PI_ID, CycleID INTO :$pi_id, :$cycle_id, :$shifts_requested, :$shifts_alloc
End SQL
  // This table has been created manually in 4D 
  //Begin SQL
  //CREATE TABLE IF NOT EXISTS TempProposalsBeamlinesSummary(PI_ID INT32, CycleID INT32, ShiftsRequested INT32, ShiftsAlloc INT32, ProposalType VARCHAR);
  //End SQL
ALERT("Number of Records"+String(Size of array($pi_id)))  //18608 on Nov. 19, 2024
ALL RECORDS([TempProposalsBeamlinesSummary])
DELETE SELECTION([TempProposalsBeamlinesSummary])

For ($tIndx;1;Size of array($pi_id))
	QUERY([ProposalSetup];[ProposalSetup]CycleID=$cycle_id{$tIndx})
	CREATE RECORD([TempProposalsBeamlinesSummary])
	[TempProposalsBeamlinesSummary]PI_ID:=$pi_id{$tIndx}
	[TempProposalsBeamlinesSummary]CycleID:=$cycle_id{$tIndx}
	[TempProposalsBeamlinesSummary]ShiftsRequested:=$shifts_requested{$tIndx}
	[TempProposalsBeamlinesSummary]ShiftsAlloc:=$shifts_alloc{$tIndx}
	[TempProposalsBeamlinesSummary]ProposalType:=[ProposalSetup]ProposalType
	[TempProposalsBeamlinesSummary]CycleEndDate:=[ProposalSetup]CycleEndDate
	SAVE RECORD([TempProposalsBeamlinesSummary])
End for 

ALERT("Done: Table  created successfully")



