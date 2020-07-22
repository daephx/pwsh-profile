# ==========================================================
#  ____             __ _ _            _   _           _
# |  _ \ _ __ ___  / _(_) | ___      | | | | ___  ___| |_
# | |_) | '__/ _ \| |_| | |/ _ \_____| |_| |/ _ \/ __| __|
# |  __/| | | (_) |  _| | |  __/_____|  _  | (_) \__ \ |_
# |_|   |_|  \___/|_| |_|_|\___|     |_| |_|\___/|___/\__|
#           Host profile - Powershell Core v6+
# ==========================================================

Clear-Host
$PSDefaultParameterValues['Install-Module:Scope'] = 'CurrentUser'
$host.privatedata.ProgressForegroundColor = "DarkYellow"
$host.privatedata.ProgressBackgroundColor = "Black"

#  ============================================================================

#region # !! Contents within this block are managed by 'conda init' !!
Set-Alias py python -Option AllScope
if (Get-Command conda.exe -erroraction 'Ignore' ) {
	(& "$((Get-Command conda.exe).source)" "shell.powershell" "hook") | Out-String | Invoke-Expression
}
#endregion


#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
(& "C:\Tools\miniconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
#endregion

