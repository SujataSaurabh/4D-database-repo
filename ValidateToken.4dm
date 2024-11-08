  //ValidateToken
  //
  // - Validates a token that it exists
  // - check to see that it has not expired (i.e. more than 24 hours)
  //
  // - returns alsid if token found and not expired
  // - returns alsid 0 if token not found 
  // - returns alsid -1 if token expired

C_LONGINT($0;$alsid)
C_TEXT($1;$token)

$alsid:=0
$token:=$1

QUERY([TokenLog];[TokenLog]TokenUUID=$token)
If (Records in selection([TokenLog])=1)
	  //Now check that the token has not expired
	If (Check24HourTimeElapsed ([TokenLog]LastAccessDate;[TokenLog]LastAccessTime)=False)
		$alsid:=[TokenLog]ALSID
	Else 
		$alsid:=-1  //token has expired
	End if 
End if 

$0:=$alsid

