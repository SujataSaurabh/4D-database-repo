QUERY([TokenLog];[TokenLog]TokenUUID="87D9015B57AC4E4E8C7CA0EFAE7C1317")
If (Records in selection([TokenLog])=1)
	$alsid:=[TokenLog]ALSID
End if 

$0:=$alsid
