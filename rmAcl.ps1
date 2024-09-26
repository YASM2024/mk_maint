########################################################################
#
#�@�t�H���_�����폜�p�X�N���v�g
#  �R�}���h���C���Ŏg�p����B
#�@��jpowershell rmAcl.ps1 $targetPath $domain $userIntegratedIDs
#
########################################################################

$now = Get-Date

try {

    $targetPath = $args[0] # "C:\Path\to\folder"
    $domain = $args[1]     # "DOMAIN"
    $userIntegratedIDs = $args[2..($args.Length - 1)] # USERNAME1, USERNAME2, USERNAME3 ...

    if ((Test-Path "$targetPath") -eq $false) {
        echo "�w�肳�ꂽ�p�X�����݂��܂���B"
        exit
    }

    foreach ($userIntegratedID in $userIntegratedIDs) {
        $permission = $domain + "\" + $userIntegratedID
        $acl = Get-Acl "$targetPath"
        $accessRule = $acl.Access | Where-Object { $_.IdentityReference -eq $permission }
        if ($accessRule -ne $null) {
            foreach ($rule in $accessRule) {
                $acl.RemoveAccessRule($rule)
                Set-Acl "$targetPath" $acl
            }
        }
    }

    echo $now
    echo "�t�H���_�����̍폜���������܂����B"
    echo "�Ώۃt�H���_�F" $targetPath
    echo "�ΏێҁF" $userIntegratedIDs

} catch {

    echo $now
    echo "�t�H���_�����̍폜�Ɏ��s���܂����B"

}
