#!/usr/bin/env python2.6
# -*- coding: utf-8 -*-
from bottle import route, view, response
import bottle
import markdown
import os, sys
import re
import codecs
import glob
import datetime
import cgi

DOCSDIR = './docs'
PAGEDIR = './pages'
CACHEDIR = './cache'

class Page(object):
    pagedir  = PAGEDIR
    cachedir = CACHEDIR
    options = ['codehilite(force_linenos=True)', 'toc']

    def __init__(self, name):
        self.name = name
        self.filename  = os.path.join(self.pagedir,  self.name+'.md')
        self.cachename = os.path.join(self.cachedir, self.name+'.html')

    @property
    def exists(self):
        return os.path.exists(self.filename)

    @property
    def rawfile(self):
        #if not self.exists:
        #    open(self.filename, 'w').close()
        return codecs.open(self.filename, encoding='utf8')

    @property
    def raw(self):
        return self.rawfile.read()

    @property
    def cachefile(self):
        if not os.path.exists(self.cachename) \
        or os.path.getmtime(self.filename) > os.path.getmtime(self.cachename):
           with self.rawfile as f:
               html = markdown.markdown(f.read(), self.options)
           with open(self.cachename, 'w') as f:
               f.write(html.encode('utf-8'))
        return codecs.open(self.cachename, encoding='utf8')

    @property
    def html(self):
        return self.cachefile.read()

    @property
    def title(self):
        ''' The first h1 element '''
        for m in re.finditer(r'<h1[^>]*>(.+?)</h1>', self.html):
            return m.group(1).strip()
        return self.name.replace('_',' ').title()

    @property
    def preview(self):
        for m in re.finditer(r'<p[^>]*>(.+?)</p>', self.html, re.DOTALL):
            return m.group(1).strip()
        return '<i>No preview available</i>'

    @property
    def blogtime(self):
        try:
            date, name = self.name.split('_', 1)
            year, month, day = map(int, date.split('-'))
            return datetime.date(year, month, day)
        except ValueError:
            raise AttributeError("This page is not a blogpost")

    @property
    def is_blogpost(self):
        try:
            self.blogtime
            return True
        except AttributeError:
            return False

def iter_blogposts():
    for post in glob.glob(os.path.join(Page.pagedir, '*.md')):
        name = os.path.basename(post)[:-3]
        if re.match(r'20[0-9]{2}-[0-9]{2}-[0-9]{2}_', name):
            yield Page(name)

def iter_docs():
    for f in os.listdir(DOCSDIR):
        d = os.path.join(DOCSDIR, f)
        i = os.path.join(d, 'index.html')
        if os.path.exists(i):
            yield f



app = bottle.Bottle()

@app.get('/bottle.py')
def bottle_download():
    bottle.redirect('https://github.com/defnull/bottle/raw/master/bottle.py')

# API docs

# Cool links never change :)
@app.get('/api')
@app.get('/api/:filename#.*#')
def api_redirect(filename=''):
    bottle.redirect('/docs/dev/%s' % filename)

@app.get('/')
@app.get('/docs')
@app.get('/docs/')
@app.get('/docs/:filename')
@app.get('/docs/:version/')
@app.get('/docs/:version/:filename#.*#')
def static(filename='', version=''):
    if version and version not in iter_docs():
        bottle.redirect('/docs/dev/%s/%s' % (version, filename))
    elif not version:
        bottle.redirect('/docs/dev/%s' % filename)
    elif not filename:
        bottle.redirect('/docs/%s/index.html' % version)
    return bottle.static_file(filename, root='./docs/%s/' % version)




# Static files

@app.get('/:filename#.+\.(css|js|ico|png|txt|html)#')
def static(filename):
    return bottle.static_file(filename, root='./static/')


# Git commit redirect

@app.get('/commit/:hash#[a-zA-Z0-9]+#')
def commit(hash):
    url = 'https://github.com/defnull/bottle/commit/%s'
    bottle.redirect(url % hash.lower())


# Bottle Pages

@app.get('/page/:name', template='page')
def page(name='start'):
    p = Page(name) #replace('/','_')? Routes don't match '/' so this is save
    if p.exists:
        return dict(page=p)
    else:
        raise bottle.HTTPError(404, 'Page not found') # raise to escape the view...


@app.get('/rss.xml', template='rss')
def blogrss():
    response.content_type = 'xml/rss'
    posts = [post for post in iter_blogposts() if post.exists and post.is_blogpost]
    posts.sort(key=lambda x: x.blogtime, reverse=True)
    return dict(posts=posts)


@app.get('/blog')
@view('blogposts')
def bloglist():
    posts = [post for post in iter_blogposts() if post.exists and post.is_blogpost]
    posts.sort(key=lambda x: x.blogtime, reverse=True)
    return dict(posts=posts)


# Start server
if __name__ == '__main__':
    bottle.debug('debug' in sys.argv)
    reload = 'reload' in sys.argv
    port = int(sys.argv[1] if len(sys.argv) > 1 else 8080)
    bottle.run(app, host='0.0.0.0', port=port, reloader=reload)
