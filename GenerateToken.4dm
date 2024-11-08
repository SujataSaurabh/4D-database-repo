  //GenerateToken

C_LONGINT($1;$alsid)
C_TEXT($0;$token)

$alsid:=$1

If (False)
	QUERY([TokenLog];[TokenLog]ALSID=$alsid;*)
	QUERY([TokenLog]; & ;[TokenLog]CallerIP=<>WEBCLIENTIP)
	If (Records in selection([TokenLog])=0)
		CREATE RECORD([TokenLog])
	End if 
Else 
	CREATE RECORD([TokenLog])
End if 

[TokenLog]TokenType:="ALSID"
[TokenLog]ALSID:=$alsid
[TokenLog]LastAccessDate:=Current date
[TokenLog]LastAccessTime:=Current time
[TokenLog]TokenUUID:=Generate UUID
[TokenLog]CallerIP:=<>WEBCLIENTIP
$token:=[TokenLog]TokenUUID
SAVE RECORD([TokenLog])
UNLOAD RECORD([TokenLog])

$0:=$token

