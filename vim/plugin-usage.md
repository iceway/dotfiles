<h1 style="text-align: center;">VIM PLUGIN USAGE</h1>

<div style="column-count:2;column-gap:2em;">


**Global**

| 操作                 | 描述                                       |
|----------------------|--------------------------------------------|
| <kbd>\\</kbd>        | 默认的`<leader>`符号。                     |
| <kbd>\<Space\></kbd> | `za`的快捷键，切换折叠、展开状态。         |
| <kbd>\\W</kbd>       | sudo保存当前文件的改动。                   |
| <kbd>\\ev</kbd>      | 纵向分割一个新的窗口，打开`~/.vimrc`文件。 |
| <kbd>F6</kbd>        | 执行`ctags`和`cscope`命令给C代码生成tag。  |

**SirVer/ultisnips**

| 操作              | 描述                                        |
|-------------------|---------------------------------------------|
| <kbd>Ctrl-j</kbd> | 触发UltiSnips自动扩展，触发后按下向前跳转。 |
| <kbd>Ctrl-k</kbd> | UltiSnips自动扩展中向后跳转。               |

**dense-analysis/ale**

| 操作              | 描述                          |
|-------------------|-------------------------------|
| <kbd>Ctrl-j</kbd> | 跳转到下一个ALE提示的错误处。 |
| <kbd>Ctrl-k</kbd> | 跳转到上一个ALE提示的错误处。 |

**Chiel92/vim-autoformat**

| 操作                   | 描述                                             |
|------------------------|--------------------------------------------------|
| <kbd>:Autoformat</kbd> | 如果安装了astyle，对于C和CPP代码用该命令格式化。 |

**easymotion/vim-easymotion**

| 操作                   | 描述                                                           |
|------------------------|----------------------------------------------------------------|
| <kbd>\\\\w</kbd>       | 向前对所有词以Easymotion的高亮格式显示。                       |
| <kbd>\\\\b</kbd>       | 向后对所有词以Easymotion的高亮格式显示。                       |
| <kbd>\\\\j</kbd>       | 向前把所有行以Easymotion的高亮格式显示。                       |
| <kbd>\\\\k</kbd>       | 向后把所有行以Easymotion的高亮格式显示。                       |
| <kbd>\\\\s{char}</kbd> | 把当前页面所有`{char}`字符的位置都以Easymotion的高亮格式显示。 |

**Yggdroot/indentLine**

| 操作                          | 描述                        |
|-------------------------------|-----------------------------|
| <kbd>:IndentLinesToggle</kbd> | 打开/关闭显示不同缩进级别。 |

**godlygeek/tabular**

| 操作                        | 描述                              |
|-----------------------------|-----------------------------------|
| <kbd>:Talularize /"</kbd>   | 以`"`为分隔符，对齐多列内容。     |
| <kbd>:Talularize /,/r</kbd> | 以`,`为分隔符，靠右对齐多列内容。 |
| <kbd>:Talularize /:/c</kbd> | 以`:`为分隔符，居中对齐多列内容。 |

**plasticboy/vim-markdown**

| 操作                       | 描述                                           |
|----------------------------|------------------------------------------------|
| <kbd>]]</kbd>              | 跳转到下一个header。                           |
| <kbd>[[</kbd>              | 跳转到上一个header。                           |
| <kbd>]c</kbd>              | 跳转到当前header。                             |
| <kbd>]u</kbd>              | 跳转到当前的父级header。                       |
| <kbd>:HeaderDecrease</kbd> | 减小header级别，`h2`变成`h1`，`h3`变成`h2`等。 |
| <kbd>:HeaderIncrease</kbd> | 增加header级别，`h1`变成`h2`，`h2`变成`h3`等。 |
| <kbd>:TableFormat</kdb>    | 格式化当前光标所在的表格（依赖插件Tabular）。  |
| <kbd>:InsertToc</kdb>      | 插入目录，`:InsertToc 3`目录级别最多到`h3`。   |

**scrooloose/nerdtree**

| 操作          | 描述                                          |
|---------------|-----------------------------------------------|
| <kbd>F2</kbd> | 打开Nerdtree目录，`:NERDTreeToggle`的快捷键。 |

**scrooloose/nerdcommenter**

| 操作                    | 描述                                       |
|-------------------------|--------------------------------------------|
| <kbd>\\cc</kbd>         | 注释当前行或者选中的多行（每行分别注释）。 |
| <kbd>\\cm</kbd>         | 使用最少的注释符号。                       |
| <kbd>\\cs</kbd>         | 把当前行或者选中行当作整块注释。           |
| <kbd>\\cu</kbd>         | 取消注释。                                 |
| <kbd>\\c\<Space\></kbd> | 切换注释、反注释当前行或者选中的多行。     |
| <kbd>\\c$</kbd>         | 从当前位置注释到行尾。                     |
| <kbd>\\cA</kbd>         | 跳到行尾，插入注释符号，并进入插入模式。   |

**dhruvasagar/vim-table-mode**

| 操作                   | 描述                                      |
|------------------------|-------------------------------------------|
| <kbd>\\tm</kbd>        | 开启/关闭表格模式。                       |
| <kbd>\\tt</kbd>        | 格式化成表格。命令`:Tableize`的快捷方式。 |
| <kbd>:Tableize/,</kbd> | 以`,`为分隔符，把内容格式化成表格。       |
| <kbd>\\tr</kbd>        | 重新对齐表格。                            |
| <kbd>\\tdd</kbd>       | 表格模式下有效，删除当前行。              |
| <kbd>\\tdc</kbd>       | 表格模式下有效，删除当前列。              |
| <kbd>\\tic</kbd>       | 表格模式下有效，在当前列后面插入一列。    |



</div>
