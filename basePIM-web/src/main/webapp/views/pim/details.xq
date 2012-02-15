import module namespace web="http://basex.org/lib/web";

<h1>The Books list!</h1>,
<ul class="book">{
  for $book in books:list-by-name($GET('name'))
  return 
    <li>{$book/title/text()} written by <em>{$book/author/text()}</em>
    <p>
        Genre: {$book/genre/text()}<br/>
        Price: {$book/price/text()}
    </p>
    </li>
}
</ul>