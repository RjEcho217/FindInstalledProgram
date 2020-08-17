function Find-InstalledProgram {  
   <#
   .Synopsis
      Allows you to look for an installed program on a remote server you have invoke-command access to. 
   .DESCRIPTION
      Can look for an installed program either on a remote machine or on a 
   .EXAMPLE
      Find-InstalledProgram -SearchBy Publisher -StringFilter Blizzard

      This will look by publisher, whose publisher name would have Blizzard in it. 
   .EXAMPLE
      Find-InstalledProgram -SearchBy Publisher -StringFilter 'Pi' -RemoteSession -ServerList @('ExampleServerName')
   #>
       [CmdletBinding()]
       
       Param(
       [Parameter(Mandatory=$true)][string][ValidateSet('Publisher','DisplayName')]$SearchBy,
       [Parameter(Mandatory=$true)][string]$StringFilter,
       [switch]$RemoteSession,
       #[switch]$LocalSession=$false,
       $ServerList = @()
       )


  if ($RemoteSession){
      foreach ($item in $ServerList){
    Invoke-Command -ComputerName $item -ScriptBlock {Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.$($SearchBy) -like "*$StringFilter*"} | Select -Property *} | Select-Object PSComputerName,DisplayName, DisplayVersion, Publisher, InstallDate -ExcludeProperty RunSpaceID
    Write-Host "This would be a remote session for $item"

    break
      }
  }
else {  
    Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.$SearchBy -like "*$StringFilter*"} | Select -Property * | Select-Object DisplayName,DisplayVersion,Publisher,InstallDate
    Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.$SearchBy -like "*$StringFilter*"} | Select -Property * | Select-Object DisplayName,DisplayVersion,Publisher,InstallDate
    Write-Host "$SearchBy $StringFilter "
    }
}

#Find-InstalledProgram -SearchBy Publisher -StringFilter 'Pi' -RemoteSession -ServerList @('ExampleServerName')