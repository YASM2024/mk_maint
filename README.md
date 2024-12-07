# mk_maint.ps1  

## 1. 概要
   このプログラムは、あらかじめ設定したフォルダに、日付名（YYYYMMDD）のフォルダを自動生成します。  
   （その直下に、「bk」というフォルダも自動的に生成します。）  

## 2. 使用方法

#### 2-1 設定ファイル（pathlist.json）のパスを設定
<div class="snippet-clipboard-content notranslate overflow-auto">
<pre class="notranslate"><code># mk_maint.ps1 21行目付近
$pathListPath = "C:\path\to\pathlist.json"
</code></pre>

#### 2-2 設定ファイル（pathlist.json）に、フォルダの出力先を設定（日本語を含む場合、文字コードは shift-jisとします）  
下記の例は、「prj1」のフォルダが「C:\path\to\folder1」に、「prj2」のフォルダが「C:\path\to\folder2」に対応しています。  
<div class="snippet-clipboard-content notranslate overflow-auto">
<pre class="notranslate"><code># pathlist.json<br>
{<br>
    "prj1":"C:\\path\\to\\folder1",<br>
    "prj2":"G:\\path\\to\\folder2",<br>
    ...<br>
}
</code></pre>  

#### 2-3 powershellコマンドに登録

#### 2-4 powershellで実行
以下を叩くと、上記で設定したフォルダに、日付名（YYYYMMDD）のフォルダを自動生成します。  
<div class="snippet-clipboard-content notranslate overflow-auto">
<pre class="notranslate"><code>mk_maint prj1</code></pre>  
