<#
.SYNOPSIS
Generate a new random encryption key.

.DESCRIPTION
Generate a new random encryption key to be used with encrypting/decrypting
stored credential files.

.NOTES
Created by: Jason Wasser
Modified: 4/20/2017 11:34:25 AM 

.PARAMETER KeyLength
Enter a valid key length for your encryption key.

.EXAMPLE
PS C:\> New-EncryptionKey
217
154
250
143
74
79
214
255
233
70
76
16
73
145
50
209
235
24
217
156
130
188
88
127
18
243
121
206
52
3
248
64
.EXAMPLE
PS C:\> New-EncryptionKey -KeyLength 16
206
152
255
54
205
81
218
131
0
100
122
160
141
126
82
110
#>
function New-EncryptionKey {
    
    param (
        [ValidateSet(16, 24, 32)]
        [int]$KeyLength = 32
    )

    begin {}
    process {
        $EncryptKey = New-Object Byte[] $KeyLength  #An example of 16 bytes key
        [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($EncryptKey)
        $EncryptKey
    }
    end {}
}