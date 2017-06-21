<#
.SYNOPSIS
Import credential object from disk.

.DESCRIPTION
Import credential object from disk to be used with automation.

.NOTES
Created by: Jason Wasser @wasserja
Modified: 4/20/2017 11:41:26 AM 

.PARAMETER CredentialFilePath
Enter a path where a credential file is stored.

.PARAMETER EncryptionKeyPath
Enter a path where an encryption key file is stored.

.EXAMPLE
PS C:\> $Credential = Import-Credential

.EXAMPLE
PS C:\> $Credential = Import-Credential -CredentialFilePath C:\Credentials\jsmith.xml -EncryptionKeyPath C:\Keys\jsmith.key
#>
function Import-Credential {
    [cmdletbinding()]
    param (
        [ValidateScript( {Test-Path -Path $_})]
        $CredentialFilePath = 'C:\Scripts\Logon.xml',
        [ValidateScript( {Test-Path -Path $_})]
        $EncryptionKeyPath
    )

    begin {
        $ErrorActionPreference = 'Stop'
        Write-Verbose "ErrorActionPreference: $ErrorActionPreference"
    }
    process {
        if ($EncryptionKeyPath) {
       
            try {
                Write-Verbose -Message 'Encryption Key Path specified.'
                $EncryptionKey = [byte[]](Get-Content $EncryptionKeyPath)

                $ImportObject = Import-Clixml -Path $CredentialFilePath
                $SecurePassword = ConvertTo-SecureString -String $ImportObject.Password -Key $EncryptionKey

                $Credential = New-Object -type System.Management.Automation.PSCredential($ImportObject.UserName, $SecurePassword)
                $Credential
            }
            catch {
                Write-Error $Error[0].Exception.Message
                return
            }
        }
        else {
            try {
                Write-Verbose -Message 'No encryption key specified, importing credential from file.'
                $Credential = Import-Clixml -Path $CredentialFilePath
                $Credential
            }
            catch {
                Write-Error $Error[0].Exception.Message
                return
            }
        }
    }
}