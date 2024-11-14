  //@SujataGoswami, Nov. 11, 2024 
  //Get ORCID By USER NAME 

  //QUERY SELECTION([People];[People]ORCID#"")  //limit to orcid only


C_TEXT($FirstName;$0)
C_TEXT($LastName;$1)

$FirstName:="[FName]"
$LastName:="[LName]"

QUERY([People];[People]FirstName=$FirstName;[People]LastName=$LastName)
If (Records in selection([People])=1)
	  //$LastName:=[People]LastName
	  //UNLOAD RECORD([People])
	$orcid:=[People]ORCID
	ALERT("Record found "+$orcid)
Else 
	ALERT("Record Not Found")
End if 


QUERY([Authors];[Authors]FirstName=$FirstName;[Authors]LastName=$LastName)
If (Records in selection([Authors])=1)
	  //$LastName:=[People]LastName
	  //UNLOAD RECORD([People])
	$orcid:=[Authors]ORCID
	ALERT("Record found "+$orcid)
Else 
	ALERT("Record Not Found")
End if 


