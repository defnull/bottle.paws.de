%rebase basehtml title="Documentation (List of Releases)"
%def natkey(key):
%    return [(int(k) if k.isdigit() else k) for k in key.split('.')]
%end
%names = sorted(releases, key=natkey, reverse=True)
%releases = [r for r in names if '.' in r]
%branches = sorted(r for r in names if r not in releases)
%stable = releases[0]
%testing = 'dev'

<h1>Documentation: List of Releases</h1>
<p>Welcome to Bottle's documentation. This is a list of all available releases. The lates stable release is "<b>bottle-{{stable}}</b>".</p>

%for r in releases:
  % name = r
  % if r == stable: name+= " (stable)"
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
  <li><a href="/page/docs">Documentation</a></li>
</ul>

<p>The documentation for older releases are no longer available.</p>

<h2>Other branches</h2>
<p>These branches are unstable and not officially released.
   They are listed here primarily for developers working on these branches.</p>

%for r in branches:
  % name = r
  % if r == testing: name+= " (testing/unstable)"
  Branch: <b>bottle-{{name}}</b>
  <ul>
    <li><a href="/docs/{{r}}/">Documentation</a> (download as
        <a href="/docs/{{r}}/bottle-docs-{{r}}.tar.gz">tar.gz</a> or
        <a href="/docs/  {{r}}/bottle-docs-{{r}}.tar.bz2">tar.bz2</a>)</li>
    <li><a href="/docs/{{r}}/changelog.html">Changelog</a></li>
  </ul>
%end


