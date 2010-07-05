%rebase basehtml title="Documentation (List of Releases)"
%def natkey(key):
% return [(int(k) if k.isdigit() else k) for k in key.split('.')]
%end

<h1>Documentation: List of Releases</h1>

<ul>
%for r in sorted(releases, key=natkey, reverse=True):
  <li>Release <b>{{r}}</b>
      - <a href="/docs/{{r}}/">Documentation</a>
        (<a href="/docs/{{r}}/bottle-docs-{{r}}.tar.gz">tar.gz</a>)
        (<a href="/docs/{{r}}/bottle-docs-{{r}}.tar.bz2">tar.bz2</a>)
      - <a href="/docs/{{r}}/bottle.py">Snapshot</a></li>
%end
</ul>

The documentation for older releases can be found <a href="/page/docs">here</a>.
