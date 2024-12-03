  // @Sujata Goswami, November 19, 2024
ARRAY LONGINT($pi_id;0)
ARRAY LONGINT($cycle_id;0)
ARRAY LONGINT($shifts_requested;0)
ARRAY LONGINT($shifts_alloc;0)
ARRAY DATE($cycle_end_date;0)


Begin SQL
	SELECT PI_ID, CycleID, SUM(ShiftsRequested), SUM(ShiftsAlloc) from TempProposalsAndBeamlines GROUP BY PI_ID, CycleID INTO :$pi_id, :$cycle_id, :$shifts_requested, :$shifts_alloc
End SQL

$doc:=Create document("";".csv")
If (OK=1)  // user creates the document
	ALERT("file created")
End if 

$exportText:=""
If (Size of array($pi_id)>0)
	For ($j;1;Size of array($pi_id))
		QUERY([ProposalSetup];[ProposalSetup]CycleID=$cycle_id{$j})
		$exportText:=$exportText+String($pi_id{$j})+","
		$exportText:=$exportText+String([ProposalSetup]CycleID)+","
		$exportText:=$exportText+String([ProposalSetup]ProposalType)+","
		$exportText:=$exportText+String($shifts_requested{$j})+","
		$exportText:=$exportText+String($shifts_alloc{$j})+","
		$exportText:=$exportText+String([ProposalSetup]CycleEndDate)+","
		$exportText:=$exportText+String([ProposalSetup]Proposal Cycle)+"\r"
	End for 
End if 

SEND PACKET($doc;$exportText)
CLOSE DOCUMENT($doc)
SHOW ON DISK(Document)
ALERT("Processing Done")
