# Set the threshold size. Change this to your preferred value.
$size_Threshold_GB = 0.45

# Get a list of all mailboxes
$mailbox_List = Get-EXOMailbox -ResultSize Unlimited | Select-Object DisplayName, PrimarySMTPAddress, UserPrincipalName
# Loop through each of the mailbox object inside the $mailbox_List variable.
foreach ($mailbox in $mailbox_List) {
    # Get the Mailbox Size in GB, rounded with two-decimal places
    $mailbox_size_GB = [math]::Round(((Get-EXOMailboxStatistics -Identity $mailbox.UserPrincipalName).TotalItemSize.Value.toBytes() / 1GB),2)
    #
    <#
    Compare the mailbox size with the configured threshold.
    If the mailbox size is bigger than the threshold, add the result to the report.
    #>
    if ($mailbox_size_GB -gt $size_Threshold_GB) {

        <#
        Create the object with properties 'Display Name', 'Email Address' and 'Mailbox Size (GB)'
				to be included in the final report.
        #>
        $finalResult = @()

        $finalResult += (
            New-Object psobject -Property @{
                'Display Name'      = $mailbox.DisplayName
                'Email Address'     = $mailbox.PrimarySMTPAddress
                'Mailbox Size (GB)' = $mailbox_size_GB
            }
        )
    }
    
}
$finalResult