import module namespace web="http://basex.org/lib/web";

<h1>The Books list!</h1>,
<ul class="book">{
  for $book in books:list()
  return 
    <li>{$book/title/text()} written by <em>{$book/author/text()}</em></li>
}
</ul>