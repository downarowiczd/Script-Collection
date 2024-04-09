Connect-AzureAD
Connect-MicrosoftTeams

$GroupId = "ENTER_YOUR_TEAMS_ID_HERE"

$users = Import-Csv -LiteralPath "..\PartnersPreviewCSV.csv"

$TeamGuests = Get-Teamuser -GroupId $GroupId -Role Guest

foreach($user in $users)
{
    Write-Host Retrieving $user.Email
    $emailValue = $user.Email

    $userDetails = Get-AzureADUser -Filter "Mail eq '$emailValue'"

    if($userDetails -eq $null)
    {
        Write-Host $emailValue not found in the tenant.  Inviting via B2B...
        New-AzureADMSInvitation -InvitedUserEmailAddress $emailValue -InviteRedirectUrl "https://www.microsoft.com/" -SendInvitationMessage $true
    }

    if($userDetails.UserState -eq "Accepted")
    {
        Write-Host $emailValue has status of $userDetails.UserState ... adding to the team.
        $upnValue = $userDetails.UserPrincipalName

        $userExists = $TeamGuests | Where-Object { $_.User -eq $userDetails.UserPrincipalName }

        if($userExists -eq $null)
        {
            Add-Teamuser -GroupId $GroupId -User $emailValue -Role Member
        }
        else
        {
            Write-Host $emailValue already exists in the team
        }
    }
    else
    {
        Write-Host $emailValue has B2B invite status of $userDetails.UserState
    }
}

Write-Host "Done for today!"