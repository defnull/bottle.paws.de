%rebase basehtml title="Documentation (List of Releases)"
%def natkey(key):
% return [(int(k) if k.isdigit() else k) for k in key.split('.')]
%end
%releases = sorted(releases, key=natkey, reverse=True)
%latest = releases[1]

<h1>Documentation: List of Releases</h1>
<p>Welcome to Bottle's documentation. This is a list of all available releases. The lates stable release is "<b>bottle-{{latest}}</b>" but old releases are still available.</p>


%for r in releases:
  % name = 'dev (testing)' if r=='dev' else r
  % if r == latest: name+= " (stable)"
  Release: <b>bottle-{{name}}</b>
  <ul>
    <li><a href="/docs/{{r}}/">Documentation</a> (download as
        <a href="/docs/{{r}}/bottle-docs-{{r}}.tar.gz">tar.gz</a> or
        <a href="/docs/{{r}}/bottle-docs-{{r}}.tar.bz2">tar.bz2</a>)</li>
    <li><a href="/docs/{{r}}/changelog.html">Changelog</a></li>
  </ul>
%end

Release: <b>bottle-0.6</b>
<ul>
  <li><a href="/page/docs/">Documentation</a></li>
</ul>

The documentation for older releases are no longer available.
