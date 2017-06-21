# MrACredential
PowerShell Credential Module

The MrACredential PowerShell is a collection of functions to save and import encrypted credential objects from disk. 

<pre>
PS C:\> Get-Command -Module MrACredential

CommandType Name              Version Source
----------- ----              ------- ------
Function    Import-Credential 1.0     MrACredential
Function    New-EncryptionKey 1.0     MrACredential
Function    Save-Credential   1.0     MrACredential
</pre>

# Usage
Install the MrACredential PowerShell module from the PowerShell Gallery.

<pre>Install-Module MrACredential</pre>

Generate a new encryption key, and save it to C:\Keys\AutomationLogon.key.

<pre>
New-EncryptionKey | Out-File C:\Keys\AutomationLogon.key
</pre>

Lock down the key file using NTFS permissions to only the accounts or groups that should be able to use the account.

Save the automation account credential to disk using the encryption key you just made.

<pre>
Save-Credential -CredentialFilePath C:\Credentials\AutomationLogon.xml -EncryptionKeyPath C:\Keys\AutomationLogon.key
</pre>

Once these two files are saved to disk and secured you can import the encrypted credential for your automation processes.

<pre>
$Credential = Import-Credential -CredentialFilePath C:\Credentials\AutomationLogon.xml -EncryptionKeyPath C:\Keys\AutomationLogon.key
</pre>

Now you can use the imported credential with your processes.
<pre>Get-WmiObject -ClassName win32_operatingsystem -ComputerName Server01 -Credential $Credential</pre>

Or you can make it a default credential for your session.
<pre>$PSDefaultParameterValues['*:Credential']=$Credential</pre>