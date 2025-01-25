############################################################################
####
#### 対象フォルダ直下に日付とフォルダ、さらにその下にbkフォルダを作成する。
#### コマンドラインで使用する。
#### 例）mk_maint $projectName
#### show オプションで、すべての候補をコンソールに表示する。
#### 例）mk_maint -show
#### showDir オプションで、すべての候補のディレクトリをコンソールに表示する。
#### 例）mk_maint -showDir
#### showSetting オプションで、設定ファイルを開く。
#### 例）mk_maint -showSetting
####
############################################################################


function mk_maint() {

    param (
        # オプションを用意
        [switch]$show, 
        [switch]$showdir, 
        [switch]$showSetting
    )

    function Get-NewDir {
        param (
            [string]$path
        )

        $formatted_date = (Get-Date).ToString("yyyyMMdd")
        $newdir = Join-Path -Path $path -ChildPath $formatted_date

        if (Test-Path $newdir) {
            $i = 2
            while (Test-Path $newdir) {
                $newdir = Join-Path -Path $path -ChildPath "${formatted_date}_${i}"
                $i++
            }
        }

        return $newdir
    }

    $scriptPath = Split-Path (Get-Module -ListAvailable mk_maint).Path -Parent
    $project = $args[0]

    try{

        $pathListPath = "${scriptPath}\pathlist.json" # 設定ファイル（リスト）
        if(-not(Test-Path $pathListPath)){ echo "設定ファイルが見つからないため、プログラムを終了します。"; exit }
        
        # $path_dictに設定ファイルを取得
        $psObject = Get-Content -Path $pathListPath | ConvertFrom-Json
        $path_dict = @{}
        $psObject.PSObject.Properties | ForEach-Object {
            $path_dict[$_.Name] = $_.Value
        }


        # -オプション選択時
        if ($show){
            # -showオプションの場合には、すべてを表示。
            Write-Host "設定済み案件は以下のとおりです。"
            $path_dict.Keys | ForEach-Object { Write-Output $_ }
            return
        } elseif ($showdir){
            # -showdirオプションの場合には、ターゲットフォルダをすべてを表示。
            Write-Host "設定済み案件のターゲットフォルダは以下のとおりです。"
            $path_dict.Values | ForEach-Object { Write-Output $_ }
            return
        } elseif ($showSetting){
            # -showSetting オプションの場合には、設定ファイルを開く。
            Invoke-Item $pathListPath
            return
        }

        # オプションがない場合には、フォルダ作成に進む。
        if ($path_dict.ContainsKey($project)) {

            $path = $path_dict[$project]
            if(-not(Test-Path $path)){ echo "所定フォルダが見つからないため、プログラムを終了します。"; exit }
            
            # 生成するディレクトリを検索し、作成する
            $newdir = Get-NewDir -path $path
            mkdir $newdir
            # ｂｋフォルダを作成する
            $bkdir = Join-Path -Path $newdir -ChildPath "bk"
            mkdir $bkdir

            Write-Host "フォルダを作成しました。"
            Invoke-Item $newdir
            return

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
                    if(-not(Test-Path $path)){ echo "所定フォルダが見つからないため、プログラムを終了します。"; exit }

                    # 生成するディレクトリを検索し、作成する。
                    $newdir = Get-NewDir -path $path
                    mkdir $newdir
                    # ｂｋフォルダを作成する
                    $bkdir = Join-Path -Path $newdir -ChildPath "bk"
                    mkdir $bkdir

                    Write-Host "フォルダを作成しました。"
                    Invoke-Item $newdir
                    return
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
