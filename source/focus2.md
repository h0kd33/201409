## CSS 的變種： LESS 與 SASS

瀏覽器所認識的語言，不外乎是 HTML/CSS/JavaScript 這些 W3C 所規定的官方語言。因此像 LESS 與 SASS 這些語言，當然就屬於「非官方語言」，也就是「變種」。

LESS 與 SASS 都是 CSS 的變種，語法和 CSS 有點像，但卻又不太一樣。這類變種語言通常提供了更強大的功能，更簡潔的語法，而且最後會被轉換成 CSS 語言之後，才能放到瀏覽器上使用。

### 變種 1 : LESS 

LESS 是由 Alexis Sellier 所設計的工具，原本是用 Ruby 實作，用來將 LESS 語法轉換成 CSS 語言。後來改用 JavaScript 設計後，就能內嵌到瀏覽器中，動態的將 LESS 轉為 CSS 後立刻呈現。

舉例而言、 LESS 擁有變數的慨念，例如以下範例中的 `@color` 就是一個變數。

```CSS
@color: #4D926F;
 
#header {
  color: @color;
}
h2 {
  color: @color;
}
```

上述 LESS 文件被轉換成 CSS 之後，會變成下列形式。

```CSS
#header {
  color: #4D926F;
}
h2 {
  color: #4D926F;
}
```

當然、LESS 還支援更強大的語法，例如 Mixin 就是個經典的功能，以下是一個簡單的範例。

```CSS
.rounded-corners (@radius: 5px) {
  border-radius: @radius;
  -webkit-border-radius: @radius;
  -moz-border-radius: @radius;
}
 
#header {
  .rounded-corners;
}
#footer {
  .rounded-corners(10px);
}
```

上述文件被轉換成 CSS 之後會變成下列形式。

```CSS
#header {
  border-radius: 5px;
  -webkit-border-radius: 5px;
  -moz-border-radius: 5px;
}
#footer {
  border-radius: 10px;
  -webkit-border-radius: 10px;
  -moz-border-radius: 10px;
}
```

LESS 可以提供層次結構的套嵌語法，以下是一個範例。

```CSS
#header {
  h1 {
    font-size: 26px;
    font-weight: bold;
  }
  p { font-size: 12px;
    a { text-decoration: none;
      &:hover { border-width: 1px }
    }
  }
}
```

上述範例被轉換成 CSS 之後如下所示。

```CSS
#header h1 {
  font-size: 26px;
  font-weight: bold;
}
#header p {
  font-size: 12px;
}
#header p a {
  text-decoration: none;
}
#header p a:hover {
  border-width: 1px;
}
```

另外、 LESS 還提供了「運算式與函數呼叫」等功能，請看以下範例。

```CSS
@the-border: 1px;
@base-color: #111;
@red:        #842210;
 
#header {
  color: @base-color * 3;
  border-left: @the-border;
  border-right: @the-border * 2;
}
#footer { 
  color: @base-color + #003300;
  border-color: desaturate(@red, 10%);
}
```

上述範例轉換成 CSS 之後，應該會像下面文件這樣。

```CSS
#header {
  color: #333;
  border-left: 1px;
  border-right: 2px;
}
#footer { 
  color: #114411;
  border-color: #7d2717;
}
```

### 變種 2 : SASS

SASS (Syntactically Awesome Stylesheets) 是由 Hampton Catlin 設計，然後由 Natalie Weizenbaum 實作的一種樣式語言。

如果您瞭解 JavaScript 與 Python 的差別，或許就能輕易理解 LESS 與 SASS 的差別了。

LESS 與 JavaScript 一樣，有用 {...} 的大括號框起來，而 SASS 則像 Python 一樣，沒有用大括號，而是透過換行與縮排來表現這種層次結構。

事實上，SASS 還有一個變種，就是加上大括號的版本，稱為 SCSS，這兩種風格可以互相轉換，您可以依照習慣挑選使用。

舉例而言，以下是一個 SASS 與 SCSS 的對照範例。

```html
<table><tr><th>SASS</th><th>SCSS</th></tr>
<tr><td>
$blue: #3bbfce
$margin: 16px
 
.content-navigation
  border-color: $blue
  color: darken($blue, 9%)
 
.border
  padding: $margin/2
  margin:  $margin/2
  border-color: $blue
</td><td>
$blue: #3bbfce;
$margin: 16px;
 
.content-navigation {
  border-color: $blue;
  color: darken($blue, 20%);
}
 
.border {
  padding: $margin / 2;
  margin: $margin / 2;
  border-color: $blue;
}
</td></tr>
</table>
```

SASS 與 LESS 都提供了「變數、mixin、函數」等功能，但是 SASS 還提供了「繼承」的功能，以下是一個範例。

```CSS
.error
  border: 1px #f00;
  background: #fdd;

.error.intrusion
  font-size: 1.3em;
  font-weight: bold;

.badError
  @extend .error;
  border-width: 3px;
```

上述範例轉換成 CSS 之後，將會產生下列文件。

```CSS
.error, .badError {
  border: 1px #f00;
  background: #fdd;
}
 
.error.intrusion,
.badError.intrusion {
  font-size: 1.3em;
  font-weight: bold;
}
 
.badError {
  border-width: 3px;
}
```

除此之外，SASS 還提供了多重繼承的功能。

由於 SASS 主要是用 Ruby 實作的，因此不像 LESS 一樣有提供立即在瀏覽器內用 JavaScript 轉換成 CSS 的功能，不過開放原始碼的領域無奇不有，或許也有人用 JavaScript 實作出 SASS 轉 CSS 的功能也說不定。

### 參考文獻
* [聊聊主流框架，Less/Sass/Compass/Bootstrap/H5bp](https://ruby-china.org/topics/4370)
* [为您详细比较三个 CSS 预处理器（框架）：Sass、LESS 和 Stylus](http://www.oschina.net/question/12_44255)
* <http://lesscss.org/>
* <http://sass-lang.com/>
* Wikipedia:[LESS層疊樣式表]
* <http://sass-lang.com/guide>


[LESS層疊樣式表]:http://zh.wikipedia.org/wiki/LESS_(%E5%B1%82%E5%8F%A0%E6%A0%B7%E5%BC%8F%E8%A1%A8)

【本文由陳鍾誠取材並修改自 [維基百科]，採用創作共用的 [姓名標示、相同方式分享] 授權】

