C_TEXT($msg)
C_LONGINT($total_count)
Begin SQL
    SELECT COUNT(*) from Experimenters INTO :$total_count
End SQL

$msg := $msg + String($total_count)
ALERT("" + $msg)