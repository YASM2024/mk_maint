############################################################################
####
#### 対象フォルダ直下に日付とフォルダ、さらにその下にbkフォルダを作成する。
#### コマンドラインで使用する。
#### 例）mk_maint $projectName
####
############################################################################


function mk_maint() {
    $project = $args[0]
    try{

        $pathListPath = "C:\path\to\pathlist.json" # 設定ファイル（リスト）
        if(-not(Test-Path $pathListPath)){ echo "設定ファイルが見つからないため、プログラムを終了します。"; exit }
        
        # $path_dictに設定ファイルを取得
        $psObject = Get-Content -Path $pathListPath | ConvertFrom-Json
        $path_dict = @{}
        $psObject.PSObject.Properties | ForEach-Object {
            $path_dict[$_.Name] = $_.Value
        }

        if ($path_dict.ContainsKey($project)) {

            $path = $path_dict[$project]

            $formatted_date = (Get-Date).ToString("yyyyMMdd")
            $newdir = "${path}\${formatted_date}"

            if(-not(Test-Path $path)){ echo "所定フォルダが見つからないため、プログラムを終了します。"; exit }

            if (Test-Path $newdir) {
    
                $i = 2
                while (Test-Path $newdir) {
                    $newdir = "${path}\${formatted_date}_${i}"
                    $i++
                }
            }

            mkdir $newdir

            mkdir "${newdir}\bk"

            Invoke-Item $newdir

        } else {

            $matching_keys = $path_dict.Keys | Where-Object { $_ -like "$project*" }

            switch ($matching_keys.Count) {
                0 {
                    Write-Host "一致するキーがありません。再度入力してください。"
                    return
                }
                1 {
                    $project = $matching_keys
                    $path = $path_dict[$project]

                    $formatted_date = (Get-Date).ToString("yyyyMMdd")
                    $newdir = "${path}\${formatted_date}"

                    if(-not(Test-Path $path)){ echo "所定フォルダが見つからないため、プログラムを終了します。"; exit }

                    if (Test-Path $newdir) {
    
                        $i = 2
                        while (Test-Path $newdir) {
                            $newdir = "${path}\${formatted_date}_${i}"
                            $i++
                        }
                    }

                    mkdir $newdir

                    mkdir "${newdir}\bk"

                    Invoke-Item $newdir
                }
                default {
                    Write-Host "複数の一致するキーが見つかりました："
                    $matching_keys | ForEach-Object { Write-Host $_ }
                    Write-Host "再度、適切なキーを選択してコマンドラインを実行してください。"
                    return
                }
            }
        }
    } catch {
        Write-Host "エラーが発生しました： $_"
        Write-Host "エラー行：$($_.InvocationInfo.ScriptLineNumber)"
    }
}
