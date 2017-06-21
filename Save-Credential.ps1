<#
.SYNOPSIS
Store credential object to disk.

.DESCRIPTION
Store credential object to disk to be used with automation.

.NOTES
Created by: Jason Wasser @wasserja
Modified: 4/20/2017 11:39:09 AM 

.PARAMETER CredentialFilePath
Enter a valid path to save the credential file.

.PARAMETER Username
Enter a username for the credential you wish to save.

.PARAMETER Password
Provide a secure string object of the password you wish to save.

.PARAMETER Message
Provide an optional message for the Get-Credential dialog.

.PARAMETER EncryptionKeyPath
Enter a valid path to an encryption key file if you wish to encrypt the credential on disk.

.EXAMPLE
PS C:\> Save-Credential

.EXAMPLE
PS C:\> Save-Credential -Username jsmith -EncryptionKeyPath c:\Keys\jsmith.key
#>
function Save-Credential {

    [cmdletbinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$CredentialFilePath = 'C:\Scripts\Logon.xml',

        [string]$UserName = $env:USERNAME,

        [securestring]$Password,

        [string]$Message = 'Enter credentials',

        [string]$EncryptionKeyPath
        )

    begin {
        $ErrorActionPreference = 'Stop'
        Write-Verbose "ErrorActionPreference: $ErrorActionPreference"
        }
    process {
        
        if ($Password) {
            Write-Verbose -Message 'Password has been supplied'
        
            try {
                $Credential = New-Object -type System.Management.Automation.PSCredential($UserName,$Password)
                }
            catch {
                Write-Error $Error[0].Exception.Message
                return
                }
        
            }
        else {
            Write-Verbose -Message 'No Password has been supplied. Prompting for Credential.'
            try {
                $Credential = Get-Credential -UserName $UserName -Message $Message
                }
            catch {
                Write-Error $Error[0].Exception.Message
                return
                }
        
            }

        if ($EncryptionKeyPath) {
            try {
                Write-Verbose -Message 'Encryption Key Path Specified.'
                $EncryptionKey = [byte[]](Get-Content $EncryptionKeyPath)

                Write-Verbose -Message 'Building exportable object using encryption key.'
                $ExportCredential = New-Object psobject -Property @{
                    UserName = $Credential.UserName
                    Password = ConvertFrom-SecureString -SecureString $Credential.Password -Key $EncryptionKey
                    }

                Write-Verbose -Message "Exporting credential to $CredentialFilePath with encryption key."
                $ExportCredential | Export-Clixml -Path $CredentialFilePath -Force
                }
            catch {
                Write-Error $Error[0].Exception.Message
                return
                }
        
            }
        else {
            try {
                if ($Credential) {
                    Write-Verbose -Message "Exporting credential to $CredentialFilePath"
                    $Credential | Export-Clixml -Path $CredentialFilePath -Force
                    }
                else {
                    Write-Verbose 'No Credential object created.'
                    }
                }
            catch {
                Write-Error $Error[0].Exception.Message
                return
                }
            }
        }
    end {}
    
}