sub MAIN
{
    build-post($_) for dir(‘posts’);
}

sub build-post(IO() $post)
{
    my %meta := read-meta($post);
    my $body := $post.slurp;
    my $html := render-post(%meta, $body);
    “docs/{%meta<slug>}.html”.IO.spurt($html);
}

sub read-meta(IO() $post)
{
    my $slug := $post.basename.subst(/‘.html’$/);
    my $rest := $post.lines.map: {
        next unless /^ ‘<!--’ \s+ ‘%’ (\S+) \s+ (.*?) \s+ ‘-->’$/;
        ~$0 => ~$1;
    };
    { :$slug, |$rest };
}

sub render-post(%meta, $body)
{
    qq:to/HTML/;
        <!DOCTYPE html>
        <html lang="en">
        <meta charset="utf-8">
        <title>{%meta<title>}</title>
        <style>
            body \{ color: rgb(34, 34, 34);
                    font-family: sans-serif;
                    font-size: 14px;
                    line-height: 1.6em;
                    margin: 1rem; \}
            abbr \{ font-size: 1.6ex; \}
            h1 \{ font-size: 2rem; \}
            h2 \{ font-size: 1.6rem; \}
            article \{ max-width: 40rem;
                       margin: 0 auto;
                       hyphens: auto;
                       text-align: justify; \}
            .irc \{ cursor: default;
                    text-decoration: underline;
                    text-decoration-style: dotted; \}
        </style>
        <article>
            <h1>{%meta<title>}</h1>
            <p>chloekek @ <time>{%meta<date>}</time></p>
            {$body}
            <p>
                You can always contact me
                on <span class="irc" title="/query chloekek">Freenode</span>
                or by <a href="mailto:rightfold\@gmail.com?subject=Re: {%meta<title>}">email</a>.
            </p>
        </article>
        </html>
        HTML
}
