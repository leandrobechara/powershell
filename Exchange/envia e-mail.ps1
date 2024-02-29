Add-PSsnapin Microsoft.Exchange.Management.PowerShell.E2010
# Defina as credenciais do remetente
$fromEmail = "<remetente>"
$smtpServer = "<servidor SMTP>"
$smtpPort = 587

# Carregue o arquivo CSV contendo os destinatários
$destinatarios = Import-Csv -Path 'C:\temp\Exchange Online recipients.CSV' -Encoding UTF8 -Delimiter ","

# Contador de e-mails enviados
$count = 0

# Loop através de cada destinatário
foreach ($destinatario in $destinatarios) {
    $toEmail = $destinatario.PrimarySmtpAddress
    $subject = "Assunto do e-mail"
    $body = @"
<p> teste</p>
<p> teste</p>
<p> teste</p>
<p> teste</p>
<p> teste</p>

"@

    # Envie o e-mail
    Send-MailMessage -From $fromEmail -To $toEmail -Subject $subject  -BodyAsHtml -Body $body -SmtpServer $smtpServer -Port $smtpPort #-UseSsl -Credential (Get-Credential) 

    $count++

    # Verifique se já foram enviados 1000 e-mails e faça uma pausa de 20 minutos
    if ($count % 1000 -eq 0) {
        Write-Host "Enviados $count e-mails. Fazendo uma pausa de 20 minutos..."
        Start-Sleep -Seconds (20 * 60) # 20 minutos
    }
}

Write-Host "Envio de e-mails concluído."