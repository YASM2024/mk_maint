# mk_maint  

## 1. 概要
   このプログラムは、あらかじめ設定したフォルダに、日付名（YYYYMMDD）のフォルダを自動生成します。  
   （その直下に、「bk」というフォルダも自動的に生成します。）  

## 2. 使用方法

#### 2-1 powershellコマンドに登録  
文字コードは shift-jisとしてください。

#### 2-2 設定ファイル（pathlist.json：プロジェクトフォルダの出力先）を設定  
「pathlist_template.json」をコピーして「pathlist.json」とし、設定を記述してください。  
日本語を含む場合、文字コードは shift-jisとしてください。  
下記の例は、「prj1」のフォルダが「C:\path\to\folder1」に、「prj2」のフォルダが「C:\path\to\folder2」に対応しています。  
<div class="snippet-clipboard-content notranslate overflow-auto">
<pre class="notranslate"><code># pathlist.json<br>
{<br>
    "prj1":"C:\\path\\to\\folder1",<br>
    "prj2":"G:\\path\\to\\folder2",<br>
    ...<br>
}
</code></pre>  

#### 2-3 powershellで実行
以下を叩くと、上記で設定したフォルダに、日付名（YYYYMMDD）のフォルダを自動生成します。  
<div class="snippet-clipboard-content notranslate overflow-auto">
<pre class="notranslate"><code> > mk_maint prj1</code></pre>  

「-show」オプションを選択すると、設定されたプロジェクト名の一覧を表示します。  
<div class="snippet-clipboard-content notranslate overflow-auto">
<pre class="notranslate"><code> > mk_maint -show</code></pre>  

「-showDir」オプションを選択すると、設定されたプロジェクトのフォルダパス一覧を表示します。  
<div class="snippet-clipboard-content notranslate overflow-auto">
<pre class="notranslate"><code> > mk_maint -showDir</code></pre>  

「-showSetting」オプションを選択すると、設定ファイルを表示します。  
<div class="snippet-clipboard-content notranslate overflow-auto">
<pre class="notranslate"><code> > mk_maint -showSetting prj1</code></pre>  
