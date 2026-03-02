</to-do>

 [this is a webOS browser app making](https://fastht.ml)
 
* [social-network](page.html.md)
* a page where interaction chat between 2 different people in different location)

* [podcast](page.html.md)
* where ***webOSdrowser*** users can listen to live event from hosts either by ai or human

* [web-radio](page.html.md)
* where ***webOSdrowser*** users can listen to radio broadcast all over the world

* [marketplace](page.html.md)
* where ***webOSdrowser***  users can buy and sell to each goods and services other , but only verified user can sell

* [vendor-spot](page.html.md)
* where ***webOSdrowser*** users can purchase all kinds of crypto from cerified vedors 

<project title="FastHTML" summary='FastHTML is a python library which brings together Starlette, Uvicorn, HTMX, and fastcore&#39;s `FT` "FastTags" into a library for creating server-rendered hypermedia applications. The `FastHTML` class itself inherits from `Starlette`, and adds decorator-based routing with many additions, Beforeware, automatic `FT` to HTML rendering, and much more.'>Things to remember when writing FastHTML apps:

- Although parts of its API are inspired by FastAPI, it is *not* compatible with FastAPI syntax and is not targeted at creating API services
- FastHTML includes support for Pico CSS and the fastlite sqlite library, although using both are optional; sqlalchemy can be used directly or via the fastsql library, and any CSS framework can be used. Support for the Surreal and css-scope-inline libraries are also included, but both are optional
- FastHTML is compatible with JS-native web components and any vanilla JS library, but not with React, Vue, or Svelte
- Use `serve()` for running uvicorn (`if __name__ == "__main__"` is not needed since it's automatic)
- When a title is needed with a response, use `Titled`; note that that already wraps children in `Container`, and already includes both the meta title as well as the H1 element.<docs><doc title="FastHTML concise guide" desc="A brief overview of idiomatic FastHTML apps"># Concise reference



## About FastHTML

``` python
from fasthtml.common import *
```

FastHTML is a python library which brings together Starlette, Uvicorn,
HTMX, and fastcore’s `FT` “FastTags” into a library for creating
server-rendered hypermedia applications. The
[`FastHTML`](https://www.fastht.ml/docs/api/core.html#fasthtml) class
itself inherits from `Starlette`, and adds decorator-based routing with
many additions, Beforeware, automatic `FT` to HTML rendering, and much
more.

Things to remember when writing FastHTML apps:

- *Not* compatible with FastAPI syntax; FastHTML is for HTML-first apps,
  not API services (although it can implement APIs too)
- FastHTML includes support for Pico CSS and the fastlite sqlite
  library, although using both are optional; sqlalchemy can be used
  directly or via the fastsql library, and any CSS framework can be
  used. MonsterUI is a richer FastHTML-first component framework with
  similar capabilities to shadcn
- FastHTML is compatible with JS-native web components and any vanilla
  JS library, but not with React, Vue, or Svelte
- Use [`serve()`](https://www.fastht.ml/docs/api/core.html#serve) for
  running uvicorn (`if __name__ == "__main__"` is not needed since it’s
  automatic)
- When a title is needed with a response, use
  [`Titled`](https://www.fastht.ml/docs/api/xtend.html#titled); note
  that that already wraps children in
  [`Container`](https://www.fastht.ml/docs/api/pico.html#container), and
  already includes both the meta title as well as the H1 element.

## Minimal App

The code examples here use fast.ai style: prefer ternary op, 1-line
docstring, minimize vertical space, etc. (Normally fast.ai style uses
few if any comments, but they’re added here as documentation.)

A minimal FastHTML app looks something like this:

``` python
# Meta-package with all key symbols from FastHTML and Starlette. Import it like this at the start of every FastHTML app.
from fasthtml.common import *
# The FastHTML app object and shortcut to `app.route`
app,rt = fast_app()

# Enums constrain the values accepted for a route parameter
name = str_enum('names', 'Alice', 'Bev', 'Charlie')

# Passing a path to `rt` is optional. If not passed (recommended), the function name is the route ('/foo')
# Both GET and POST HTTP methods are handled by default
# Type-annotated params are passed as query params (recommended) unless a path param is defined (which it isn't here)
@rt
def foo(nm: name):
    # `Title` and `P` here are FastTags: direct m-expression mappings of HTML tags to Python functions with positional and named parameters. All standard HTML tags are included in the common wildcard import.
    # When a tuple is returned, this returns concatenated HTML partials. HTMX by default will use a title HTML partial to set the current page name. HEAD tags (e.g. Meta, Link, etc) in the returned tuple are automatically placed in HEAD; everything else is placed in BODY.
    # FastHTML will automatically return a complete HTML document with appropriate headers if a normal HTTP request is received. For an HTMX request, however, just the partials are returned.
    return Title("FastHTML"), H1("My web app"), P(f"Hello, {name}!")
# By default `serve` runs uvicorn on port 5001. Never write `if __name__ == "__main__"` since `serve` checks it internally.
serve()
```

To run this web app:

``` bash
python main.py  # access via localhost:5001
```

## FastTags (aka FT Components or FTs)

FTs are m-expressions plus simple sugar. Positional params map to
children. Named parameters map to attributes. Aliases must be used for
Python reserved words.

``` python
tags = Title("FastHTML"), H1("My web app"), P(f"Let's do this!", cls="myclass")
tags
```

    (title(('FastHTML',),{}),
     h1(('My web app',),{}),
     p(("Let's do this!",),{'class': 'myclass'}))

This example shows key aspects of how FTs handle attributes:

``` python
Label(
    "Choose an option", 
    Select(
        Option("one", value="1", selected=True),  # True renders just the attribute name
        Option("two", value=2, selected=False),   # Non-string values are converted to strings. False omits the attribute entirely
        cls="selector", id="counter",             # 'cls' becomes 'class'
        **{'@click':"alert('Clicked');"},         # Dict unpacking for attributes with special chars
    ),
    _for="counter",                               # '_for' becomes 'for' (can also use 'fr')
)
```

Classes with `__ft__` defined are rendered using that method.

``` python
class FtTest:
    def __ft__(self): return P('test')
    
to_xml(FtTest())
```

    '<p>test</p>\n'

You can create new FTs by importing the new component from
`fasthtml.components`. If the FT doesn’t exist within that module,
FastHTML will create it.

``` python
from fasthtml.components import Some_never_before_used_tag

Some_never_before_used_tag()
```

``` html
<some-never-before-used-tag></some-never-before-used-tag>
```

FTs can be combined by defining them as a function.

``` python
def Hero(title, statement): return Div(H1(title),P(statement), cls="hero")
to_xml(Hero("Hello World", "This is a hero statement"))
```

    '<div class="hero">\n  <h1>Hello World</h1>\n  <p>This is a hero statement</p>\n</div>\n'

When handling a response, FastHTML will automatically render FTs using
the `to_xml` function.

``` python
to_xml(tags)
```

    '<title>FastHTML</title>\n<h1>My web app</h1>\n<p class="myclass">Let&#x27;s do this!</p>\n'

## JS

The [`Script`](https://www.fastht.ml/docs/api/xtend.html#script)
function allows you to include JavaScript. You can use Python to
generate parts of your JS or JSON like this:

``` python
# In future snippets this import will not be shown, but is required
from fasthtml.common import * 
app,rt = fast_app(hdrs=[Script(src="https://cdn.plot.ly/plotly-2.32.0.min.js")])
# `index` is a special function name which maps to the `/` route. 
@rt
def index():
    data = {'somedata':'fill me in…'}
    # `Titled` returns a title tag and an h1 tag with the 1st param, with remaining params as children in a `Main` parent.
    return Titled("Chart Demo", Div(id="myDiv"), Script(f"var data = {data}; Plotly.newPlot('myDiv', data);"))
# In future snippets `serve() will not be shown, but is required
serve()
```

Prefer Python whenever possible over JS. Never use React or shadcn.

## fast_app hdrs

``` python
# In future snippets we'll skip showing the `fast_app` call if it has no params
app, rt = fast_app(
    pico=False, # The Pico CSS framework is included by default, so pass `False` to disable it if needed. No other CSS frameworks are included.
    # These are added to the `head` part of the page for non-HTMX requests.
    hdrs=(
        Link(rel='stylesheet', href='assets/normalize.min.css', type='text/css'),
        Link(rel='stylesheet', href='assets/sakura.css', type='text/css'),
        Style("p {color: red;}"),
        # `MarkdownJS` and `HighlightJS` are available via concise functions
        MarkdownJS(), HighlightJS(langs=['python', 'javascript', 'html', 'css']),
        # by default, all standard static extensions are served statically from the web app dir,
        #   which can be modified using e.g `static_path='public'`
        )
)

@rt
def index(req): return Titled("Markdown rendering example",
                              # This will be client-side rendered to HTML with highlight-js
                              Div("*hi* there",cls="marked"),
                              # This will be syntax highlighted
                              Pre(Code("def foo(): pass")))
```

## Responses

Routes can return various types:

1.  FastTags or tuples of FastTags (automatically rendered to HTML)
2.  Standard Starlette responses (used directly)
3.  JSON-serializable types (returned as JSON in a plain text response)

``` python
@rt("/{fname:path}.{ext:static}")
async def serve_static_file(fname:str, ext:str): return FileResponse(f'public/{fname}.{ext}')

app, rt = fast_app(hdrs=(MarkdownJS(), HighlightJS(langs=['python', 'javascript'])))
@rt
def index(): 
    return Titled("Example",
                  Div("*markdown* here", cls="marked"),
                  Pre(Code("def foo(): pass")))
```

Route functions can be used in attributes like `href` or `action` and
will be converted to paths. Use `.to()` to generate paths with query
parameters.

``` python
@rt
def profile(email:str): return fill_form(profile_form, profiles[email])

profile_form = Form(action=profile)(
    Label("Email", Input(name="email")),
    Button("Save", type="submit")
)

user_profile_path = profile.to(email="user@example.com")  # '/profile?email=user%40example.com'
```

``` python
from dataclasses import dataclass

app,rt = fast_app()
```

When a route handler function is used as a fasttag attribute (such as
`href`, `hx_get`, or `action`) it is converted to that route’s path.
[`fill_form`](https://www.fastht.ml/docs/api/components.html#fill_form)
is used to copy an object’s matching attrs into matching-name form
fields.

``` python
@dataclass
class Profile: email:str; phone:str; age:int
email = 'john@example.com'
profiles = {email: Profile(email=email, phone='123456789', age=5)}
@rt
def profile(email:str): return fill_form(profile_form, profiles[email])

profile_form = Form(method="post", action=profile)(
        Fieldset(
            Label('Email', Input(name="email")),
            Label("Phone", Input(name="phone")),
            Label("Age", Input(name="age"))),
        Button("Save", type="submit"))
```

## Testing

We can use `TestClient` for testing.

``` python
from starlette.testclient import TestClient
```

``` python
path = "/profile?email=webmaster@example.com"
client = TestClient(app)
htmx_req = {'HX-Request':'1'}
print(client.get(path, headers=htmx_req).text)
```

    <form enctype="multipart/form-data" method="post" action="/profile"><fieldset><label>Email       <input name="email" value="john@example.com">
    </label><label>Phone       <input name="phone" value="123456789">
    </label><label>Age       <input name="age" value="5">
    </label></fieldset><button type="submit">Save</button></form>

## Form Handling and Data Binding

When a dataclass, namedtuple, etc. is used as a type annotation, the
form body will be unpacked into matching attribute names automatically.

``` python
@rt
def edit_profile(profile: Profile):
    profiles[email]=profile
    return RedirectResponse(url=path)

new_data = dict(email='john@example.com', phone='7654321', age=25)
print(client.post("/edit_profile", data=new_data, headers=htmx_req).text)
```

    <form enctype="multipart/form-data" method="post" action="/profile"><fieldset><label>Email       <input name="email" value="john@example.com">
    </label><label>Phone       <input name="phone" value="7654321">
    </label><label>Age       <input name="age" value="25">
    </label></fieldset><button type="submit">Save</button></form>

## fasttag Rendering Rules

The general rules for rendering children inside tuples or fasttag
children are: - `__ft__` method will be called (for default components
like `P`, `H2`, etc. or if you define your own components) - If you pass
a string, it will be escaped - On other python objects, `str()` will be
called

If you want to include plain HTML tags directly into e.g. a `Div()` they
will get escaped by default (as a security measure to avoid code
injections). This can be avoided by using `Safe(...)`, e.g to show a
data frame use `Div(NotStr(df.to_html()))`.

## Exceptions

FastHTML allows customization of exception handlers.

``` python
def not_found(req, exc): return Titled("404: I don't exist!")
exception_handlers = {404: not_found}
app, rt = fast_app(exception_handlers=exception_handlers)
```

## Cookies

We can set cookies using the
[`cookie()`](https://www.fastht.ml/docs/api/core.html#cookie) function.

``` python
@rt
def setcook(): return P(f'Set'), cookie('mycookie', 'foobar')
print(client.get('/setcook', headers=htmx_req).text)
```

     <p>Set</p>

``` python
@rt
def getcook(mycookie:str): return f'Got {mycookie}'
# If handlers return text instead of FTs, then a plaintext response is automatically created
print(client.get('/getcook').text)
```

    Got foobar

FastHTML provide access to Starlette’s request object automatically
using special `request` parameter name (or any prefix of that name).

``` python
@rt
def headers(req): return req.headers['host']
```

## Request and Session Objects

FastHTML provides access to Starlette’s session middleware automatically
using the special `session` parameter name (or any prefix of that name).

``` python
@rt
def profile(req, sess, user_id: int=None):
    ip = req.client.host
    sess['last_visit'] = datetime.now().isoformat()
    visits = sess.setdefault('visit_count', 0) + 1
    sess['visit_count'] = visits
    user = get_user(user_id or sess.get('user_id'))
    return Titled(f"Profile: {user.name}", 
                  P(f"Visits: {visits}"), 
                  P(f"IP: {ip}"),
                  Button("Logout", hx_post=logout))
```

Handler functions can return the
[`HtmxResponseHeaders`](https://www.fastht.ml/docs/api/core.html#htmxresponseheaders)
object to set HTMX-specific response headers.

``` python
@rt
def htmlredirect(app): return HtmxResponseHeaders(location="http://example.org")
```

## APIRouter

[`APIRouter`](https://www.fastht.ml/docs/api/core.html#apirouter) lets
you organize routes across multiple files in a FastHTML app.

``` python
# products.py
ar = APIRouter()

@ar
def details(pid: int): return f"Here are the product details for ID: {pid}"

@ar
def all_products(req):
    return Div(
        Div(
            Button("Details",hx_get=details.to(pid=42),hx_target="#products_list",hx_swap="outerHTML",),
        ), id="products_list")
```

``` python
# main.py
from products import ar,all_products

app, rt = fast_app()
ar.to_app(app)

@rt
def index():
    return Div(
        "Products",
        hx_get=all_products, hx_swap="outerHTML")
```

## Toasts

Toasts can be of four types:

- info
- success
- warning
- error

Toasts require the use of the `setup_toasts()` function, plus every
handler needs:

- The session argument
- Must return FT components

``` python
setup_toasts(app)

@rt
def toasting(session):
    add_toast(session, f"cooked", "info")
    add_toast(session, f"ready", "success")
    return Titled("toaster")
```

`setup_toasts(duration)` allows you to specify how long a toast will be
visible before disappearing.10 seconds.

Authentication and authorization are handled with Beforeware, which
functions that run before the route handler is called.

## Auth

``` python
def user_auth_before(req, sess):
    # `auth` key in the request scope is automatically provided to any handler which requests it and can not be injected
    auth = req.scope['auth'] = sess.get('auth', None)
    if not auth: return RedirectResponse('/login', status_code=303)

beforeware = Beforeware(
    user_auth_before,
    skip=[r'/favicon\.ico', r'/static/.*', r'.*\.css', r'.*\.js', '/login', '/']
)

app, rt = fast_app(before=beforeware)
```

## Server-Side Events (SSE)

FastHTML supports the HTMX SSE extension.

``` python
import random
hdrs=(Script(src="https://unpkg.com/htmx-ext-sse@2.2.3/sse.js"),)
app,rt = fast_app(hdrs=hdrs)

@rt
def index(): return Div(hx_ext="sse", sse_connect="/numstream", hx_swap="beforeend show:bottom", sse_swap="message")

# `signal_shutdown()` gets an event that is set on shutdown
shutdown_event = signal_shutdown()

async def number_generator():
    while not shutdown_event.is_set():
        data = Article(random.randint(1, 100))
        yield sse_message(data)

@rt
async def numstream(): return EventStream(number_generator())
```

## Websockets

FastHTML provides useful tools for HTMX’s websockets extension.

``` python
# These HTMX extensions are available through `exts`:
#   head-support preload class-tools loading-states multi-swap path-deps remove-me ws chunked-transfer
app, rt = fast_app(exts='ws')

def mk_inp(): return Input(id='msg', autofocus=True)

@rt
async def index(request):
    # `ws_send` tells HTMX to send a message to the nearest websocket based on the trigger for the form element
    cts = Div(
        Div(id='notifications'),
        Form(mk_inp(), id='form', ws_send=True),
        hx_ext='ws', ws_connect='/ws')
    return Titled('Websocket Test', cts)

async def on_connect(send): await send(Div('Hello, you have connected', id="notifications"))
async def on_disconnect(ws): print('Disconnected!')

@app.ws('/ws', conn=on_connect, disconn=on_disconnect)
async def ws(msg:str, send):
    # websocket hander returns/sends are treated as OOB swaps
    await send(Div('Hello ' + msg, id="notifications"))
    return Div('Goodbye ' + msg, id="notifications"), mk_inp()
```

Sample chatbot that uses FastHTML’s `setup_ws` function:

``` py
app = FastHTML(exts='ws')
rt = app.route
msgs = []

@rt('/')
def home():
    return Div(hx_ext='ws', ws_connect='/ws')(
        Div(Ul(*[Li(m) for m in msgs], id='msg-list')),
        Form(Input(id='msg'), id='form', ws_send=True)
    )

async def ws(msg:str):
    msgs.append(msg)
    await send(Ul(*[Li(m) for m in msgs], id='msg-list'))

send = setup_ws(app, ws)
```

### Single File Uploads

[`Form`](https://www.fastht.ml/docs/api/xtend.html#form) defaults to
“multipart/form-data”. A Starlette UploadFile is passed to the handler.

``` python
upload_dir = Path("filez")

@rt
def index():
    return (
        Form(hx_post=upload, hx_target="#result")(
            Input(type="file", name="file"),
            Button("Upload", type="submit")),
        Div(id="result")
    )

# Use `async` handlers where IO is used to avoid blocking other clients
@rt
async def upload(file: UploadFile):
    filebuffer = await file.read()
    (upload_dir / file.filename).write_bytes(filebuffer)
    return P('Size: ', file.size)
```

For multi-file, use `Input(..., multiple=True)`, and a type annotation
of `list[UploadFile]` in the handler.

## Fastlite

Fastlite and the MiniDataAPI specification it’s built on are a
CRUD-oriented API for working with SQLite. APSW and apswutils is used to
connect to SQLite, optimized for speed and clean error handling.

``` python
from fastlite import *
```

``` python
db = database(':memory:') # or database('data/app.db')
```

Tables are normally constructed with classes, field types are specified
as type hints.

``` python
class Book: isbn: str; title: str; pages: int; userid: int
# The transform arg instructs fastlite to change the db schema when fields change.
# Create only creates a table if the table doesn't exist.
books = db.create(Book, pk='isbn', transform=True)
                
class User: id: int; name: str; active: bool = True
# If no pk is provided, id is used as the primary key.
users = db.create(User, transform=True)
users
```

    <Table user (id, name, active)>

### Fastlite CRUD operations

Every operation in fastlite returns a full superset of dataclass
functionality.

``` python
user = users.insert(name='kubu',active=False)
user
```

    User(id=1, name='Alex', active=0)

``` python
# List all records
users()
```

    [User(id=1, name='kubu', active=0)]

``` python
# Limit, offset, and order results:
users(order_by='name', limit=2, offset=1)

# Filter on the results
users(where="name='kubu'")

# Placeholder for avoiding injection attacks
users("name=?", ('kubu',))

# A single record by pk
users[user.id]
```

    User(id=1, name='kubu', active=0)

Test if a record exists by using `in` keyword on primary key:

``` python
1 in users
```

    True

Updates (which take a dict or a typed object) return the updated record.

``` python
user.name='qubuhub'
user.active=True
users.update(user)
```

    User(id=1, name='qubuhub', active=1)

`.xtra()` to automatically constrain queries, updates, and inserts from
there on:

``` python
users.xtra(active=True)
users()
```

    [User(id=1, name='qubuhub', active=1)]

Deleting by pk:

``` python
users.delete(user.id)
```

    <Table user (id, name, active)>

NotFoundError is raised by pk `[]`, updates, and deletes.

``` python
try: users['Amy']
except NotFoundError: print('User not found')
```

    User not found

## MonsterUI

MonsterUI is a shadcn-like component library for FastHTML. It adds the
Tailwind-based libraries FrankenUI and DaisyUI to FastHTML, as well as
Python’s mistletoe for Markdown, HighlightJS for code highlighting, and
Katex for latex support, following semantic HTML patterns when possible.
It is recommended for when you wish to go beyond the basics provided by
FastHTML’s built-in pico support.

A minimal app:

``` python
from fasthtml.common import *
from monsterui.all import *

app, rt = fast_app(hdrs=Theme.blue.headers(highlightjs=True)) # Use MonsterUI blue theme and highlight code in markdown

@rt
def index():
    socials = (('github','https://github.com/AnswerDotAI/MonsterUI'),)
    return Titled("App",
        Card(
            P("App", cls=TextPresets.muted_sm),
            # LabelInput, DivLAigned, and UkIconLink are non-semantic MonsterUI FT Components,
            LabelInput('Email', type='email', required=True),
            footer=DivLAligned(*[UkIconLink(icon,href=url) for icon,url in socials])))
```

MonsterUI recommendations:

- Use defaults as much as possible, for example
  [`Container`](https://www.fastht.ml/docs/api/pico.html#container) in
  monsterui already has defaults for margins
- Use `*T` for button styling consistency, for example
  `cls=ButtonT.destructive` for a red delete button or
  `cls=ButtonT.primary` for a CTA button
- Use `Label*` functions for forms as much as possible
  (e.g. `LabelInput`, `LabelRange`) which creates and links both the
  `FormLabel` and user input appropriately to avoid boiler plate.

Flex Layout Elements (such as `DivLAligned` and `DivFullySpaced`) can be
used to create layouts concisely

``` python
def TeamCard(name, role, location="Remote"):
    icons = ("mail", "linkedin", "github")
    return Card(
        DivLAligned(
            DiceBearAvatar(name, h=24, w=24),
            Div(H3(name), P(role))),
        footer=DivFullySpaced(
            DivHStacked(UkIcon("map-pin", height=16), P(location)),
            DivHStacked(*(UkIconLink(icon, height=16) for icon in icons))))
```

Forms are styled and spaced for you without significant additional
classes.

``` python
def MonsterForm():
    relationship = ["Parent",'Sibling', "Friend", "Spouse", "Significant Other", "Relative", "Child", "Other"]
    return Div(
        DivCentered(
            H3("Emergency Contact Form"),
            P("Please fill out the form completely", cls=TextPresets.muted_sm)),
        Form(
            Grid(LabelInput("Name",id='name'),LabelInput("Email",     id='email')),
            H3("Relationship to patient"),
            Grid(*[LabelCheckboxX(o) for o in relationship], cols=4, cls='space-y-3'),
            DivCentered(Button("Submit Form", cls=ButtonT.primary))),
        cls='space-y-4')
```

Text can be styled with markdown automatically with MonsterUI

```` python
render_md("""
# My Document

> Important note here

+ List item with **bold**
+ Another with `code`

```python
def hello():
    print("world")
```
""")
````

    '<div><h1 class="uk-h1 text-4xl font-bold mt-12 mb-6">My Document</h1>\n<blockquote class="uk-blockquote pl-4 border-l-4 border-primary italic mb-6">\n<p class="text-lg leading-relaxed mb-6">Important note here</p>\n</blockquote>\n<ul class="uk-list uk-list-bullet space-y-2 mb-6 ml-6 text-lg">\n<li class="leading-relaxed">List item with <strong>bold</strong></li>\n<li class="leading-relaxed">Another with <code class="uk-codespan px-1">code</code></li>\n</ul>\n<pre class="bg-base-200 rounded-lg p-4 mb-6"><code class="language-python uk-codespan px-1 uk-codespan px-1 block overflow-x-auto">def hello():\n    print("world")\n</code></pre>\n</div>'

Or using semantic HTML:

``` python
def SemanticText():
    return Card(
        H1("MonsterUI's Semantic Text"),
        P(
            Strong("MonsterUI"), " brings the power of semantic HTML to life with ",
            Em("beautiful styling"), " and ", Mark("zero configuration"), "."),
        Blockquote(
            P("Write semantic HTML in pure Python, get modern styling for free."),
            Cite("MonsterUI Team")),
        footer=Small("Released February 2025"),)
```</doc><doc title="HTMX reference" desc="Brief description of all HTMX attributes, CSS classes, headers, events, extensions, js lib methods, and config options">+++
title = "Reference"
+++

## Contents

* [htmx Core Attributes](#attributes)
* [htmx Additional Attributes](#attributes-additional)
* [htmx CSS Classes](#classes)
* [htmx Request Headers](#request_headers)
* [htmx Response Headers](#response_headers)
* [htmx Events](#events)
* [htmx Extensions](/extensions)
* [JavaScript API](#api)
* [Configuration Options](#config)

## Core Attribute Reference {#attributes}

The most common attributes when using htmx.

<div class="info-table">

| Attribute                                        | Description                                                                                                        |
|--------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| [`hx-get`](@/attributes/hx-get.md)               | issues a `GET` to the specified URL                                                                                |
| [`hx-post`](@/attributes/hx-post.md)             | issues a `POST` to the specified URL                                                                               |
| [`hx-on*`](@/attributes/hx-on.md)                | handle events with inline scripts on elements                                                                      |
| [`hx-push-url`](@/attributes/hx-push-url.md)     | push a URL into the browser location bar to create history                                                         |
| [`hx-select`](@/attributes/hx-select.md)         | select content to swap in from a response                                                                          |
| [`hx-select-oob`](@/attributes/hx-select-oob.md) | select content to swap in from a response, somewhere other than the target (out of band)                           |
| [`hx-swap`](@/attributes/hx-swap.md)             | controls how content will swap in (`outerHTML`, `beforeend`, `afterend`, ...)                                      |
| [`hx-swap-oob`](@/attributes/hx-swap-oob.md)     | mark element to swap in from a response (out of band)                                                              |
| [`hx-target`](@/attributes/hx-target.md)         | specifies the target element to be swapped                                                                         |
| [`hx-trigger`](@/attributes/hx-trigger.md)       | specifies the event that triggers the request                                                                      |
| [`hx-vals`](@/attributes/hx-vals.md)             | add values to submit with the request (JSON format)                                                                |

</div>

## Additional Attribute Reference {#attributes-additional}

All other attributes available in htmx.

<div class="info-table">

| Attribute                                            | Description                                                                                                                        |
|------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------|
| [`hx-boost`](@/attributes/hx-boost.md)               | add [progressive enhancement](https://en.wikipedia.org/wiki/Progressive_enhancement) for links and forms                           |
| [`hx-confirm`](@/attributes/hx-confirm.md)           | shows a `confirm()` dialog before issuing a request                                                                                |
| [`hx-delete`](@/attributes/hx-delete.md)             | issues a `DELETE` to the specified URL                                                                                             |
| [`hx-disable`](@/attributes/hx-disable.md)           | disables htmx processing for the given node and any children nodes                                                                 |
| [`hx-disabled-elt`](@/attributes/hx-disabled-elt.md) | adds the `disabled` attribute to the specified elements while a request is in flight                                               |
| [`hx-disinherit`](@/attributes/hx-disinherit.md)     | control and disable automatic attribute inheritance for child nodes                                                                |
| [`hx-encoding`](@/attributes/hx-encoding.md)         | changes the request encoding type                                                                                                  |
| [`hx-ext`](@/attributes/hx-ext.md)                   | extensions to use for this element                                                                                                 |
| [`hx-headers`](@/attributes/hx-headers.md)           | adds to the headers that will be submitted with the request                                                                        |
| [`hx-history`](@/attributes/hx-history.md)           | prevent sensitive data being saved to the history cache                                                                            |
| [`hx-history-elt`](@/attributes/hx-history-elt.md)   | the element to snapshot and restore during history navigation                                                                      |
| [`hx-include`](@/attributes/hx-include.md)           | include additional data in requests                                                                                                |
| [`hx-indicator`](@/attributes/hx-indicator.md)       | the element to put the `htmx-request` class on during the request                                                                  |
| [`hx-inherit`](@/attributes/hx-inherit.md)           | control and enable automatic attribute inheritance for child nodes if it has been disabled by default                            |
| [`hx-params`](@/attributes/hx-params.md)             | filters the parameters that will be submitted with a request                                                                       |
| [`hx-patch`](@/attributes/hx-patch.md)               | issues a `PATCH` to the specified URL                                                                                              |
| [`hx-preserve`](@/attributes/hx-preserve.md)         | specifies elements to keep unchanged between requests                                                                              |
| [`hx-prompt`](@/attributes/hx-prompt.md)             | shows a `prompt()` before submitting a request                                                                                     |
| [`hx-put`](@/attributes/hx-put.md)                   | issues a `PUT` to the specified URL                                                                                                |
| [`hx-replace-url`](@/attributes/hx-replace-url.md)   | replace the URL in the browser location bar                                                                                        |
| [`hx-request`](@/attributes/hx-request.md)           | configures various aspects of the request                                                                                          |
| [`hx-sync`](@/attributes/hx-sync.md)                 | control how requests made by different elements are synchronized                                                                   |
| [`hx-validate`](@/attributes/hx-validate.md)         | force elements to validate themselves before a request                                                                             |
| [`hx-vars`](@/attributes/hx-vars.md)                 | adds values dynamically to the parameters to submit with the request (deprecated, please use [`hx-vals`](@/attributes/hx-vals.md)) |

</div>

## CSS Class Reference {#classes}

<div class="info-table">

| Class | Description |
|-----------|-------------|
| `htmx-added` | Applied to a new piece of content before it is swapped, removed after it is settled.
| `htmx-indicator` | A dynamically generated class that will toggle visible (opacity:1) when a `htmx-request` class is present
| `htmx-request` | Applied to either the element or the element specified with [`hx-indicator`](@/attributes/hx-indicator.md) while a request is ongoing
| `htmx-settling` | Applied to a target after content is swapped, removed after it is settled. The duration can be modified via [`hx-swap`](@/attributes/hx-swap.md).
| `htmx-swapping` | Applied to a target before any content is swapped, removed after it is swapped. The duration can be modified via [`hx-swap`](@/attributes/hx-swap.md).

</div>

## HTTP Header Reference {#headers}

### Request Headers Reference {#request_headers}

<div class="info-table">

| Header | Description |
|--------|-------------|
| `HX-Boosted` | indicates that the request is via an element using [hx-boost](@/attributes/hx-boost.md)
| `HX-Current-URL` | the current URL of the browser
| `HX-History-Restore-Request` | "true" if the request is for history restoration after a miss in the local history cache
| `HX-Prompt` | the user response to an [hx-prompt](@/attributes/hx-prompt.md)
| `HX-Request` | always "true"
| `HX-Target` | the `id` of the target element if it exists
| `HX-Trigger-Name` | the `name` of the triggered element if it exists
| `HX-Trigger` | the `id` of the triggered element if it exists

</div>

### Response Headers Reference {#response_headers}

<div class="info-table">

| Header                                               | Description |
|------------------------------------------------------|-------------|
| [`HX-Location`](@/headers/hx-location.md)            | allows you to do a client-side redirect that does not do a full page reload
| [`HX-Push-Url`](@/headers/hx-push-url.md)            | pushes a new url into the history stack
| [`HX-Redirect`](@/headers/hx-redirect.md)            | can be used to do a client-side redirect to a new location
| `HX-Refresh`                                         | if set to "true" the client-side will do a full refresh of the page
| [`HX-Replace-Url`](@/headers/hx-replace-url.md)      | replaces the current URL in the location bar
| `HX-Reswap`                                          | allows you to specify how the response will be swapped. See [hx-swap](@/attributes/hx-swap.md) for possible values
| `HX-Retarget`                                        | a CSS selector that updates the target of the content update to a different element on the page
| `HX-Reselect`                                        | a CSS selector that allows you to choose which part of the response is used to be swapped in. Overrides an existing [`hx-select`](@/attributes/hx-select.md) on the triggering element
| [`HX-Trigger`](@/headers/hx-trigger.md)              | allows you to trigger client-side events
| [`HX-Trigger-After-Settle`](@/headers/hx-trigger.md) | allows you to trigger client-side events after the settle step
| [`HX-Trigger-After-Swap`](@/headers/hx-trigger.md)   | allows you to trigger client-side events after the swap step

</div>

## Event Reference {#events}

<div class="info-table">

| Event | Description |
|-------|-------------|
| [`htmx:abort`](@/events.md#htmx:abort) | send this event to an element to abort a request
| [`htmx:afterOnLoad`](@/events.md#htmx:afterOnLoad) | triggered after an AJAX request has completed processing a successful response
| [`htmx:afterProcessNode`](@/events.md#htmx:afterProcessNode) | triggered after htmx has initialized a node
| [`htmx:afterRequest`](@/events.md#htmx:afterRequest)  | triggered after an AJAX request has completed
| [`htmx:afterSettle`](@/events.md#htmx:afterSettle)  | triggered after the DOM has settled
| [`htmx:afterSwap`](@/events.md#htmx:afterSwap)  | triggered after new content has been swapped in
| [`htmx:beforeCleanupElement`](@/events.md#htmx:beforeCleanupElement)  | triggered before htmx [disables](@/attributes/hx-disable.md) an element or removes it from the DOM
| [`htmx:beforeOnLoad`](@/events.md#htmx:beforeOnLoad)  | triggered before any response processing occurs
| [`htmx:beforeProcessNode`](@/events.md#htmx:beforeProcessNode) | triggered before htmx initializes a node
| [`htmx:beforeRequest`](@/events.md#htmx:beforeRequest)  | triggered before an AJAX request is made
| [`htmx:beforeSwap`](@/events.md#htmx:beforeSwap)  | triggered before a swap is done, allows you to configure the swap
| [`htmx:beforeSend`](@/events.md#htmx:beforeSend)  | triggered just before an ajax request is sent
| [`htmx:beforeTransition`](@/events.md#htmx:beforeTransition)  | triggered before the [View Transition](https://developer.mozilla.org/en-US/docs/Web/API/View_Transitions_API) wrapped swap occurs
| [`htmx:configRequest`](@/events.md#htmx:configRequest)  | triggered before the request, allows you to customize parameters, headers
| [`htmx:confirm`](@/events.md#htmx:confirm)  | triggered after a trigger occurs on an element, allows you to cancel (or delay) issuing the AJAX request
| [`htmx:historyCacheError`](@/events.md#htmx:historyCacheError)  | triggered on an error during cache writing
| [`htmx:historyCacheHit`](@/events.md#htmx:historyCacheHit)  | triggered on a cache hit in the history subsystem
| [`htmx:historyCacheMiss`](@/events.md#htmx:historyCacheMiss)  | triggered on a cache miss in the history subsystem
| [`htmx:historyCacheMissLoadError`](@/events.md#htmx:historyCacheMissLoadError)  | triggered on a unsuccessful remote retrieval
| [`htmx:historyCacheMissLoad`](@/events.md#htmx:historyCacheMissLoad)  | triggered on a successful remote retrieval
| [`htmx:historyRestore`](@/events.md#htmx:historyRestore)  | triggered when htmx handles a history restoration action
| [`htmx:beforeHistorySave`](@/events.md#htmx:beforeHistorySave)  | triggered before content is saved to the history cache
| [`htmx:load`](@/events.md#htmx:load)  | triggered when new content is added to the DOM
| [`htmx:noSSESourceError`](@/events.md#htmx:noSSESourceError)  | triggered when an element refers to a SSE event in its trigger, but no parent SSE source has been defined
| [`htmx:onLoadError`](@/events.md#htmx:onLoadError)  | triggered when an exception occurs during the onLoad handling in htmx
| [`htmx:oobAfterSwap`](@/events.md#htmx:oobAfterSwap)  | triggered after an out of band element as been swapped in
| [`htmx:oobBeforeSwap`](@/events.md#htmx:oobBeforeSwap)  | triggered before an out of band element swap is done, allows you to configure the swap
| [`htmx:oobErrorNoTarget`](@/events.md#htmx:oobErrorNoTarget)  | triggered when an out of band element does not have a matching ID in the current DOM
| [`htmx:prompt`](@/events.md#htmx:prompt)  | triggered after a prompt is shown
| [`htmx:pushedIntoHistory`](@/events.md#htmx:pushedIntoHistory)  | triggered after a url is pushed into history
| [`htmx:replacedInHistory`](@/events.md#htmx:replacedInHistory)  | triggered after a url is replaced in history
| [`htmx:responseError`](@/events.md#htmx:responseError)  | triggered when an HTTP response error (non-`200` or `300` response code) occurs
| [`htmx:sendAbort`](@/events.md#htmx:sendAbort)  | triggered when a request is aborted
| [`htmx:sendError`](@/events.md#htmx:sendError)  | triggered when a network error prevents an HTTP request from happening
| [`htmx:sseError`](@/events.md#htmx:sseError)  | triggered when an error occurs with a SSE source
| [`htmx:sseOpen`](/events#htmx:sseOpen)  | triggered when a SSE source is opened
| [`htmx:swapError`](@/events.md#htmx:swapError)  | triggered when an error occurs during the swap phase
| [`htmx:targetError`](@/events.md#htmx:targetError)  | triggered when an invalid target is specified
| [`htmx:timeout`](@/events.md#htmx:timeout)  | triggered when a request timeout occurs
| [`htmx:validation:validate`](@/events.md#htmx:validation:validate)  | triggered before an element is validated
| [`htmx:validation:failed`](@/events.md#htmx:validation:failed)  | triggered when an element fails validation
| [`htmx:validation:halted`](@/events.md#htmx:validation:halted)  | triggered when a request is halted due to validation errors
| [`htmx:xhr:abort`](@/events.md#htmx:xhr:abort)  | triggered when an ajax request aborts
| [`htmx:xhr:loadend`](@/events.md#htmx:xhr:loadend)  | triggered when an ajax request ends
| [`htmx:xhr:loadstart`](@/events.md#htmx:xhr:loadstart)  | triggered when an ajax request starts
| [`htmx:xhr:progress`](@/events.md#htmx:xhr:progress)  | triggered periodically during an ajax request that supports progress events

</div>

## JavaScript API Reference {#api}

<div class="info-table">

| Method | Description |
|-------|-------------|
| [`htmx.addClass()`](@/api.md#addClass)  | Adds a class to the given element
| [`htmx.ajax()`](@/api.md#ajax)  | Issues an htmx-style ajax request
| [`htmx.closest()`](@/api.md#closest)  | Finds the closest parent to the given element matching the selector
| [`htmx.config`](@/api.md#config)  | A property that holds the current htmx config object
| [`htmx.createEventSource`](@/api.md#createEventSource)  | A property holding the function to create SSE EventSource objects for htmx
| [`htmx.createWebSocket`](@/api.md#createWebSocket)  | A property holding the function to create WebSocket objects for htmx
| [`htmx.defineExtension()`](@/api.md#defineExtension)  | Defines an htmx [extension](https://htmx.org/extensions)
| [`htmx.find()`](@/api.md#find)  | Finds a single element matching the selector
| [`htmx.findAll()` `htmx.findAll(elt, selector)`](@/api.md#find)  | Finds all elements matching a given selector
| [`htmx.logAll()`](@/api.md#logAll)  | Installs a logger that will log all htmx events
| [`htmx.logger`](@/api.md#logger)  | A property set to the current logger (default is `null`)
| [`htmx.off()`](@/api.md#off)  | Removes an event listener from the given element
| [`htmx.on()`](@/api.md#on)  | Creates an event listener on the given element, returning it
| [`htmx.onLoad()`](@/api.md#onLoad)  | Adds a callback handler for the `htmx:load` event
| [`htmx.parseInterval()`](@/api.md#parseInterval)  | Parses an interval declaration into a millisecond value
| [`htmx.process()`](@/api.md#process)  | Processes the given element and its children, hooking up any htmx behavior
| [`htmx.remove()`](@/api.md#remove)  | Removes the given element
| [`htmx.removeClass()`](@/api.md#removeClass)  | Removes a class from the given element
| [`htmx.removeExtension()`](@/api.md#removeExtension)  | Removes an htmx [extension](https://htmx.org/extensions)
| [`htmx.swap()`](@/api.md#swap)  | Performs swapping (and settling) of HTML content
| [`htmx.takeClass()`](@/api.md#takeClass)  | Takes a class from other elements for the given element
| [`htmx.toggleClass()`](@/api.md#toggleClass)  | Toggles a class from the given element
| [`htmx.trigger()`](@/api.md#trigger)  | Triggers an event on an element
| [`htmx.values()`](@/api.md#values)  | Returns the input values associated with the given element

</div>


## Configuration Reference {#config}

Htmx has some configuration options that can be accessed either programmatically or declaratively.  They are
listed below:

<div class="info-table">

| Config Variable                        | Info                                                                                                                                                                       |
|----------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `htmx.config.historyEnabled`           | defaults to `true`, really only useful for testing                                                                                                                         |
| `htmx.config.historyCacheSize`         | defaults to 10                                                                                                                                                             |
| `htmx.config.refreshOnHistoryMiss`     | defaults to `false`, if set to `true` htmx will issue a full page refresh on history misses rather than use an AJAX request                                                |
| `htmx.config.defaultSwapStyle`         | defaults to `innerHTML`                                                                                                                                                    |
| `htmx.config.defaultSwapDelay`         | defaults to 0                                                                                                                                                              |
| `htmx.config.defaultSettleDelay`       | defaults to 20                                                                                                                                                             |
| `htmx.config.includeIndicatorStyles`   | defaults to `true` (determines if the indicator styles are loaded)                                                                                                         |
| `htmx.config.indicatorClass`           | defaults to `htmx-indicator`                                                                                                                                               |
| `htmx.config.requestClass`             | defaults to `htmx-request`                                                                                                                                                 |
| `htmx.config.addedClass`               | defaults to `htmx-added`                                                                                                                                                   |
| `htmx.config.settlingClass`            | defaults to `htmx-settling`                                                                                                                                                |
| `htmx.config.swappingClass`            | defaults to `htmx-swapping`                                                                                                                                                |
| `htmx.config.allowEval`                | defaults to `true`, can be used to disable htmx's use of eval for certain features (e.g. trigger filters)                                                                  |
| `htmx.config.allowScriptTags`          | defaults to `true`, determines if htmx will process script tags found in new content                                                                                       |
| `htmx.config.inlineScriptNonce`        | defaults to `''`, meaning that no nonce will be added to inline scripts                                                                                                    |
| `htmx.config.inlineStyleNonce`         | defaults to `''`, meaning that no nonce will be added to inline styles                                                                                                     |
| `htmx.config.attributesToSettle`       | defaults to `["class", "style", "width", "height"]`, the attributes to settle during the settling phase                                                                    |
| `htmx.config.wsReconnectDelay`         | defaults to `full-jitter`                                                                                                                                                  |
| `htmx.config.wsBinaryType`             | defaults to `blob`, the [the type of binary data](https://developer.mozilla.org/docs/Web/API/WebSocket/binaryType) being received over the WebSocket connection            |
| `htmx.config.disableSelector`          | defaults to `[hx-disable], [data-hx-disable]`, htmx will not process elements with this attribute on it or a parent                                                        |
| `htmx.config.disableInheritance`       | defaults to `false`. If it is set to `true`, the inheritance of attributes is completely disabled and you can explicitly specify the inheritance with the [hx-inherit](@/attributes/hx-inherit.md) attribute.
| `htmx.config.withCredentials`          | defaults to `false`, allow cross-site Access-Control requests using credentials such as cookies, authorization headers or TLS client certificates                          |
| `htmx.config.timeout`                  | defaults to 0, the number of milliseconds a request can take before automatically being terminated                                                                         |
| `htmx.config.scrollBehavior`           | defaults to 'instant', the scroll behavior when using the [show](@/attributes/hx-swap.md#scrolling-scroll-show) modifier with `hx-swap`. The allowed values are `instant` (scrolling should happen instantly in a single jump), `smooth` (scrolling should animate smoothly) and `auto` (scroll behavior is determined by the computed value of [scroll-behavior](https://developer.mozilla.org/en-US/docs/Web/CSS/scroll-behavior)). |
| `htmx.config.defaultFocusScroll`       | if the focused element should be scrolled into view, defaults to false and can be overridden using the [focus-scroll](@/attributes/hx-swap.md#focus-scroll) swap modifier. |
| `htmx.config.getCacheBusterParam`      | defaults to false, if set to true htmx will append the target element to the `GET` request in the format `org.htmx.cache-buster=targetElementId`                           |
| `htmx.config.globalViewTransitions`    | if set to `true`, htmx will use the [View Transition](https://developer.mozilla.org/en-US/docs/Web/API/View_Transitions_API) API when swapping in new content.             |
| `htmx.config.methodsThatUseUrlParams`  | defaults to `["get", "delete"]`, htmx will format requests with these methods by encoding their parameters in the URL, not the request body                                |
| `htmx.config.selfRequestsOnly`         | defaults to `true`, whether to only allow AJAX requests to the same domain as the current document                                                             |
| `htmx.config.ignoreTitle`              | defaults to `false`, if set to `true` htmx will not update the title of the document when a `title` tag is found in new content                                            |
| `htmx.config.scrollIntoViewOnBoost`    | defaults to `true`, whether or not the target of a boosted element is scrolled into the viewport. If `hx-target` is omitted on a boosted element, the target defaults to `body`, causing the page to scroll to the top. |
| `htmx.config.triggerSpecsCache`        | defaults to `null`, the cache to store evaluated trigger specifications into, improving parsing performance at the cost of more memory usage. You may define a simple object to use a never-clearing cache, or implement your own system using a [proxy object](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Proxy) |
| `htmx.config.responseHandling`         | the default [Response Handling](@/docs.md#response-handling) behavior for response status codes can be configured here to either swap or error                             |
| `htmx.config.allowNestedOobSwaps`      | defaults to `true`, whether to process OOB swaps on elements that are nested within the main response element. See [Nested OOB Swaps](@/attributes/hx-swap-oob.md#nested-oob-swaps). |
| `htmx.config.historyRestoreAsHxRequest`| defaults to `true`, Whether to treat history cache miss full page reload requests as a "HX-Request" by returning this response header. This should always be disabled when using HX-Request header to optionally return partial responses                                                                                                         |


</div>

You can set them directly in javascript, or you can use a `meta` tag:

```html
<meta name="htmx-config" content='{"defaultSwapStyle":"outerHTML"}'>
```</doc><doc title="Starlette quick guide" desc="A quick overview of some Starlette features useful to FastHTML devs."># 🌟 Starlette Quick Manual


2020-02-09

Starlette is the ASGI web framework used as the foundation of FastHTML. Listed here are some Starlette features FastHTML developers can use directly, since the `FastHTML` class inherits from the `Starlette` class (but note that FastHTML has its own customised `RouteX` and `RouterX` classes for routing, to handle FT element trees etc).

## Get uploaded file content

```
async def handler(request):
    inp = await request.form()
    uploaded_file = inp["filename"]
    filename = uploaded_file.filename           # abc.png
    content_type = uploaded.content_type    # MIME type, e.g. image/png
    content = await uploaded_file.read()       # image content

```

## Return a customized response (status code and headers)

```
import json
from starlette.responses import Response

async def handler(request):
    data = {
        "name": "Bo"
    }
    return Response(json.dumps(data), media_type="application/json")

```

`Response` takes `status_code`, `headers` and `media_type`, so if we want to change a response's status code, we can do:

```
return Response(content, statu_code=404)

```

And customized headers:

```
headers = {
	"x-extra-key": "value"
}
return Response(content, status_code=200, headers=headers)

```

## Redirect

```
from starlette.responses import RedirectResponse

async handler(request):
    # Customize status_code: 
    #   301: permanent redirect 
    #   302: temporary redirect 
    #   303: see others
    #   307: temporary redirect (default)
    return RedirectResponse(url=url, status_code=303)

```

## Request context

### URL Object: `request.url`

  * Get request full url: `url = str(request.url)`
  * Get scheme: `request.url.scheme` (http, https, ws, wss)
  * Get netloc: `request.url.netloc`, e.g.: example.com:8080
  * Get path: `request.url.path`, e.g.: /search
  * Get query string: `request.url.query`, e.g.: kw=hello
  * Get hostname: `request.url.hostname`, e.g.: example.com
  * Get port: `request.url.port`, e.g.: 8080
  * If using secure scheme: `request.url.is_secure`, True is schme is `https` or `wss`

### Headers: `request.headers`

```
{
    'host': 'example.com:8080', 
    'connection': 'keep-alive', 
    'cache-control': 'max-age=0', 
    'sec-ch-ua': 'Google Chrome 80', 
    'dnt': '1', 
    'upgrade-insecure-requests': '1', 
    'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) ...',
    'sec-fetch-dest': 'document', 
    'accept': 'text/html,image/apng,*/*;q=0.8;v=b3;q=0.9', 
    'sec-origin-policy': '0', 
    'sec-fetch-site': 'none', 
    'sec-fetch-mode': 'navigate', 
    'sec-fetch-user': '?1', 
    'accept-encoding': 'gzip, deflate, br', 
    'accept-language': 'en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7,zh-TW;q=0.6', 
    'cookie': 'session=eyJhZG1pbl91c2_KiQ...'
}

```

### Client: `request.client`

  * `request.client.host`: get client sock IP
  * `request.client.port`: get client sock port

### Method: `request.method`

  * `request.method`: GET, POST, etc.

### Get Data

  * `await request.body()`: get raw data from body
  * `await request.json()`: get passed data and parse it as JSON
  * `await request.form()`: get posted data and pass it as dictionary

### Scope: `request.scope`

```
{
    'type': 'http', 
    'http_version': '1.1', 
    'server': ('127.0.0.1', 9092), 
    'client': ('127.0.0.1', 53102), 
    'scheme': 'https', 
    'method': 'GET', 
    'root_path': '', 
    'path': '/', 
    'raw_path': b'/', 
    'query_string': b'kw=hello', 
    'headers': [
        (b'host', b'example.com:8080'), 
        (b'connection', b'keep-alive'), 
        (b'cache-control', b'max-age=0'), 
        ...
    ], 
    'app': <starlette.applications.Starlette object at 0x1081bd650>, 
    'session': {'uid': '57ba03ea7333f72a25f837cf'}, 
    'router': <starlette.routing.Router object at 0x1081bd6d0>, 
    'endpoint': <class 'app.index.Index'>, 
    'path_params': {}
}

```

## Put varaible in request & app scope

```
app.state.dbconn = get_db_conn()
request.state.start_time = time.time()
# use app-scope state variable in a request
request.app.state.dbconn

```

## Utility functions

### Use `State` to wrap a dictionary

```
from starlette.datastructures import State

data = {
    "name": "Bo"
}
print(data["name"])
# now wrap it with State function
wrapped = State(data)
# You can use the dot syntaxt, but can't use `wrapped["name"]` any more.
print(wrapped.name)

```

### login_required wrapper function

NB: This is easier to do in FastHTML using Beforeware.

```
import functools
from starlette.endpoints import HTTPEndpoint
from starlette.responses import Response

def login_required(login_url="/signin"):
    def decorator(handler):
        @functools.wraps(handler)
        async def new_handler(obj, req, *args, **kwargs):
            user = req.session.get("login_user")
            if user is None:
                return seeother(login_url)
            return await handler(obj, req, *args, **kwargs)
        return new_handler
    return decorator

class MyAccount(HTTPEndpiont):
    @login_required()
    async def get(self, request):
        # some logic here
        content = "hello"
        return Response(content)

```

## Exceptions

Handle exception and customize 403, 404, 503, 500 page:

```
from starlette.exceptions import HTTPException

async def exc_handle_403(request, exc):
    return HTMLResponse("My 403 page", status_code=exc.status_code)

async def exc_handle_404(request, exc):
    return HTMLResponse("My 404 page", status_code=exc.status_code)

async def exc_handle_503(request, exc):
    return HTMLResponse("Failed, please try it later", status_code=exc.status_code)

# error is not exception, 500 is server side unexpected error, all other status code will be treated as Exception
async def err_handle_500(request, exc):
    import traceback
    Log.error(traceback.format_exc())
    return HTMLResponse("My 500 page", status_code=500)

# To add handler, we can add either status_code or Exception itself as key
exception_handlers = {
    403: exc_handle_403,
    404: exc_handle_404,
    503: exc_handle_503,
    500: err_handle_500,
    #HTTPException: exc_handle_500,
}

app = Starlette(routes=routes, exception_handlers=exception_handlers)

```

## Background Task

### Put some async task as background task

```
import aiofiles
from starlette.background import BackgroundTask
from starlette.responses import Response

aiofiles_remove = aiofiles.os.wrap(os.remove)

async def del_file(fpath):
    await aiofiles_remove(fpath)

async def handler(request):
    content = ""
    fpath = "/tmp/tmpfile.txt"
    task = BackgroundTask(del_file, fpath=fpath)
    return Response(content, background=task)

```

### Put multiple tasks as background task

```
from starlette.background import BackgroundTasks

async def task1(name):
    pass

async def task2(email):
    pass

async def handler(request):
    tasks = BackgroundTasks()
    tasks.add_task(task1, name="John")
    tasks.add_task(task2, email="info@example.com")
    content = ""
    return Response(content, background=tasks)

```

## Write middleware

There are 2 ways to write middleware:

### Define `__call__` function:

```
class MyMiddleware:
    def __init__(self, app):
        self.app = app

    async def __call__(self, scope, receive, send):
        # see above scope dictionary as reference
        headers = dict(scope["headers"])
        # do something
        # pass to next middleware
        return await self.app(scope, receive, send)

```

### Use `BaseHTTPMiddleware`

```
from starlette.middleware.base import BaseHTTPMiddleware

class CustomHeaderMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request, call_next):
        # do something before pass to next middleware
        response = await call_next(request)
        # do something after next middleware returned
        response.headers['X-Author'] = 'John'
        return response

```</doc></docs><api><doc title="API List" desc="A succint list of all functions and methods in fasthtml."># fasthtml Module Documentation
```
## fasthtml.authmw

- `class BasicAuthMiddleware`
    - `def __init__(self, app, cb, skip)`
    - `def __call__(self, scope, receive, send)`
    - `def authenticate(self, conn)`

## fasthtml.cli

- `@call_parse def railway_link()`
    Link the current directory to the current project's Railway service

- `@call_parse def railway_deploy(name, mount)`
    Deploy a FastHTML app to Railway

## fasthtml.components

> `ft_html` and `ft_hx` functions to add some conveniences to `ft`, along with a full set of basic HTML components, and functions to work with forms and `FT` conversion

- `def File(fname)`
    Use the unescaped text in file `fname` directly

- `def show(ft, *rest)`
    Renders FT Components into HTML within a Jupyter notebook.

- `def fill_form(form, obj)`
    Fills named items in `form` using attributes in `obj`

- `def fill_dataclass(src, dest)`
    Modifies dataclass in-place and returns it

- `def find_inputs(e, tags, **kw)`
    Recursively find all elements in `e` with `tags` and attrs matching `kw`

- `def html2ft(html, attr1st)`
    Convert HTML to an `ft` expression

- `def sse_message(elm, event)`
    Convert element `elm` into a format suitable for SSE streaming

## fasthtml.core

> The `FastHTML` subclass of `Starlette`, along with the `RouterX` and `RouteX` classes it automatically uses.

- `def parsed_date(s)`
    Convert `s` to a datetime

- `def snake2hyphens(s)`
    Convert `s` from snake case to hyphenated and capitalised

- `@dataclass class HtmxHeaders`
    - `def __bool__(self)`
    - `def __init__(self, boosted, current_url, history_restore_request, prompt, request, target, trigger_name, trigger)`

- `@dataclass class HttpHeader`
    - `def __init__(self, k, v)`

- `@use_kwargs_dict(**htmx_resps) def HtmxResponseHeaders(**kwargs)`
    HTMX response headers

- `def form2dict(form)`
    Convert starlette form data to a dict

- `def parse_form(req)`
    Starlette errors on empty multipart forms, so this checks for that situation

- `class JSONResponse`
    Same as starlette's version, but auto-stringifies non serializable types

    - `def render(self, content)`

- `def flat_xt(lst)`
    Flatten lists

- `class Beforeware`
    - `def __init__(self, f, skip)`

- `def EventStream(s)`
    Create a text/event-stream response from `s`

- `def flat_tuple(o)`
    Flatten lists

- `def noop_body(c, req)`
    Default Body wrap function which just returns the content

- `def respond(req, heads, bdy)`
    Default FT response creation function

- `class Redirect`
    Use HTMX or Starlette RedirectResponse as required to redirect to `loc`

    - `def __init__(self, loc)`
    - `def __response__(self, req)`

- `def qp(p, **kw)`
    Add parameters kw to path p

- `def def_hdrs(htmx, surreal)`
    Default headers for a FastHTML app

- `class FastHTML`
    - `def __init__(self, debug, routes, middleware, title, exception_handlers, on_startup, on_shutdown, lifespan, hdrs, ftrs, exts, before, after, surreal, htmx, default_hdrs, sess_cls, secret_key, session_cookie, max_age, sess_path, same_site, sess_https_only, sess_domain, key_fname, body_wrap, htmlkw, nb_hdrs, canonical, **bodykw)`

- `@patch def ws(self, path, conn, disconn, name, middleware)`
    Add a websocket route at `path`

- `def nested_name(f)`
    Get name of function `f` using '_' to join nested function names

- `@patch def route(self, path, methods, name, include_in_schema, body_wrap)`
    Add a route at `path`

- `def serve(appname, app, host, port, reload, reload_includes, reload_excludes)`
    Run the app in an async server, with live reload set as the default.

- `class Client`
    A simple httpx ASGI client that doesn't require `async`

    - `def __init__(self, app, url)`

- `class RouteFuncs`
    - `def __init__(self)`
    - `def __setattr__(self, name, value)`
    - `def __getattr__(self, name)`
    - `def __dir__(self)`

- `class APIRouter`
    Add routes to an app

    - `def __init__(self, prefix, body_wrap)`
    - `def __call__(self, path, methods, name, include_in_schema, body_wrap)`
        Add a route at `path`

    - `def __getattr__(self, name)`
    - `def to_app(self, app)`
        Add routes to `app`

    - `def ws(self, path, conn, disconn, name, middleware)`
        Add a websocket route at `path`


- `def cookie(key, value, max_age, expires, path, domain, secure, httponly, samesite)`
    Create a 'set-cookie' `HttpHeader`

- `@patch def static_route_exts(self, prefix, static_path, exts)`
    Add a static route at URL path `prefix` with files from `static_path` and `exts` defined by `reg_re_param()`

- `@patch def static_route(self, ext, prefix, static_path)`
    Add a static route at URL path `prefix` with files from `static_path` and single `ext` (including the '.')

- `class MiddlewareBase`
    - `def __call__(self, scope, receive, send)`

- `class FtResponse`
    Wrap an FT response with any Starlette `Response`

    - `def __init__(self, content, status_code, headers, cls, media_type, background)`
    - `def __response__(self, req)`

## fasthtml.fastapp

> The `fast_app` convenience wrapper

- `def fast_app(db_file, render, hdrs, ftrs, tbls, before, middleware, live, debug, title, routes, exception_handlers, on_startup, on_shutdown, lifespan, default_hdrs, pico, surreal, htmx, exts, canonical, secret_key, key_fname, session_cookie, max_age, sess_path, same_site, sess_https_only, sess_domain, htmlkw, bodykw, reload_attempts, reload_interval, static_path, body_wrap, nb_hdrs, **kwargs)`
    Create a FastHTML or FastHTMLWithLiveReload app.

## fasthtml.js

> Basic external Javascript lib wrappers

- `def light_media(css)`
    Render light media for day mode views

- `def dark_media(css)`
    Render dark media for night mode views

- `def MarkdownJS(sel)`
    Implements browser-based markdown rendering.

- `def HighlightJS(sel, langs, light, dark)`
    Implements browser-based syntax highlighting. Usage example [here](/tutorials/quickstart_for_web_devs.html#code-highlighting).

- `def MermaidJS(sel, theme)`
    Implements browser-based Mermaid diagram rendering.

## fasthtml.jupyter

> Use FastHTML in Jupyter notebooks

- `def nb_serve(app, log_level, port, host, **kwargs)`
    Start a Jupyter compatible uvicorn server with ASGI `app` on `port` with `log_level`

- `def nb_serve_async(app, log_level, port, host, **kwargs)`
    Async version of `nb_serve`

- `def is_port_free(port, host)`
    Check if `port` is free on `host`

- `def wait_port_free(port, host, max_wait)`
    Wait for `port` to be free on `host`

- `class JupyUvi`
    Start and stop a Jupyter compatible uvicorn server with ASGI `app` on `port` with `log_level`

    - `def __init__(self, app, log_level, host, port, start, **kwargs)`
    - `def start(self)`
    - `def start_async(self)`
    - `def stop(self)`

- `class JupyUviAsync`
    Start and stop an async Jupyter compatible uvicorn server with ASGI `app` on `port` with `log_level`

    - `def __init__(self, app, log_level, host, port, **kwargs)`
    - `def start(self)`
    - `def stop(self)`

- `def HTMX(path, host, app, port, height, link, iframe)`
    An iframe which displays the HTMX application in a notebook.

## fasthtml.live_reload

- `class FastHTMLWithLiveReload`
    `FastHTMLWithLiveReload` enables live reloading.
    This means that any code changes saved on the server will automatically
    trigger a reload of both the server and browser window.

    How does it work?
      - a websocket is created at `/live-reload`
      - a small js snippet `LIVE_RELOAD_SCRIPT` is injected into each webpage
      - this snippet connects to the websocket at `/live-reload` and listens for an `onclose` event
      - when the `onclose` event is detected the browser is reloaded

    Why do we listen for an `onclose` event?
      When code changes are saved the server automatically reloads if the --reload flag is set.
      The server reload kills the websocket connection. The `onclose` event serves as a proxy
      for "developer has saved some changes".

    Usage
        >>> from fasthtml.common import *
        >>> app = FastHTMLWithLiveReload()

        Run:
            serve()

    - `def __init__(self, *args, **kwargs)`

## fasthtml.oauth

> Basic scaffolding for handling OAuth

- `class GoogleAppClient`
    A `WebApplicationClient` for Google oauth2

    - `def __init__(self, client_id, client_secret, code, scope, project_id, **kwargs)`
    - `@classmethod def from_file(cls, fname, code, scope, **kwargs)`

- `class GitHubAppClient`
    A `WebApplicationClient` for GitHub oauth2

    - `def __init__(self, client_id, client_secret, code, scope, **kwargs)`

- `class HuggingFaceClient`
    A `WebApplicationClient` for HuggingFace oauth2

    - `def __init__(self, client_id, client_secret, code, scope, state, **kwargs)`

- `class DiscordAppClient`
    A `WebApplicationClient` for Discord oauth2

    - `def __init__(self, client_id, client_secret, is_user, perms, scope, **kwargs)`
    - `def login_link(self, redirect_uri, scope, state)`
    - `def parse_response(self, code, redirect_uri)`

- `class Auth0AppClient`
    A `WebApplicationClient` for Auth0 OAuth2

    - `def __init__(self, domain, client_id, client_secret, code, scope, redirect_uri, **kwargs)`
    - `def login_link(self, req)`

- `@patch def login_link(self, redirect_uri, scope, state, **kwargs)`
    Get a login link for this client

- `def redir_url(request, redir_path, scheme)`
    Get the redir url for the host in `request`

- `@patch def parse_response(self, code, redirect_uri)`
    Get the token from the oauth2 server response

- `@patch def get_info(self, token)`
    Get the info for authenticated user

- `@patch def retr_info(self, code, redirect_uri)`
    Combines `parse_response` and `get_info`

- `@patch def retr_id(self, code, redirect_uri)`
    Call `retr_info` and then return id/subscriber value

- `class OAuth`
    - `def __init__(self, app, cli, skip, redir_path, error_path, logout_path, login_path, https, http_patterns)`
    - `def redir_login(self, session)`
    - `def redir_url(self, req)`
    - `def login_link(self, req, scope, state)`
    - `def check_invalid(self, req, session, auth)`
    - `def logout(self, session)`
    - `def get_auth(self, info, ident, session, state)`

- `@patch() def consent_url(self, proj)`
    Get Google OAuth consent screen URL

- `@patch def save(self, fname)`
    Save credentials to `fname`

- `def load_creds(fname)`
    Load credentials from `fname`

- `@patch def creds(self)`
    Create `Credentials` from the client, refreshing if needed

## fasthtml.pico

> Basic components for generating Pico CSS tags

- `@delegates(ft_hx, keep=True) def Card(*c, **kwargs)`
    A PicoCSS Card, implemented as an Article with optional Header and Footer

- `@delegates(ft_hx, keep=True) def Group(*c, **kwargs)`
    A PicoCSS Group, implemented as a Fieldset with role 'group'

- `@delegates(ft_hx, keep=True) def Search(*c, **kwargs)`
    A PicoCSS Search, implemented as a Form with role 'search'

- `@delegates(ft_hx, keep=True) def Grid(*c, **kwargs)`
    A PicoCSS Grid, implemented as child Divs in a Div with class 'grid'

- `@delegates(ft_hx, keep=True) def DialogX(*c, **kwargs)`
    A PicoCSS Dialog, with children inside a Card

- `@delegates(ft_hx, keep=True) def Container(*args, **kwargs)`
    A PicoCSS Container, implemented as a Main with class 'container'

## fasthtml.stripe_otp

- `def create_price(app_nm, amt, currency)`
    Create a product and bind it to a price object. If product already exist just return the price list.

- `def archive_price(app_nm)`
    Archive a price - useful for cleanup if testing.

- `class Payment`

## fasthtml.svg

> Simple SVG FT elements

- `def Svg(*args, **kwargs)`
    An SVG tag; xmlns is added automatically, and viewBox defaults to height and width if not provided

- `@delegates(ft_hx) def ft_svg(tag, *c, **kwargs)`
    Create a standard `FT` element with some SVG-specific attrs

- `@delegates(ft_svg) def Rect(width, height, x, y, fill, stroke, stroke_width, rx, ry, **kwargs)`
    A standard SVG `rect` element

- `@delegates(ft_svg) def Circle(r, cx, cy, fill, stroke, stroke_width, **kwargs)`
    A standard SVG `circle` element

- `@delegates(ft_svg) def Ellipse(rx, ry, cx, cy, fill, stroke, stroke_width, **kwargs)`
    A standard SVG `ellipse` element

- `def transformd(translate, scale, rotate, skewX, skewY, matrix)`
    Create an SVG `transform` kwarg dict

- `@delegates(ft_svg) def Line(x1, y1, x2, y2, stroke, w, stroke_width, **kwargs)`
    A standard SVG `line` element

- `@delegates(ft_svg) def Polyline(*args, **kwargs)`
    A standard SVG `polyline` element

- `@delegates(ft_svg) def Polygon(*args, **kwargs)`
    A standard SVG `polygon` element

- `@delegates(ft_svg) def Text(*args, **kwargs)`
    A standard SVG `text` element

- `class PathFT`
    - `def M(self, x, y)`
        Move to.

    - `def L(self, x, y)`
        Line to.

    - `def H(self, x)`
        Horizontal line to.

    - `def V(self, y)`
        Vertical line to.

    - `def Z(self)`
        Close path.

    - `def C(self, x1, y1, x2, y2, x, y)`
        Cubic Bézier curve.

    - `def S(self, x2, y2, x, y)`
        Smooth cubic Bézier curve.

    - `def Q(self, x1, y1, x, y)`
        Quadratic Bézier curve.

    - `def T(self, x, y)`
        Smooth quadratic Bézier curve.

    - `def A(self, rx, ry, x_axis_rotation, large_arc_flag, sweep_flag, x, y)`
        Elliptical Arc.


- `def SvgOob(*args, **kwargs)`
    Wraps an SVG shape as required for an HTMX OOB swap

- `def SvgInb(*args, **kwargs)`
    Wraps an SVG shape as required for an HTMX inband swap

## fasthtml.xtend

> Simple extensions to standard HTML components, such as adding sensible defaults

- `@delegates(ft_hx, keep=True) def A(*c, **kwargs)`
    An A tag; `href` defaults to '#' for more concise use with HTMX

- `@delegates(ft_hx, keep=True) def AX(txt, hx_get, target_id, hx_swap, href, **kwargs)`
    An A tag with just one text child, allowing hx_get, target_id, and hx_swap to be positional params

- `@delegates(ft_hx, keep=True) def Form(*c, **kwargs)`
    A Form tag; identical to plain `ft_hx` version except default `enctype='multipart/form-data'`

- `@delegates(ft_hx, keep=True) def Hidden(value, id, **kwargs)`
    An Input of type 'hidden'

- `@delegates(ft_hx, keep=True) def CheckboxX(checked, label, value, id, name, **kwargs)`
    A Checkbox optionally inside a Label, preceded by a `Hidden` with matching name

- `@delegates(ft_html, keep=True) def Script(code, **kwargs)`
    A Script tag that doesn't escape its code

- `@delegates(ft_html, keep=True) def Style(*c, **kwargs)`
    A Style tag that doesn't escape its code

- `def double_braces(s)`
    Convert single braces to double braces if next to special chars or newline

- `def undouble_braces(s)`
    Convert double braces to single braces if next to special chars or newline

- `def loose_format(s, **kw)`
    String format `s` using `kw`, without being strict about braces outside of template params

- `def ScriptX(fname, src, nomodule, type, _async, defer, charset, crossorigin, integrity, **kw)`
    A `script` element with contents read from `fname`

- `def replace_css_vars(css, pre, **kwargs)`
    Replace `var(--)` CSS variables with `kwargs` if name prefix matches `pre`

- `def StyleX(fname, **kw)`
    A `style` element with contents read from `fname` and variables replaced from `kw`

- `def Nbsp()`
    A non-breaking space

- `def Surreal(code)`
    Wrap `code` in `domReadyExecute` and set `m=me()` and `p=me('-')`

- `def On(code, event, sel, me)`
    An async surreal.js script block event handler for `event` on selector `sel,p`, making available parent `p`, event `ev`, and target `e`

- `def Prev(code, event)`
    An async surreal.js script block event handler for `event` on previous sibling, with same vars as `On`

- `def Now(code, sel)`
    An async surreal.js script block on selector `me(sel)`

- `def AnyNow(sel, code)`
    An async surreal.js script block on selector `any(sel)`

- `def run_js(js, id, **kw)`
    Run `js` script, auto-generating `id` based on name of caller if needed, and js-escaping any `kw` params

- `def jsd(org, repo, root, path, prov, typ, ver, esm, **kwargs)`
    jsdelivr `Script` or CSS `Link` tag, or URL

- `class Fragment`
    An empty tag, used as a container

    - `def __init__(self, *c)`

- `@delegates(ft_hx, keep=True) def Titled(title, *args, **kwargs)`
    An HTML partial containing a `Title`, and `H1`, and any provided children

- `def Socials(title, site_name, description, image, url, w, h, twitter_site, creator, card)`
    OG and Twitter social card headers

- `def YouTubeEmbed(video_id, **kwargs)`
    Embed a YouTube video

- `def Favicon(light_icon, dark_icon)`
    Light and dark favicon headers
</doc><doc title="MonsterUI API List" desc="Complete API Reference for Monster UI, a component framework similar to shadcn, but for FastHTML"># monsterui Module Documentation

## monsterui.core

- `class ThemeRadii(Enum)`
    Members: none, sm, md, lg


- `class ThemeShadows`

- `class ThemeFont`

- `class Theme(Enum)`
    Selector to choose theme and get all headers needed for app.  Includes frankenui + tailwind + daisyui + highlight.js options
    Members: slate, stone, gray, neutral, red, rose, orange, green, blue, yellow, violet, zinc

    - `headers(self, mode, icons, daisy, highlightjs, katex, apex_charts, radii, shadows, font)`
        Create frankenui and tailwind cdns

    - `local_headers(self, mode, static_dir, icons, daisy, highlightjs, katex, apex_charts, radii, shadows, font)`
        Create headers using local files downloaded from CDNs


## monsterui.daisy

- `class AlertT(Enum)`
    Alert styles from DaisyUI
    Members: info, success, warning, error


- `def Alert(*c, **kwargs)`
    Alert informs users about important events.

- `class StepsT(Enum)`
    Options for Steps
    Members: vertical, horizonal


- `class StepT(Enum)`
    Step styles for LiStep
    Members: primary, secondary, accent, info, success, warning, error, neutral


- `def Steps(*li, **kwargs)`
    Creates a steps container

- `def LiStep(*c, **kwargs)`
    Creates a step list item

- `class LoadingT(Enum)`
    Members: spinner, dots, ring, ball, bars, infinity, xs, sm, md, lg


- `def Loading(cls, htmx_indicator, **kwargs)`
    Creates a loading animation component

- `class ToastHT(Enum)`
    Horizontal position for Toast
    Members: start, center, end


- `class ToastVT(Enum)`
    Vertical position for Toast
    Members: top, middle, bottom


## monsterui.foundations

> Data Structures and Utilties

- `def stringify(o)`
    Converts input types into strings that can be passed to FT components

- `class VEnum(Enum)`
    Members: 

    - `__str__(self)`
    - `__add__(self, other)`
    - `__radd__(self, other)`

## monsterui.franken

- `class TextT(Enum)`
    Text Styles from https://franken-ui.dev/docs/text
    Members: paragraph, lead, meta, gray, italic, xs, sm, lg, xl, light, normal, medium, bold, extrabold, muted, primary, secondary, success, warning, error, info, left, right, center, justify, start, end, top, middle, bottom, truncate, break_, nowrap, underline, highlight


- `class TextPresets(Enum)`
    Common Typography Presets
    Members: muted_sm, muted_lg, bold_sm, bold_lg, md_weight_sm, md_weight_muted


- `def CodeSpan(*c, **kwargs)`
    A CodeSpan with Styling

- `def CodeBlock(*c, **kwargs)`
    CodeBlock with Styling

- `def H1(*c, **kwargs)`
    H1 with styling and appropriate size

- `def H2(*c, **kwargs)`
    H2 with styling and appropriate size

- `def H3(*c, **kwargs)`
    H3 with styling and appropriate size

- `def H4(*c, **kwargs)`
    H4 with styling and appropriate size

- `def H5(*c, **kwargs)`
    H5 with styling and appropriate size

- `def H6(*c, **kwargs)`
    H6 with styling and appropriate size

- `def Subtitle(*c, **kwargs)`
    Styled muted_sm text designed to go under Headings and Titles

- `def Q(*c, **kwargs)`
    Styled quotation mark

- `def Em(*c, **kwargs)`
    Styled emphasis text

- `def Strong(*c, **kwargs)`
    Styled strong text

- `def I(*c, **kwargs)`
    Styled italic text

- `def Small(*c, **kwargs)`
    Styled small text

- `def Mark(*c, **kwargs)`
    Styled highlighted text

- `def Del(*c, **kwargs)`
    Styled deleted text

- `def Ins(*c, **kwargs)`
    Styled inserted text

- `def Sub(*c, **kwargs)`
    Styled subscript text

- `def Sup(*c, **kwargs)`
    Styled superscript text

- `def Blockquote(*c, **kwargs)`
    Blockquote with Styling

- `def Caption(*c, **kwargs)`
    Styled caption text

- `def Cite(*c, **kwargs)`
    Styled citation text

- `def Time(*c, **kwargs)`
    Styled time element

- `def Address(*c, **kwargs)`
    Styled address element

- `def Abbr(*c, **kwargs)`
    Styled abbreviation with dotted underline

- `def Dfn(*c, **kwargs)`
    Styled definition term with italic and medium weight

- `def Kbd(*c, **kwargs)`
    Styled keyboard input with subtle background

- `def Samp(*c, **kwargs)`
    Styled sample output with subtle background

- `def Var(*c, **kwargs)`
    Styled variable with italic monospace

- `def Figure(*c, **kwargs)`
    Styled figure container with card-like appearance

- `def Details(*c, **kwargs)`
    Styled details element

- `def Summary(*c, **kwargs)`
    Styled summary element

- `def Data(*c, **kwargs)`
    Styled data element

- `def Meter(*c, **kwargs)`
    Styled meter element

- `def S(*c, **kwargs)`
    Styled strikethrough text (different semantic meaning from Del)

- `def U(*c, **kwargs)`
    Styled underline (for proper names in Chinese, proper spelling etc)

- `def Output(*c, **kwargs)`
    Styled output element for form results

- `def PicSumImg(h, w, id, grayscale, blur, **kwargs)`
    Creates a placeholder image using https://picsum.photos/

- `def AccordionItem(title, *c)`
    Creates a single item for use within an Accordion component, handling title, content, and open state.

- `def Accordion(*c, **kwargs)`
    Creates a styled Accordion container using accordion component.

- `class ButtonT(Enum)`
    Options for styling Buttons
    Members: default, ghost, primary, secondary, destructive, text, link, xs, sm, lg, xl, icon


- `def Button(*c, **kwargs)`
    Button with Styling (defaults to `submit` for form submission)

- `class ContainerT(Enum)`
    Max width container sizes from https://franken-ui.dev/docs/container
    Members: xs, sm, lg, xl, expand


- `class BackgroundT(Enum)`
    Members: muted, primary, secondary, default


- `def Container(*c, **kwargs)`
    Div to be used as a container that often wraps large sections or a page of content

- `def Titled(title, *c, **kwargs)`
    Creates a standard page structure for titled page.  Main(Container(title, content))

- `class DividerT(Enum)`
    Divider Styles from https://franken-ui.dev/docs/divider
    Members: icon, sm, vertical


- `def Divider(*c, **kwargs)`
    Divider with default styling and margin

- `def DividerSplit(*c)`
    Creates a simple horizontal line divider with configurable thickness and vertical spacing

- `def Article(*c, **kwargs)`
    A styled article container for blog posts or similar content

- `def ArticleTitle(*c, **kwargs)`
    A title component for use within an Article

- `def ArticleMeta(*c, **kwargs)`
    A metadata component for use within an Article showing things like date, author etc

- `class SectionT(Enum)`
    Section styles from https://franken-ui.dev/docs/section
    Members: default, muted, primary, secondary, xs, sm, lg, xl, remove_vertical


- `def Section(*c, **kwargs)`
    Section with styling and margins

- `def Form(*c, **kwargs)`
    A Form with default spacing between form elements

- `def Fieldset(*c, **kwargs)`
    A Fieldset with default styling

- `def Legend(*c, **kwargs)`
    A Legend with default styling

- `def Input(*c, **kwargs)`
    An Input with default styling

- `def Radio(*c, **kwargs)`
    A Radio with default styling

- `def CheckboxX(*c, **kwargs)`
    A Checkbox with default styling

- `def Range(*c, **kwargs)`
    A Range with default styling

- `def TextArea(*c, **kwargs)`
    A Textarea with default styling

- `def Switch(*c, **kwargs)`
    A Switch with default styling

- `def Upload(*c, **kwargs)`
    A file upload component with default styling

- `def UploadZone(*c, **kwargs)`
    A file drop zone component with default styling

- `def FormLabel(*c, **kwargs)`
    A Label with default styling

- `class LabelT(Enum)`
    Members: primary, secondary, destructive


- `def Label(*c, **kwargs)`
    FrankenUI labels, which look like pills

- `def UkFormSection(title, description, *c)`
    A form section with a title, description and optional button

- `def GenericLabelInput(label, lbl_cls, input_cls, container, cls, id, input_fn, **kwargs)`
    `Div(Label,Input)` component with Uk styling injected appropriately. Generally you should higher level API, such as `LabelInput` which is created for you in this library

- `def LabelInput(label, lbl_cls, input_cls, cls, id, **kwargs)`
    A `FormLabel` and `Input` pair that provides default spacing and links/names them based on id

- `def LabelRadio(label, lbl_cls, input_cls, container, cls, id, **kwargs)`
    A FormLabel and Radio pair that provides default spacing and links/names them based on id

- `def LabelCheckboxX(label, lbl_cls, input_cls, container, cls, id, **kwargs)`
    A FormLabel and CheckboxX pair that provides default spacing and links/names them based on id

- `def Options(*c)`
    Helper function to wrap things into `Option`s for use in `Select`

- `def Select(*option, **kwargs)`
    Creates a select dropdown with uk styling and option for adding a search box

- `def LabelSelect(*option, **kwargs)`
    A FormLabel and Select pair that provides default spacing and links/names them based on id

- `@delegates(GenericLabelInput, but=['input_fn', 'cls']) def LabelRange(label, lbl_cls, input_cls, cls, id, value, min, max, step, label_range, **kwargs)`
    A FormLabel and Range pair that provides default spacing and links/names them based on id

- `class AT(Enum)`
    Link styles from https://franken-ui.dev/docs/link
    Members: muted, text, reset, primary, classic


- `class ListT(Enum)`
    List styles using Tailwind CSS
    Members: disc, circle, square, decimal, hyphen, bullet, divider, striped


- `def ModalContainer(*c, **kwargs)`
    Creates a modal container that components go in

- `def ModalDialog(*c, **kwargs)`
    Creates a modal dialog

- `def ModalHeader(*c, **kwargs)`
    Creates a modal header

- `def ModalBody(*c, **kwargs)`
    Creates a modal body

- `def ModalFooter(*c, **kwargs)`
    Creates a modal footer

- `def ModalTitle(*c, **kwargs)`
    Creates a modal title

- `def ModalCloseButton(*c, **kwargs)`
    Creates a button that closes a modal with js

- `def Modal(*c, **kwargs)`
    Creates a modal with the appropriate classes to put the boilerplate in the appropriate places for you

- `def Placeholder(*c, **kwargs)`
    Creates a placeholder

- `def Progress(*c, **kwargs)`
    Creates a progress bar

- `def UkIcon(icon, height, width, stroke_width, cls, **kwargs)`
    Creates an icon using lucide icons

- `def UkIconLink(icon, height, width, stroke_width, cls, button, **kwargs)`
    Creates an icon link using lucide icons

- `def DiceBearAvatar(seed_name, h, w)`
    Creates an Avatar using https://dicebear.com/

- `def Center(*c, **kwargs)`
    Centers contents both vertically and horizontally by default

- `class FlexT(Enum)`
    Flexbox modifiers using Tailwind CSS
    Members: block, inline, left, center, right, between, around, stretch, top, middle, bottom, row, row_reverse, column, column_reverse, nowrap, wrap, wrap_reverse


- `def Grid(*div, **kwargs)`
    Creates a responsive grid layout with smart defaults based on content

- `def DivFullySpaced(*c, **kwargs)`
    Creates a flex div with it's components having as much space between them as possible

- `def DivCentered(*c, **kwargs)`
    Creates a flex div with it's components centered in it

- `def DivLAligned(*c, **kwargs)`
    Creates a flex div with it's components aligned to the left

- `def DivRAligned(*c, **kwargs)`
    Creates a flex div with it's components aligned to the right

- `def DivVStacked(*c, **kwargs)`
    Creates a flex div with it's components stacked vertically

- `def DivHStacked(*c, **kwargs)`
    Creates a flex div with it's components stacked horizontally

- `class NavT(Enum)`
    Members: default, primary, secondary


- `def NavContainer(*li, **kwargs)`
    Creates a navigation container (useful for creating a sidebar navigation).  A Nav is a list (NavBar is something different)

- `def NavParentLi(*nav_container, **kwargs)`
    Creates a navigation list item with a parent nav for nesting

- `def NavDividerLi(*c, **kwargs)`
    Creates a navigation list item with a divider

- `def NavHeaderLi(*c, **kwargs)`
    Creates a navigation list item with a header

- `def NavSubtitle(*c, **kwargs)`
    Creates a navigation subtitle

- `def NavCloseLi(*c, **kwargs)`
    Creates a navigation list item with a close button

- `class ScrollspyT(Enum)`
    Members: underline, bold


- `def NavBar(*c)`
    Creates a responsive navigation bar with mobile menu support

- `def SliderContainer(*c, **kwargs)`
    Creates a slider container

- `def SliderItems(*c, **kwargs)`
    Creates a slider items container

- `def SliderNav(cls, prev_cls, next_cls, **kwargs)`
    Navigation arrows for Slider component

- `def Slider(*c, **kwargs)`
    Creates a slider with optional navigation arrows

- `def DropDownNavContainer(*li, **kwargs)`
    A Nav that is part of a DropDown

- `def TabContainer(*li, **kwargs)`
    A TabContainer where children will be different tabs

- `class CardT(Enum)`
    Card styles from UIkit
    Members: default, primary, secondary, destructive, hover


- `def CardTitle(*c, **kwargs)`
    Creates a card title

- `def CardHeader(*c, **kwargs)`
    Creates a card header

- `def CardBody(*c, **kwargs)`
    Creates a card body

- `def CardFooter(*c, **kwargs)`
    Creates a card footer

- `def CardContainer(*c, **kwargs)`
    Creates a card container

- `def Card(*c, **kwargs)`
    Creates a Card with a header, body, and footer

- `class TableT(Enum)`
    Members: divider, striped, hover, sm, lg, justify, middle, responsive


- `def Table(*c, **kwargs)`
    Creates a table

- `def TableFromLists(header_data, body_data, footer_data, header_cell_render, body_cell_render, footer_cell_render, cls, sortable, **kwargs)`
    Creates a Table from a list of header data and a list of lists of body data

- `def TableFromDicts(header_data, body_data, footer_data, header_cell_render, body_cell_render, footer_cell_render, cls, sortable, **kwargs)`
    Creates a Table from a list of header data and a list of dicts of body data

- `def apply_classes(html_str, class_map, class_map_mods)`
    Apply classes to html string

- `def render_md(md_content, class_map, class_map_mods)`
    Renders markdown using mistletoe and lxml

- `def get_franken_renderer(img_dir)`
    Create a renderer class with the specified img_dir

- `def ThemePicker(color, radii, shadows, font, mode, cls, custom_themes)`
    Theme picker component with configurable sections

- `def LightboxContainer(*lightboxitem, **kwargs)`
    Lightbox container that will hold `LightboxItems`

- `def LightboxItem(*c, **kwargs)`
    Anchor tag with appropriate structure to go inside a `LightBoxContainer`

- `def ApexChart(**kws)`
    Apex chart component
</doc></api><examples><doc title="Websockets application" desc="Very brief example of using websockets with HTMX and FastHTML">from asyncio import sleep
from fasthtml.common import *

app = FastHTML(exts='ws')
rt = app.route

def mk_inp(): return Input(id='msg')
nid = 'notifications'

@rt('/')
async def get():
    cts = Div(
        Div(id=nid),
        Form(mk_inp(), id='form', ws_send=True),
        hx_ext='ws', ws_connect='/ws')
    return Titled('Websocket Test', cts)

async def on_connect(send): await send(Div('Hello, you have connected', id=nid))
async def on_disconnect( ): print('Disconnected!')

@app.ws('/ws', conn=on_connect, disconn=on_disconnect)
async def ws(msg:str, send):
    await send(Div('Hello ' + msg, id=nid))
    await sleep(2)
    return Div('Goodbye ' + msg, id=nid), mk_inp()

serve()
</doc><doc title="Todo list application" desc="Detailed walk-thru of a complete CRUD app in FastHTML showing idiomatic use of FastHTML and HTMX patterns.">### Walkthrough of an idiomatic fasthtml app ###

# This fasthtml app includes functionality from fastcore, starlette, fastlite, and fasthtml itself.
# Run with: `python adv_app.py`
# Importing from `fasthtml.common` brings the key parts of all of these together. We recommend using a wildcard import since only necessary parts are exported by the module.
from fasthtml.common import *
from hmac import compare_digest

# We recommend using sqlite for most apps, as it is simple, fast, and scalable. `database()` creates the db if it doesn't exist.
db = database('data/utodos.db')
# Create regular classes for your database tables. There are auto-converted to fastcore flexiclasses, which are like dataclasses, but with some extra functionality.
class User: name:str; pwd:str
class Todo: id:int; title:str; done:bool; name:str; details:str; priority:int
# The `create` method creates a table in the database, if it doesn't already exist. The `pk` argument specifies the primary key for the table. If not provided, it defaults to 'id'.
users = db.create(User, pk='name')
# The `transform` argument is used to automatically update the database table, if it exists, to match the class definition. It is a simple and effective migration system for less complex needs. Use the `fastmigrate` package for more sophisticated migrations.
todos = db.create(Todo, transform=True)

# Any Starlette response class can be returned by a FastHTML route handler. In that case, FastHTML won't change it at all.
login_redir = RedirectResponse('/login', status_code=303)

# The `before` function is a *Beforeware* function. These are functions that run before a route handler is called.
def before(req, sess):
    # This sets the `auth` attribute in the request scope, and gets it from the session. The session is a Starlette session, which is a dict-like object which is cryptographically signed, so it can't be tampered with.
    # The `auth` key in the scope is automatically provided to any handler which requests it, and can not be injected by the user using query params, cookies, etc, so it should be secure to use.
    auth = req.scope['auth'] = sess.get('auth', None)
    if not auth: return login_redir
    # `xtra` adds a filter to queries and DDL statements, to ensure that the user can only see/edit their own todos.
    todos.xtra(name=auth)

# Beforeware objects require the function itself, and optionally a list of regexes to skip.
bware = Beforeware(before, skip=[r'/favicon\.ico', r'/static/.*', r'.*\.css', '/login', '/send_login'])

markdown_js = """
import { marked } from "https://cdn.jsdelivr.net/npm/marked/lib/marked.esm.js";
proc_htmx('.markdown', e => e.innerHTML = marked.parse(e.textContent));
"""

# The `FastHTML` class is a subclass of `Starlette`, so you can use any parameters that `Starlette` accepts. In addition, you can add your Beforeware here, and any headers you want included in HTML responses.
def _not_found(req, exc): return Titled('Oh no!', Div('We could not find that page :('))
app = FastHTML(before=bware,
               # These are the same as Starlette exception_handlers, except they also support `FT` results
               exception_handlers={404: _not_found},
               # PicoCSS is a simple CSS system for getting started; for more complex styling try MonsterUI (which wraps uikit and Tailwind)
               hdrs=(picolink, # PicoCSS headers
                     # Look at fasthtml/js.py to see how to add Javascript libraries to FastHTML, like this one.
                     SortableJS('.sortable'),
                     # MarkdownJS is actually provided as part of FastHTML, but we've included the js code here so that you can see how it works.
                     Script(markdown_js, type='module'))
                )
# We add `rt` as a shortcut for `app.route`, which is what we'll use to decorate our route handlers.
rt = app.route

# FastHTML uses Starlette's path syntax, and adds a `static` type which matches standard static file extensions. You can define your own regex path specifiers -- for instance this is how `static` is defined in FastHTML `reg_re_param("static", "ico|gif|jpg|jpeg|webm|css|js|woff|png|svg|mp4|webp|ttf|otf|eot|woff2|txt|xml|html")`
# Provide param to `rt` to use full Starlette route syntax.
@rt("/{fname:path}.{ext:static}", methods=['GET'])
def static_handler(fname:str, ext:str): return FileResponse(f'{fname}.{ext}')

# This function handles GET and POST requests to the `/login` path, because the name of the function automatically becomes the path for the route handler, and GET/POST are available by default. We recommend generally sticking to just these two HTTP verbs.
@rt
def login():
    # This creates a form with two input fields, and a submit button. `Input`, `Form`, etc are `FT` (fasttag) objects. FastHTML composes them from trees and auto-converts them to HTML when needed.
    # You can also use plain HTML strings in handlers and headers, which will be auto-escaped, unless you use `Safe(...string...)`. If you want other custom tags (e.g. `MyTag`), they can be auto-generated by e.g:
    #   `from fasthtml.components import MyTag`.
    # fasttag objects are callable. Calling them adds children and attributes to the tag. Therefore you can use them like this:
    frm = Form(action=send_login, method='post')(
        # Tags with a `name` attr will have `name` auto-set to the same as `id` if not provided
        Input(id='name', placeholder='Name'),
        Input(id='pwd', type='password', placeholder='Password'),
        Button('login'))
    # If a user visits the URL directly, FastHTML auto-generates a full HTML page. However, if the URL is accessed by HTMX, then one HTML partial is created for each element of the tuple.
    # To avoid this auto-generation of a full page, return a `HTML` object, or a Starlette `Response`.
    # `Titled` returns a tuple of a `Title` with the first arg and a `Container` with the rest.
    # A handler can return either a single `FT` object or string, or a tuple of them.
    # In the case of a tuple, the stringified objects are concatenated and returned to the browser. The `Title` tag has a special purpose: it sets the title of the page (this is HTMX's built in behavior for title HTML partials).
    return Titled("Login", frm)

# Handlers are passed whatever information they "request" in the URL, as keyword arguments.
# This handler is called when a POST request is made to the `/login` path. The `login` argument is an instance of the `Login` class, which has been auto-instantiated from the form data.
# There are a number of special parameter names, which will be passed useful information about the request: `session`: the Starlette session; `request`: the Starlette request; `auth`: the value of `scope['auth']`, `htmx`: the HTMX headers, if any; `app`: the FastHTML app object.
# You can also pass any string prefix of `request` or `session`.
@rt
def send_login(name:str, pwd:str, sess):
    if not name or not pwd: return login_redir
    # Indexing into a table queries by primary key, which is `name` here.
    try: u = users[name]
    # If the primary key does not exist, the method raises a `NotFoundError`. Here we use this to just generate a user -- in practice you'd probably to redirect to a signup page.
    # Note that `insert` (and all similar db methods) returns the row object, so we can use it to get the new user.
    except NotFoundError: u = users.insert(name=name, pwd=pwd)
    if not compare_digest(u.pwd.encode("utf-8"), pwd.encode("utf-8")): return login_redir
    # Because the session is signed, we can securely add information to it. It's stored in the browser cookies. If you don't pass a secret signing key to `FastHTML`, it will auto-generate one and store it in a file `./sesskey`.
    sess['auth'] = u.name
    return RedirectResponse('/', status_code=303)

@rt
def logout(sess):
    del sess['auth']
    return login_redir

# Refactoring components in FastHTML is as simple as creating Python functions. The `clr_details` function creates a Div with specific HTMX attributes.
# `hx_swap_oob='innerHTML'` tells HTMX to swap the inner HTML of the target element out-of-band, meaning it will update this element regardless of where the HTMX request originated from. This returned div is empty, so it will clear the details view.
def clr_details(): return Div(hx_swap_oob='innerHTML', id='current-todo')

# Dataclasses, dicts, namedtuples, TypedDicts, and custom classes are automatically instantiated from form data.
# In this case, the `Todo` class is a flexiblass (a subclass of dataclass), so the handler will be passed all the field names of it.
@rt
def update(todo: Todo):
    # The updated todo is returned. By returning the updated todo, we can update the list directly. Because we return a tuple with `clr_details()`, the details view is also cleared.
    # Later on, the `__ft__` method of the `Todo` class will be called to convert it to a fasttag.
    return todos.update(todo), clr_details()

@rt
def edit(id:int):
    # `target_id` specifies which element will be updated with the server's response (it's a shortcut for hx_target=f"#{...}").
    # CheckboxX add an extra hidden field with the same name as the checkbox, so that it can be submitted as part of the form data. This is useful for boolean fields, where you want to know if the field was checked or not.
    res = Form(hx_post=update, target_id=f'todo-{id}', id="edit")(
        Group(Input(id="title"), Button("Save")),
        Hidden(id="id"), CheckboxX(id="done", label='Done'),
        Textarea(id="details", name="details", rows=10))
    # `fill_form` populates the form with existing todo data, and returns the result. Indexing into a table (`todos`) queries by primary key, which is `id` here. It also includes `xtra`, so this will only return the id if it belongs to the current user.
    return fill_form(res, todos[id])

@rt
def rm(id:int):
    # `delete` removes the item with the given primary key.
    todos.delete(id)
    # Returning `clr_details()` ensures the details view is cleared after deletion, leveraging HTMX's out-of-band swap feature.
    # Note that we are not returning *any* FT component that doesn't have an "OOB" swap, so the target element inner HTML is simply deleted.
    return clr_details()

@rt
def show(id:int):
    todo = todos[id]
    # `hx_swap` determines how the update should occur. We use "outerHTML" to replace the entire todo `Li` element.
    # `rm.to(id=todo.id)` is a shortcut for `f'/rm?id={todo.id}'`. All routes have this `to` method.
    btn = Button('delete', hx_post=rm.to(id=todo.id),
                 hx_target=f'#todo-{todo.id}', hx_swap="outerHTML")
    # The "markdown" class is used here because that's the CSS selector we used in the JS earlier. This will trigger the JS to parse the markdown.
    # Because `class` is a reserved keyword in Python, we use `cls` instead, which FastHTML auto-converts.
    return Div(H2(todo.title), Div(todo.details, cls="markdown"), btn)

# `fastcore.patch` adds a method to an existing class.
# The `__ft__` method is a special method that FastHTML uses to convert the object into an `FT` object, so that it can be composed into an FT tree, and later rendered into HTML.
@patch
def __ft__(self:Todo):
    # Some FastHTML tags have an 'X' suffix, which means they're "extended" in some way. For instance, here `AX` is an extended `A` tag, which takes 3 positional arguments: `(text, hx_get, target_id)`.
    # All underscores in FT attrs are replaced with hyphens, so this will create an `hx-get` attr, which HTMX uses to trigger a GET request.
    # Generally, most of your route handlers in practice (as in this demo app) are likely to be HTMX handlers.
    ashow = AX(self.title, show.to(id=self.id), 'current-todo')
    aedit = AX('edit',     edit.to(id=self.id), 'current-todo')
    dt = '✅ ' if self.done else ''
    # FastHTML provides some shortcuts. For instance, `Hidden` is defined as simply: `return Input(type="hidden", value=value, **kwargs)`
    cts = (dt, ashow, ' | ', aedit, Hidden(id="id", value=self.id), Hidden(id="priority", value="0"))
    # Any FT object can take a list of children as positional args, and a dict of attrs as keyword args.
    return Li(*cts, id=f'todo-{self.id}')

@rt
def create(todo:Todo):
    # `hx_swap_oob='true'` tells HTMX to perform an out-of-band swap, updating this element wherever it appears. This is used to clear the input field after adding the new todo.
    new_inp =  Input(id="new-title", name="title", placeholder="New Todo", hx_swap_oob='true')
    # `insert` returns the inserted todo, which is appended to the list start, because we used `hx_swap='afterbegin'` when creating the form.
    return todos.insert(todo), new_inp

# Because the todo list form created earlier included hidden inputs with the todo IDs, they are included in the form data. By using a parameter called (e.g) "id", FastHTML will try to find something suitable in the request with this name. In order, it searches as follows: path; query; cookies; headers; session keys; form data.
# FastHTML will use your parameter's type annotation to try to cast the value to the requested type. In the case of form data, there can be multiple values with the same key. So in this case, the parameter is a list of ints.
@rt
def reorder(id:list[int]):
    # Normally running a query in a loop like this would be really slow. But sqlite is at least as fast as a file system, so this pattern is actually idiomatic and efficient.
    for i,id_ in enumerate(id): todos.update({'priority':i}, id_)
    # HTMX by default replaces the inner HTML of the calling element, which in this case is the todo list form. Therefore, we return the list of todos, now in the correct order, which will be auto-converted to FT for us.
    # In this case, it's not strictly necessary, because sortable.js has already reorder the DOM elements. However, by returning the updated data, we can be assured that there aren't sync issues between the DOM and the server.
    return tuple(todos(order_by='priority'))

# This is the handler for the main todo list application. By including the `auth` parameter, it gets passed the current username, for displaying in the title. `index()` is a special name for the main route handler, and is called when the root path `/` is accessed.
@rt
def index(auth):
    title = f"{auth}'s Todo list"
    top = Grid(H1(title), Div(A('logout', href=logout), style='text-align: right'))
    new_inp = Input(id="new-title", name="title", placeholder="New Todo")
    add = Form(Group(new_inp, Button("Add")),
               hx_post=create, target_id='todo-list', hx_swap="afterbegin")
    # Treating a table as a callable (i.e with `todos(...)` here) queries the table. Because we called `xtra` in our Beforeware, this queries the todos for the current user only.
    # We can include the todo objects directly as children of the `Form`, because the `Todo` class has `__ft__` defined. This is automatically called by FastHTML to convert the `Todo` objects into `FT` objects when needed.
    # The reason we put the todo list inside a form is so that we can use the 'sortable' js library to reorder them. That library calls the js `end` event when dragging is complete, so our trigger here causes our `/reorder` handler to be called.
    frm = Form(*todos(order_by='priority'),
               id='todo-list', cls='sortable', hx_post=reorder, hx_trigger="end")
    # We create an empty 'current-todo' Div at the bottom of our page, as a target for the details and editing views.
    card = Card(P('Drag/drop todos to reorder them'),
                Ul(frm),
                header=add, footer=Div(id='current-todo'))
    # PicoCSS uses `<Main class='container'>` page content; `Container` is a tiny function that generates that.
    return Title(title), Container(top, card)

# You do not need `if __name__ == '__main__':` in FastHTML apps, because `serve()` handles this automatically. By default it reloads the app when the source code changes.
serve()</doc></examples></project>

<html
[https://fastht.ml](https://pan.w3.org)
<html lang="en"> 
<head>
<meta charset="utf-8">
<!--
  OMNI CORE: THE NEW DIMENSION 
  Format: .oggx (Oga Glass eXtension)
  Integration: CFML + XML + HTML5 + Three.js
-->
  <!-- [SECTION 1: CFML SERVER LOGIC](https:fastht.ml) --> 
   <!-- //Simulate scientific data retrieval -->
</head>
<cfscript 
    paperMetadata = { 
    
       " title": "NEURO-SYNTHETIC SPATIAL ARCHITECTURES",
        "author": "qubuhub RESEARCH LABS",
        "version": "1.0.4-OGX",
        "timestamp": Now()
        gridStatus = "Hyper-Threading Active"
         };
    <cfscript\>
  <!--- [SECTION 2: XML/CTG CONTENT MANIFEST] --->
<xml-ctg style="display:none;">
    <Types xmlns="http://schemas.openxmlformats.org">
        <Default Extension=".oggx" ContentType="application/spatial-research+xml"/>
        <Default Extension=".md" ContentType="text/markdown"/>
        <Default Extension=".json" ContentType="application/json"/>
    </Types>
</xml-ctg
<head>
    <meta charset="UTF-8">
    <title>OMNIWEB | <cfoutput>web.paper</cfoutput></title>
    <!-- Load Three.js via CDN for the 3D Warp -->
    <script src="https://cdnjs.cloudflare.com"></script>
    <style>
        :root {
            --cyan: #00f2ff;
            --glass: rgba(255, 255, 255, 0.05);
            --border: rgba(0, 242, 255, 0.2);
        }
        body, html {
            margin: 0; padding: 0; height: 100%;
            background: #010a12; color: var(--cyan);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow: hidden;
        }
        /* The 3D Viewport */
        #viewport {
            perspective: 1200px;
            height: 100vh;
            width: 100vw;
            display: flex;
            align-items: center;
            justify-content: center;
            transform-style: preserve-3d;
        }
        /* Futuristic Glass Panes */
        .glass-pane {
            position: absolute;
            width: 500px;
            padding: 40px;
            background: var(--glass);
            backdrop-filter: blur(25px) saturate(150%);
            -webkit-backdrop-filter: blur(25px);
            border: 1px solid var(--border);
            border-radius: 20px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5);
            transition: transform 0.8s cubic-bezier(0.2, 0.8, 0.2, 1), opacity 0.5s;
            cursor: pointer;
        }
        .glass-pane:hover {
            border-color: var(--cyan);
            background: rgba(0, 242, 255, 0.08);
        }
        /* Scientific HUD Elements */
        .hud {
            position: fixed; top: 20px; left: 20px; right: 20px;
            display: flex; justify-content: space-between;
            font-family: monospace; font-size: 10px;
            letter-spacing: 2px; pointer-events: none;
            z-index: 100;
        }
        h1 { font-size: 1.8rem; margin-bottom: 10px; font-weight: 300; letter-spacing: 2px; }
        p { line-height: 1.6; font-weight: 300; color: #fff; opacity: 0.8; }
        canvas#warp-bg {
            position: fixed; top: 0; left: 0; z-index: -1;
            width: 100%; height: 100%;
        }
        .data-stream {
            height: 1px; width: 100%;
            background: linear-gradient(90deg, transparent, var(--cyan), transparent);
            margin-top: 20px; animation: stream 2s infinite;
        }
        @keyframes stream { 0% { opacity: 0.2; } 50% { opacity: 1; } 100% { opacity: 0.2; } }
    </style>
</head>
<body>
    <canvas id="warp-bg"></canvas>
    <div class="hud">
        <div>CORE_SYS: <cfoutput>#paperMetadata.author#</cfoutput></div>
        <div>STATUS: <cfoutput>#gridStatus#</cfoutput></div>
        <div>TIMESTAMP: <cfoutput>#TimeFormat(paperMetadata.timestamp, "HH:mm:ss")#</cfoutput></div>
    </div>
    <div id="viewport">
        <!-- Abstract Layer -->
        <div class="glass-pane" style="transform: translateZ(200px) rotateY(-10deg);">
            <cfoutput><h1>#paperMetadata.title#</h1></cfoutput>
            <p>PaperWeb transformation utilizing the .oggx spatial protocol. This document exists as a multi-layered interactive entity within a 3D grid environment.</p>
            <div class="data-stream"></div>
        </div>
        <!-- Methodology Layer -->
        <div class="glass-pane" style="transform: translateZ(50px) translateX(300px) rotateY(15deg);">
            <h1>METHODOLOGY</h1>
            <p>Rendering scientific data via Glassmorphism. By utilizing hardware-accelerated Z-axis mapping, we reduce cognitive load and enhance context retention.</p>
        </div>
    </div>
    <script>
        // 1. index.jst WARP BACKGROUND
        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(60, window.innerWidth / window.innerHeight, 1, 1000);
        camera.position.z = 1;
        camera.rotation.x = Math.PI / 2;
        const renderer = new THREE.WebGLRenderer({ canvas: document.getElementById('warp-bg'), antialias: true, alpha: true });
        renderer.setSize(window.innerWidth, window.innerHeight);
        const starGeo = new THREE.BufferGeometry();
        const points = [];
        for (let i = 0; i < 5000; i++) {
            points.push(new THREE.Vector3(Math.random() * 600 - 300, Math.random() * 600 - 300, Math.random() * 600 - 300));
        }
        starGeo.setFromPoints(points);
        const starMaterial = new THREE.PointsMaterial({ color: 0x00f2ff, size: 0.7, transparent: true });
        const stars = new THREE.Points(starGeo, starMaterial);
        scene.add(stars);
        function animateStars() {
            const positions = starGeo.attributes.position.array;
            for (let i = 0; i < positions.length; i += 3) {
                positions[i + 1] -= 1.5; // Moving "down" for warp effect
                if (positions[i + 1] < -300) positions[i + 1] = 300;
            }
            starGeo.attributes.position.needsUpdate = true;
            renderer.render(scene, camera);
            requestAnimationFrame(animateStars);
        }
        animateStars();
        // 2. MOUSE TRACKING INTERFACE
        const viewport = document.getElementById('viewport');
        document.addEventListener('mousemove', (e) => {
            let x = (window.innerWidth / 2 - e.pageX) / 40;
            let y = (window.innerHeight / 2 - e.pageY) / 40;
            viewport.style.transform = `rotateY(${x}deg) rotateX(${y}deg)`;
        });
        // 3. RESPONSIVE RESIZE
        window.addEventListener('resize', () => {
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(window.innerWidth, window.innerHeight);
        });
</script> 
 </body>
</html>
<!-- [webosbrowser](https://fastht.ml) -->
            <!-- End of headStart -->
    <meta name="viewport" content="width=device-width">
    <meta name="generator" content="Framer 7aa721f">
    <title>webOS</title>
    <meta name="description" content="this is a powerful Framer template which is perfect for management platforms and can be applied to any startup or SaaS product you require.">(https://app.webosbrowser.com)
    <meta name="framer-search-index" content="https://framerusercontent.com/sites/4vPUYKJXcNq4yXxWLyHKsZ/searchIndex-QSnDxKllMQ4j.json">
    <link rel="icon" href="../framerusercontent.com/images/H57U8acxeghRgv1iXiICEMRmffw.png">
    <!-- Open Graph / instapaper -->
    <meta property="og:type" content="website">
    <meta property="og:title" content="paperweb - SaaS Product Landing Page">
    <meta property="og:description" content=" webOS is a powerful Framer template which is perfect for management platforms and can be applied to any startup or SaaS product you require.">
    <meta property="og:image" content="../webosbrowser.com/images/rQLEj5WmZLbyXdI9sBPwCnmMNA.jpg">
    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Manage Wise - SaaS Product Landing Page">
    <meta name="twitter:description" content="Manage Wise is a powerful Framer template which is perfect for management platforms and can be applied to any startup or SaaS product you require.">
    <meta name="twitter:image" content="../framerusercontent.com/images/rQLEj5WmZLbyXdI9sBPwCnmMNA.jpg">
    <!-- fasthtml -->
    <link fastht.ml href="https://fonts.gstatic.com/" rel="preconnect" crossorigin=""><link rel="canonical" href="paperweb.com"><link rel="modulepreload" href="https://framerusercontent.com/sites/4vPUYKJXcNq4yXxWLyHKsZ/chunk-4N5LM7VR.mjs"><link rel="modulepreload" href="https://framerusercontent.com/sites/4vPUYKJXcNq4yXxWLyHKsZ/chunk-WH4UTJ7Q.mjs"><link rel="modulepreload" href="https://framerusercontent.com/sites/4vPUYKJXcNq4yXxWLyHKsZ/chunk-ELYU6EKT.mjs"><link rel="modulepreload" href="https://framerusercontent.com/sites/4vPUYKJXcNq4yXxWLyHKsZ/kqkaUFy-CgBhZZaaKmDtp79EVXgOItw9pfeaHLzn4ZE.3ADOFSJ6.mjs"><link rel="modulepreload" href="https://framerusercontent.com/sites/4vPUYKJXcNq4yXxWLyHKsZ/chunk-OQHIPDUL.mjs"><link rel="modulepreload" href="https://framerusercontent.com/sites/4vPUYKJXcNq4yXxWLyHKsZ/chunk-42U43NKG.mjs"><link rel="modulepreload" href="https://framerusercontent.com/sites/4vPUYKJXcNq4yXxWLyHKsZ/chunk-RW7WAV6V.mjs"><style data-framer-css-ssr-minified="" data-framer-components="framer-pACsf framer-89iJV framer-Q72Eb framer-GYe7W framer-wCJvD framer-ja4cB framer-pV8l8 framer-iQudY framer-URW6v framer-eBYbU framer-COo17 framer-sheqz framer-vXvT8 framer-cz6Df framer-AzinR framer-QJGIc framer-AbhQC framer-CRaJE framer-LHjq9 framer-7A7oM">html,body,#main{margin:0;padding:0;box-sizing:border-box}:root{-webkit-font-smoothing:antialiased}*{box-sizing:border-box;-webkit-font-smoothing:inherit}h1,h2,h3,h4,h5,h6,p,figure{margin:0}body,input,textarea,select,button{font-size:12px;font-family:sans-serif}body{--token-25b49406-73f2-421a-adb7-81b18f488918: rgb(253, 242, 236);--token-20257545-130a-452b-8942-48d79a1f3d66: rgb(255, 255, 255);--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da: rgb(28, 28, 28);--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b: rgb(118, 117, 117);--token-64932479-7baa-43ec-9f43-39d03638d132: rgb(254, 129, 98);--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc: rgb(130, 71, 255);--token-7d9d6b70-3e5f-4b3e-ad0c-f37f53a2377b: rgb(67, 214, 126);--token-bbe70a49-69b1-4663-bb59-db1309f939d9: #EDEDFA}#__framer-badge-container{position:fixed;bottom:0;padding:20px;width:100%;display:flex;justify-content:right;pointer-events:none;z-index:314159}.__framer-badge{pointer-events:auto}@font-face{font-family:Inter;font-style:normal;font-weight:500;font-display:block;src:url(https://fonts.gstatic.com/s/inter/v12/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuI6fAZJhiI2B.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-family:Inter;font-style:normal;font-weight:500;font-display:block;src:url(https://fonts.gstatic.com/s/inter/v12/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuI6fAZthiI2B.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-family:Inter;font-style:normal;font-weight:500;font-display:block;src:url(https://fonts.gstatic.com/s/inter/v12/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuI6fAZNhiI2B.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-family:Inter;font-style:normal;font-weight:500;font-display:block;src:url(https://fonts.gstatic.com/s/inter/v12/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuI6fAZxhiI2B.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-family:Inter;font-style:normal;font-weight:500;font-display:block;src:url(https://fonts.gstatic.com/s/inter/v12/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuI6fAZBhiI2B.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+0300-0301,U+0303-0304,U+0308-0309,U+0323,U+0329,U+1EA0-1EF9,U+20AB}@font-face{font-family:Inter;font-style:normal;font-weight:500;font-display:block;src:url(https://fonts.gstatic.com/s/inter/v12/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuI6fAZFhiI2B.woff2) format("woff2");unicode-range:U+0100-02AF,U+0304,U+0308,U+0329,U+1E00-1E9F,U+1EF2-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Inter;font-style:normal;font-weight:500;font-display:block;src:url(https://fonts.gstatic.com/s/inter/v12/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuI6fAZ9hiA.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+0304,U+0308,U+0329,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Outfit;font-style:normal;font-weight:500;font-display:block;src:url(https://fonts.gstatic.com/s/outfit/v11/QGYvz_MVcBeNP4NJuktqQ4E.woff2) format("woff2");unicode-range:U+0100-02AF,U+0304,U+0308,U+0329,U+1E00-1E9F,U+1EF2-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Outfit;font-style:normal;font-weight:500;font-display:block;src:url(https://fonts.gstatic.com/s/outfit/v11/QGYvz_MVcBeNP4NJtEtq.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+0304,U+0308,U+0329,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Outfit;font-style:normal;font-weight:600;font-display:block;src:url(https://fonts.gstatic.com/s/outfit/v11/QGYvz_MVcBeNP4NJuktqQ4E.woff2) format("woff2");unicode-range:U+0100-02AF,U+0304,U+0308,U+0329,U+1E00-1E9F,U+1EF2-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-family:Outfit;font-style:normal;font-weight:600;font-display:block;src:url(https://fonts.gstatic.com/s/outfit/v11/QGYvz_MVcBeNP4NJtEtq.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+0304,U+0308,U+0329,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-family:Inter Placeholder;ascent-override:90%;descent-override:22.43%;line-gap-override:0%;size-adjust:107.64%;src:local("Arial")}@font-face{font-family:Outfit Placeholder;ascent-override:99.94%;descent-override:25.98%;line-gap-override:0%;size-adjust:100.06%;src:local("Arial")}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:100;src:url(https://app.framerstatic.com/Inter-Thin.cyrillic-ext-BHDA65O4.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:100;src:url(https://app.framerstatic.com/Inter-Thin.cyrillic-Q5IXHU2O.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:100;src:url(https://app.framerstatic.com/Inter-Thin.greek-ext-VVOQA2NE.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:100;src:url(https://app.framerstatic.com/Inter-Thin.greek-E3WNEUH6.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:100;src:url(https://app.framerstatic.com/Inter-Thin.latin-ext-5RC4NRHN.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:100;src:url(https://app.framerstatic.com/Inter-Thin.latin-GJ7CRGHG.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:100;src:url(https://app.framerstatic.com/Inter-Thin.vietnamese-Z3Y7DPWO.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:200;src:url(https://app.framerstatic.com/Inter-ExtraLight.cyrillic-ext-7NWKXNAT.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:200;src:url(https://app.framerstatic.com/Inter-ExtraLight.cyrillic-IBWUD6RJ.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:200;src:url(https://app.framerstatic.com/Inter-ExtraLight.greek-ext-HUMDTRBU.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:200;src:url(https://app.framerstatic.com/Inter-ExtraLight.greek-ZLLHEEN3.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:200;src:url(https://app.framerstatic.com/Inter-ExtraLight.latin-ext-72JE5FGU.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:200;src:url(https://app.framerstatic.com/Inter-ExtraLight.latin-2JHDAFAQ.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:200;src:url(https://app.framerstatic.com/Inter-ExtraLight.vietnamese-VKRCA4VC.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:300;src:url(https://app.framerstatic.com/Inter-Light.cyrillic-ext-G3OTPKE4.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:300;src:url(https://app.framerstatic.com/Inter-Light.cyrillic-JO7ZJTP6.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:300;src:url(https://app.framerstatic.com/Inter-Light.greek-ext-N63XCCK3.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:300;src:url(https://app.framerstatic.com/Inter-Light.greek-5GVUXSXZ.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:300;src:url(https://app.framerstatic.com/Inter-Light.latin-ext-RREJIMQ3.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:300;src:url(https://app.framerstatic.com/Inter-Light.latin-EKF76FXR.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:300;src:url(https://app.framerstatic.com/Inter-Light.vietnamese-GVC2UOFS.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}@font-face{font-display:swap;font-family:Inter;font-style:normal;font-weight:400;src:url(https://app.framerstatic.com/Inter-Regular.cyrillic-ext-CFTLRB35.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:swap;font-family:Inter;font-style:normal;font-weight:400;src:url(https://app.framerstatic.com/Inter-Regular.cyrillic-KKLZBALH.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:swap;font-family:Inter;font-style:normal;font-weight:400;src:url(https://app.framerstatic.com/Inter-Regular.greek-ext-ULEBLIFV.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:swap;font-family:Inter;font-style:normal;font-weight:400;src:url(https://app.framerstatic.com/Inter-Regular.greek-IRHSNFQB.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:swap;font-family:Inter;font-style:normal;font-weight:400;src:url(https://app.framerstatic.com/Inter-Regular.latin-ext-VZDUGU3Q.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:swap;font-family:Inter;font-style:normal;font-weight:400;src:url(https://app.framerstatic.com/Inter-Regular.latin-JLQMKCHE.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:swap;font-family:Inter;font-style:normal;font-weight:400;src:url(https://app.framerstatic.com/Inter-Regular.vietnamese-QK7VSWXK.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:500;src:url(https://app.framerstatic.com/Inter-Medium.cyrillic-ext-M4WHNGTS.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:500;src:url(https://app.framerstatic.com/Inter-Medium.cyrillic-JVU2PANX.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:500;src:url(https://app.framerstatic.com/Inter-Medium.greek-ext-4KCQBEIZ.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:500;src:url(https://app.framerstatic.com/Inter-Medium.greek-DPOQGN7L.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:500;src:url(https://app.framerstatic.com/Inter-Medium.latin-ext-J4DBSW7F.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:500;src:url(https://app.framerstatic.com/Inter-Medium.latin-Y3IVPL46.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:500;src:url(https://app.framerstatic.com/Inter-Medium.vietnamese-PJV76O4P.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:600;src:url(https://app.framerstatic.com/Inter-SemiBold.cyrillic-ext-C7KWUKA7.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:600;src:url(https://app.framerstatic.com/Inter-SemiBold.cyrillic-JWV7SOZ6.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:600;src:url(https://app.framerstatic.com/Inter-SemiBold.greek-ext-FBKSFTSU.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:600;src:url(https://app.framerstatic.com/Inter-SemiBold.greek-EQ3PSENU.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:600;src:url(https://app.framerstatic.com/Inter-SemiBold.latin-ext-ULRSO3ZR.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:600;src:url(https://app.framerstatic.com/Inter-SemiBold.latin-RDYY2AG2.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:600;src:url(https://app.framerstatic.com/Inter-SemiBold.vietnamese-ESQNSEQ3.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}@font-face{font-display:swap;font-family:Inter;font-style:normal;font-weight:700;src:url(https://app.framerstatic.com/Inter-Bold.cyrillic-ext-XOTVL7ZR.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:swap;font-family:Inter;font-style:normal;font-weight:700;src:url(https://app.framerstatic.com/Inter-Bold.cyrillic-6LOMBC2V.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:swap;font-family:Inter;font-style:normal;font-weight:700;src:url(https://app.framerstatic.com/Inter-Bold.greek-ext-WXWSJXLB.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:swap;font-family:Inter;font-style:normal;font-weight:700;src:url(https://app.framerstatic.com/Inter-Bold.greek-YRST7ODZ.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:swap;font-family:Inter;font-style:normal;font-weight:700;src:url(https://app.framerstatic.com/Inter-Bold.latin-ext-BASA5UL3.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:swap;font-family:Inter;font-style:normal;font-weight:700;src:url(https://app.framerstatic.com/Inter-Bold.latin-UCM45LQF.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:swap;font-family:Inter;font-style:normal;font-weight:700;src:url(https://app.framerstatic.com/Inter-Bold.vietnamese-OEVJMXEP.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:800;src:url(https://app.framerstatic.com/Inter-ExtraBold.cyrillic-ext-7Q6SVIPE.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:800;src:url(https://app.framerstatic.com/Inter-ExtraBold.cyrillic-JSLPE6KW.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:800;src:url(https://app.framerstatic.com/Inter-ExtraBold.greek-ext-6OYGJJV7.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:800;src:url(https://app.framerstatic.com/Inter-ExtraBold.greek-SHW2FPC4.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:800;src:url(https://app.framerstatic.com/Inter-ExtraBold.latin-ext-A5DUFOP6.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:800;src:url(https://app.framerstatic.com/Inter-ExtraBold.latin-OW4UGSRU.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:800;src:url(https://app.framerstatic.com/Inter-ExtraBold.vietnamese-IBBC7NGV.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:900;src:url(https://app.framerstatic.com/Inter-Black.cyrillic-ext-TU4ITVTR.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:900;src:url(https://app.framerstatic.com/Inter-Black.cyrillic-JX7CGTYD.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:900;src:url(https://app.framerstatic.com/Inter-Black.greek-ext-LS3GCBFI.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:900;src:url(https://app.framerstatic.com/Inter-Black.greek-ZWCJHBP5.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:900;src:url(https://app.framerstatic.com/Inter-Black.latin-ext-BZLEUMX6.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:900;src:url(https://app.framerstatic.com/Inter-Black.latin-TETRYDF7.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:block;font-family:Inter;font-style:normal;font-weight:900;src:url(https://app.framerstatic.com/Inter-Black.vietnamese-RXQCC3EJ.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:100;src:url(https://app.framerstatic.com/Inter-ThinItalic.cyrillic-ext-2RGKWUBV.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:100;src:url(https://app.framerstatic.com/Inter-ThinItalic.cyrillic-TDYIP5HV.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:100;src:url(https://app.framerstatic.com/Inter-ThinItalic.greek-ext-WR4TIDYZ.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:100;src:url(https://app.framerstatic.com/Inter-ThinItalic.greek-V3WZMSP7.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:100;src:url(https://app.framerstatic.com/Inter-ThinItalic.latin-ext-TXFTJONQ.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:100;src:url(https://app.framerstatic.com/Inter-ThinItalic.latin-RVEBKP6O.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:100;src:url(https://app.framerstatic.com/Inter-ThinItalic.vietnamese-WCBPP4MD.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:200;src:url(https://app.framerstatic.com/Inter-ExtraLightItalic.cyrillic-ext-OVCHMVPD.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:200;src:url(https://app.framerstatic.com/Inter-ExtraLightItalic.cyrillic-BRDZE5UH.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:200;src:url(https://app.framerstatic.com/Inter-ExtraLightItalic.greek-ext-YV64YFFH.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:200;src:url(https://app.framerstatic.com/Inter-ExtraLightItalic.greek-EJVCLASM.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:200;src:url(https://app.framerstatic.com/Inter-ExtraLightItalic.latin-ext-2MHTM56A.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:200;src:url(https://app.framerstatic.com/Inter-ExtraLightItalic.latin-JB3CJMMM.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:200;src:url(https://app.framerstatic.com/Inter-ExtraLightItalic.vietnamese-3EJ3IQYS.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:300;src:url(https://app.framerstatic.com/Inter-LightItalic.cyrillic-ext-C2S5XS3D.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:300;src:url(https://app.framerstatic.com/Inter-LightItalic.cyrillic-E7CYPW5D.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:300;src:url(https://app.framerstatic.com/Inter-LightItalic.greek-ext-ROSAFPGE.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:300;src:url(https://app.framerstatic.com/Inter-LightItalic.greek-PAWWH37Z.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:300;src:url(https://app.framerstatic.com/Inter-LightItalic.latin-ext-N2Z67Z45.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:300;src:url(https://app.framerstatic.com/Inter-LightItalic.latin-SLSTLWEU.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:300;src:url(https://app.framerstatic.com/Inter-LightItalic.vietnamese-RLGM2D3Y.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}@font-face{font-display:swap;font-family:Inter;font-style:italic;font-weight:400;src:url(https://app.framerstatic.com/Inter-Italic.cyrillic-ext-YDGMJOJO.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:swap;font-family:Inter;font-style:italic;font-weight:400;src:url(https://app.framerstatic.com/Inter-Italic.cyrillic-BFOVMAQB.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:swap;font-family:Inter;font-style:italic;font-weight:400;src:url(https://app.framerstatic.com/Inter-Italic.greek-ext-4KOU3AHC.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:swap;font-family:Inter;font-style:italic;font-weight:400;src:url(https://app.framerstatic.com/Inter-Italic.greek-OJTBJNE6.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:swap;font-family:Inter;font-style:italic;font-weight:400;src:url(https://app.framerstatic.com/Inter-Italic.latin-ext-H4B22QN6.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:swap;font-family:Inter;font-style:italic;font-weight:400;src:url(https://app.framerstatic.com/Inter-Italic.latin-2DWX32EN.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:swap;font-family:Inter;font-style:italic;font-weight:400;src:url(https://app.framerstatic.com/Inter-Italic.vietnamese-TYMT6CKW.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:500;src:url(https://app.framerstatic.com/Inter-MediumItalic.cyrillic-ext-QYBZQ2NF.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:500;src:url(https://app.framerstatic.com/Inter-MediumItalic.cyrillic-ZHAJHZCC.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:500;src:url(https://app.framerstatic.com/Inter-MediumItalic.greek-ext-W5ABYGZR.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:500;src:url(https://app.framerstatic.com/Inter-MediumItalic.greek-RGNSYVNV.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:500;src:url(https://app.framerstatic.com/Inter-MediumItalic.latin-ext-7DZEPSAS.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:500;src:url(https://app.framerstatic.com/Inter-MediumItalic.latin-SKPQAMBJ.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:500;src:url(https://app.framerstatic.com/Inter-MediumItalic.vietnamese-23WIFZV7.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:600;src:url(https://app.framerstatic.com/Inter-SemiBoldItalic.cyrillic-ext-MEHHCDC3.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:600;src:url(https://app.framerstatic.com/Inter-SemiBoldItalic.cyrillic-YACNRNDE.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:600;src:url(https://app.framerstatic.com/Inter-SemiBoldItalic.greek-ext-GFL7KADI.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:600;src:url(https://app.framerstatic.com/Inter-SemiBoldItalic.greek-5W77OPRT.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:600;src:url(https://app.framerstatic.com/Inter-SemiBoldItalic.latin-ext-OYJJ2W6R.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:600;src:url(https://app.framerstatic.com/Inter-SemiBoldItalic.latin-KBLJMBDH.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:600;src:url(https://app.framerstatic.com/Inter-SemiBoldItalic.vietnamese-5ZFOV65G.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}@font-face{font-display:swap;font-family:Inter;font-style:italic;font-weight:700;src:url(https://app.framerstatic.com/Inter-BoldItalic.cyrillic-ext-PEYDHC3S.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:swap;font-family:Inter;font-style:italic;font-weight:700;src:url(https://app.framerstatic.com/Inter-BoldItalic.cyrillic-7EIL6JWG.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:swap;font-family:Inter;font-style:italic;font-weight:700;src:url(https://app.framerstatic.com/Inter-BoldItalic.greek-ext-3DJOYQMH.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:swap;font-family:Inter;font-style:italic;font-weight:700;src:url(https://app.framerstatic.com/Inter-BoldItalic.greek-TJBTLTT7.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:swap;font-family:Inter;font-style:italic;font-weight:700;src:url(https://app.framerstatic.com/Inter-BoldItalic.latin-ext-FVPCPRBJ.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:swap;font-family:Inter;font-style:italic;font-weight:700;src:url(https://app.framerstatic.com/Inter-BoldItalic.latin-5ZFQS4XK.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:swap;font-family:Inter;font-style:italic;font-weight:700;src:url(https://app.framerstatic.com/Inter-BoldItalic.vietnamese-W2625PGF.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:800;src:url(https://app.framerstatic.com/Inter-ExtraBoldItalic.cyrillic-ext-ACWDZ3VD.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:800;src:url(https://app.framerstatic.com/Inter-ExtraBoldItalic.cyrillic-ZKBSDAI2.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:800;src:url(https://app.framerstatic.com/Inter-ExtraBoldItalic.greek-ext-3CY5DPTP.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:800;src:url(https://app.framerstatic.com/Inter-ExtraBoldItalic.greek-YL5CC63W.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:800;src:url(https://app.framerstatic.com/Inter-ExtraBoldItalic.latin-ext-7IZFJI4D.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:800;src:url(https://app.framerstatic.com/Inter-ExtraBoldItalic.latin-O5HH4IX3.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:800;src:url(https://app.framerstatic.com/Inter-ExtraBoldItalic.vietnamese-UW3XUJOD.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:900;src:url(https://app.framerstatic.com/Inter-BlackItalic.cyrillic-ext-TRM4ITYR.woff2) format("woff2");unicode-range:U+0460-052F,U+1C80-1C88,U+20B4,U+2DE0-2DFF,U+A640-A69F,U+FE2E-FE2F}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:900;src:url(https://app.framerstatic.com/Inter-BlackItalic.cyrillic-FPHIQVZS.woff2) format("woff2");unicode-range:U+0301,U+0400-045F,U+0490-0491,U+04B0-04B1,U+2116}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:900;src:url(https://app.framerstatic.com/Inter-BlackItalic.greek-ext-JTGUUSP5.woff2) format("woff2");unicode-range:U+1F00-1FFF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:900;src:url(https://app.framerstatic.com/Inter-BlackItalic.greek-LUNA3RFO.woff2) format("woff2");unicode-range:U+0370-03FF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:900;src:url(https://app.framerstatic.com/Inter-BlackItalic.latin-ext-KU7ICFYH.woff2) format("woff2");unicode-range:U+0100-024F,U+0259,U+1E00-1EFF,U+2020,U+20A0-20AB,U+20AD-20CF,U+2113,U+2C60-2C7F,U+A720-A7FF}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:900;src:url(https://app.framerstatic.com/Inter-BlackItalic.latin-FRVXWQSB.woff2) format("woff2");unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD}@font-face{font-display:block;font-family:Inter;font-style:italic;font-weight:900;src:url(https://app.framerstatic.com/Inter-BlackItalic.vietnamese-2Q7MQKJX.woff2) format("woff2");unicode-range:U+0102-0103,U+0110-0111,U+0128-0129,U+0168-0169,U+01A0-01A1,U+01AF-01B0,U+1EA0-1EF9,U+20AB}[data-framer-component-type]{position:absolute}[data-framer-component-type=Text]{cursor:inherit}[data-framer-component-text-autosized] *{white-space:pre}[data-framer-component-type=Text]>*{text-align:var(--framer-text-alignment, start)}[data-framer-component-type=Text] span span,[data-framer-component-type=Text] p span,[data-framer-component-type=Text] h1 span,[data-framer-component-type=Text] h2 span,[data-framer-component-type=Text] h3 span,[data-framer-component-type=Text] h4 span,[data-framer-component-type=Text] h5 span,[data-framer-component-type=Text] h6 span{display:block}[data-framer-component-type=Text] span span span,[data-framer-component-type=Text] p span span,[data-framer-component-type=Text] h1 span span,[data-framer-component-type=Text] h2 span span,[data-framer-component-type=Text] h3 span span,[data-framer-component-type=Text] h4 span span,[data-framer-component-type=Text] h5 span span,[data-framer-component-type=Text] h6 span span{display:unset}[data-framer-component-type=Text] div div span,[data-framer-component-type=Text] a div span,[data-framer-component-type=Text] span span span,[data-framer-component-type=Text] p span span,[data-framer-component-type=Text] h1 span span,[data-framer-component-type=Text] h2 span span,[data-framer-component-type=Text] h3 span span,[data-framer-component-type=Text] h4 span span,[data-framer-component-type=Text] h5 span span,[data-framer-component-type=Text] h6 span span,[data-framer-component-type=Text] a{font-family:var(--font-family);font-style:var(--font-style);font-weight:min(calc(var(--framer-font-weight-increase, 0) + var(--font-weight, 400)),900);color:var(--text-color);letter-spacing:var(--letter-spacing);font-size:var(--font-size);text-transform:var(--text-transform);text-decoration:var(--text-decoration);line-height:var(--line-height)}[data-framer-component-type=Text] div div span,[data-framer-component-type=Text] a div span,[data-framer-component-type=Text] span span span,[data-framer-component-type=Text] p span span,[data-framer-component-type=Text] h1 span span,[data-framer-component-type=Text] h2 span span,[data-framer-component-type=Text] h3 span span,[data-framer-component-type=Text] h4 span span,[data-framer-component-type=Text] h5 span span,[data-framer-component-type=Text] h6 span span,[data-framer-component-type=Text] a{--font-family: var(--framer-font-family);--font-style: var(--framer-font-style);--font-weight: var(--framer-font-weight);--text-color: var(--framer-text-color);--letter-spacing: var(--framer-letter-spacing);--font-size: var(--framer-font-size);--text-transform: var(--framer-text-transform);--text-decoration: var(--framer-text-decoration);--line-height: var(--framer-line-height)}[data-framer-component-type=Text] a,[data-framer-component-type=Text] a div span,[data-framer-component-type=Text] a span span span,[data-framer-component-type=Text] a p span span,[data-framer-component-type=Text] a h1 span span,[data-framer-component-type=Text] a h2 span span,[data-framer-component-type=Text] a h3 span span,[data-framer-component-type=Text] a h4 span span,[data-framer-component-type=Text] a h5 span span,[data-framer-component-type=Text] a h6 span span{--font-family: var(--framer-link-font-family, var(--framer-font-family));--font-style: var(--framer-link-font-style, var(--framer-font-style));--font-weight: var(--framer-link-font-weight, var(--framer-font-weight));--text-color: var(--framer-link-text-color, var(--framer-text-color));--font-size: var(--framer-link-font-size, var(--framer-font-size));--text-transform: var(--framer-link-text-transform, var(--framer-text-transform));--text-decoration: var(--framer-link-text-decoration, var(--framer-text-decoration))}[data-framer-component-type=Text] a:hover,[data-framer-component-type=Text] a div span:hover,[data-framer-component-type=Text] a span span span:hover,[data-framer-component-type=Text] a p span span:hover,[data-framer-component-type=Text] a h1 span span:hover,[data-framer-component-type=Text] a h2 span span:hover,[data-framer-component-type=Text] a h3 span span:hover,[data-framer-component-type=Text] a h4 span span:hover,[data-framer-component-type=Text] a h5 span span:hover,[data-framer-component-type=Text] a h6 span span:hover{--font-family: var(--framer-link-hover-font-family, var(--framer-link-font-family, var(--framer-font-family)));--font-style: var(--framer-link-hover-font-style, var(--framer-link-font-style, var(--framer-font-style)));--font-weight: var(--framer-link-hover-font-weight, var(--framer-link-font-weight, var(--framer-font-weight)));--text-color: var(--framer-link-hover-text-color, var(--framer-link-text-color, var(--framer-text-color)));--font-size: var(--framer-link-hover-font-size, var(--framer-link-font-size, var(--framer-font-size)));--text-transform: var(--framer-link-hover-text-transform, var(--framer-link-text-transform, var(--framer-text-transform)));--text-decoration: var(--framer-link-hover-text-decoration, var(--framer-link-text-decoration, var(--framer-text-decoration)))}[data-framer-component-type=Text].isCurrent a,[data-framer-component-type=Text].isCurrent a div span,[data-framer-component-type=Text].isCurrent a span span span,[data-framer-component-type=Text].isCurrent a p span span,[data-framer-component-type=Text].isCurrent a h1 span span,[data-framer-component-type=Text].isCurrent a h2 span span,[data-framer-component-type=Text].isCurrent a h3 span span,[data-framer-component-type=Text].isCurrent a h4 span span,[data-framer-component-type=Text].isCurrent a h5 span span,[data-framer-component-type=Text].isCurrent a h6 span span{--font-family: var(--framer-link-current-font-family, var(--framer-link-font-family, var(--framer-font-family)));--font-style: var(--framer-link-current-font-style, var(--framer-link-font-style, var(--framer-font-style)));--font-weight: var(--framer-link-current-font-weight, var(--framer-link-font-weight, var(--framer-font-weight)));--text-color: var(--framer-link-current-text-color, var(--framer-link-text-color, var(--framer-text-color)));--font-size: var(--framer-link-current-font-size, var(--framer-link-font-size, var(--framer-font-size)));--text-transform: var(--framer-link-current-text-transform, var(--framer-link-text-transform, var(--framer-text-transform)));--text-decoration: var(--framer-link-current-text-decoration, var(--framer-link-text-decoration, var(--framer-text-decoration)))}p.framer-text,div.framer-text,h1.framer-text,h2.framer-text,h3.framer-text,h4.framer-text,h5.framer-text,h6.framer-text,ol.framer-text,ul.framer-text{margin:0;padding:0}p.framer-text,div.framer-text,h1.framer-text,h2.framer-text,h3.framer-text,h4.framer-text,h5.framer-text,h6.framer-text,li.framer-text,ol.framer-text,ul.framer-text,span.framer-text:not([data-text-fill]){font-family:var(--framer-font-family, Inter, Inter Placeholder, sans-serif);font-style:var(--framer-font-style, normal);font-weight:var(--framer-font-weight, 400);color:var(--framer-text-color, #000);font-size:calc(var(--framer-font-size, 16px) * var(--framer-font-size-scale, 1));letter-spacing:var(--framer-letter-spacing, 0);text-transform:var(--framer-text-transform, none);text-decoration:var(--framer-text-decoration, none);line-height:var(--framer-line-height, 1.2em);text-align:var(--framer-text-alignment, start)}strong.framer-text{font-family:var(--framer-font-family-bold);font-style:var(--framer-font-style-bold);font-weight:var(--framer-font-weight-bold, bolder)}em.framer-text{font-family:var(--framer-font-family-italic);font-style:var(--framer-font-style-italic, italic);font-weight:var(--framer-font-weight-italic)}em.framer-text>strong.framer-text{font-family:var(--framer-font-family-bold-italic);font-style:var(--framer-font-style-bold-italic, italic);font-weight:var(--framer-font-weight-bold-italic, bolder)}p.framer-text:not(:first-child),div.framer-text:not(:first-child),h1.framer-text:not(:first-child),h2.framer-text:not(:first-child),h3.framer-text:not(:first-child),h4.framer-text:not(:first-child),h5.framer-text:not(:first-child),h6.framer-text:not(:first-child),ol.framer-text:not(:first-child),ul.framer-text:not(:first-child),.framer-image.framer-text:not(:first-child){margin-top:var(--framer-paragraph-spacing, 0)}li.framer-text>ul.framer-text:nth-child(2),li.framer-text>ol.framer-text:nth-child(2){margin-top:0}.framer-text[data-text-fill]{display:inline-block;background-clip:text;-webkit-background-clip:text;-webkit-text-fill-color:transparent;padding:max(0em,calc(calc(1.3em - var(--framer-line-height, 1.3em)) / 2));margin:min(0em,calc(calc(1.3em - var(--framer-line-height, 1.3em)) / -2))}code.framer-text,code.framer-text span.framer-text:not([data-text-fill]){font-family:var(--framer-code-font-family, var(--framer-font-family, Inter, Inter Placeholder, sans-serif));font-style:var(--framer-code-font-style, var(--framer-font-style, normal));font-weight:var(--framer-code-font-weight, var(--framer-font-weight, 400));color:var(--framer-code-text-color, var(--framer-text-color, #000));font-size:calc(var(--framer-font-size, 16px) * var(--framer-font-size-scale, 1));letter-spacing:var(--framer-letter-spacing, 0);line-height:var(--framer-line-height, 1.2em)}a.framer-text,a.framer-text span.framer-text:not([data-text-fill]){font-family:var(--framer-link-font-family, var(--framer-font-family, Inter, Inter Placeholder, sans-serif));font-style:var(--framer-link-font-style, var(--framer-font-style, normal));font-weight:var(--framer-link-font-weight, var(--framer-font-weight, 400));color:var(--framer-link-text-color, var(--framer-text-color, #000));font-size:calc(var(--framer-link-font-size, var(--framer-font-size, 16px)) * var(--framer-font-size-scale, 1));text-transform:var(--framer-link-text-transform, var(--framer-text-transform, none));text-decoration:var(--framer-link-text-decoration, var(--framer-text-decoration, none));cursor:var(--framer-custom-cursors, pointer)}code.framer-text a.framer-text,code.framer-text a.framer-text span.framer-text:not([data-text-fill]){font-family:var(--framer-code-font-family, var(--framer-font-family, Inter, Inter Placeholder, sans-serif));font-style:var(--framer-code-font-style, var(--framer-font-style, normal));font-weight:var(--framer-code-font-weight, var(--framer-font-weight, 400));color:var(--framer-link-text-color, var(--framer-code-text-color, var(--framer-text-color, #000)));font-size:calc(var(--framer-link-font-size, var(--framer-font-size, 16px)) * var(--framer-font-size-scale, 1))}a.framer-text:hover,a.framer-text:hover span.framer-text:not([data-text-fill]){font-family:var(--framer-link-hover-font-family, var(--framer-link-font-family, var(--framer-font-family, Inter, Inter Placeholder, sans-serif)));font-style:var(--framer-link-hover-font-style, var(--framer-link-font-style, var(--framer-font-style, normal)));font-weight:var(--framer-link-hover-font-weight, var(--framer-link-font-weight, var(--framer-font-weight, 400)));color:var(--framer-link-hover-text-color, var(--framer-link-text-color, var(--framer-text-color, #000)));font-size:calc(var(--framer-link-hover-font-size, var(--framer-link-font-size, var(--framer-font-size, 16px))) * var(--framer-font-size-scale, 1));text-transform:var(--framer-link-hover-text-transform, var(--framer-link-text-transform, var(--framer-text-transform, none)));text-decoration:var(--framer-link-hover-text-decoration, var(--framer-link-text-decoration, var(--framer-text-decoration, none)))}code.framer-text a.framer-text:hover,code.framer-text a.framer-text:hover span.framer-text:not([data-text-fill]){font-family:var(--framer-code-font-family, var(--framer-font-family, Inter, Inter Placeholder, sans-serif));font-style:var(--framer-code-font-style, var(--framer-font-style, normal));font-weight:var(--framer-code-font-weight, var(--framer-font-weight, 400));color:var(--framer-link-hover-text-color, var(--framer-link-text-color, var(--framer-code-text-color, var(--framer-text-color, #000))));font-size:calc(var(--framer-link-hover-font-size, var(--framer-link-font-size, var(--framer-font-size, 16px))) * var(--framer-font-size-scale, 1))}a.framer-text[data-framer-page-link-current],a.framer-text[data-framer-page-link-current] span.framer-text:not([data-text-fill]){font-family:var(--framer-link-current-font-family, var(--framer-link-font-family, var(--framer-font-family, Inter, Inter Placeholder, sans-serif)));font-style:var(--framer-link-current-font-style, var(--framer-link-font-style, var(--framer-font-style, normal)));font-weight:var(--framer-link-current-font-weight, var(--framer-link-font-weight, var(--framer-font-weight, 400)));color:var(--framer-link-current-text-color, var(--framer-link-text-color, var(--framer-text-color, #000)));font-size:calc(var(--framer-link-current-font-size, var(--framer-link-font-size, var(--framer-font-size, 16px))) * var(--framer-font-size-scale, 1));text-transform:var(--framer-link-current-text-transform, var(--framer-link-text-transform, var(--framer-text-transform, none)));text-decoration:var(--framer-link-current-text-decoration, var(--framer-link-text-decoration, var(--framer-text-decoration, none)))}code.framer-text a.framer-text[data-framer-page-link-current],code.framer-text a.framer-text[data-framer-page-link-current] span.framer-text:not([data-text-fill]){font-family:var(--framer-code-font-family, var(--framer-font-family, Inter, Inter Placeholder, sans-serif));font-style:var(--framer-code-font-style, var(--framer-font-style, normal));font-weight:var(--framer-code-font-weight, var(--framer-font-weight, 400));color:var(--framer-link-current-text-color, var(--framer-link-text-color, var(--framer-code-text-color, var(--framer-text-color, #000))));font-size:calc(var(--framer-link-current-font-size, var(--framer-link-font-size, var(--framer-font-size, 16px))) * var(--framer-font-size-scale, 1))}a.framer-text[data-framer-page-link-current]:hover,a.framer-text[data-framer-page-link-current]:hover span.framer-text:not([data-text-fill]){font-family:var(--framer-link-hover-font-family, var(--framer-link-current-font-family, var(--framer-link-font-family, var(--framer-font-family, Inter, Inter Placeholder, sans-serif))));font-style:var(--framer-link-hover-font-style, var(--framer-link-current-font-style, var(--framer-link-font-style, var(--framer-font-style, normal))));font-weight:var(--framer-link-hover-font-weight, var(--framer-link-current-font-weight, var(--framer-link-font-weight, var(--framer-font-weight, 400))));color:var(--framer-link-hover-text-color, var(--framer-link-current-text-color, var(--framer-link-text-color, var(--framer-text-color, #000))));font-size:calc(var(--framer-link-hover-font-size, var(--framer-link-current-font-size, var(--framer-link-font-size, var(--framer-font-size, 16px)))) * var(--framer-font-size-scale, 1));text-transform:var(--framer-link-hover-text-transform, var(--framer-link-current-text-transform, var(--framer-link-text-transform, var(--framer-text-transform, none))));text-decoration:var(--framer-link-hover-text-decoration, var(--framer-link-current-text-decoration, var(--framer-link-text-decoration, var(--framer-text-decoration, none))))}code.framer-text a.framer-text[data-framer-page-link-current]:hover,code.framer-text a.framer-text[data-framer-page-link-current]:hover span.framer-text:not([data-text-fill]){font-family:var(--framer-code-font-family, var(--framer-font-family, Inter, Inter Placeholder, sans-serif));font-style:var(--framer-code-font-style, var(--framer-font-style, normal));font-weight:var(--framer-code-font-weight, var(--framer-font-weight, 400));color:var(--framer-link-hover-text-color, var(--framer-link-current-text-color, var(--framer-link-text-color, var(--framer-code-text-color, var(--framer-text-color, #000)))));font-size:calc(var(--framer-link-hover-font-size, var(--framer-link-current-font-size, var(--framer-link-font-size, var(--framer-font-size, 16px)))) * var(--framer-font-size-scale, 1))}.framer-image.framer-text{display:block;max-width:100%;height:auto}.text-styles-preset-reset.framer-text{--framer-font-family: Inter, Inter Placeholder, sans-serif;--framer-font-style: normal;--framer-font-weight: 500;--framer-text-color: #000;--framer-font-size: 16px;--framer-letter-spacing: 0;--framer-text-transform: none;--framer-text-decoration: none;--framer-line-height: 1.2em;--framer-text-alignment: start}ul.framer-text,ol.framer-text{display:table;width:100%}li.framer-text{display:table-row;counter-increment:list-item;list-style:none}ol.framer-text>li.framer-text:before{display:table-cell;width:2.25ch;box-sizing:border-box;padding-inline-end:.75ch;content:counter(list-item) ".";white-space:nowrap}ul.framer-text>li.framer-text:before{display:table-cell;width:2.25ch;box-sizing:border-box;padding-inline-end:.75ch;content:"\2022"}.framer-text-module[style*=aspect-ratio]>:first-child{width:100%}@supports not (aspect-ratio: 1){.framer-text-module[style*=aspect-ratio]{position:relative}}@supports not (aspect-ratio: 1){.framer-text-module[style*=aspect-ratio]:before{content:"";display:block;padding-bottom:calc(100% / calc(var(--aspect-ratio)))}}@supports not (aspect-ratio: 1){.framer-text-module[style*=aspect-ratio]>:first-child{position:absolute;top:0;left:0;height:100%}}[data-framer-component-type=DeprecatedRichText]{cursor:inherit}[data-framer-component-type=DeprecatedRichText] .text-styles-preset-reset{--framer-font-family: Inter, Inter Placeholder, sans-serif;--framer-font-style: normal;--framer-font-weight: 500;--framer-text-color: #000;--framer-font-size: 16px;--framer-letter-spacing: 0;--framer-text-transform: none;--framer-text-decoration: none;--framer-line-height: 1.2em;--framer-text-alignment: start}[data-framer-component-type=DeprecatedRichText] p,[data-framer-component-type=DeprecatedRichText] div,[data-framer-component-type=DeprecatedRichText] h1,[data-framer-component-type=DeprecatedRichText] h2,[data-framer-component-type=DeprecatedRichText] h3,[data-framer-component-type=DeprecatedRichText] h4,[data-framer-component-type=DeprecatedRichText] h5,[data-framer-component-type=DeprecatedRichText] h6{margin:0;padding:0}[data-framer-component-type=DeprecatedRichText] p,[data-framer-component-type=DeprecatedRichText] div,[data-framer-component-type=DeprecatedRichText] h1,[data-framer-component-type=DeprecatedRichText] h2,[data-framer-component-type=DeprecatedRichText] h3,[data-framer-component-type=DeprecatedRichText] h4,[data-framer-component-type=DeprecatedRichText] h5,[data-framer-component-type=DeprecatedRichText] h6,[data-framer-component-type=DeprecatedRichText] li,[data-framer-component-type=DeprecatedRichText] ol,[data-framer-component-type=DeprecatedRichText] ul,[data-framer-component-type=DeprecatedRichText] span:not([data-text-fill]){font-family:var(--framer-font-family, Inter, Inter Placeholder, sans-serif);font-style:var(--framer-font-style, normal);font-weight:var(--framer-font-weight, 400);color:var(--framer-text-color, #000);font-size:var(--framer-font-size, 16px);letter-spacing:var(--framer-letter-spacing, 0);text-transform:var(--framer-text-transform, none);text-decoration:var(--framer-text-decoration, none);line-height:var(--framer-line-height, 1.2em);text-align:var(--framer-text-alignment, start)}[data-framer-component-type=DeprecatedRichText] p:not(:first-child),[data-framer-component-type=DeprecatedRichText] div:not(:first-child),[data-framer-component-type=DeprecatedRichText] h1:not(:first-child),[data-framer-component-type=DeprecatedRichText] h2:not(:first-child),[data-framer-component-type=DeprecatedRichText] h3:not(:first-child),[data-framer-component-type=DeprecatedRichText] h4:not(:first-child),[data-framer-component-type=DeprecatedRichText] h5:not(:first-child),[data-framer-component-type=DeprecatedRichText] h6:not(:first-child),[data-framer-component-type=DeprecatedRichText] ol:not(:first-child),[data-framer-component-type=DeprecatedRichText] ul:not(:first-child),[data-framer-component-type=DeprecatedRichText] .framer-image:not(:first-child){margin-top:var(--framer-paragraph-spacing, 0)}[data-framer-component-type=DeprecatedRichText] span[data-text-fill]{display:inline-block;background-clip:text;-webkit-background-clip:text;-webkit-text-fill-color:transparent}[data-framer-component-type=DeprecatedRichText] a,[data-framer-component-type=DeprecatedRichText] a span:not([data-text-fill]){font-family:var(--framer-link-font-family, var(--framer-font-family, Inter, Inter Placeholder, sans-serif));font-style:var(--framer-link-font-style, var(--framer-font-style, normal));font-weight:var(--framer-link-font-weight, var(--framer-font-weight, 400));color:var(--framer-link-text-color, var(--framer-text-color, #000));font-size:var(--framer-link-font-size, var(--framer-font-size, 16px));text-transform:var(--framer-link-text-transform, var(--framer-text-transform, none));text-decoration:var(--framer-link-text-decoration, var(--framer-text-decoration, none))}[data-framer-component-type=DeprecatedRichText] a:hover,[data-framer-component-type=DeprecatedRichText] a:hover span:not([data-text-fill]){font-family:var(--framer-link-hover-font-family, var(--framer-link-font-family, var(--framer-font-family, Inter, Inter Placeholder, sans-serif)));font-style:var(--framer-link-hover-font-style, var(--framer-link-font-style, var(--framer-font-style, normal)));font-weight:var(--framer-link-hover-font-weight, var(--framer-link-font-weight, var(--framer-font-weight, 400)));color:var(--framer-link-hover-text-color, var(--framer-link-text-color, var(--framer-text-color, #000)));font-size:var(--framer-link-hover-font-size, var(--framer-link-font-size, var(--framer-font-size, 16px)));text-transform:var(--framer-link-hover-text-transform, var(--framer-link-text-transform, var(--framer-text-transform, none)));text-decoration:var(--framer-link-hover-text-decoration, var(--framer-link-text-decoration, var(--framer-text-decoration, none)))}a[data-framer-page-link-current],a[data-framer-page-link-current] span:not([data-text-fill]){font-family:var(--framer-link-current-font-family, var(--framer-link-font-family, var(--framer-font-family, Inter, Inter Placeholder, sans-serif)));font-style:var(--framer-link-current-font-style, var(--framer-link-font-style, var(--framer-font-style, normal)));font-weight:var(--framer-link-current-font-weight, var(--framer-link-font-weight, var(--framer-font-weight, 400)));color:var(--framer-link-current-text-color, var(--framer-link-text-color, var(--framer-text-color, #000)));font-size:var(--framer-link-current-font-size, var(--framer-link-font-size, var(--framer-font-size, 16px)));text-transform:var(--framer-link-current-text-transform, var(--framer-link-text-transform, var(--framer-text-transform, none)));text-decoration:var(--framer-link-current-text-decoration, var(--framer-link-text-decoration, var(--framer-text-decoration, none)))}a[data-framer-page-link-current]:hover,a[data-framer-page-link-current]:hover span:not([data-text-fill]){font-family:var(--framer-link-hover-font-family, var(--framer-link-current-font-family, var(--framer-link-font-family, var(--framer-font-family, Inter, Inter Placeholder, sans-serif))));font-style:var(--framer-link-hover-font-style, var(--framer-link-current-font-style, var(--framer-link-font-style, var(--framer-font-style, normal))));font-weight:var(--framer-link-hover-font-weight, var(--framer-link-current-font-weight, var(--framer-link-font-weight, var(--framer-font-weight, 400))));color:var(--framer-link-hover-text-color, var(--framer-link-current-text-color, var(--framer-link-text-color, var(--framer-text-color, #000))));font-size:var(--framer-link-hover-font-size, var(--framer-link-current-font-size, var(--framer-link-font-size, var(--framer-font-size, 16px))));text-transform:var(--framer-link-hover-text-transform, var(--framer-link-current-text-transform, var(--framer-link-text-transform, var(--framer-text-transform, none))));text-decoration:var(--framer-link-hover-text-decoration, var(--framer-link-current-text-decoration, var(--framer-link-text-decoration, var(--framer-text-decoration, none))))}[data-framer-component-type=DeprecatedRichText] strong{font-weight:bolder}[data-framer-component-type=DeprecatedRichText] em{font-style:italic}[data-framer-component-type=DeprecatedRichText] .framer-image{display:block;max-width:100%;height:auto}[data-framer-component-type=DeprecatedRichText] ul,[data-framer-component-type=DeprecatedRichText] ol{display:table;width:100%;padding-left:0;margin:0}[data-framer-component-type=DeprecatedRichText] li{display:table-row;counter-increment:list-item;list-style:none}[data-framer-component-type=DeprecatedRichText] ol>li:before{display:table-cell;width:2.25ch;box-sizing:border-box;padding-right:.75ch;content:counter(list-item) ".";white-space:nowrap}[data-framer-component-type=DeprecatedRichText] ul>li:before{display:table-cell;width:2.25ch;box-sizing:border-box;padding-right:.75ch;content:"\2022"}:not([data-framer-generated])>[data-framer-stack-content-wrapper]>*,:not([data-framer-generated])>[data-framer-stack-content-wrapper]>[data-framer-component-type],:not([data-framer-generated])>[data-framer-stack-content-wrapper]>[data-framer-legacy-stack-gap-enabled]>*,:not([data-framer-generated])>[data-framer-stack-content-wrapper]>[data-framer-legacy-stack-gap-enabled]>[data-framer-component-type]{position:relative}.flexbox-gap-not-supported [data-framer-legacy-stack-gap-enabled=true]>*,[data-framer-legacy-stack-gap-enabled=true][data-framer-stack-flexbox-gap=false]{margin-top:calc(var(--stack-gap-y) / 2);margin-bottom:calc(var(--stack-gap-y) / 2);margin-right:calc(var(--stack-gap-x) / 2);margin-left:calc(var(--stack-gap-x) / 2)}[data-framer-stack-content-wrapper][data-framer-stack-gap-enabled=true]{row-gap:var(--stack-native-row-gap);column-gap:var(--stack-native-column-gap)}.flexbox-gap-not-supported [data-framer-stack-content-wrapper][data-framer-stack-gap-enabled=true]{row-gap:unset;column-gap:unset}.flexbox-gap-not-supported [data-framer-stack-direction-reverse=false] [data-framer-legacy-stack-gap-enabled=true]>*:first-child,[data-framer-stack-direction-reverse=false] [data-framer-legacy-stack-gap-enabled=true][data-framer-stack-flexbox-gap=false]>*:first-child,.flexbox-gap-not-supported [data-framer-stack-direction-reverse=true] [data-framer-legacy-stack-gap-enabled=true]>*:last-child,[data-framer-stack-direction-reverse=true] [data-framer-legacy-stack-gap-enabled=true][data-framer-stack-flexbox-gap=false]>*:last-child{margin-top:0;margin-left:0}.flexbox-gap-not-supported [data-framer-stack-direction-reverse=false] [data-framer-legacy-stack-gap-enabled=true]>*:last-child,[data-framer-stack-direction-reverse=false] [data-framer-legacy-stack-gap-enabled=true][data-framer-stack-flexbox-gap=false]>*:last-child,.flexbox-gap-not-supported [data-framer-stack-direction-reverse=true] [data-framer-legacy-stack-gap-enabled=true]>*:first-child,[data-framer-stack-direction-reverse=true] [data-framer-legacy-stack-gap-enabled=true][data-framer-stack-flexbox-gap=false]>*:first-child{margin-right:0;margin-bottom:0}NavigationContainer [data-framer-component-type=NavigationContainer]>*,[data-framer-component-type=NavigationContainer]>[data-framer-component-type]{position:relative}[data-framer-component-type=Scroll]::-webkit-scrollbar{display:none}[data-framer-component-type=ScrollContentWrapper]>*{position:relative}[data-framer-component-type=NativeScroll]{-webkit-overflow-scrolling:touch}[data-framer-component-type=NativeScroll]>*{position:relative}[data-framer-component-type=NativeScroll].direction-both{overflow-x:scroll;overflow-y:scroll}[data-framer-component-type=NativeScroll].direction-vertical{overflow-x:hidden;overflow-y:scroll}[data-framer-component-type=NativeScroll].direction-horizontal{overflow-x:scroll;overflow-y:hidden}[data-framer-component-type=NativeScroll].direction-vertical>*{width:100%!important}[data-framer-component-type=NativeScroll].direction-horizontal>*{height:100%!important}[data-framer-component-type=NativeScroll].scrollbar-hidden::-webkit-scrollbar{display:none}[data-framer-component-type=PageContentWrapper]>*,[data-framer-component-type=PageContentWrapper]>[data-framer-component-type]{position:relative}[data-framer-component-type=DeviceComponent].no-device>*{width:100%!important;height:100%!important}[data-is-present=false],[data-is-present=false] *{pointer-events:none!important}[data-framer-cursor=pointer]{cursor:pointer}[data-framer-cursor=grab]{cursor:grab}[data-framer-cursor=grab]:active{cursor:grabbing}[data-framer-component-type=Frame] *,[data-framer-component-type=Stack] *{pointer-events:auto}[data-framer-generated] *{pointer-events:unset}.svgContainer svg{display:block}[data-reset=button]{border-width:0;padding:0;background:none}[data-hide-scrollbars=true]::-webkit-scrollbar{width:0px;height:0px}[data-hide-scrollbars=true]::-webkit-scrollbar-thumb{background:transparent}.framer-pACsf [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-body-augiA20Il{background:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(238, 233, 228))}.framer-pACsf .framer-lux5qc{display:block}.framer-pACsf .framer-72rtr7{align-content:center;align-items:center;background-color:var(--token-25b49406-73f2-421a-adb7-81b18f488918, #eee9e4);display:flex;flex-direction:column;flex-wrap:nowrap;gap:0px;height:min-content;justify-content:flex-start;overflow:visible;padding:0;position:relative;width:1400px}.framer-pACsf .framer-piijv0-container{flex:none;height:auto;position:relative;width:100%;z-index:10}.framer-pACsf .framer-1g2ju43{align-content:center;align-items:center;background:linear-gradient(180deg,var(--token-25b49406-73f2-421a-adb7-81b18f488918, #fdf2ec) 0%,var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255)) 100%);display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:0px;height:min-content;justify-content:center;overflow:hidden;padding:100px 0 0;position:relative;width:100%}.framer-pACsf .framer-8f3uib{align-content:center;align-items:center;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:80px;height:min-content;justify-content:center;max-width:1200px;overflow:hidden;padding:0;position:relative;width:90%}.framer-pACsf .framer-1c1y0hg{align-content:center;align-items:center;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:0px;height:min-content;justify-content:center;overflow:visible;padding:0 0 10px;position:relative;width:100%}.framer-pACsf .framer-1hyemqj{align-content:center;align-items:center;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:8px;height:min-content;justify-content:center;max-width:1200px;overflow:hidden;padding:0 0 30px;position:relative;transform:perspective(1200px);width:100%}.framer-pACsf .framer-vhthrs-container,.framer-pACsf .framer-1t3qw2v-container,.framer-pACsf .framer-ztvmem-container,.framer-pACsf .framer-npbiqa-container,.framer-pACsf .framer-1l14qh3-container,.framer-pACsf .framer-1hsyw3u-container,.framer-pACsf .framer-wmr7d4-container,.framer-pACsf .framer-54ls01-container,.framer-pACsf .framer-vsn5kf-container{flex:none;height:auto;position:relative;width:auto}.framer-pACsf .framer-zvqr6c{--framer-link-text-color: #0099ff;--framer-link-text-decoration: underline;--framer-paragraph-spacing: 0px;flex:none;height:auto;overflow:visible;position:relative;white-space:pre-wrap;width:100%;word-break:break-word;word-wrap:break-word;z-index:1}.framer-pACsf .framer-15dce9y{--framer-paragraph-spacing: 0px;flex:none;height:auto;max-width:700px;overflow:visible;position:relative;transform:perspective(1200px);white-space:pre-wrap;width:60%;word-break:break-word;word-wrap:break-word;z-index:3}.framer-pACsf .framer-1febxrw{align-content:center;align-items:center;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:24px;height:min-content;justify-content:center;overflow:visible;padding:30px 0 0;position:relative;transform:perspective(1200px);width:min-content;z-index:1}.framer-pACsf .framer-19oy2xt-container,.framer-pACsf .framer-1yi82id-container{flex:none;height:56px;position:relative;width:211px}.framer-pACsf .framer-bujhiz-container{flex:none;height:56px;position:relative;width:auto}.framer-pACsf .framer-1xg95ak{align-content:center;align-items:center;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:10px;height:824px;justify-content:center;overflow:hidden;padding:60px 0 100px;position:relative;width:90%}.framer-pACsf .framer-1hc0e4d{align-content:center;align-items:center;border-radius:27px;box-shadow:0 .6021873017743928px .36131238106463576px -.9166666666666666px #fafcff14,0 2.288533303243457px 1.3731199819460744px -1.8333333333333333px #fafcff14,0 10px 6.000000000000001px -2.75px #fafcff11,0 34px 30px -16px #e3e7ed;display:flex;flex:1 0 0px;flex-direction:column;flex-wrap:nowrap;gap:10px;height:1px;justify-content:center;max-width:1200px;overflow:hidden;padding:0;position:relative;transform:perspective(1200px);width:100%;will-change:transform;z-index:1}.framer-pACsf .framer-cpr011{align-content:center;align-items:center;background-color:#fff;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:50px;height:min-content;justify-content:center;overflow:hidden;padding:80px 0 120px;position:relative;width:100%}.framer-pACsf .framer-4d1i2v,.framer-pACsf .framer-1wrfpcj{align-content:center;align-items:center;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:60px;height:min-content;justify-content:center;max-width:1200px;overflow:hidden;padding:0;position:relative;width:90%}.framer-pACsf .framer-hnhq2k,.framer-pACsf .framer-1286ntv{align-content:center;align-items:center;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:20px;height:min-content;justify-content:center;overflow:hidden;padding:0;position:relative;width:100%}.framer-pACsf .framer-9cdg7p,.framer-pACsf .framer-126mjd9,.framer-pACsf .framer-15p3n3o{--framer-link-text-color: #0099ff;--framer-link-text-decoration: underline;--framer-paragraph-spacing: 0px;flex:none;height:auto;max-width:1200px;position:relative;transform:perspective(1200px);white-space:pre-wrap;width:100%;word-break:break-word;word-wrap:break-word;z-index:1}.framer-pACsf .framer-ukor2f{--framer-paragraph-spacing: 0px;flex:none;height:auto;max-width:600px;overflow:visible;position:relative;white-space:pre-wrap;width:100%;word-break:break-word;word-wrap:break-word;z-index:3}.framer-pACsf .framer-1f37ktk{align-content:flex-start;align-items:flex-start;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:40px;height:min-content;justify-content:center;overflow:visible;padding:0;position:relative;width:100%}.framer-pACsf .framer-4yt290-container{flex:none;height:auto;max-width:750px;position:relative;transform:perspective(1200px);width:47%}.framer-pACsf .framer-1rkd6ro-container{flex:none;height:auto;max-width:750px;position:relative;transform:perspective(1200px);width:50%}.framer-pACsf .framer-1irddqm{display:grid;flex:none;gap:40px;grid-auto-rows:minmax(0,1fr);grid-template-columns:repeat(3,minmax(200px,1fr));grid-template-rows:repeat(1,minmax(0,1fr));height:min-content;justify-content:center;overflow:visible;padding:0;position:relative;width:100%}.framer-pACsf .framer-yfbogm-container,.framer-pACsf .framer-14gm12y-container,.framer-pACsf .framer-1w8iix2-container{align-self:start;flex:none;height:100%;justify-self:start;position:relative;transform:perspective(1200px);width:100%}.framer-pACsf .framer-1vgtvbt{align-content:center;align-items:center;background-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, #07061b);display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:80px;height:min-content;justify-content:flex-start;overflow:hidden;padding:120px 0;position:relative;transform:perspective(1200px);width:100%}.framer-pACsf .framer-6b3l05{align-content:flex-start;align-items:flex-start;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:20px;height:min-content;justify-content:center;overflow:hidden;padding:0;position:relative;width:100%}.framer-pACsf .framer-1lhoc99,.framer-pACsf .framer-1ua56ph{--framer-link-text-color: #0099ff;--framer-link-text-decoration: underline;--framer-paragraph-spacing: 0px;flex:none;height:auto;max-width:1200px;overflow:visible;position:relative;transform:perspective(1200px);white-space:pre-wrap;width:100%;word-break:break-word;word-wrap:break-word;z-index:1}.framer-pACsf .framer-nxqp8w,.framer-pACsf .framer-ml4sbc{--framer-paragraph-spacing: 0px;flex:none;height:auto;max-width:550px;overflow:visible;position:relative;white-space:pre-wrap;width:60%;word-break:break-word;word-wrap:break-word;z-index:3}.framer-pACsf .framer-6qjmop{align-content:flex-start;align-items:flex-start;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:40px;height:min-content;justify-content:flex-start;overflow:visible;padding:0;position:relative;width:100%}.framer-pACsf .framer-m68jij-container,.framer-pACsf .framer-x6ivpm-container{align-self:stretch;flex:1 0 0px;height:auto;position:relative;transform:perspective(1200px);width:1px}.framer-pACsf .framer-n4m4v-container,.framer-pACsf .framer-yjy15x-container{flex:1 0 0px;height:auto;position:relative;transform:perspective(1200px);width:1px}.framer-pACsf .framer-19tcqvo{align-content:center;align-items:center;background-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, #07061b);display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:20px;height:min-content;justify-content:center;overflow:hidden;padding:100px 0 0;position:relative;width:100%}.framer-pACsf .framer-rwu701{align-content:center;align-items:center;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:60px;height:min-content;justify-content:center;max-width:1200px;overflow:hidden;padding:0;position:relative;width:95%}.framer-pACsf .framer-50o0lr{--framer-link-text-color: #0099ff;--framer-link-text-decoration: underline;--framer-paragraph-spacing: 0px;flex:none;height:auto;max-width:600px;position:relative;transform:perspective(1200px);white-space:pre-wrap;width:100%;word-break:break-word;word-wrap:break-word;z-index:1}.framer-pACsf .framer-jlqzes{--framer-paragraph-spacing: 0px;flex:none;height:auto;max-width:450px;overflow:visible;position:relative;white-space:pre-wrap;width:100%;word-break:break-word;word-wrap:break-word;z-index:3}.framer-pACsf .framer-1bpscfd{border-top-left-radius:30px;border-top-right-radius:30px;flex:none;height:273px;max-width:580px;overflow:visible;position:relative;transform:perspective(1200px);width:100%;z-index:1}.framer-pACsf .framer-1jcpmsn{align-content:center;align-items:center;bottom:0;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:10px;justify-content:center;left:calc(50.00000000000002% - 1319px / 2);overflow:hidden;padding:0;position:absolute;top:0;width:1319px;z-index:0}.framer-pACsf .framer-1mi0wzd-container{aspect-ratio:1 / 1;bottom:119px;flex:none;height:var(--framer-aspect-ratio-supported, 80px);left:0;position:absolute;width:80px;z-index:1}.framer-pACsf .framer-nc2gw-container{flex:none;height:65px;left:13px;position:absolute;top:90px;width:65px;z-index:1}.framer-pACsf .framer-15qwzes-container{flex:none;height:65px;left:30px;position:absolute;top:calc(45.597897503285175% - 65px / 2);width:65px;z-index:1}.framer-pACsf .framer-119alcv-container{aspect-ratio:1 / 1;flex:none;height:var(--framer-aspect-ratio-supported, 80px);left:167px;position:absolute;top:215px;width:80px;z-index:1}.framer-pACsf .framer-1u2vokm-container{bottom:230px;flex:none;height:65px;left:172px;position:absolute;width:65px;z-index:1}.framer-pACsf .framer-1vuwi02-container{aspect-ratio:1 / 1;flex:none;height:var(--framer-aspect-ratio-supported, 80px);position:absolute;right:174px;top:424px;width:80px;z-index:1}.framer-pACsf .framer-lwwy2d-container{flex:none;height:65px;position:absolute;right:169px;top:221px;width:65px;z-index:1}.framer-pACsf .framer-ldl97h-container{flex:none;height:65px;position:absolute;right:32px;top:301px;width:65px;z-index:1}.framer-pACsf .framer-15vuql8-container{aspect-ratio:1 / 1;flex:none;height:var(--framer-aspect-ratio-supported, 80px);left:1226px;position:absolute;top:97px;width:80px;z-index:1}.framer-pACsf .framer-3pv3wu-container{aspect-ratio:1 / 1;bottom:119px;flex:none;height:var(--framer-aspect-ratio-supported, 80px);position:absolute;right:0;width:80px;z-index:1}.framer-pACsf .framer-eu9qz1{align-content:center;align-items:center;background-color:#fff;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:0px;height:min-content;justify-content:center;overflow:hidden;padding:150px 0 120px;position:relative;width:100%}.framer-pACsf .framer-1resr3z{align-content:flex-start;align-items:flex-start;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:center;max-width:1200px;overflow:hidden;padding:0;position:relative;width:90%}.framer-pACsf .framer-18ygqcl{align-content:flex-start;align-items:flex-start;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:20px;height:min-content;justify-content:center;max-width:465px;overflow:hidden;padding:0;position:relative;width:100%}.framer-pACsf .framer-162n34d{--framer-link-text-color: #0099ff;--framer-link-text-decoration: underline;--framer-paragraph-spacing: 0px;flex:none;height:auto;max-width:400px;overflow:visible;position:relative;transform:perspective(1200px);white-space:pre-wrap;width:100%;word-break:break-word;word-wrap:break-word;z-index:1}.framer-pACsf .framer-1w5ylyc{--framer-paragraph-spacing: 0px;flex:none;height:auto;max-width:550px;overflow:visible;position:relative;white-space:pre-wrap;width:70%;word-break:break-word;word-wrap:break-word;z-index:3}.framer-pACsf .framer-10wpf6g{align-content:center;align-items:center;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:center;max-width:100%;overflow:visible;padding:0;position:relative;width:60%}.framer-pACsf .framer-15az9bq-container{flex:none;height:auto;position:relative;transform:perspective(1200px);width:100%;z-index:2}.framer-pACsf .framer-jzlnh3{align-content:center;align-items:center;background-color:#fff;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:60px;height:min-content;justify-content:flex-start;overflow:visible;padding:80px 0 100px;position:relative;width:100%}.framer-pACsf .framer-hgc32s{align-content:center;align-items:center;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:center;max-width:1200px;overflow:hidden;padding:0;position:relative;width:90%}.framer-pACsf .framer-1pm53h8{align-content:center;align-items:center;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:20px;height:min-content;justify-content:center;overflow:hidden;padding:0 0 40px;position:relative;width:100%}.framer-pACsf .framer-e8r11j{--framer-paragraph-spacing: 0px;flex:none;height:auto;max-width:500px;overflow:visible;position:relative;white-space:pre-wrap;width:100%;word-break:break-word;word-wrap:break-word;z-index:3}.framer-pACsf .framer-11poge1{align-content:flex-end;align-items:flex-end;display:flex;flex:none;flex-direction:row;flex-wrap:wrap;gap:20px;height:min-content;justify-content:center;max-width:1200px;overflow:visible;padding:0;position:relative;width:100%}.framer-pACsf .framer-gir2f7-container,.framer-pACsf .framer-da44k0-container{flex:1 0 0px;height:468px;position:relative;transform:perspective(1200px);width:1px}.framer-pACsf .framer-1mz79k2{align-content:center;align-items:center;background:linear-gradient(180deg,var(--token-20257545-130a-452b-8942-48d79a1f3d66, #ffffff) 0%,var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255)) 100%);display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:60px;height:min-content;justify-content:center;overflow:hidden;padding:100px 0 0;position:relative;width:100%}.framer-pACsf .framer-rd7mqg{align-content:flex-start;align-items:flex-start;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:20px;height:min-content;justify-content:center;max-width:1200px;overflow:hidden;padding:0;position:relative;width:95%}.framer-pACsf .framer-8dmr5w{align-content:center;align-items:center;background:linear-gradient(180deg,var(--token-20257545-130a-452b-8942-48d79a1f3d66, #ffffff) 0%,var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236)) 100%);display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:0px;height:min-content;justify-content:center;overflow:visible;padding:60px 0;position:relative;width:100%}.framer-pACsf .framer-1j90mhs{align-content:center;align-items:center;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:30px;height:min-content;justify-content:center;max-width:1200px;overflow:visible;padding:0;position:relative;transform:perspective(1200px);width:90%}.framer-pACsf .framer-ntrwh0{--border-bottom-width: 1px;--border-color: var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, #ededfa) ;--border-left-width: 1px;--border-right-width: 1px;--border-style: solid;--border-top-width: 1px;align-content:center;align-items:center;background-color:#fff;border-radius:30px;box-shadow:0 .6021873017743928px .36131238106463576px -.9166666666666666px #fafcff14,0 2.288533303243457px 1.3731199819460744px -1.8333333333333333px #fafcff14,0 10px 6.000000000000001px -2.75px #fafcff11,0 34px 30px -16px #fe81620d;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:center;overflow:hidden;padding:100px 30px;position:relative;width:100%;will-change:transform}.framer-pACsf .framer-30o11{align-content:flex-start;align-items:flex-start;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:20px;height:min-content;justify-content:center;max-width:500px;overflow:visible;padding:0;position:relative;width:100%}.framer-pACsf .framer-1gwe6da{--framer-paragraph-spacing: 0px;flex:none;height:auto;max-width:100%;overflow:visible;position:relative;white-space:pre-wrap;width:70%;word-break:break-word;word-wrap:break-word;z-index:3}.framer-pACsf .framer-1q2tti4{align-content:center;align-items:center;border-radius:30px;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:center;max-width:440px;overflow:hidden;padding:0;position:relative;width:100%;will-change:transform}.framer-pACsf .framer-mu1j3l{align-content:center;align-items:center;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:center;overflow:hidden;padding:0;position:relative;width:100%}.framer-pACsf .framer-1m07ksk{flex:none;height:108px;position:relative;width:364px}.framer-pACsf .framer-y7jtbf{--framer-link-text-color: #0099ff;--framer-link-text-decoration: underline;--framer-paragraph-spacing: 0px;flex:none;height:auto;left:50%;overflow:visible;position:absolute;top:38px;transform:translate(-50%);white-space:pre-wrap;width:208px;word-break:break-word;word-wrap:break-word;z-index:1}.framer-pACsf .framer-1cbq31u{align-content:center;align-items:center;display:flex;flex:none;flex-direction:column;flex-wrap:wrap;gap:10px;height:min-content;justify-content:center;overflow:hidden;padding:0;position:relative;width:100%}.framer-pACsf .framer-1rvel35{bottom:0;flex:none;left:0;overflow:hidden;position:absolute;top:0;width:100%;z-index:2}.framer-pACsf .framer-rnonvr{aspect-ratio:2.588235294117647 / 1;flex:none;height:var(--framer-aspect-ratio-supported, 170px);overflow:visible;position:relative;width:440px}.framer-pACsf .framer-1x95hcq-container{flex:none;height:auto;position:relative;width:100%}@supports (background: -webkit-named-image(i)) and (not (scale:1)){.framer-pACsf .framer-72rtr7,.framer-pACsf .framer-1g2ju43,.framer-pACsf .framer-8f3uib,.framer-pACsf .framer-1c1y0hg,.framer-pACsf .framer-1hyemqj,.framer-pACsf .framer-1febxrw,.framer-pACsf .framer-1xg95ak,.framer-pACsf .framer-1hc0e4d,.framer-pACsf .framer-cpr011,.framer-pACsf .framer-4d1i2v,.framer-pACsf .framer-hnhq2k,.framer-pACsf .framer-1f37ktk,.framer-pACsf .framer-1vgtvbt,.framer-pACsf .framer-1wrfpcj,.framer-pACsf .framer-6b3l05,.framer-pACsf .framer-6qjmop,.framer-pACsf .framer-19tcqvo,.framer-pACsf .framer-rwu701,.framer-pACsf .framer-1286ntv,.framer-pACsf .framer-1jcpmsn,.framer-pACsf .framer-eu9qz1,.framer-pACsf .framer-1resr3z,.framer-pACsf .framer-18ygqcl,.framer-pACsf .framer-10wpf6g,.framer-pACsf .framer-jzlnh3,.framer-pACsf .framer-hgc32s,.framer-pACsf .framer-1pm53h8,.framer-pACsf .framer-11poge1,.framer-pACsf .framer-1mz79k2,.framer-pACsf .framer-rd7mqg,.framer-pACsf .framer-8dmr5w,.framer-pACsf .framer-1j90mhs,.framer-pACsf .framer-ntrwh0,.framer-pACsf .framer-30o11,.framer-pACsf .framer-1q2tti4,.framer-pACsf .framer-mu1j3l,.framer-pACsf .framer-1cbq31u{gap:0px}.framer-pACsf .framer-72rtr7>*,.framer-pACsf .framer-1g2ju43>*,.framer-pACsf .framer-1c1y0hg>*{margin:0}.framer-pACsf .framer-72rtr7>:first-child,.framer-pACsf .framer-1g2ju43>:first-child,.framer-pACsf .framer-8f3uib>:first-child,.framer-pACsf .framer-1c1y0hg>:first-child,.framer-pACsf .framer-1hyemqj>:first-child,.framer-pACsf .framer-1xg95ak>:first-child,.framer-pACsf .framer-1hc0e4d>:first-child,.framer-pACsf .framer-cpr011>:first-child,.framer-pACsf .framer-4d1i2v>:first-child,.framer-pACsf .framer-hnhq2k>:first-child,.framer-pACsf .framer-1vgtvbt>:first-child,.framer-pACsf .framer-1wrfpcj>:first-child,.framer-pACsf .framer-6b3l05>:first-child,.framer-pACsf .framer-19tcqvo>:first-child,.framer-pACsf .framer-rwu701>:first-child,.framer-pACsf .framer-1286ntv>:first-child,.framer-pACsf .framer-18ygqcl>:first-child,.framer-pACsf .framer-jzlnh3>:first-child,.framer-pACsf .framer-hgc32s>:first-child,.framer-pACsf .framer-1pm53h8>:first-child,.framer-pACsf .framer-1mz79k2>:first-child,.framer-pACsf .framer-rd7mqg>:first-child,.framer-pACsf .framer-30o11>:first-child,.framer-pACsf .framer-1q2tti4>:first-child,.framer-pACsf .framer-mu1j3l>:first-child,.framer-pACsf .framer-1cbq31u>:first-child{margin-top:0}.framer-pACsf .framer-72rtr7>:last-child,.framer-pACsf .framer-1g2ju43>:last-child,.framer-pACsf .framer-8f3uib>:last-child,.framer-pACsf .framer-1c1y0hg>:last-child,.framer-pACsf .framer-1hyemqj>:last-child,.framer-pACsf .framer-1xg95ak>:last-child,.framer-pACsf .framer-1hc0e4d>:last-child,.framer-pACsf .framer-cpr011>:last-child,.framer-pACsf .framer-4d1i2v>:last-child,.framer-pACsf .framer-hnhq2k>:last-child,.framer-pACsf .framer-1vgtvbt>:last-child,.framer-pACsf .framer-1wrfpcj>:last-child,.framer-pACsf .framer-6b3l05>:last-child,.framer-pACsf .framer-19tcqvo>:last-child,.framer-pACsf .framer-rwu701>:last-child,.framer-pACsf .framer-1286ntv>:last-child,.framer-pACsf .framer-18ygqcl>:last-child,.framer-pACsf .framer-jzlnh3>:last-child,.framer-pACsf .framer-hgc32s>:last-child,.framer-pACsf .framer-1pm53h8>:last-child,.framer-pACsf .framer-1mz79k2>:last-child,.framer-pACsf .framer-rd7mqg>:last-child,.framer-pACsf .framer-30o11>:last-child,.framer-pACsf .framer-1q2tti4>:last-child,.framer-pACsf .framer-mu1j3l>:last-child,.framer-pACsf .framer-1cbq31u>:last-child{margin-bottom:0}.framer-pACsf .framer-8f3uib>*,.framer-pACsf .framer-1vgtvbt>*{margin:40px 0}.framer-pACsf .framer-1hyemqj>*{margin:4px 0}.framer-pACsf .framer-1febxrw>*{margin:0 12px}.framer-pACsf .framer-1febxrw>:first-child,.framer-pACsf .framer-1f37ktk>:first-child,.framer-pACsf .framer-6qjmop>:first-child,.framer-pACsf .framer-1jcpmsn>:first-child,.framer-pACsf .framer-eu9qz1>:first-child,.framer-pACsf .framer-1resr3z>:first-child,.framer-pACsf .framer-10wpf6g>:first-child,.framer-pACsf .framer-11poge1>:first-child,.framer-pACsf .framer-8dmr5w>:first-child,.framer-pACsf .framer-1j90mhs>:first-child,.framer-pACsf .framer-ntrwh0>:first-child{margin-left:0}.framer-pACsf .framer-1febxrw>:last-child,.framer-pACsf .framer-1f37ktk>:last-child,.framer-pACsf .framer-6qjmop>:last-child,.framer-pACsf .framer-1jcpmsn>:last-child,.framer-pACsf .framer-eu9qz1>:last-child,.framer-pACsf .framer-1resr3z>:last-child,.framer-pACsf .framer-10wpf6g>:last-child,.framer-pACsf .framer-11poge1>:last-child,.framer-pACsf .framer-8dmr5w>:last-child,.framer-pACsf .framer-1j90mhs>:last-child,.framer-pACsf .framer-ntrwh0>:last-child{margin-right:0}.framer-pACsf .framer-1xg95ak>*,.framer-pACsf .framer-1hc0e4d>*,.framer-pACsf .framer-hgc32s>*,.framer-pACsf .framer-1q2tti4>*,.framer-pACsf .framer-mu1j3l>*,.framer-pACsf .framer-1cbq31u>*{margin:5px 0}.framer-pACsf .framer-cpr011>*{margin:25px 0}.framer-pACsf .framer-4d1i2v>*,.framer-pACsf .framer-1wrfpcj>*,.framer-pACsf .framer-rwu701>*,.framer-pACsf .framer-jzlnh3>*,.framer-pACsf .framer-1mz79k2>*{margin:30px 0}.framer-pACsf .framer-hnhq2k>*,.framer-pACsf .framer-6b3l05>*,.framer-pACsf .framer-19tcqvo>*,.framer-pACsf .framer-1286ntv>*,.framer-pACsf .framer-18ygqcl>*,.framer-pACsf .framer-1pm53h8>*,.framer-pACsf .framer-rd7mqg>*,.framer-pACsf .framer-30o11>*{margin:10px 0}.framer-pACsf .framer-1f37ktk>*,.framer-pACsf .framer-6qjmop>*{margin:0 20px}.framer-pACsf .framer-1jcpmsn>*,.framer-pACsf .framer-1resr3z>*,.framer-pACsf .framer-10wpf6g>*,.framer-pACsf .framer-ntrwh0>*{margin:0 5px}.framer-pACsf .framer-eu9qz1>*,.framer-pACsf .framer-8dmr5w>*{margin:0}.framer-pACsf .framer-11poge1>*{margin:0 10px}.framer-pACsf .framer-1j90mhs>*{margin:0 15px}}@media (min-width: 1400px){.framer-pACsf .hidden-72rtr7{display:none!important}}@media (min-width: 810px) and (max-width: 1399px){.framer-pACsf .hidden-2u6iyy{display:none!important}.framer-body-augiA20Il{background:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(238, 233, 228))}.framer-pACsf .framer-72rtr7{width:810px}.framer-pACsf .framer-1g2ju43{height:970px}.framer-pACsf .framer-1c1y0hg{overflow:hidden}.framer-pACsf .framer-15dce9y{opacity:.8;width:80%}.framer-pACsf .framer-1xg95ak{flex:1 0 0px;height:1px;justify-content:flex-start;padding:60px 0 50px}.framer-pACsf .framer-1hc0e4d{max-width:unset}.framer-pACsf .framer-cpr011,.framer-pACsf .framer-1vgtvbt{padding:100px 0}.framer-pACsf .framer-4d1i2v,.framer-pACsf .framer-1wrfpcj{gap:50px}.framer-pACsf .framer-1f37ktk{flex-direction:column;max-width:600px}.framer-pACsf .framer-4yt290-container,.framer-pACsf .framer-1rkd6ro-container,.framer-pACsf .framer-10wpf6g,.framer-pACsf .framer-54ls01-container{width:100%}.framer-pACsf .framer-1irddqm{grid-template-columns:repeat(1,minmax(200px,1fr));grid-template-rows:repeat(2,minmax(0,1fr));max-width:600px;overflow:auto}.framer-pACsf .framer-yfbogm-container{max-width:100%}.framer-pACsf .framer-6qjmop,.framer-pACsf .framer-1resr3z,.framer-pACsf .framer-1j90mhs{flex-direction:column}.framer-pACsf .framer-m68jij-container,.framer-pACsf .framer-x6ivpm-container{align-self:unset;flex:none;width:100%}.framer-pACsf .framer-n4m4v-container,.framer-pACsf .framer-gir2f7-container,.framer-pACsf .framer-yjy15x-container,.framer-pACsf .framer-da44k0-container{flex:none;width:100%}.framer-pACsf .framer-19tcqvo{gap:60px}.framer-pACsf .framer-rwu701{gap:50px;order:1}.framer-pACsf .framer-jlqzes{width:70%}.framer-pACsf .framer-1jcpmsn{bottom:unset;height:min-content;left:unset;order:0;position:relative;top:unset;width:100%}.framer-pACsf .framer-1mi0wzd-container{aspect-ratio:unset;bottom:unset;height:auto;left:unset;position:relative;width:auto}.framer-pACsf .framer-nc2gw-container,.framer-pACsf .framer-15qwzes-container{height:auto;left:unset;position:relative;top:unset;width:auto}.framer-pACsf .framer-119alcv-container,.framer-pACsf .framer-15vuql8-container{aspect-ratio:unset;height:auto;left:unset;position:relative;top:unset;width:auto}.framer-pACsf .framer-1u2vokm-container{bottom:unset;height:auto;left:unset;position:relative;width:auto}.framer-pACsf .framer-1vuwi02-container{aspect-ratio:unset;height:auto;position:relative;right:unset;top:unset;width:auto}.framer-pACsf .framer-lwwy2d-container,.framer-pACsf .framer-ldl97h-container{height:auto;position:relative;right:unset;top:unset;width:auto}.framer-pACsf .framer-3pv3wu-container{aspect-ratio:unset;bottom:unset;height:auto;position:relative;right:unset;width:auto}.framer-pACsf .framer-eu9qz1{flex-direction:column;gap:60px;padding:100px 0 60px}.framer-pACsf .framer-18ygqcl{max-width:unset;padding:0 0 30px}.framer-pACsf .framer-jzlnh3{padding:60px 0}.framer-pACsf .framer-11poge1{flex-direction:column;max-width:500px}.framer-pACsf .framer-1mz79k2{gap:50px;padding:100px 0 10px}.framer-pACsf .framer-rd7mqg{width:90%}.framer-pACsf .framer-ntrwh0{flex-direction:column;padding:80px 30px}.framer-pACsf .framer-30o11{align-content:center;align-items:center;max-width:unset;padding:0 0 40px}.framer-pACsf .framer-1gwe6da{max-width:600px;width:100%}@supports (background: -webkit-named-image(i)) and (not (scale:1)){.framer-pACsf .framer-4d1i2v,.framer-pACsf .framer-1f37ktk,.framer-pACsf .framer-1wrfpcj,.framer-pACsf .framer-6qjmop,.framer-pACsf .framer-19tcqvo,.framer-pACsf .framer-rwu701,.framer-pACsf .framer-eu9qz1,.framer-pACsf .framer-1resr3z,.framer-pACsf .framer-11poge1,.framer-pACsf .framer-1mz79k2,.framer-pACsf .framer-1j90mhs,.framer-pACsf .framer-ntrwh0{gap:0px}.framer-pACsf .framer-4d1i2v>*,.framer-pACsf .framer-1wrfpcj>*,.framer-pACsf .framer-rwu701>*,.framer-pACsf .framer-1mz79k2>*{margin:25px 0}.framer-pACsf .framer-4d1i2v>:first-child,.framer-pACsf .framer-1f37ktk>:first-child,.framer-pACsf .framer-1wrfpcj>:first-child,.framer-pACsf .framer-6qjmop>:first-child,.framer-pACsf .framer-19tcqvo>:first-child,.framer-pACsf .framer-rwu701>:first-child,.framer-pACsf .framer-eu9qz1>:first-child,.framer-pACsf .framer-1resr3z>:first-child,.framer-pACsf .framer-11poge1>:first-child,.framer-pACsf .framer-1mz79k2>:first-child,.framer-pACsf .framer-1j90mhs>:first-child,.framer-pACsf .framer-ntrwh0>:first-child{margin-top:0}.framer-pACsf .framer-4d1i2v>:last-child,.framer-pACsf .framer-1f37ktk>:last-child,.framer-pACsf .framer-1wrfpcj>:last-child,.framer-pACsf .framer-6qjmop>:last-child,.framer-pACsf .framer-19tcqvo>:last-child,.framer-pACsf .framer-rwu701>:last-child,.framer-pACsf .framer-eu9qz1>:last-child,.framer-pACsf .framer-1resr3z>:last-child,.framer-pACsf .framer-11poge1>:last-child,.framer-pACsf .framer-1mz79k2>:last-child,.framer-pACsf .framer-1j90mhs>:last-child,.framer-pACsf .framer-ntrwh0>:last-child{margin-bottom:0}.framer-pACsf .framer-1f37ktk>*,.framer-pACsf .framer-6qjmop>*{margin:20px 0}.framer-pACsf .framer-19tcqvo>*,.framer-pACsf .framer-eu9qz1>*{margin:30px 0}.framer-pACsf .framer-1resr3z>*,.framer-pACsf .framer-ntrwh0>*{margin:5px 0}.framer-pACsf .framer-11poge1>*{margin:10px 0}.framer-pACsf .framer-1j90mhs>*{margin:15px 0}}}@media (max-width: 809px){.framer-pACsf .hidden-fynrlu{display:none!important}.framer-body-augiA20Il{background:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(238, 233, 228))}.framer-pACsf .framer-72rtr7{width:390px}.framer-pACsf .framer-1g2ju43{padding:80px 0 0}.framer-pACsf .framer-1hyemqj{padding:0 0 20px}.framer-pACsf .framer-15dce9y{width:90%}.framer-pACsf .framer-1febxrw{flex-direction:column;padding:20px 0 0;width:100%}.framer-pACsf .framer-19oy2xt-container,.framer-pACsf .framer-bujhiz-container,.framer-pACsf .framer-4yt290-container,.framer-pACsf .framer-1rkd6ro-container,.framer-pACsf .framer-nxqp8w,.framer-pACsf .framer-1w5ylyc,.framer-pACsf .framer-10wpf6g,.framer-pACsf .framer-ml4sbc{width:100%}.framer-pACsf .framer-1xg95ak{height:min-content;justify-content:flex-start;padding:50px 0}.framer-pACsf .framer-1hc0e4d{border-radius:8px;flex:none;height:224px;justify-content:flex-start;max-width:unset}.framer-pACsf .framer-cpr011,.framer-pACsf .framer-1vgtvbt,.framer-pACsf .framer-jzlnh3{padding:60px 0}.framer-pACsf .framer-4d1i2v,.framer-pACsf .framer-1wrfpcj{gap:40px}.framer-pACsf .framer-hnhq2k,.framer-pACsf .framer-6b3l05,.framer-pACsf .framer-1286ntv,.framer-pACsf .framer-1pm53h8{gap:15px}.framer-pACsf .framer-1f37ktk,.framer-pACsf .framer-6qjmop{flex-direction:column;gap:20px}.framer-pACsf .framer-1irddqm{gap:20px;grid-template-columns:repeat(1,minmax(200px,1fr));grid-template-rows:repeat(2,minmax(0,1fr));overflow:auto}.framer-pACsf .framer-yfbogm-container{max-width:100%}.framer-pACsf .framer-m68jij-container,.framer-pACsf .framer-x6ivpm-container{align-self:unset;flex:none;width:100%}.framer-pACsf .framer-n4m4v-container,.framer-pACsf .framer-gir2f7-container,.framer-pACsf .framer-yjy15x-container,.framer-pACsf .framer-da44k0-container{flex:none;width:100%}.framer-pACsf .framer-19tcqvo{padding:60px 0 0}.framer-pACsf .framer-rwu701{gap:40px;order:1}.framer-pACsf .framer-jlqzes{width:80%}.framer-pACsf .framer-1bpscfd{border-top-left-radius:20px;border-top-right-radius:20px;height:172px;width:90%}.framer-pACsf .framer-1jcpmsn{align-content:flex-start;align-items:flex-start;bottom:unset;flex-wrap:wrap;gap:12px;height:min-content;left:unset;max-width:390px;order:0;padding:0 0 20px;position:relative;top:unset;width:90%}.framer-pACsf .framer-1mi0wzd-container{aspect-ratio:unset;bottom:unset;height:60px;left:unset;position:relative;width:60px}.framer-pACsf .framer-nc2gw-container,.framer-pACsf .framer-15qwzes-container{height:60px;left:unset;position:relative;top:unset;width:60px}.framer-pACsf .framer-119alcv-container,.framer-pACsf .framer-15vuql8-container{aspect-ratio:unset;height:60px;left:unset;position:relative;top:unset;width:60px}.framer-pACsf .framer-1u2vokm-container{bottom:unset;height:60px;left:unset;position:relative;width:60px}.framer-pACsf .framer-1vuwi02-container{aspect-ratio:unset;height:60px;position:relative;right:unset;top:unset;width:60px}.framer-pACsf .framer-lwwy2d-container,.framer-pACsf .framer-ldl97h-container{height:60px;position:relative;right:unset;top:unset;width:60px}.framer-pACsf .framer-3pv3wu-container{aspect-ratio:unset;bottom:unset;height:60px;position:relative;right:unset;width:60px}.framer-pACsf .framer-eu9qz1{flex-direction:column;gap:60px;padding:60px 0}.framer-pACsf .framer-1resr3z{align-content:center;align-items:center;flex-direction:column;gap:40px}.framer-pACsf .framer-18ygqcl{align-content:center;align-items:center;gap:15px}.framer-pACsf .framer-hgc32s{gap:0px}.framer-pACsf .framer-11poge1,.framer-pACsf .framer-8dmr5w,.framer-pACsf .framer-1j90mhs{flex-direction:column}.framer-pACsf .framer-1mz79k2{gap:40px;padding:60px 0 0}.framer-pACsf .framer-rd7mqg{order:0;width:90%}.framer-pACsf .framer-54ls01-container{order:1;width:100%}.framer-pACsf .framer-ntrwh0{border-radius:20px;flex-direction:column;padding:60px 0}.framer-pACsf .framer-30o11{align-content:center;align-items:center;padding:0 30px 30px}@supports (background: -webkit-named-image(i)) and (not (scale:1)){.framer-pACsf .framer-1febxrw,.framer-pACsf .framer-4d1i2v,.framer-pACsf .framer-hnhq2k,.framer-pACsf .framer-1f37ktk,.framer-pACsf .framer-1irddqm,.framer-pACsf .framer-1wrfpcj,.framer-pACsf .framer-6b3l05,.framer-pACsf .framer-6qjmop,.framer-pACsf .framer-rwu701,.framer-pACsf .framer-1286ntv,.framer-pACsf .framer-1jcpmsn,.framer-pACsf .framer-eu9qz1,.framer-pACsf .framer-1resr3z,.framer-pACsf .framer-18ygqcl,.framer-pACsf .framer-hgc32s,.framer-pACsf .framer-1pm53h8,.framer-pACsf .framer-11poge1,.framer-pACsf .framer-1mz79k2,.framer-pACsf .framer-8dmr5w,.framer-pACsf .framer-1j90mhs,.framer-pACsf .framer-ntrwh0{gap:0px}.framer-pACsf .framer-1febxrw>*{margin:12px 0}.framer-pACsf .framer-1febxrw>:first-child,.framer-pACsf .framer-4d1i2v>:first-child,.framer-pACsf .framer-hnhq2k>:first-child,.framer-pACsf .framer-1f37ktk>:first-child,.framer-pACsf .framer-1wrfpcj>:first-child,.framer-pACsf .framer-6b3l05>:first-child,.framer-pACsf .framer-6qjmop>:first-child,.framer-pACsf .framer-rwu701>:first-child,.framer-pACsf .framer-1286ntv>:first-child,.framer-pACsf .framer-eu9qz1>:first-child,.framer-pACsf .framer-1resr3z>:first-child,.framer-pACsf .framer-18ygqcl>:first-child,.framer-pACsf .framer-hgc32s>:first-child,.framer-pACsf .framer-1pm53h8>:first-child,.framer-pACsf .framer-11poge1>:first-child,.framer-pACsf .framer-1mz79k2>:first-child,.framer-pACsf .framer-8dmr5w>:first-child,.framer-pACsf .framer-1j90mhs>:first-child,.framer-pACsf .framer-ntrwh0>:first-child{margin-top:0}.framer-pACsf .framer-1febxrw>:last-child,.framer-pACsf .framer-4d1i2v>:last-child,.framer-pACsf .framer-hnhq2k>:last-child,.framer-pACsf .framer-1f37ktk>:last-child,.framer-pACsf .framer-1wrfpcj>:last-child,.framer-pACsf .framer-6b3l05>:last-child,.framer-pACsf .framer-6qjmop>:last-child,.framer-pACsf .framer-rwu701>:last-child,.framer-pACsf .framer-1286ntv>:last-child,.framer-pACsf .framer-eu9qz1>:last-child,.framer-pACsf .framer-1resr3z>:last-child,.framer-pACsf .framer-18ygqcl>:last-child,.framer-pACsf .framer-hgc32s>:last-child,.framer-pACsf .framer-1pm53h8>:last-child,.framer-pACsf .framer-11poge1>:last-child,.framer-pACsf .framer-1mz79k2>:last-child,.framer-pACsf .framer-8dmr5w>:last-child,.framer-pACsf .framer-1j90mhs>:last-child,.framer-pACsf .framer-ntrwh0>:last-child{margin-bottom:0}.framer-pACsf .framer-4d1i2v>*,.framer-pACsf .framer-1wrfpcj>*,.framer-pACsf .framer-rwu701>*,.framer-pACsf .framer-1resr3z>*,.framer-pACsf .framer-1mz79k2>*{margin:20px 0}.framer-pACsf .framer-hnhq2k>*,.framer-pACsf .framer-6b3l05>*,.framer-pACsf .framer-1286ntv>*,.framer-pACsf .framer-18ygqcl>*,.framer-pACsf .framer-1pm53h8>*{margin:7.5px 0}.framer-pACsf .framer-1f37ktk>*,.framer-pACsf .framer-6qjmop>*,.framer-pACsf .framer-11poge1>*{margin:10px 0}.framer-pACsf .framer-1irddqm>*,.framer-pACsf .framer-1irddqm>:first-child,.framer-pACsf .framer-1irddqm>:last-child{margin:0}.framer-pACsf .framer-1jcpmsn>*{margin:0 6px}.framer-pACsf .framer-1jcpmsn>:first-child{margin-left:0}.framer-pACsf .framer-1jcpmsn>:last-child{margin-right:0}.framer-pACsf .framer-eu9qz1>*{margin:30px 0}.framer-pACsf .framer-hgc32s>*,.framer-pACsf .framer-8dmr5w>*{margin:0}.framer-pACsf .framer-1j90mhs>*{margin:15px 0}.framer-pACsf .framer-ntrwh0>*{margin:5px 0}}}.framer-Kygub .framer-styles-preset-1w52vu0:not(.rich-text-wrapper),.framer-Kygub .framer-styles-preset-1w52vu0.rich-text-wrapper h1{--framer-font-family: "Outfit", sans-serif;--framer-font-size: 85px;--framer-font-style: normal;--framer-font-weight: 500;--framer-letter-spacing: -2px;--framer-line-height: 1em;--framer-paragraph-spacing: 40px;--framer-text-alignment: center;--framer-text-color: #ffffff;--framer-text-decoration: none;--framer-text-transform: none}@media (max-width: 1199px) and (min-width: 810px){.framer-Kygub .framer-styles-preset-1w52vu0:not(.rich-text-wrapper),.framer-Kygub .framer-styles-preset-1w52vu0.rich-text-wrapper h1{--framer-font-family: "Outfit", sans-serif;--framer-font-size: 68px;--framer-font-style: normal;--framer-font-weight: 500;--framer-letter-spacing: -2px;--framer-line-height: 1em;--framer-paragraph-spacing: 40px;--framer-text-alignment: center;--framer-text-color: #ffffff;--framer-text-decoration: none;--framer-text-transform: none}}@media (max-width: 809px) and (min-width: 0px){.framer-Kygub .framer-styles-preset-1w52vu0:not(.rich-text-wrapper),.framer-Kygub .framer-styles-preset-1w52vu0.rich-text-wrapper h1{--framer-font-family: "Outfit", sans-serif;--framer-font-size: 54px;--framer-font-style: normal;--framer-font-weight: 500;--framer-letter-spacing: -2px;--framer-line-height: 1em;--framer-paragraph-spacing: 40px;--framer-text-alignment: center;--framer-text-color: #ffffff;--framer-text-decoration: none;--framer-text-transform: none}}.framer-Q72Eb [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-Q72Eb .framer-1n98qpg{display:block}.framer-Q72Eb .framer-cj7bgq{align-content:center;align-items:center;display:flex;flex-direction:column;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:center;overflow:hidden;padding:10px;position:relative;text-decoration:none;width:min-content}.framer-Q72Eb .framer-1pk6ob0{flex:none;height:auto;overflow:visible;position:relative;white-space:pre;width:auto;z-index:1}.framer-Q72Eb .framer-v-cj7bgq .framer-cj7bgq{cursor:pointer}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-Q72Eb .framer-cj7bgq{gap:0px}.framer-Q72Eb .framer-cj7bgq>*{margin:5px 0}.framer-Q72Eb .framer-cj7bgq>:first-child{margin-top:0}.framer-Q72Eb .framer-cj7bgq>:last-child{margin-bottom:0}}.framer-89iJV [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-89iJV .framer-1teyoyz{display:block}.framer-89iJV .framer-1c8ccoq{align-content:center;align-items:center;display:flex;flex-direction:row;flex-wrap:nowrap;height:min-content;justify-content:space-between;padding:16px 24px;position:relative;width:1200px}.framer-89iJV .framer-1ppb8fb{aspect-ratio:4.021739130434782 / 1;flex:none;height:var(--framer-aspect-ratio-supported, 45px);overflow:visible;position:relative;width:180px}.framer-89iJV .framer-12kf1xo{align-content:center;align-items:center;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:40px;height:46px;justify-content:center;overflow:visible;padding:0;position:relative;width:min-content;z-index:1}.framer-89iJV .framer-1cpe080{align-content:center;align-items:center;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:16px;height:46px;justify-content:center;overflow:visible;padding:0;position:relative;width:min-content}.framer-89iJV .framer-16cvm8q-container,.framer-89iJV .framer-vojyhk-container,.framer-89iJV .framer-1oni54s-container,.framer-89iJV .framer-1udkk67-container{flex:none;height:auto;position:relative;width:auto}.framer-89iJV .framer-1iwl0hw,.framer-89iJV .framer-1r3bk6j,.framer-89iJV .framer-1jz79wd{aspect-ratio:.8 / 1;flex:none;height:var(--framer-aspect-ratio-supported, 5px);position:relative;width:4px}.framer-89iJV .framer-39xqeb-container{flex:1 0 0px;height:48px;position:relative;width:1px}.framer-89iJV .framer-jrcz5n-container{flex:none;height:48px;position:relative;width:auto}.framer-89iJV .framer-hq90p7-container{flex:none;height:36px;left:calc(92.30769230769234% - 36px / 2);position:absolute;top:21px;width:36px;z-index:1}.framer-89iJV .framer-11tjfpm-container{flex:none;height:36px;position:absolute;right:12px;top:calc(50.649350649350666% - 36px / 2);width:36px;z-index:1}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-89iJV .framer-12kf1xo,.framer-89iJV .framer-1cpe080{gap:0px}.framer-89iJV .framer-12kf1xo>*{margin:0 20px}.framer-89iJV .framer-12kf1xo>:first-child,.framer-89iJV .framer-1cpe080>:first-child{margin-left:0}.framer-89iJV .framer-12kf1xo>:last-child,.framer-89iJV .framer-1cpe080>:last-child{margin-right:0}.framer-89iJV .framer-1cpe080>*{margin:0 8px}}.framer-89iJV.framer-v-1tazxdj .framer-1c8ccoq{width:810px}.framer-89iJV.framer-v-1tazxdj .framer-1ppb8fb{aspect-ratio:unset;height:45px;width:46px}.framer-89iJV.framer-v-1tazxdj .framer-12kf1xo{gap:30px}.framer-89iJV.framer-v-1tazxdj .framer-1cpe080,.framer-89iJV.framer-v-1t6worc .framer-1ppb8fb{order:0}.framer-89iJV.framer-v-1tazxdj .framer-jrcz5n-container,.framer-89iJV.framer-v-1t6worc .framer-hq90p7-container{order:2}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-89iJV.framer-v-1tazxdj .framer-12kf1xo{gap:0px}.framer-89iJV.framer-v-1tazxdj .framer-12kf1xo>*{margin:0 15px}.framer-89iJV.framer-v-1tazxdj .framer-12kf1xo>:first-child{margin-left:0}.framer-89iJV.framer-v-1tazxdj .framer-12kf1xo>:last-child{margin-right:0}}.framer-89iJV.framer-v-1a9p1ph .framer-1c8ccoq{padding:16px 24px 16px 20px;width:390px}.framer-89iJV.framer-v-1t6worc .framer-1c8ccoq{align-content:flex-start;align-items:flex-start;flex-direction:column;gap:24px;height:477px;justify-content:flex-start;min-height:calc(var(--framer-viewport-height, 100vh) * 1);padding:16px 24px 60px 20px;width:390px}.framer-89iJV.framer-v-1t6worc .framer-12kf1xo{flex-direction:column;gap:50px;height:min-content;left:19px;order:1;padding:20px 0 0;position:absolute;top:86px;width:90%}.framer-89iJV.framer-v-1t6worc .framer-1cpe080{flex-direction:column;gap:10px;height:min-content;width:87px}.framer-89iJV.framer-v-1t6worc .framer-39xqeb-container{flex:none;width:100%}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-89iJV.framer-v-1t6worc .framer-1c8ccoq,.framer-89iJV.framer-v-1t6worc .framer-12kf1xo,.framer-89iJV.framer-v-1t6worc .framer-1cpe080{gap:0px}.framer-89iJV.framer-v-1t6worc .framer-1c8ccoq>*{margin:12px 0}.framer-89iJV.framer-v-1t6worc .framer-1c8ccoq>:first-child,.framer-89iJV.framer-v-1t6worc .framer-12kf1xo>:first-child,.framer-89iJV.framer-v-1t6worc .framer-1cpe080>:first-child{margin-top:0}.framer-89iJV.framer-v-1t6worc .framer-1c8ccoq>:last-child,.framer-89iJV.framer-v-1t6worc .framer-12kf1xo>:last-child,.framer-89iJV.framer-v-1t6worc .framer-1cpe080>:last-child{margin-bottom:0}.framer-89iJV.framer-v-1t6worc .framer-12kf1xo>*{margin:25px 0}.framer-89iJV.framer-v-1t6worc .framer-1cpe080>*{margin:5px 0}}.framer-pV8l8 [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-pV8l8 .framer-1qvg9qj{display:block}.framer-pV8l8 .framer-1j7wqg{align-content:center;align-items:center;display:flex;flex-direction:row;flex-wrap:nowrap;gap:8px;height:56px;justify-content:center;padding:16px 26px;position:relative;text-decoration:none;width:min-content}.framer-pV8l8 .framer-upesbu{flex:none;height:auto;position:relative;white-space:pre;width:auto}.framer-pV8l8 .framer-1tmmp9l-container,.framer-pV8l8 .framer-18uqlum-container,.framer-pV8l8 .framer-1jveaxk-container,.framer-pV8l8 .framer-n815dq-container{flex:none;height:24px;position:relative;width:24px}.framer-pV8l8 .framer-v-1j7wqg .framer-1j7wqg{cursor:pointer}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-pV8l8 .framer-1j7wqg{gap:0px}.framer-pV8l8 .framer-1j7wqg>*{margin:0 4px}.framer-pV8l8 .framer-1j7wqg>:first-child{margin-left:0}.framer-pV8l8 .framer-1j7wqg>:last-child{margin-right:0}}.framer-iQudY [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-iQudY .framer-gajig0{display:block}.framer-iQudY .framer-1dbgsa2{align-content:flex-start;align-items:flex-start;display:flex;flex-direction:column;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:center;padding:78px 40px 35px;position:relative;width:580px}.framer-iQudY .framer-1dqpucs{align-content:center;align-items:center;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:10px;height:50px;justify-content:center;overflow:hidden;padding:9px;position:relative;width:50px;will-change:transform}.framer-iQudY .framer-1esqs8p{flex:none;height:auto;position:relative;white-space:pre;width:auto}.framer-iQudY .framer-8gadg7{flex:none;height:auto;max-width:500px;overflow:visible;position:relative;white-space:pre-wrap;width:100%;word-break:break-word;word-wrap:break-word}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-iQudY .framer-1dbgsa2,.framer-iQudY .framer-1dqpucs{gap:0px}.framer-iQudY .framer-1dbgsa2>*{margin:5px 0}.framer-iQudY .framer-1dbgsa2>:first-child{margin-top:0}.framer-iQudY .framer-1dbgsa2>:last-child{margin-bottom:0}.framer-iQudY .framer-1dqpucs>*{margin:0 5px}.framer-iQudY .framer-1dqpucs>:first-child{margin-left:0}.framer-iQudY .framer-1dqpucs>:last-child{margin-right:0}}.framer-uw2CS .framer-styles-preset-o12rgh:not(.rich-text-wrapper),.framer-uw2CS .framer-styles-preset-o12rgh.rich-text-wrapper h2{--framer-font-family: "Outfit", sans-serif;--framer-font-size: 42px;--framer-font-style: normal;--framer-font-weight: 500;--framer-letter-spacing: -1px;--framer-line-height: 1.3em;--framer-paragraph-spacing: 40px;--framer-text-alignment: center;--framer-text-color: #ffffff;--framer-text-decoration: none;--framer-text-transform: none}@media (max-width: 1199px) and (min-width: 810px){.framer-uw2CS .framer-styles-preset-o12rgh:not(.rich-text-wrapper),.framer-uw2CS .framer-styles-preset-o12rgh.rich-text-wrapper h2{--framer-font-family: "Outfit", sans-serif;--framer-font-size: 34px;--framer-font-style: normal;--framer-font-weight: 500;--framer-letter-spacing: -1px;--framer-line-height: 1.3em;--framer-paragraph-spacing: 40px;--framer-text-alignment: center;--framer-text-color: #ffffff;--framer-text-decoration: none;--framer-text-transform: none}}@media (max-width: 809px) and (min-width: 0px){.framer-uw2CS .framer-styles-preset-o12rgh:not(.rich-text-wrapper),.framer-uw2CS .framer-styles-preset-o12rgh.rich-text-wrapper h2{--framer-font-family: "Outfit", sans-serif;--framer-font-size: 27px;--framer-font-style: normal;--framer-font-weight: 500;--framer-letter-spacing: -1px;--framer-line-height: 1.3em;--framer-paragraph-spacing: 40px;--framer-text-alignment: center;--framer-text-color: #ffffff;--framer-text-decoration: none;--framer-text-transform: none}}.framer-URW6v [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-URW6v .framer-1wisrch{display:block}.framer-URW6v .framer-1fk2kwq{align-content:center;align-items:center;display:flex;flex-direction:column;flex-wrap:nowrap;gap:0px;height:min-content;justify-content:center;overflow:hidden;padding:0;position:relative;width:580px;will-change:transform}.framer-URW6v .framer-13g0du7{flex:none;height:323px;position:relative;width:100%}.framer-URW6v .framer-9ln4br{align-content:flex-start;align-items:flex-start;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:flex-end;padding:30px;position:relative;width:100%}.framer-URW6v .framer-190cacd,.framer-URW6v .framer-ig49ty{flex:none;height:auto;overflow:visible;position:relative;white-space:pre-wrap;width:100%;word-break:break-word;word-wrap:break-word}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-URW6v .framer-1fk2kwq,.framer-URW6v .framer-9ln4br{gap:0px}.framer-URW6v .framer-1fk2kwq>*{margin:0}.framer-URW6v .framer-1fk2kwq>:first-child,.framer-URW6v .framer-9ln4br>:first-child{margin-top:0}.framer-URW6v .framer-1fk2kwq>:last-child,.framer-URW6v .framer-9ln4br>:last-child{margin-bottom:0}.framer-URW6v .framer-9ln4br>*{margin:5px 0}}.framer-URW6v.framer-v-gvt0t4 .framer-1fk2kwq{width:360px}.framer-URW6v.framer-v-gvt0t4 .framer-9ln4br{gap:2px;padding:16px 30px 20px}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-URW6v.framer-v-gvt0t4 .framer-9ln4br{gap:0px}.framer-URW6v.framer-v-gvt0t4 .framer-9ln4br>*{margin:1px 0}.framer-URW6v.framer-v-gvt0t4 .framer-9ln4br>:first-child{margin-top:0}.framer-URW6v.framer-v-gvt0t4 .framer-9ln4br>:last-child{margin-bottom:0}}.framer-eBYbU [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-eBYbU .framer-1gbrk9l{display:block}.framer-eBYbU .framer-1rya34{align-content:center;align-items:center;display:flex;flex-direction:column;flex-wrap:nowrap;gap:0px;height:min-content;justify-content:center;overflow:hidden;padding:0;position:relative;width:360px;will-change:transform}.framer-eBYbU .framer-3mtodw{aspect-ratio:1.2413793103448276 / 1;flex:none;height:var(--framer-aspect-ratio-supported, 290px);position:relative;width:100%}.framer-eBYbU .framer-1hnjuxt{align-content:flex-start;align-items:flex-start;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:flex-end;padding:30px;position:relative;width:100%}.framer-eBYbU .framer-16f1i88,.framer-eBYbU .framer-10e46b8{flex:none;height:auto;overflow:visible;position:relative;white-space:pre-wrap;width:100%;word-break:break-word;word-wrap:break-word}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-eBYbU .framer-1rya34,.framer-eBYbU .framer-1hnjuxt{gap:0px}.framer-eBYbU .framer-1rya34>*{margin:0}.framer-eBYbU .framer-1rya34>:first-child,.framer-eBYbU .framer-1hnjuxt>:first-child{margin-top:0}.framer-eBYbU .framer-1rya34>:last-child,.framer-eBYbU .framer-1hnjuxt>:last-child{margin-bottom:0}.framer-eBYbU .framer-1hnjuxt>*{margin:5px 0}}.framer-eBYbU.framer-v-m5tdbz .framer-1hnjuxt{gap:2px;padding:16px 30px 20px}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-eBYbU.framer-v-m5tdbz .framer-1hnjuxt{gap:0px}.framer-eBYbU.framer-v-m5tdbz .framer-1hnjuxt>*{margin:1px 0}.framer-eBYbU.framer-v-m5tdbz .framer-1hnjuxt>:first-child{margin-top:0}.framer-eBYbU.framer-v-m5tdbz .framer-1hnjuxt>:last-child{margin-bottom:0}}.framer-COo17 [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-COo17 .framer-4rgsd7{display:block}.framer-COo17 .framer-1dpw8pi{align-content:center;align-items:center;display:flex;flex-direction:column;flex-wrap:nowrap;gap:20px;height:min-content;justify-content:flex-start;padding:50px 30px 60px;position:relative;width:400px}.framer-COo17 .framer-u80wk3{align-content:center;align-items:center;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:center;overflow:hidden;padding:13px;position:relative;width:min-content;will-change:transform}.framer-COo17 .framer-16cdmu3-container{flex:none;height:35px;position:relative;width:35px}.framer-COo17 .framer-ypjcbp{align-content:center;align-items:center;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:center;overflow:hidden;padding:0;position:relative;width:100%}.framer-COo17 .framer-1zt7e9,.framer-COo17 .framer-17i34le{flex:none;height:auto;overflow:visible;position:relative;white-space:pre-wrap;width:100%;word-break:break-word;word-wrap:break-word}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-COo17 .framer-1dpw8pi,.framer-COo17 .framer-u80wk3,.framer-COo17 .framer-ypjcbp{gap:0px}.framer-COo17 .framer-1dpw8pi>*{margin:10px 0}.framer-COo17 .framer-1dpw8pi>:first-child,.framer-COo17 .framer-ypjcbp>:first-child{margin-top:0}.framer-COo17 .framer-1dpw8pi>:last-child,.framer-COo17 .framer-ypjcbp>:last-child{margin-bottom:0}.framer-COo17 .framer-u80wk3>*{margin:0 5px}.framer-COo17 .framer-u80wk3>:first-child{margin-left:0}.framer-COo17 .framer-u80wk3>:last-child{margin-right:0}.framer-COo17 .framer-ypjcbp>*{margin:5px 0}}.framer-sheqz [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-sheqz .framer-6fbeeo{display:block}.framer-sheqz .framer-3bxmev{align-content:center;align-items:center;display:flex;flex-direction:row;flex-wrap:nowrap;gap:10px;height:65px;justify-content:center;overflow:hidden;padding:9px;position:relative;width:65px;will-change:transform}.framer-sheqz .framer-naj6nb-container{aspect-ratio:1 / 1;flex:none;height:var(--framer-aspect-ratio-supported, 40px);position:relative;width:40px}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-sheqz .framer-3bxmev{gap:0px}.framer-sheqz .framer-3bxmev>*{margin:0 5px}.framer-sheqz .framer-3bxmev>:first-child{margin-left:0}.framer-sheqz .framer-3bxmev>:last-child{margin-right:0}}.framer-vXvT8 [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-vXvT8 .framer-yvdw9e{display:block}.framer-vXvT8 .framer-127b3l2{height:60px;overflow:hidden;position:relative;width:60px}.framer-vXvT8 .framer-1y0xt7e{flex:none;height:46px;left:calc(50.00000000000002% - 46px / 2);position:absolute;top:calc(50.00000000000002% - 46px / 2);width:46px}.framer-vXvT8 .framer-mlo1a9,.framer-vXvT8 .framer-1mhdsh8{flex:none;height:36px;left:calc(50.00000000000002% - 36px / 2);position:absolute;top:calc(50.00000000000002% - 36px / 2);width:36px}.framer-vXvT8 .framer-1wnngen{flex:none;height:34px;left:calc(51.66666666666669% - 34px / 2);position:absolute;top:calc(50.00000000000002% - 34px / 2);width:34px}.framer-vXvT8 .framer-1yin3ht{flex:none;height:36px;left:calc(50.00000000000002% - 39px / 2);position:absolute;top:calc(50.00000000000002% - 36px / 2);width:39px}.framer-vXvT8 .framer-sr6gqo{flex:none;height:33px;left:calc(50.00000000000002% - 38px / 2);position:absolute;top:calc(50.00000000000002% - 33px / 2);width:38px}.framer-vXvT8 .framer-1ihngpw{flex:none;height:35px;left:calc(50.00000000000002% - 38px / 2);position:absolute;top:calc(50.00000000000002% - 35px / 2);width:38px}.framer-vXvT8 .framer-r1vtts{flex:none;height:38px;left:calc(50.00000000000002% - 39px / 2);position:absolute;top:calc(50.00000000000002% - 38px / 2);width:39px}.framer-vXvT8 .framer-mq7pic{flex:none;height:38px;left:calc(50.00000000000002% - 38px / 2);position:absolute;top:calc(51.66666666666669% - 38px / 2);width:38px}.framer-vXvT8 .framer-1d87js3{flex:none;height:41px;left:calc(50.00000000000002% - 39px / 2);position:absolute;top:calc(50.00000000000002% - 41px / 2);width:39px}.framer-vXvT8.framer-v-13pltmb .framer-127b3l2,.framer-vXvT8.framer-v-4o6azf .framer-127b3l2,.framer-vXvT8.framer-v-5nyyq7 .framer-127b3l2,.framer-vXvT8.framer-v-isoj3a .framer-127b3l2,.framer-vXvT8.framer-v-p9uy0n .framer-127b3l2,.framer-vXvT8.framer-v-ma5u7u .framer-127b3l2,.framer-vXvT8.framer-v-1v3vwjs .framer-127b3l2,.framer-vXvT8.framer-v-lwxoub .framer-127b3l2,.framer-vXvT8.framer-v-1nbjdk7 .framer-127b3l2{aspect-ratio:1 / 1;height:var(--framer-aspect-ratio-supported, 60px)}.framer-cz6Df [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-cz6Df .framer-1389fyu{display:block}.framer-cz6Df .framer-zd1ut8{align-content:flex-start;align-items:flex-start;display:flex;flex-direction:column;flex-wrap:nowrap;gap:12px;height:min-content;justify-content:flex-start;overflow:hidden;padding:0;position:relative;width:800px;will-change:transform}.framer-cz6Df .framer-15lwsq6-container,.framer-cz6Df .framer-1yjslvu-container,.framer-cz6Df .framer-1e62rmx-container,.framer-cz6Df .framer-apthg1-container,.framer-cz6Df .framer-18wsf7q-container{flex:none;height:auto;position:relative;width:100%}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-cz6Df .framer-zd1ut8{gap:0px}.framer-cz6Df .framer-zd1ut8>*{margin:6px 0}.framer-cz6Df .framer-zd1ut8>:first-child{margin-top:0}.framer-cz6Df .framer-zd1ut8>:last-child{margin-bottom:0}}.framer-AzinR [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-AzinR .framer-1d2v2v9{display:block}.framer-AzinR .framer-1iem2z4{align-content:flex-start;align-items:flex-start;display:flex;flex-direction:column;flex-wrap:nowrap;gap:0px;height:min-content;justify-content:flex-start;overflow:hidden;padding:0 15px 0 30px;position:relative;width:400px;will-change:transform}.framer-AzinR .framer-hx559f{-webkit-user-select:none;align-content:center;align-items:center;cursor:pointer;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:24px;height:min-content;justify-content:flex-start;overflow:visible;padding:20px 0;position:relative;user-select:none;width:100%}.framer-AzinR .framer-11zole{flex:1 0 0px;height:auto;position:relative;white-space:pre-wrap;width:1px;word-break:break-word;word-wrap:break-word}.framer-AzinR .framer-5niy1l-container{flex:none;height:30px;position:relative;width:30px;z-index:1}.framer-AzinR .framer-1u5bl2m{align-content:flex-start;align-items:flex-start;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:flex-start;overflow:visible;padding:0 20px 20px 0;position:relative;width:100%}.framer-AzinR .framer-2fzm90{-webkit-user-select:none;flex:none;height:auto;position:relative;user-select:none;white-space:pre-wrap;width:100%;word-break:break-word;word-wrap:break-word}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-AzinR .framer-1iem2z4,.framer-AzinR .framer-hx559f,.framer-AzinR .framer-1u5bl2m{gap:0px}.framer-AzinR .framer-1iem2z4>*{margin:0}.framer-AzinR .framer-1iem2z4>:first-child,.framer-AzinR .framer-1u5bl2m>:first-child{margin-top:0}.framer-AzinR .framer-1iem2z4>:last-child,.framer-AzinR .framer-1u5bl2m>:last-child{margin-bottom:0}.framer-AzinR .framer-hx559f>*{margin:0 12px}.framer-AzinR .framer-hx559f>:first-child{margin-left:0}.framer-AzinR .framer-hx559f>:last-child{margin-right:0}.framer-AzinR .framer-1u5bl2m>*{margin:5px 0}}.framer-AzinR.framer-v-ydksc3 .framer-1iem2z4{padding:0 15px 15px 30px}.framer-yZDyR .framer-styles-preset-rvj9v6:not(.rich-text-wrapper),.framer-yZDyR .framer-styles-preset-rvj9v6.rich-text-wrapper h5{--framer-font-family: "Outfit", sans-serif;--framer-font-size: 25px;--framer-font-style: normal;--framer-font-weight: 600;--framer-letter-spacing: -.5px;--framer-line-height: 1.3em;--framer-paragraph-spacing: 40px;--framer-text-alignment: left;--framer-text-color: var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, #07061b);--framer-text-decoration: none;--framer-text-transform: none}@media (max-width: 1199px) and (min-width: 810px){.framer-yZDyR .framer-styles-preset-rvj9v6:not(.rich-text-wrapper),.framer-yZDyR .framer-styles-preset-rvj9v6.rich-text-wrapper h5{--framer-font-family: "Outfit", sans-serif;--framer-font-size: 24px;--framer-font-style: normal;--framer-font-weight: 600;--framer-letter-spacing: -.5px;--framer-line-height: 1.3em;--framer-paragraph-spacing: 40px;--framer-text-alignment: left;--framer-text-color: var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, #07061b);--framer-text-decoration: none;--framer-text-transform: none}}@media (max-width: 809px) and (min-width: 0px){.framer-yZDyR .framer-styles-preset-rvj9v6:not(.rich-text-wrapper),.framer-yZDyR .framer-styles-preset-rvj9v6.rich-text-wrapper h5{--framer-font-family: "Outfit", sans-serif;--framer-font-size: 22px;--framer-font-style: normal;--framer-font-weight: 600;--framer-letter-spacing: -.5px;--framer-line-height: 1.3em;--framer-paragraph-spacing: 40px;--framer-text-alignment: left;--framer-text-color: var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, #07061b);--framer-text-decoration: none;--framer-text-transform: none}}.framer-AbhQC [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-AbhQC .framer-j4qz97{display:block}.framer-AbhQC .framer-1jl5bk5{align-content:center;align-items:center;display:flex;flex-direction:row;flex-wrap:nowrap;gap:8px;height:48px;justify-content:center;padding:16px 20px;position:relative;text-decoration:none;width:min-content}.framer-AbhQC .framer-yw0mic{flex:none;height:auto;position:relative;white-space:pre;width:auto}.framer-AbhQC .framer-enchlq-container,.framer-AbhQC .framer-9beici-container,.framer-AbhQC .framer-2g8dij-container,.framer-AbhQC .framer-1vvxztz-container{flex:none;height:24px;position:relative;width:24px}.framer-AbhQC .framer-v-1jl5bk5 .framer-1jl5bk5{cursor:pointer}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-AbhQC .framer-1jl5bk5{gap:0px}.framer-AbhQC .framer-1jl5bk5>*{margin:0 4px}.framer-AbhQC .framer-1jl5bk5>:first-child{margin-left:0}.framer-AbhQC .framer-1jl5bk5>:last-child{margin-right:0}}.framer-QJGIc [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-QJGIc .framer-w2ty6h{display:block}.framer-QJGIc .framer-zgp91r{align-content:flex-start;align-items:flex-start;display:flex;flex-direction:column;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:flex-start;overflow:hidden;padding:40px 30px;position:relative;width:387px;will-change:transform}.framer-QJGIc .framer-1x3d2to{align-content:flex-start;align-items:flex-start;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:15px;height:min-content;justify-content:center;overflow:hidden;padding:0;position:relative;width:100%}.framer-QJGIc .framer-1iqyay8-container{flex:none;height:auto;position:relative;width:auto}.framer-QJGIc .framer-hessy3{align-content:flex-end;align-items:flex-end;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:5px;height:min-content;justify-content:flex-start;overflow:visible;padding:0;position:relative;width:min-content}.framer-QJGIc .framer-123h1n0,.framer-QJGIc .framer-1r6clop{flex:none;height:auto;position:relative;white-space:pre;width:auto}.framer-QJGIc .framer-rhnj1c{align-content:center;align-items:center;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:10px;height:234px;justify-content:flex-start;overflow:visible;padding:20px 0;position:relative;width:327px}.framer-QJGIc .framer-7i7pwb,.framer-QJGIc .framer-1w4hovk,.framer-QJGIc .framer-1uv7g8s,.framer-QJGIc .framer-icf272,.framer-QJGIc .framer-1neptcv,.framer-QJGIc .framer-1p6b1c7{align-content:flex-start;align-items:flex-start;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:flex-start;overflow:visible;padding:0;position:relative;width:100%}.framer-QJGIc .framer-1oqwx8b-container,.framer-QJGIc .framer-wwg05k-container,.framer-QJGIc .framer-1vm0f1x-container,.framer-QJGIc .framer-1vekzme-container,.framer-QJGIc .framer-v6r9sr-container,.framer-QJGIc .framer-1lbdgy1-container{flex:none;height:24px;position:relative;width:24px}.framer-QJGIc .framer-176aztz,.framer-QJGIc .framer-u513nc,.framer-QJGIc .framer-1y3r2u,.framer-QJGIc .framer-1dlbrxe,.framer-QJGIc .framer-1l0spno,.framer-QJGIc .framer-1om743s{flex:1 0 0px;height:auto;position:relative;white-space:pre-wrap;width:1px;word-break:break-word;word-wrap:break-word}.framer-QJGIc .framer-67ei2v,.framer-QJGIc .framer-1p6mk8l{align-content:center;align-items:center;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:flex-start;overflow:visible;padding:0;position:relative;width:100%}.framer-QJGIc .framer-2ebv60-container,.framer-QJGIc .framer-doecf0-container{flex:none;height:48px;position:relative;width:auto}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-QJGIc .framer-zgp91r,.framer-QJGIc .framer-1x3d2to,.framer-QJGIc .framer-hessy3,.framer-QJGIc .framer-rhnj1c,.framer-QJGIc .framer-7i7pwb,.framer-QJGIc .framer-1w4hovk,.framer-QJGIc .framer-1uv7g8s,.framer-QJGIc .framer-icf272,.framer-QJGIc .framer-1neptcv,.framer-QJGIc .framer-1p6b1c7,.framer-QJGIc .framer-67ei2v,.framer-QJGIc .framer-1p6mk8l{gap:0px}.framer-QJGIc .framer-zgp91r>*,.framer-QJGIc .framer-rhnj1c>*{margin:5px 0}.framer-QJGIc .framer-zgp91r>:first-child,.framer-QJGIc .framer-1x3d2to>:first-child,.framer-QJGIc .framer-rhnj1c>:first-child{margin-top:0}.framer-QJGIc .framer-zgp91r>:last-child,.framer-QJGIc .framer-1x3d2to>:last-child,.framer-QJGIc .framer-rhnj1c>:last-child{margin-bottom:0}.framer-QJGIc .framer-1x3d2to>*{margin:7.5px 0}.framer-QJGIc .framer-hessy3>*{margin:0 2.5px}.framer-QJGIc .framer-hessy3>:first-child,.framer-QJGIc .framer-7i7pwb>:first-child,.framer-QJGIc .framer-1w4hovk>:first-child,.framer-QJGIc .framer-1uv7g8s>:first-child,.framer-QJGIc .framer-icf272>:first-child,.framer-QJGIc .framer-1neptcv>:first-child,.framer-QJGIc .framer-1p6b1c7>:first-child,.framer-QJGIc .framer-67ei2v>:first-child,.framer-QJGIc .framer-1p6mk8l>:first-child{margin-left:0}.framer-QJGIc .framer-hessy3>:last-child,.framer-QJGIc .framer-7i7pwb>:last-child,.framer-QJGIc .framer-1w4hovk>:last-child,.framer-QJGIc .framer-1uv7g8s>:last-child,.framer-QJGIc .framer-icf272>:last-child,.framer-QJGIc .framer-1neptcv>:last-child,.framer-QJGIc .framer-1p6b1c7>:last-child,.framer-QJGIc .framer-67ei2v>:last-child,.framer-QJGIc .framer-1p6mk8l>:last-child{margin-right:0}.framer-QJGIc .framer-7i7pwb>*,.framer-QJGIc .framer-1w4hovk>*,.framer-QJGIc .framer-1uv7g8s>*,.framer-QJGIc .framer-icf272>*,.framer-QJGIc .framer-1neptcv>*,.framer-QJGIc .framer-1p6b1c7>*,.framer-QJGIc .framer-67ei2v>*,.framer-QJGIc .framer-1p6mk8l>*{margin:0 5px}}.framer-QJGIc.framer-v-42r5rv .framer-zgp91r{padding:50px 30px 40px;width:387px}.framer-QJGIc.framer-v-42r5rv .framer-1x3d2to{order:0}.framer-QJGIc.framer-v-42r5rv .framer-rhnj1c{order:1}.framer-QJGIc.framer-v-42r5rv .framer-2ebv60-container{order:2}.framer-t2HbJ .framer-styles-preset-1kn4yjy:not(.rich-text-wrapper),.framer-t2HbJ .framer-styles-preset-1kn4yjy.rich-text-wrapper h2{--framer-font-family: "Outfit", sans-serif;--framer-font-size: 56px;--framer-font-style: normal;--framer-font-weight: 500;--framer-letter-spacing: -1px;--framer-line-height: 1em;--framer-paragraph-spacing: 40px;--framer-text-alignment: center;--framer-text-color: #ffffff;--framer-text-decoration: none;--framer-text-transform: none}@media (max-width: 1399px) and (min-width: 810px){.framer-t2HbJ .framer-styles-preset-1kn4yjy:not(.rich-text-wrapper),.framer-t2HbJ .framer-styles-preset-1kn4yjy.rich-text-wrapper h2{--framer-font-family: "Outfit", sans-serif;--framer-font-size: 45px;--framer-font-style: normal;--framer-font-weight: 500;--framer-letter-spacing: -1px;--framer-line-height: 1em;--framer-paragraph-spacing: 40px;--framer-text-alignment: center;--framer-text-color: #ffffff;--framer-text-decoration: none;--framer-text-transform: none}}@media (max-width: 809px) and (min-width: 0px){.framer-t2HbJ .framer-styles-preset-1kn4yjy:not(.rich-text-wrapper),.framer-t2HbJ .framer-styles-preset-1kn4yjy.rich-text-wrapper h2{--framer-font-family: "Outfit", sans-serif;--framer-font-size: 36px;--framer-font-style: normal;--framer-font-weight: 500;--framer-letter-spacing: -1px;--framer-line-height: 1em;--framer-paragraph-spacing: 40px;--framer-text-alignment: center;--framer-text-color: #ffffff;--framer-text-decoration: none;--framer-text-transform: none}}.framer-GYe7W [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-GYe7W .framer-1fc7vqd{display:block}.framer-GYe7W .framer-uxqkqo{align-content:center;align-items:center;display:flex;flex-direction:row;flex-wrap:nowrap;gap:8px;height:48px;justify-content:center;padding:16px 20px;position:relative;text-decoration:none;width:min-content}.framer-GYe7W .framer-1xqtqpo{flex:none;height:auto;position:relative;white-space:pre;width:auto}.framer-GYe7W .framer-1rhixts-container,.framer-GYe7W .framer-kx7dlg-container,.framer-GYe7W .framer-a159r4-container,.framer-GYe7W .framer-1kkapz3-container{flex:none;height:24px;position:relative;width:24px}.framer-GYe7W .framer-v-uxqkqo .framer-uxqkqo{cursor:pointer}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-GYe7W .framer-uxqkqo{gap:0px}.framer-GYe7W .framer-uxqkqo>*{margin:0 4px}.framer-GYe7W .framer-uxqkqo>:first-child{margin-left:0}.framer-GYe7W .framer-uxqkqo>:last-child{margin-right:0}}.framer-CRaJE [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-CRaJE .framer-1l3jcu6{display:block}.framer-CRaJE .framer-11qry34{align-content:center;align-items:center;display:flex;flex-direction:row;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:center;overflow:hidden;padding:0;position:relative;width:min-content}.framer-CRaJE .framer-th1nd8-container{flex:none;height:464px;position:relative;width:1402px}.framer-CRaJE .framer-1pkbqav-container,.framer-CRaJE .framer-1eln0xy-container,.framer-CRaJE .framer-42fyjj-container,.framer-CRaJE .framer-5mviaa-container{height:auto;position:relative;width:auto}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-CRaJE .framer-11qry34{gap:0px}.framer-CRaJE .framer-11qry34>*{margin:0 5px}.framer-CRaJE .framer-11qry34>:first-child{margin-left:0}.framer-CRaJE .framer-11qry34>:last-child{margin-right:0}}.framer-LHjq9 [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-LHjq9 .framer-17wa1eq{display:block}.framer-LHjq9 .framer-yfdsr1{align-content:center;align-items:center;display:flex;flex-direction:column;flex-wrap:nowrap;gap:30px;height:min-content;justify-content:flex-start;overflow:visible;padding:50px 40px 40px;position:relative;width:min-content}.framer-LHjq9 .framer-1fuhp6q{align-self:stretch;flex:none;height:auto;overflow:hidden;position:relative;white-space:pre-wrap;width:auto;word-break:break-word;word-wrap:break-word}.framer-LHjq9 .framer-13nqy58{align-content:center;align-items:center;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:12px;height:min-content;justify-content:flex-start;overflow:visible;padding:0;position:relative;width:260px}.framer-LHjq9 .framer-1hux1zy{aspect-ratio:1 / 1;flex:none;height:54px;overflow:visible;position:relative;width:var(--framer-aspect-ratio-supported, 54px)}.framer-LHjq9 .framer-13bxuqs{align-content:flex-start;align-items:flex-start;display:flex;flex:1 0 0px;flex-direction:column;flex-wrap:nowrap;gap:0px;height:min-content;justify-content:flex-start;overflow:visible;padding:0;position:relative;width:1px}.framer-LHjq9 .framer-xohxo2,.framer-LHjq9 .framer-lcz8nb{flex:none;height:auto;overflow:hidden;position:relative;white-space:pre-wrap;width:100%;word-break:break-word;word-wrap:break-word}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-LHjq9 .framer-yfdsr1,.framer-LHjq9 .framer-13nqy58,.framer-LHjq9 .framer-13bxuqs{gap:0px}.framer-LHjq9 .framer-yfdsr1>*{margin:15px 0}.framer-LHjq9 .framer-yfdsr1>:first-child,.framer-LHjq9 .framer-13bxuqs>:first-child{margin-top:0}.framer-LHjq9 .framer-yfdsr1>:last-child,.framer-LHjq9 .framer-13bxuqs>:last-child{margin-bottom:0}.framer-LHjq9 .framer-13nqy58>*{margin:0 6px}.framer-LHjq9 .framer-13nqy58>:first-child{margin-left:0}.framer-LHjq9 .framer-13nqy58>:last-child{margin-right:0}.framer-LHjq9 .framer-13bxuqs>*{margin:0}}.framer-MfPvW .framer-styles-preset-1il5k53:not(.rich-text-wrapper),.framer-MfPvW .framer-styles-preset-1il5k53.rich-text-wrapper p{--framer-font-family: "Inter", sans-serif;--framer-font-size: 20px;--framer-font-style: normal;--framer-font-weight: 500;--framer-letter-spacing: -.5px;--framer-line-height: 1.5em;--framer-paragraph-spacing: 20px;--framer-text-alignment: center;--framer-text-color: var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, #767575);--framer-text-decoration: none;--framer-text-transform: none}@media (max-width: 1399px) and (min-width: 810px){.framer-MfPvW .framer-styles-preset-1il5k53:not(.rich-text-wrapper),.framer-MfPvW .framer-styles-preset-1il5k53.rich-text-wrapper p{--framer-font-family: "Inter", sans-serif;--framer-font-size: 20px;--framer-font-style: normal;--framer-font-weight: 500;--framer-letter-spacing: -.5px;--framer-line-height: 1.5em;--framer-paragraph-spacing: 20px;--framer-text-alignment: center;--framer-text-color: var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, #767575);--framer-text-decoration: none;--framer-text-transform: none}}@media (max-width: 809px) and (min-width: 0px){.framer-MfPvW .framer-styles-preset-1il5k53:not(.rich-text-wrapper),.framer-MfPvW .framer-styles-preset-1il5k53.rich-text-wrapper p{--framer-font-family: "Inter", sans-serif;--framer-font-size: 18px;--framer-font-style: normal;--framer-font-weight: 500;--framer-letter-spacing: -.5px;--framer-line-height: 1.5em;--framer-paragraph-spacing: 20px;--framer-text-alignment: center;--framer-text-color: var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, #767575);--framer-text-decoration: none;--framer-text-transform: none}}.framer-wCJvD [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-wCJvD .framer-1dmg7ny{display:block}.framer-wCJvD .framer-1putop8{align-content:center;align-items:center;display:flex;flex-direction:row;flex-wrap:nowrap;gap:6px;height:min-content;justify-content:center;padding:4px 10px;position:relative;width:min-content}.framer-wCJvD .framer-z50fkt,.framer-wCJvD .framer-s13pw5{flex:none;height:auto;position:relative;white-space:pre;width:auto}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-wCJvD .framer-1putop8{gap:0px}.framer-wCJvD .framer-1putop8>*{margin:0 3px}.framer-wCJvD .framer-1putop8>:first-child{margin-left:0}.framer-wCJvD .framer-1putop8>:last-child{margin-right:0}}.framer-ja4cB [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}.framer-ja4cB .framer-xg6orl{display:block}.framer-ja4cB .framer-66h6mb{align-content:center;align-items:center;display:flex;flex-direction:row;flex-wrap:nowrap;gap:8px;height:56px;justify-content:center;padding:16px 26px;position:relative;text-decoration:none;width:211px}.framer-ja4cB .framer-zrci7o{flex:none;height:auto;position:relative;white-space:pre;width:auto}.framer-ja4cB .framer-u2gr0z-container,.framer-ja4cB .framer-139hg03-container,.framer-ja4cB .framer-1ei4sym-container,.framer-ja4cB .framer-tc263p-container,.framer-ja4cB .framer-1u9xvrn-container{flex:none;height:24px;position:relative;width:24px}.framer-ja4cB .framer-v-66h6mb .framer-66h6mb{cursor:pointer}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-ja4cB .framer-66h6mb{gap:0px}.framer-ja4cB .framer-66h6mb>*{margin:0 4px}.framer-ja4cB .framer-66h6mb>:first-child{margin-left:0}.framer-ja4cB .framer-66h6mb>:last-child{margin-right:0}}.ssr-variant{display:contents}.framer-7A7oM [data-border=true]:after{content:"";border-width:var(--border-top-width, 0) var(--border-right-width, 0) var(--border-bottom-width, 0) var(--border-left-width, 0);border-color:var(--border-color, none);border-style:var(--border-style, none);width:100%;height:100%;position:absolute;box-sizing:border-box;left:0;top:0;border-radius:inherit;pointer-events:none}@supports (aspect-ratio: 1){body{--framer-aspect-ratio-supported: auto}}.framer-7A7oM .framer-p44cbb{display:block}.framer-7A7oM .framer-15ydkky{align-content:center;align-items:center;display:flex;flex-direction:row;flex-wrap:nowrap;gap:230px;height:min-content;justify-content:center;overflow:visible;padding:80px 0 40px;position:relative;width:1400px}.framer-7A7oM .framer-13etdgb{align-content:center;align-items:center;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:120px;height:min-content;justify-content:flex-start;max-width:1200px;overflow:visible;padding:0;position:relative;width:90%}.framer-7A7oM .framer-qtnvi9{align-content:flex-start;align-items:flex-start;display:flex;flex:none;flex-direction:row;flex-wrap:wrap;height:min-content;justify-content:space-between;max-width:1200px;overflow:visible;padding:0;position:relative;width:100%}.framer-7A7oM .framer-1h7o8p6{aspect-ratio:4.021739130434782 / 1;flex:none;height:var(--framer-aspect-ratio-supported, 48px);overflow:visible;position:relative;width:193px}.framer-7A7oM .framer-ajjz1r{align-content:flex-start;align-items:flex-start;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:120px;height:min-content;justify-content:flex-end;max-width:50%;overflow:visible;padding:0;position:relative;width:600px}.framer-7A7oM .framer-1nj0pi2{align-content:flex-end;align-items:flex-end;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:15px;height:min-content;justify-content:flex-start;overflow:visible;padding:0;position:relative;width:min-content}.framer-7A7oM .framer-nemxzq{align-content:flex-start;align-items:flex-start;display:flex;flex:none;flex-direction:column;flex-wrap:nowrap;gap:10px;height:min-content;justify-content:flex-start;overflow:visible;padding:0;position:relative;width:min-content}.framer-7A7oM .framer-1ga0r7l,.framer-7A7oM .framer-1vunyui,.framer-7A7oM .framer-1o2uvx5,.framer-7A7oM .framer-svfcx9,.framer-7A7oM .framer-1bm4zdu{flex:none;height:auto;overflow:visible;position:relative;white-space:pre;width:auto}.framer-7A7oM .framer-1am5xcs{align-content:center;align-items:center;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;height:min-content;justify-content:space-between;max-width:1200px;overflow:visible;padding:40px 0 0;position:relative;width:100%}.framer-7A7oM .framer-1aa7prg{align-content:center;align-items:center;display:flex;flex:none;flex-direction:row;flex-wrap:nowrap;gap:16px;height:min-content;justify-content:flex-start;overflow:visible;padding:0;position:relative;width:min-content}.framer-7A7oM .framer-w9rx7l,.framer-7A7oM .framer-18icjf5,.framer-7A7oM .framer-itd4wn{flex:none;height:24px;position:relative;text-decoration:none;width:24px}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-7A7oM .framer-15ydkky,.framer-7A7oM .framer-13etdgb,.framer-7A7oM .framer-ajjz1r,.framer-7A7oM .framer-1nj0pi2,.framer-7A7oM .framer-nemxzq,.framer-7A7oM .framer-1aa7prg{gap:0px}.framer-7A7oM .framer-15ydkky>*{margin:0 115px}.framer-7A7oM .framer-15ydkky>:first-child,.framer-7A7oM .framer-ajjz1r>:first-child,.framer-7A7oM .framer-1aa7prg>:first-child{margin-left:0}.framer-7A7oM .framer-15ydkky>:last-child,.framer-7A7oM .framer-ajjz1r>:last-child,.framer-7A7oM .framer-1aa7prg>:last-child{margin-right:0}.framer-7A7oM .framer-13etdgb>*{margin:60px 0}.framer-7A7oM .framer-13etdgb>:first-child,.framer-7A7oM .framer-1nj0pi2>:first-child,.framer-7A7oM .framer-nemxzq>:first-child{margin-top:0}.framer-7A7oM .framer-13etdgb>:last-child,.framer-7A7oM .framer-1nj0pi2>:last-child,.framer-7A7oM .framer-nemxzq>:last-child{margin-bottom:0}.framer-7A7oM .framer-ajjz1r>*{margin:0 60px}.framer-7A7oM .framer-1nj0pi2>*{margin:7.5px 0}.framer-7A7oM .framer-nemxzq>*{margin:5px 0}.framer-7A7oM .framer-1aa7prg>*{margin:0 8px}}.framer-7A7oM.framer-v-vdokl6 .framer-15ydkky{width:810px}.framer-7A7oM.framer-v-x85nsx .framer-15ydkky{padding:60px 40px 40px;width:390px}.framer-7A7oM.framer-v-x85nsx .framer-13etdgb{gap:40px}.framer-7A7oM.framer-v-x85nsx .framer-qtnvi9{align-content:center;align-items:center;flex-direction:column;gap:40px;justify-content:flex-start}.framer-7A7oM.framer-v-x85nsx .framer-ajjz1r{justify-content:center}.framer-7A7oM.framer-v-x85nsx .framer-nemxzq{align-content:center;align-items:center}.framer-7A7oM.framer-v-x85nsx .framer-1am5xcs{flex-direction:column;gap:20px;justify-content:flex-start;padding:20px 0 0}@supports (background: -webkit-named-image(i)) and (not (font-palette:dark)){.framer-7A7oM.framer-v-x85nsx .framer-13etdgb,.framer-7A7oM.framer-v-x85nsx .framer-qtnvi9,.framer-7A7oM.framer-v-x85nsx .framer-1am5xcs{gap:0px}.framer-7A7oM.framer-v-x85nsx .framer-13etdgb>*,.framer-7A7oM.framer-v-x85nsx .framer-qtnvi9>*{margin:20px 0}.framer-7A7oM.framer-v-x85nsx .framer-13etdgb>:first-child,.framer-7A7oM.framer-v-x85nsx .framer-qtnvi9>:first-child,.framer-7A7oM.framer-v-x85nsx .framer-1am5xcs>:first-child{margin-top:0}.framer-7A7oM.framer-v-x85nsx .framer-13etdgb>:last-child,.framer-7A7oM.framer-v-x85nsx .framer-qtnvi9>:last-child,.framer-7A7oM.framer-v-x85nsx .framer-1am5xcs>:last-child{margin-bottom:0}.framer-7A7oM.framer-v-x85nsx .framer-1am5xcs>*{margin:10px 0}}.framer-vhuia .framer-styles-preset-1b2w4bo:not(.rich-text-wrapper),.framer-vhuia .framer-styles-preset-1b2w4bo.rich-text-wrapper p{--framer-font-family: "Inter-Medium", "Inter", sans-serif;--framer-font-size: 16px;--framer-font-style: normal;--framer-font-weight: 500;--framer-letter-spacing: 0em;--framer-line-height: 1.5em;--framer-paragraph-spacing: 20px;--framer-text-alignment: start;--framer-text-color: #333333;--framer-text-decoration: none;--framer-text-transform: none}.framer-pUwjr .framer-styles-preset-mrsdzn:not(.rich-text-wrapper),.framer-pUwjr .framer-styles-preset-mrsdzn.rich-text-wrapper a{--framer-link-current-text-color: #111111;--framer-link-current-text-decoration: underline;--framer-link-hover-text-color: var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, #767575);--framer-link-hover-text-decoration: none;--framer-link-text-color: var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, #1c1c1c);--framer-link-text-decoration: none}
</style>
    
    <!-- End of headEnd -->
</head>

<body class="framer-body-augiA20Il">
    <script async="" src="https://events.framer.com/script" data-fid=""use strict";(()=>{var pe,V,fe;function Re(){pe=Intl.DateTimeFormat().resolvedOptions(),V=pe.timeZone,fe=pe.locale}var he=null;function b(){if(!he){let t=document.currentScript;he={src:t.src,framerSiteId:t?t.getAttribute("data-fid"):null,trackNavigation:!t?.hasAttribute("data-no-nt"),cdn:"https://framerusercontent.com/sites/"}}return he}var ut=b();function x(){return Math.floor((1+Math.random())*65536).toString(16).substring(1)}function mt(){return`${x()}${x()}-${x()}-${x()}-${x()}-${x()}${x()}${x()}`}var S=class{constructor(e,o){this.timestamp=Date.now(),this.data={type:"track",uuid:mt(),event:e,...o,context:{framerSiteId:ut.framerSiteId,visitTimeOrigin:performance.timeOrigin,origin:location.origin,pathname:location.pathname,search:location.search,...o.context}}}serialize(e){return{source:"framer.site",timestamp:this.timestamp,sentTimestamp:e,data:this.data}}};var ze=new Set,Te=t=>ze.forEach(({callback:e,on:o})=>o===t&&e()),z=(t,e="lazy")=>ze.add({callback:t,on:e});addEventListener("visibilitychange",()=>{document.hidden&&Te("lazy")},!0);addEventListener("pagehide",()=>Te("lazy"),!0);addEventListener("load",()=>Te("load"));var ve,ee,N;function gt(t,e,o,r){let i=JSON.stringify(e);try{return window.fetchLater(t,{method:"POST",body:i,signal:r,activateAfter:o?3e3:10*6e4})}catch{return Ie(t,i),{activated:!0}}}function pt(t,e,o){return!1}function Ie(t,e){fetch(t,{method:"POST",body:e})}function ft(t,e){return navigator.sendBeacon(t,e)}function ye(t,e,o){if(!pt(t,e,o)){let r=JSON.stringify(e);ft(t,r)||Ie(t,r)}}var te=new Set;function Be(){for(let t of te)t();te.clear()}var I=window.scheduler,ht=I&&"yield"in I,_e=I&&"postTask"in I;function _(t=!1){return new Promise(e=>{if(te.add(e),!document.hidden){requestAnimationFrame(()=>{let o=()=>{te.delete(e),e()};t?ht?I.yield().then(o):_e?I.postTask(o):o():_e?I.postTask(o,{priority:"background"}):setTimeout(o,1)});return}Be()})}z(Be,"lazy");var Tt=b(),vt=new URL(Tt.src),Oe=`${vt.origin}/anonymous`;function Ne(t,e){return t==="eager"||e==="eager"?"eager":e??t}var ne=new Set,Se=!1;function Ee(){if(ne.size===0)return;if(!Se){Se=!0,queueMicrotask(Ee);return}let t=[],e=Date.now();ne.forEach(o=>o.forEach(r=>t.push(r.serialize(e)))),ne.clear(),ye(Oe,t,!1),Se=!1}async function w(t,e="lazy"){if(location.protocol.startsWith("https")&&t.length!==0){if(e==="eager"){await _();let o=Date.now();ye(Oe,t.map(r=>r.serialize(o)),!0);return}ne.add(t),document.hidden&&Ee()}}z(Ee,"lazy");var W="__framer_events";function We(){window[W]||(window[W]=[]);function t(e){let o,r=e.map(i=>{let[a,n,c]=i;return o=Ne(o,c),new S(a,n)});w(r,o??"eager")}window[W].length>0&&(t(window[W]),window[W].length=0),window[W].push=(...e)=>(t(e),-1)}var yt=b();function Q(t){let e=[new S("published_site_pageview",{referrer:t?.initialReferrer||null,url:location.href,hostname:location.hostname||null,pathname:location.pathname||null,hash:location.hash||null,search:location.search||null,framerSiteId:yt.framerSiteId,timezone:V,locale:fe})];w(e,"eager")}function Ue(){addEventListener("popstate",()=>Q());let t=history.pushState;history.pushState=(...e)=>{t.apply(history,e),Q()}}var ie=class{t;o=0;i=[];u(e){if(e.hadRecentInput)return;let o=this.i[0],r=this.i.at(-1);this.o&&o&&r&&e.startTime-r.startTime<1e3&&e.startTime-o.startTime<5e3?(this.o+=e.value,this.i.push(e)):(this.o=e.value,this.i=[e]),this.t?.(e)}},q=()=>{let t=performance.getEntriesByType("navigation")[0];if(t&&t.responseStart>0&&t.responseStart<performance.now())return t},oe=t=>{if(document.readyState==="loading")return"loading";{let e=q();if(e){if(t<e.domInteractive)return"loading";if(e.domContentLoadedEventStart===0||t<e.domContentLoadedEventStart)return"dom-interactive";if(e.domComplete===0||t<e.domComplete)return"dom-content-loaded"}}return"complete"},St=t=>{let e=t.nodeName;return t.nodeType===1?e.toLowerCase():e.toUpperCase().replace(/^#/,"")},we=t=>{let e="";try{for(;t?.nodeType!==9;){let o=t,r=o.id?"#"+o.id:[St(o),...Array.from(o.classList).sort()].join(".");if(e.length+r.length>99)return e||r;if(e=e?r+">"+e:r,o.id)break;t=o.parentNode}}catch{}return e},be=new WeakMap;function $(t,e){return be.get(t)||be.set(t,new e),be.get(t)}var Ye=-1,Ke=()=>Ye,j=t=>{addEventListener("pageshow",e=>{e.persisted&&(Ye=e.timeStamp,t(e))},!0)},L=(t,e,o,r)=>{let i,a;return n=>{e.value>=0&&(n||r)&&(a=e.value-(i??0),(a||i===void 0)&&(i=e.value,e.delta=a,e.rating=((c,l)=>c>l[1]?"poor":c>l[0]?"needs-improvement":"good")(e.value,o),t(e)))}},De=t=>{requestAnimationFrame(()=>requestAnimationFrame(()=>t()))},Z=()=>q()?.activationStart??0,P=(t,e=-1)=>{let o=q(),r="navigate";return Ke()>=0?r="back-forward-cache":o&&(document.prerendering||Z()>0?r="prerender":document.wasDiscarded?r="restore":o.type&&(r=o.type.replace(/_/g,"-"))),{name:t,value:e,rating:"good",delta:0,entries:[],id:`v5-${Date.now()}-${Math.floor(8999999999999*Math.random())+1e12}`,navigationType:r}},H=(t,e,o={})=>{try{if(PerformanceObserver.supportedEntryTypes.includes(t)){let r=new PerformanceObserver(i=>{Promise.resolve().then(()=>{e(i.getEntries())})});return r.observe({type:t,buffered:!0,...o}),r}}catch{}},Me=t=>{let e=!1;return()=>{e||(t(),e=!0)}},U=-1,$e=()=>document.visibilityState!=="hidden"||document.prerendering?1/0:0,ae=t=>{document.visibilityState==="hidden"&&U>-1&&(U=t.type==="visibilitychange"?t.timeStamp:0,Et())},He=()=>{addEventListener("visibilitychange",ae,!0),addEventListener("prerenderingchange",ae,!0)},Et=()=>{removeEventListener("visibilitychange",ae,!0),removeEventListener("prerenderingchange",ae,!0)},et=()=>{if(U<0){let t=Z();U=(document.prerendering?void 0:globalThis.performance.getEntriesByType("visibility-state").filter(o=>o.name==="hidden"&&o.startTime>t)[0]?.startTime)??$e(),He(),j(()=>{setTimeout(()=>{U=$e(),He()})})}return{get firstHiddenTime(){return U}}},de=t=>{document.prerendering?addEventListener("prerenderingchange",()=>t(),!0):t()},qe=[1800,3e3],tt=(t,e={})=>{de(()=>{let o=et(),r,i=P("FCP"),a=H("paint",n=>{for(let c of n)c.name==="first-contentful-paint"&&(a.disconnect(),c.startTime<o.firstHiddenTime&&(i.value=Math.max(c.startTime-Z(),0),i.entries.push(c),r(!0)))});a&&(r=L(t,i,qe,e.reportAllChanges),j(n=>{i=P("FCP"),r=L(t,i,qe,e.reportAllChanges),De(()=>{i.value=performance.now()-n.timeStamp,r(!0)})}))})},je=[.1,.25],Je=t=>t.find(e=>e.node?.nodeType===1)||t[0],nt=(t,e={})=>{let o=$(e=Object.assign({},e),ie),r=new WeakMap;o.t=i=>{if(i?.sources?.length){let a=Je(i.sources);if(a){let n=(e.generateTarget??we)(a.node);r.set(a,n)}}},((i,a={})=>{tt(Me(()=>{let n,c=P("CLS",0),l=$(a,ie),g=s=>{for(let f of s)l.u(f);l.o>c.value&&(c.value=l.o,c.entries=l.i,n())},p=H("layout-shift",g);p&&(n=L(i,c,je,a.reportAllChanges),document.addEventListener("visibilitychange",()=>{document.visibilityState==="hidden"&&(g(p.takeRecords()),n(!0))}),j(()=>{l.o=0,c=P("CLS",0),n=L(i,c,je,a.reportAllChanges),De(()=>n())}),setTimeout(n))}))})(i=>{let a=(n=>{let c={};if(n.entries.length){let l=n.entries.reduce((g,p)=>g.value>p.value?g:p);if(l?.sources?.length){let g=Je(l.sources);g&&(c={largestShiftTarget:r.get(g),largestShiftTime:l.startTime,largestShiftValue:l.value,largestShiftSource:g,largestShiftEntry:l,loadState:oe(l.startTime)})}}return Object.assign(n,{attribution:c})})(i);t(a)},e)},rt=(t,e={})=>{tt(o=>{let r=(i=>{let a={timeToFirstByte:0,firstByteToFCP:i.value,loadState:oe(Ke())};if(i.entries.length){let n=q(),c=i.entries.at(-1);if(n){let l=n.activationStart||0,g=Math.max(0,n.responseStart-l);a={timeToFirstByte:g,firstByteToFCP:i.value-g,loadState:oe(i.entries[0].startTime),navigationEntry:n,fcpEntry:c}}}return Object.assign(i,{attribution:a})})(o);t(r)},e)},it=0,Ce=1/0,re=0,bt=t=>{for(let e of t)e.interactionId&&(Ce=Math.min(Ce,e.interactionId),re=Math.max(re,e.interactionId),it=re?(re-Ce)/7+1:0)},Le,Ve=()=>Le?it:performance.interactionCount??0,Ct=()=>{"interactionCount"in performance||Le||(Le=H("event",bt,{type:"event",buffered:!0,durationThreshold:0}))},Ge=0,se=class{l=[];h=new Map;m;p;v(){Ge=Ve(),this.l.length=0,this.h.clear()}M(){let e=Math.min(this.l.length-1,Math.floor((Ve()-Ge)/50));return this.l[e]}u(e){if(this.m?.(e),!e.interactionId&&e.entryType!=="first-input")return;let o=this.l.at(-1),r=this.h.get(e.interactionId);if(r||this.l.length<10||e.duration>o.T){if(r?e.duration>r.T?(r.entries=[e],r.T=e.duration):e.duration===r.T&&e.startTime===r.entries[0].startTime&&r.entries.push(e):(r={id:e.interactionId,entries:[e],T:e.duration},this.h.set(r.id,r),this.l.push(r)),this.l.sort((i,a)=>a.T-i.T),this.l.length>10){let i=this.l.splice(10);for(let a of i)this.h.delete(a.id)}this.p?.(r)}}},Pe=t=>{let e=globalThis.requestIdleCallback||setTimeout;document.visibilityState==="hidden"?t():(t=Me(t),document.addEventListener("visibilitychange",t,{once:!0}),e(()=>{t(),document.removeEventListener("visibilitychange",t)}))},Qe=[200,500],ot=(t,e={})=>{let o=$(e=Object.assign({},e),se),r=[],i=[],a=0,n=new WeakMap,c=new WeakMap,l=!1,g=()=>{l||(Pe(p),l=!0)},p=()=>{let d=o.l.map(T=>n.get(T.entries[0])),u=i.length-50;i=i.filter((T,y)=>y>=u||d.includes(T));let m=new Set;for(let T of i){let y=s(T.startTime,T.processingEnd);for(let E of y)m.add(E)}let h=r.length-1-50;r=r.filter((T,y)=>T.startTime>a&&y>h||m.has(T)),l=!1};o.m=d=>{let u=d.startTime+d.duration,m;a=Math.max(a,d.processingEnd);for(let h=i.length-1;h>=0;h--){let T=i[h];if(Math.abs(u-T.renderTime)<=8){m=T,m.startTime=Math.min(d.startTime,m.startTime),m.processingStart=Math.min(d.processingStart,m.processingStart),m.processingEnd=Math.max(d.processingEnd,m.processingEnd),m.entries.push(d);break}}m||(m={startTime:d.startTime,processingStart:d.processingStart,processingEnd:d.processingEnd,renderTime:u,entries:[d]},i.push(m)),(d.interactionId||d.entryType==="first-input")&&n.set(d,m),g()},o.p=d=>{if(!c.get(d)){let u=(e.generateTarget??we)(d.entries[0].target);c.set(d,u)}};let s=(d,u)=>{let m=[];for(let h of r)if(!(h.startTime+h.duration<d)){if(h.startTime>u)break;m.push(h)}return m},f=d=>{let u=d.entries[0],m=n.get(u),h=u.processingStart,T=Math.max(u.startTime+u.duration,h),y=Math.min(m.processingEnd,T),E=m.entries.sort((v,C)=>v.processingStart-C.processingStart),A=s(u.startTime,y),D=o.h.get(u.interactionId),F={interactionTarget:c.get(D),interactionType:u.name.startsWith("key")?"keyboard":"pointer",interactionTime:u.startTime,nextPaintTime:T,processedEventEntries:E,longAnimationFrameEntries:A,inputDelay:h-u.startTime,processingDuration:y-h,presentationDelay:T-y,loadState:oe(u.startTime),longestScript:void 0,totalScriptDuration:void 0,totalStyleAndLayoutDuration:void 0,totalPaintDuration:void 0,totalUnattributedDuration:void 0};return(v=>{if(!v.longAnimationFrameEntries?.length)return;let C=v.interactionTime,R=v.inputDelay,X=v.processingDuration,M,O,le=0,J=0,ue=0,me=0;for(let Y of v.longAnimationFrameEntries){J=J+Y.startTime+Y.duration-Y.styleAndLayoutStart;for(let k of Y.scripts){let Ae=k.startTime+k.duration;if(Ae<C)continue;let K=Ae-Math.max(C,k.startTime),Fe=k.duration?K/k.duration*k.forcedStyleAndLayoutDuration:0;le+=K-Fe,J+=Fe,K>me&&(O=k.startTime<C+R?"input-delay":k.startTime>=C+R+X?"presentation-delay":"processing-duration",M=k,me=K)}}let ge=v.longAnimationFrameEntries.at(-1),xe=ge?ge.startTime+ge.duration:0;xe>=C+R+X&&(ue=v.nextPaintTime-xe),M&&O&&(v.longestScript={entry:M,subpart:O,intersectingDuration:me}),v.totalScriptDuration=le,v.totalStyleAndLayoutDuration=J,v.totalPaintDuration=ue,v.totalUnattributedDuration=v.nextPaintTime-C-le-J-ue})(F),Object.assign(d,{attribution:F})};H("long-animation-frame",d=>{r=r.concat(d),g()}),((d,u={})=>{globalThis.PerformanceEventTiming&&"interactionId"in PerformanceEventTiming.prototype&&de(()=>{Ct();let m,h=P("INP"),T=$(u,se),y=A=>{Pe(()=>{for(let F of A)T.u(F);let D=T.M();D&&D.T!==h.value&&(h.value=D.T,h.entries=D.entries,m())})},E=H("event",y,{durationThreshold:u.durationThreshold??40});m=L(d,h,Qe,u.reportAllChanges),E&&(E.observe({type:"first-input",buffered:!0}),document.addEventListener("visibilitychange",()=>{document.visibilityState==="hidden"&&(y(E.takeRecords()),m(!0))}),j(()=>{T.v(),h=P("INP"),m=L(d,h,Qe,u.reportAllChanges)}))})})(d=>{let u=f(d);t(u)},e)},ce=class{m;u(e){this.m?.(e)}},Ze=[2500,4e3],at=(t,e={})=>{let o=$(e=Object.assign({},e),ce),r=new WeakMap;o.m=i=>{if(i.element){let a=(e.generateTarget??we)(i.element);r.set(i,a)}},((i,a={})=>{de(()=>{let n=et(),c,l=P("LCP"),g=$(a,ce),p=f=>{a.reportAllChanges||(f=f.slice(-1));for(let d of f)g.u(d),d.startTime<n.firstHiddenTime&&(l.value=Math.max(d.startTime-Z(),0),l.entries=[d],c())},s=H("largest-contentful-paint",p);if(s){c=L(i,l,Ze,a.reportAllChanges);let f=Me(()=>{p(s.takeRecords()),s.disconnect(),c(!0)});for(let d of["keydown","click","visibilitychange"])addEventListener(d,()=>Pe(f),{capture:!0,once:!0});j(d=>{l=P("LCP"),c=L(i,l,Ze,a.reportAllChanges),De(()=>{l.value=performance.now()-d.timeStamp,c(!0)})})}})})(i=>{let a=(n=>{let c={timeToFirstByte:0,resourceLoadDelay:0,resourceLoadDuration:0,elementRenderDelay:n.value};if(n.entries.length){let l=q();if(l){let g=l.activationStart||0,p=n.entries.at(-1),s=p.url&&performance.getEntriesByType("resource").filter(m=>m.name===p.url)[0],f=Math.max(0,l.responseStart-g),d=Math.max(f,s?(s.requestStart||s.startTime)-g:0),u=Math.min(n.value,Math.max(d,s?s.responseEnd-g:0));c={target:r.get(p),timeToFirstByte:f,resourceLoadDelay:d-f,resourceLoadDuration:u-d,elementRenderDelay:n.value-u,navigationEntry:l,lcpEntry:p},p.url&&(c.url=p.url),s&&(c.lcpResourceEntry=s)}}return Object.assign(n,{attribution:c})})(i);t(a)},e)},Xe=[800,1800],ke=t=>{document.prerendering?de(()=>ke(t)):document.readyState!=="complete"?addEventListener("load",()=>ke(t),!0):setTimeout(t)},st=(t,e={})=>{((o,r={})=>{let i=P("TTFB"),a=L(o,i,Xe,r.reportAllChanges);ke(()=>{let n=q();n&&(i.value=Math.max(n.responseStart-Z(),0),i.entries=[n],a(!0),j(()=>{i=P("TTFB",0),a=L(o,i,Xe,r.reportAllChanges),a(!0)}))})})(o=>{let r=(i=>{let a={waitingDuration:0,cacheDuration:0,dnsDuration:0,connectionDuration:0,requestDuration:0};if(i.entries.length){let n=i.entries[0],c=n.activationStart||0,l=Math.max((n.workerStart||n.fetchStart)-c,0),g=Math.max(n.domainLookupStart-c,0),p=Math.max(n.connectStart-c,0),s=Math.max(n.connectEnd-c,0);a={waitingDuration:l,cacheDuration:g-l,dnsDuration:p-g,connectionDuration:s-p,requestDuration:i.value-s,navigationEntry:n}}return Object.assign(i,{attribution:a})})(o);t(r)},e)};function Lt(t){for(let e in t)if(t[e]!==void 0)return!0;return!1}function B(t){return Lt(t)?t:void 0}function dt(){let t=document.getElementById("main");if(!t)return;let e=new Set;try{let a=n=>e.add(n);at(a),rt(a),nt(({value:n,...c})=>{e.add({...c,value:n*1e3})}),ot(a),st(a)}catch{}let o=new Set([...performance.getEntriesByType("mark"),...performance.getEntriesByType("measure")].filter(a=>a.name.startsWith("framer-")));new PerformanceObserver(a=>{a.getEntries().forEach(n=>{n.name.startsWith("framer-")&&o.add(n)})}).observe({entryTypes:["measure","mark"]});let r=t.dataset,i={pageOptimizedAt:r.framerPageOptimizedAt?new Date(r.framerPageOptimizedAt).getTime():null,ssrReleasedAt:r.framerSsrReleasedAt?new Date(r.framerSsrReleasedAt).getTime():null,origin:document.location.origin,pathname:document.location.pathname,search:document.location.search};z(()=>xt(i),"load"),z(()=>Pt(e,o,i),"lazy")}var ct=!1;function Pt(t,e,o){let r=document.getElementById("main");if(!r)return;let i=[];if(ct||(i.push(kt(o,r)),ct=!0),t.size>0&&(i.push(...Dt(t,o)),t.clear()),e.size>0){let a=Mt(e);a&&i.push(a),e.clear()}w(i)}function kt({pageOptimizedAt:t,ssrReleasedAt:e,origin:o,pathname:r,search:i},a){let n=performance.getEntriesByType("navigation")[0],c=document.querySelector("[data-framer-css-ssr-minified]");return new S("published_site_performance",{hydrationDurationMs:null,pageLoadDurationMs:null,domNodes:document.getElementsByTagName("*").length,resourcesCount:performance.getEntriesByType("resource").length,headSize:document.head.innerHTML.length,framerCSSSize:c?.textContent?.length,modulePreloads:document.querySelectorAll(`link[rel="modulepreload"][href^="${b().cdn}"]`).length,hasPageContent:a.dataset["framer-no-content"]===void 0,timeZone:V,pageOptimizedAt:t,ssrReleasedAt:e,devicePixelRatio:window.devicePixelRatio,timeToFirstByteMs:null,navigationTiming:n?{activationStart:n.activationStart,connectEnd:n.connectEnd,connectStart:n.connectStart,criticalCHRestart:n.criticalCHRestart,decodedBodySize:n.decodedBodySize,deliveryType:n.deliveryType,domComplete:n.domComplete,domContentLoadedEventEnd:n.domContentLoadedEventEnd,domContentLoadedEventStart:n.domContentLoadedEventStart,domInteractive:n.domInteractive,domainLookupEnd:n.domainLookupEnd,domainLookupStart:n.domainLookupStart,duration:n.duration,encodedBodySize:n.encodedBodySize,fetchStart:n.fetchStart,firstInterimResponseStart:n.firstInterimResponseStart,loadEventEnd:n.loadEventEnd,loadEventStart:n.loadEventStart,nextHopProtocol:n.nextHopProtocol,redirectCount:n.redirectCount,redirectEnd:n.redirectEnd,redirectStart:n.redirectStart,requestStart:n.requestStart,responseEnd:n.responseEnd,responseStart:n.responseStart,responseStatus:n.responseStatus,secureConnectionStart:n.secureConnectionStart,serverTiming:n.serverTiming?JSON.stringify(n.serverTiming):null,startTime:n.startTime,transferSize:n.transferSize,type:n.type,unloadEventEnd:n.unloadEventEnd,unloadEventStart:n.unloadEventStart,workerStart:n.workerStart}:void 0,connection:B({downlink:navigator.connection?.downlink,downlinkMax:navigator.connection?.downlinkMax,rtt:navigator.connection?.rtt,saveData:navigator.connection?.saveData,type:navigator.connection?.type}),context:{origin:o,pathname:r,search:i}})}var wt=0;function Dt(t,{pageOptimizedAt:e,ssrReleasedAt:o,origin:r,pathname:i,search:a}){let n=[];return t.forEach(c=>{t.delete(c);let{name:l,value:g,id:p,attribution:s}=c,f={metric:l,label:p,value:Math.round(g),counter:wt++,pageOptimizedAt:e,ssrReleasedAt:o,context:{origin:r,pathname:i,search:a},attributionLcp:void 0,attributionCls:void 0,attributionInp:void 0,attributionFcp:void 0,attributionTtfb:void 0};l==="LCP"?f.attributionLcp=B({element:s.target,timeToFirstByte:s.timeToFirstByte,resourceLoadDelay:s.resourceLoadDelay,resourceLoadTime:s.resourceLoadDuration,elementRenderDelay:s.elementRenderDelay,url:s.url}):l==="CLS"?f.attributionCls=B({largestShiftTarget:s.largestShiftTarget,largestShiftTime:s.largestShiftTime,largestShiftValue:s.largestShiftValue,loadState:s.loadState}):l==="INP"?f.attributionInp=B({eventTarget:s.interactionTarget,eventType:s.interactionType,eventTime:s.interactionTime?Math.round(s.interactionTime):void 0,loadState:s.loadState,inputDelay:s.inputDelay,processingDuration:s.processingDuration,presentationDelay:s.presentationDelay,nextPaintTime:s.nextPaintTime,totalScriptDuration:s.totalScriptDuration,totalStyleAndLayoutDuration:s.totalStyleAndLayoutDuration,totalPaintDuration:s.totalPaintDuration,totalUnattributedDuration:s.totalUnattributedDuration,longestScript:JSON.stringify(s.longestScript)}):l==="FCP"?f.attributionFcp=B({timeToFirstByte:s.timeToFirstByte,firstByteToFCP:s.firstByteToFCP,loadState:s.loadState}):l==="TTFB"&&(f.attributionTtfb=B({waitingTime:s.waitingDuration,dnsTime:s.dnsDuration,connectionTime:s.connectionDuration,requestTime:s.requestDuration,cacheDuration:s.cacheDuration})),n.push(new S("published_site_performance_web_vitals",f))}),n}function Mt(t){let e=[];if(t.forEach(o=>{t.delete(o);let{name:r,startTime:i,duration:a,detail:n}=o,c={name:r,startTime:i,duration:a,detail:n};e.push(c)}),e.length!==0)return new S("published_site_performance_user_timings",{timings:JSON.stringify(e)})}async function xt({origin:t,pathname:e,search:o}){let r=document.getElementById("main");if(!r)return;await _();let i=1/0,a=null,n=null,c=0,l=0,g=0,p=0,s=b().cdn,f=`^${s}[^/]+/`,d=".[^.]+.mjs$",u=new RegExp(`${f}script_main${d}`),m=new RegExp(`${f}framer${d}`),h=new RegExp(`${f}motion${d}`),T=performance.getEntriesByType("resource"),y=T.length;for(let A=0;A<y;A++){let D=T[A],{deliveryType:F,initiatorType:v,transferSize:C,decodedBodySize:R,encodedBodySize:X,name:M,startTime:O}=D;O>i||!(v==="script"&&M.startsWith(s))||(++g,(F==="cache"||F!==void 0&&C===0)&&++p,c+=X,l+=R,u.test(M)?i=O:a===null&&m.test(M)?a=R:n===null&&h.test(M)&&(n=R))}await _();let E=performance.getEntriesByType("navigation")[0];w([new S("published_site_performance_load",{pageLoadDurationMs:E?.domContentLoadedEventEnd!==void 0&&E.domContentLoadedEventStart!==void 0?Math.round(E.domContentLoadedEventEnd-E.domContentLoadedEventStart):null,resourcesCount:y,domNodes:document.getElementsByTagName("*").length,headSize:document.head.innerHTML.length,headDomNodes:document.head.getElementsByTagName("*").length,bodySize:document.body.innerHTML.length,bodyDomNodes:document.body.getElementsByTagName("*").length,reactRootSize:r.innerHTML.length,reactRootDomNodes:r.getElementsByTagName("*").length,jsSizeDecoded:l,jsSizeEncoded:c,jsCountCached:p,jsCountTotal:g,mainScriptStartTime:Number.isFinite(i)?i:null,libraryJSSizeDecoded:a,motionJSSizeDecoded:n,context:{origin:t,pathname:e,search:o}})])}function lt(){window.__send_framer_event=(t,e)=>{let o=new S(t,e);w([o],"eager")}}var At=b(),Ft=async()=>{if(await _(!0),Re(),At.trackNavigation){Ue();let t=typeof document.referrer=="string";Q({initialReferrer:t&&document.referrer||null})}dt(),lt(),We()};Ft();})();"></script>

    
    <!-- End of bodyStart -->
    <div id="main" data-framer-hydrate-v2="{&quot;routeId&quot;:&quot;augiA20Il&quot;,&quot;localizationId&quot;:&quot;default&quot;,&quot;localeId&quot;:&quot;default&quot;}" data-framer-ssr-released-at="2023-09-12T12:15:35.145Z" data-framer-page-optimized-at="2023-09-12T21:54:32.825Z"><div class="framer-pACsf framer-Kygub framer-MfPvW framer-t2HbJ framer-yZDyR" style="display:contents"><div class="framer-72rtr7" style="min-height:100%;width:auto"><div class="framer-piijv0-container"><div class="ssr-variant hidden-2u6iyy hidden-fynrlu"><div class="framer-89iJV framer-v-1c8ccoq" style="display:contents" tabindex="0"><div class="framer-1c8ccoq" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:2px;--border-color:rgba(118, 117, 117, 0.05);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;background-color:rgb(253, 242, 236);width:100%"><div class="framer-1ppb8fb" data-framer-name="Logo_ManageWise"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/tgELERqZ0nObn14bTi418qTbg17f5.png?scale-down-to=512" alt="Logo" srcset="https://framerusercontent.com/images/tgELERqZ0nObn14bTi418qTbg.png?scale-down-to=512 512w, https://framerusercontent.com/images/tgELERqZ0nObn14bTi418qTbg.png 555w" sizes="(min-width: 1400px) max(180px, 193.0435px), (max-width: 809px) max(180px, 193.0435px), (min-width: 810px) and (max-width: 1399px) 193.0435px" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" data-framer-original-sizes="180px"></div></div><div class="framer-12kf1xo" data-framer-name="Header Sections"><div class="framer-1cpe080" data-framer-name="Links"><div class="framer-16cvm8q-container"><div class="framer-Q72Eb framer-v-cj7bgq" style="display:contents" tabindex="0"><a class="framer-cj7bgq framer-1n98qpg" data-framer-name="Deafult" href="index.html#features"><div class="framer-1pk6ob0" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-hover-text-color:rgba(153, 153, 153, 0.6);--framer-link-text-decoration:none;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7SW50ZXItNTAw;--framer-font-weight:500;--framer-line-height:1.6em;--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Features</p></div></a></div></div><div data-framer-component-type="SVG" data-framer-name="Dot" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-1iwl0hw"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 4 5"><use href="#svg-819241569_136"></use></svg></div></div><div class="framer-vojyhk-container"><div class="framer-Q72Eb framer-v-cj7bgq" style="display:contents" tabindex="0"><a class="framer-cj7bgq framer-1n98qpg" data-framer-name="Deafult" href="index.html#faq"><div class="framer-1pk6ob0" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-hover-text-color:rgba(153, 153, 153, 0.6);--framer-link-text-decoration:none;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7SW50ZXItNTAw;--framer-font-weight:500;--framer-line-height:1.6em;--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">FAQ</p></div></a></div></div><div data-framer-component-type="SVG" data-framer-name="Dot" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-1r3bk6j"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 4 5"><use href="#svg-819241569_136"></use></svg></div></div><div class="framer-1oni54s-container"><div class="framer-Q72Eb framer-v-cj7bgq" style="display:contents" tabindex="0"><a class="framer-cj7bgq framer-1n98qpg" data-framer-name="Deafult" href="index.html#pricing"><div class="framer-1pk6ob0" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-hover-text-color:rgba(153, 153, 153, 0.6);--framer-link-text-decoration:none;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7SW50ZXItNTAw;--framer-font-weight:500;--framer-line-height:1.6em;--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Pricing</p></div></a></div></div><div data-framer-component-type="SVG" data-framer-name="Dot" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-1jz79wd"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 4 5"><use href="#svg-819241569_136"></use></svg></div></div><div class="framer-1udkk67-container"><div class="framer-Q72Eb framer-v-cj7bgq" style="display:contents" tabindex="0"><a class="framer-cj7bgq framer-1n98qpg" data-framer-name="Deafult" href="index.html#testimonials"><div class="framer-1pk6ob0" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-hover-text-color:rgba(153, 153, 153, 0.6);--framer-link-text-decoration:none;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7SW50ZXItNTAw;--framer-font-weight:500;--framer-line-height:1.6em;--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Testimonials</p></div></a></div></div></div><div class="framer-jrcz5n-container"><div class="framer-GYe7W framer-v-uxqkqo" style="display:contents" tabindex="0"><a aria-label="Primary" class="framer-uxqkqo framer-1fc7vqd" data-border="true" data-framer-name="Variant 1" data-reset="button" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:12px;border-bottom-right-radius:12px;border-top-left-radius:12px;border-top-right-radius:12px;height:100%" tabindex="0" href="https://templatesunit.lemonsqueezy.com/checkout/buy/181cb12c-ca54-44c6-bebd-46e3b656defc" target="_blank" rel="noopener"><div class="framer-1xqtqpo" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Buy Template</p></div></a></div></div></div></div></div></div><div class="ssr-variant hidden-72rtr7 hidden-fynrlu"><div class="framer-89iJV framer-v-1tazxdj" style="display:contents" tabindex="0"><div class="framer-1c8ccoq" data-border="true" data-framer-name="Tablet" style="--border-bottom-width:2px;--border-color:rgba(118, 117, 117, 0.05);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;background-color:rgb(253, 242, 236);width:100%"><div class="framer-1ppb8fb" data-framer-name="Logo_ManageWise"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/MwRbsJrk7ItYxeL7mKvPzrq3g.png" alt="Logo" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:contain;image-rendering:auto"></div></div><div class="framer-12kf1xo" data-framer-name="Header Sections"><div class="framer-1cpe080" data-framer-name="Links"><div class="framer-16cvm8q-container"><div class="framer-Q72Eb framer-v-cj7bgq" style="display:contents" tabindex="0"><a class="framer-cj7bgq framer-1n98qpg" data-framer-name="Deafult" href="index.html#features"><div class="framer-1pk6ob0" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-hover-text-color:rgba(153, 153, 153, 0.6);--framer-link-text-decoration:none;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7SW50ZXItNTAw;--framer-font-weight:500;--framer-line-height:1.6em;--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Features</p></div></a></div></div><div data-framer-component-type="SVG" data-framer-name="Dot" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-1iwl0hw"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 4 5"><use href="#svg-819241569_136"></use></svg></div></div><div class="framer-vojyhk-container"><div class="framer-Q72Eb framer-v-cj7bgq" style="display:contents" tabindex="0"><a class="framer-cj7bgq framer-1n98qpg" data-framer-name="Deafult" href="index.html#faq"><div class="framer-1pk6ob0" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-hover-text-color:rgba(153, 153, 153, 0.6);--framer-link-text-decoration:none;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7SW50ZXItNTAw;--framer-font-weight:500;--framer-line-height:1.6em;--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">FAQ</p></div></a></div></div><div data-framer-component-type="SVG" data-framer-name="Dot" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-1r3bk6j"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 4 5"><use href="#svg-819241569_136"></use></svg></div></div><div class="framer-1oni54s-container"><div class="framer-Q72Eb framer-v-cj7bgq" style="display:contents" tabindex="0"><a class="framer-cj7bgq framer-1n98qpg" data-framer-name="Deafult" href="index.html#pricing"><div class="framer-1pk6ob0" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-hover-text-color:rgba(153, 153, 153, 0.6);--framer-link-text-decoration:none;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7SW50ZXItNTAw;--framer-font-weight:500;--framer-line-height:1.6em;--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Pricing</p></div></a></div></div><div data-framer-component-type="SVG" data-framer-name="Dot" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-1jz79wd"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 4 5"><use href="#svg-819241569_136"></use></svg></div></div><div class="framer-1udkk67-container"><div class="framer-Q72Eb framer-v-cj7bgq" style="display:contents" tabindex="0"><a class="framer-cj7bgq framer-1n98qpg" data-framer-name="Deafult" href="index.html#testimonials"><div class="framer-1pk6ob0" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-hover-text-color:rgba(153, 153, 153, 0.6);--framer-link-text-decoration:none;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7SW50ZXItNTAw;--framer-font-weight:500;--framer-line-height:1.6em;--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Testimonials</p></div></a></div></div></div><div class="framer-jrcz5n-container"><div class="framer-GYe7W framer-v-uxqkqo" style="display:contents" tabindex="0"><a aria-label="Primary" class="framer-uxqkqo framer-1fc7vqd" data-border="true" data-framer-name="Variant 1" data-reset="button" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:12px;border-bottom-right-radius:12px;border-top-left-radius:12px;border-top-right-radius:12px;height:100%" tabindex="0" href="https://templatesunit.lemonsqueezy.com/checkout/buy/181cb12c-ca54-44c6-bebd-46e3b656defc" target="_blank" rel="noopener"><div class="framer-1xqtqpo" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Buy Template</p></div></a></div></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-89iJV framer-v-1a9p1ph" style="display:contents" tabindex="0"><div class="framer-1c8ccoq" data-border="true" data-framer-name="Phone" style="--border-bottom-width:2px;--border-color:rgba(118, 117, 117, 0.05);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;background-color:rgb(253, 242, 236);width:100%"><div class="framer-1ppb8fb" data-framer-name="Logo_ManageWise"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/tgELERqZ0nObn14bTi418qTbg17f5.png?scale-down-to=512" alt="Logo" srcset="https://framerusercontent.com/images/tgELERqZ0nObn14bTi418qTbg.png?scale-down-to=512 512w, https://framerusercontent.com/images/tgELERqZ0nObn14bTi418qTbg.png 555w" sizes="(min-width: 1400px) max(180px, 193.0435px), (max-width: 809px) max(180px, 193.0435px), (min-width: 810px) and (max-width: 1399px) 193.0435px" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" data-framer-original-sizes="180px"></div></div><div class="framer-11tjfpm-container" data-framer-name="Close X" name="Close X"><div style="display:contents"></div></div></div></div></div></div><header class="framer-1g2ju43" data-framer-name="Hero Section" name="Hero Section"><div class="framer-8f3uib" data-framer-name="Container" name="Container"><div class="framer-1c1y0hg" data-framer-name="Content" name="Content"><div class="framer-1hyemqj" data-framer-name="Heading wrapper" name="Heading wrapper" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="framer-vhthrs-container"><div class="framer-wCJvD framer-v-1putop8" style="display:contents" tabindex="0"><div class="framer-1putop8" data-border="true" data-framer-name="With Icon" style="--border-bottom-width:1px;--border-color:rgba(130, 71, 255, 0.2);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:8px;border-bottom-right-radius:8px;border-top-left-radius:8px;border-top-right-radius:8px"><div class="framer-z50fkt" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">👋</p></div><div class="framer-s13pw5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:12px;--framer-font-weight:600;--framer-letter-spacing:0.08em;--framer-text-color:var(--extracted-r6o4lv);--framer-text-transform:uppercase" class="framer-text">Welcome to Manage Wise!</p></div></div></div></div><div class="framer-zvqr6c" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;transform:none" data-framer-component-type="RichTextContainer"><h1 class="framer-text framer-styles-preset-1w52vu0" data-styles-preset="UvfdUSADq" style="--framer-text-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27))">Empower your business with <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">Strategic</span> insights<!-- --></h1></div></div><div class="ssr-variant hidden-2u6iyy"><div class="framer-15dce9y" data-framer-name="Paragraph" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ">Powerful management platform designed to streamline your business operations, boost productivity, and drive success</p></div></div><div class="ssr-variant hidden-72rtr7 hidden-fynrlu"><div class="framer-15dce9y" data-framer-name="Paragraph" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ">Powerful management platform designed to streamline your business operations, boost productivity, and drive success</p></div></div><div class="ssr-variant hidden-2u6iyy hidden-fynrlu"><div class="framer-1febxrw" data-framer-appear-id="1febxrw" data-framer-name="Buttons wrapper" name="Buttons wrapper" style="opacity:0.001;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) translateZ(0)"><div class="framer-19oy2xt-container"><div class="framer-ja4cB framer-v-66h6mb" style="display:contents" tabindex="0"><a aria-label="Primary" class="framer-66h6mb framer-xg6orl" data-framer-name="Variant 1" data-reset="button" style="background-color:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));border-bottom-left-radius:18px;border-bottom-right-radius:18px;border-top-left-radius:18px;border-top-right-radius:18px;box-shadow:none;height:100%;width:100%" tabindex="0" href="https://templatesunit.lemonsqueezy.com/checkout/buy/181cb12c-ca54-44c6-bebd-46e3b656defc" target="_blank" rel="noopener"><div class="framer-zrci7o" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:20px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Get Started</p></div></a></div></div><div class="framer-bujhiz-container"><div class="framer-pV8l8 framer-v-1j7wqg" style="display:contents" tabindex="0"><a aria-label="Primary" class="framer-1j7wqg framer-1qvg9qj" data-border="true" data-framer-name="Variant 1" data-reset="button" style="--border-bottom-width:1px;--border-color:rgb(221, 217, 212);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:18px;border-bottom-right-radius:18px;border-top-left-radius:18px;border-top-right-radius:18px;height:100%" tabindex="0" href="https://www.youtube.com/" target="_blank" rel="noopener"><div class="framer-upesbu" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:20px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Whatch Demo</p></div><div class="framer-1jveaxk-container"><div style="display:contents"></div></div></a></div></div></div></div><div class="ssr-variant hidden-72rtr7 hidden-fynrlu"><div class="framer-1febxrw" data-framer-appear-id="1djw3cv" data-framer-name="Buttons wrapper" name="Buttons wrapper" style="opacity:0.001;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) translateZ(0)"><div class="framer-19oy2xt-container"><div class="framer-ja4cB framer-v-66h6mb" style="display:contents" tabindex="0"><a aria-label="Primary" class="framer-66h6mb framer-xg6orl" data-framer-name="Variant 1" data-reset="button" style="background-color:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));border-bottom-left-radius:18px;border-bottom-right-radius:18px;border-top-left-radius:18px;border-top-right-radius:18px;box-shadow:none;height:100%;width:100%" tabindex="0" href="https://templatesunit.lemonsqueezy.com/checkout/buy/181cb12c-ca54-44c6-bebd-46e3b656defc" target="_blank" rel="noopener"><div class="framer-zrci7o" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:20px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Get Started</p></div></a></div></div><div class="framer-bujhiz-container"><div class="framer-pV8l8 framer-v-1j7wqg" style="display:contents" tabindex="0"><a aria-label="Primary" class="framer-1j7wqg framer-1qvg9qj" data-border="true" data-framer-name="Variant 1" data-reset="button" style="--border-bottom-width:1px;--border-color:rgb(221, 217, 212);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:18px;border-bottom-right-radius:18px;border-top-left-radius:18px;border-top-right-radius:18px;height:100%" tabindex="0" href="https://www.youtube.com/" target="_blank" rel="noopener"><div class="framer-upesbu" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:20px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Whatch Demo</p></div><div class="framer-1jveaxk-container"><div style="display:contents"></div></div></a></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-1febxrw" data-framer-appear-id="pw8hg2" data-framer-name="Buttons wrapper" name="Buttons wrapper" style="opacity:0.001;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) translateZ(0)"><div class="framer-19oy2xt-container"><div class="framer-ja4cB framer-v-66h6mb" style="display:contents" tabindex="0"><a aria-label="Primary" class="framer-66h6mb framer-xg6orl" data-framer-name="Variant 1" data-reset="button" style="background-color:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));border-bottom-left-radius:18px;border-bottom-right-radius:18px;border-top-left-radius:18px;border-top-right-radius:18px;box-shadow:none;height:100%;width:100%" tabindex="0" href="https://templatesunit.lemonsqueezy.com/checkout/buy/181cb12c-ca54-44c6-bebd-46e3b656defc" target="_blank" rel="noopener"><div class="framer-zrci7o" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:20px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Get Started</p></div></a></div></div><div class="framer-bujhiz-container"><div class="framer-pV8l8 framer-v-1j7wqg" style="display:contents" tabindex="0"><a aria-label="Primary" class="framer-1j7wqg framer-1qvg9qj" data-border="true" data-framer-name="Variant 1" data-reset="button" style="--border-bottom-width:1px;--border-color:rgb(221, 217, 212);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:18px;border-bottom-right-radius:18px;border-top-left-radius:18px;border-top-right-radius:18px;height:100%;width:100%" tabindex="0" href="https://www.youtube.com/" target="_blank" rel="noopener"><div class="framer-upesbu" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:20px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Whatch Demo</p></div><div class="framer-1jveaxk-container"><div style="display:contents"></div></div></a></div></div></div></div></div></div><div class="framer-1xg95ak" data-framer-name="Container" name="Container"><div class="ssr-variant hidden-2u6iyy hidden-fynrlu"><div class="framer-1hc0e4d" data-framer-name="Hero image" name="Hero image" style="opacity:1;transform:perspective(1200px) translateX(0px) translateY(0px) scale(0.9) rotate(0deg) rotateX(-20deg) rotateY(0deg) translateZ(0)"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg" alt="Graph" srcset="https://framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg?scale-down-to=512 512w, https://framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg?scale-down-to=1024 1024w, https://framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg?scale-down-to=2048 2048w, https://framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg?scale-down-to=4096 4096w, https://framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg 5768w" sizes="(min-width: 1400px) min(90vw, 1200px), (min-width: 810px) and (max-width: 1399px) 90vw, (max-width: 809px) 90vw" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:contain;image-rendering:auto" data-framer-original-sizes="min(90vw, 1200px)"></div></div></div><div class="ssr-variant hidden-72rtr7 hidden-fynrlu"><div class="framer-1hc0e4d" data-framer-name="Hero image" name="Hero image" style="opacity:1;transform:perspective(1200px) translateX(0px) translateY(0px) scale(0.9) rotate(0deg) rotateX(-20deg) rotateY(0deg) translateZ(0)"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg" alt="Graph" srcset="https://framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg?scale-down-to=512 512w, https://framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg?scale-down-to=1024 1024w, https://framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg?scale-down-to=2048 2048w, https://framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg?scale-down-to=4096 4096w, https://framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg 5768w" sizes="(min-width: 1400px) min(90vw, 1200px), (min-width: 810px) and (max-width: 1399px) 90vw, (max-width: 809px) 90vw" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:contain;image-rendering:auto" data-framer-original-sizes="90vw"></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-1hc0e4d" data-framer-name="Hero image" name="Hero image" style="opacity:1;transform:perspective(1200px) translateX(0px) translateY(0px) scale(0.9) rotate(0deg) rotateX(-20deg) rotateY(0deg) translateZ(0)"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg" alt="Graph" srcset="https://framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg?scale-down-to=512 512w, https://framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg?scale-down-to=1024 1024w, https://framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg?scale-down-to=2048 2048w, https://framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg?scale-down-to=4096 4096w, https://framerusercontent.com/images/t9qCSNfZSNdBCMSiohCGNEIl4.jpg 5768w" sizes="(min-width: 1400px) min(90vw, 1200px), (min-width: 810px) and (max-width: 1399px) 90vw, (max-width: 809px) 90vw" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:contain;image-rendering:auto" data-framer-original-sizes="90vw"></div></div></div></div></header><section aria-label="Features" class="framer-cpr011" data-framer-name="Features Section 1" id="features" name="Features Section 1" tabindex="0"><div class="framer-4d1i2v" data-framer-name="Container" name="Container"><div class="framer-hnhq2k" data-framer-name="Heading wrapper" name="Heading wrapper"><div class="framer-1t3qw2v-container"><div class="framer-wCJvD framer-v-1putop8" style="display:contents" tabindex="0"><div class="framer-1putop8" data-border="true" data-framer-name="With Icon" style="--border-bottom-width:1px;--border-color:rgba(130, 71, 255, 0.2);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:8px;border-bottom-right-radius:8px;border-top-left-radius:8px;border-top-right-radius:8px"><div class="framer-z50fkt" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">🔥</p></div><div class="framer-s13pw5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:12px;--framer-font-weight:600;--framer-letter-spacing:0.08em;--framer-text-color:var(--extracted-r6o4lv);--framer-text-transform:uppercase" class="framer-text">Premier features</p></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-fynrlu"><div class="framer-9cdg7p" data-framer-appear-id="9cdg7p" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h2 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27))">Discover our product's <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">Capabilities</span></h2></div></div><div class="ssr-variant hidden-72rtr7 hidden-fynrlu"><div class="framer-9cdg7p" data-framer-appear-id="98p300" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h2 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27))">Discover our product's <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">Capabilities</span></h2></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-9cdg7p" data-framer-appear-id="1vwx3w1" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h2 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27))">Discover our product's <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">Capabilities</span></h2></div></div><div class="framer-ukor2f" data-framer-name="Paragraph" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ">Don't settle for mediocrity - embrace the future of management with Manage Wise.</p></div></div><div class="framer-1f37ktk" data-framer-name="Big Cards" name="Big Cards"><div class="framer-4yt290-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="framer-iQudY framer-uw2CS framer-v-1dbgsa2" style="display:contents" tabindex="0"><div class="framer-1dbgsa2" data-framer-name="Variant 1" style="background-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;max-width:100%;width:100%"><div class="framer-1dqpucs" data-framer-name="Icon wrapper" style="background-color:rgb(255, 255, 255);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div class="framer-1esqs8p" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:28px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">⭐️</p></div></div><div class="framer-8gadg7" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-a0htzi:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h3 class="framer-text framer-styles-preset-o12rgh" data-styles-preset="uqRE_N40d" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-a0htzi)">Boost productivity and streamline workflow with us. Enjoy our intuitive interface and robust features.</h3></div></div></div></div><div class="framer-1rkd6ro-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="ssr-variant hidden-fynrlu"><div class="framer-URW6v framer-yZDyR framer-vhuia framer-v-1fk2kwq" style="display:contents" tabindex="0"><div class="framer-1fk2kwq" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px;max-width:100%;width:100%"><div class="framer-13g0du7" style="border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/qJeaFhSmQ29M1S55GRW5kYb4.png" alt="Task management" srcset="https://framerusercontent.com/images/qJeaFhSmQ29M1S55GRW5kYb4.png?scale-down-to=512 512w, https://framerusercontent.com/images/qJeaFhSmQ29M1S55GRW5kYb4.png?scale-down-to=1024 1024w, https://framerusercontent.com/images/qJeaFhSmQ29M1S55GRW5kYb4.png 1740w" sizes="(min-width: 1400px) min(580px, 100vw), (min-width: 810px) and (max-width: 1399px) min(580px, 100vw), (max-width: 809px) min(360px, 100vw)" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" data-framer-original-sizes="min(580px, 100vw)"></div></div><div class="framer-9ln4br" data-framer-name="Content"><div class="framer-190cacd" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-color:var(--extracted-r6o4lv)">Smart Task Management</p></div><div class="framer-ig49ty" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-r6o4lv)">Say goodbye to chaos with our smart task management system</p></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-URW6v framer-yZDyR framer-vhuia framer-v-gvt0t4" style="display:contents" tabindex="0"><div class="framer-1fk2kwq" data-border="true" data-framer-name="Mobile" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;max-width:100%;width:100%"><div class="framer-13g0du7" style="border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/qJeaFhSmQ29M1S55GRW5kYb4.png" alt="Task management" srcset="https://framerusercontent.com/images/qJeaFhSmQ29M1S55GRW5kYb4.png?scale-down-to=512 512w, https://framerusercontent.com/images/qJeaFhSmQ29M1S55GRW5kYb4.png?scale-down-to=1024 1024w, https://framerusercontent.com/images/qJeaFhSmQ29M1S55GRW5kYb4.png 1740w" sizes="(min-width: 1400px) min(580px, 100vw), (min-width: 810px) and (max-width: 1399px) min(580px, 100vw), (max-width: 809px) min(360px, 100vw)" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" data-framer-original-sizes="min(360px, 100vw)"></div></div><div class="framer-9ln4br" data-framer-name="Content"><div class="framer-190cacd" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-color:var(--extracted-r6o4lv)">Smart Task Management</p></div><div class="framer-ig49ty" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-r6o4lv)">Say goodbye to chaos with our smart task management system</p></div></div></div></div></div></div></div><div class="framer-1irddqm" data-framer-name="Small Cards" name="Small Cards"><div class="framer-yfbogm-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="ssr-variant hidden-2u6iyy hidden-fynrlu"><div class="framer-eBYbU framer-yZDyR framer-vhuia framer-v-1rya34" style="display:contents" tabindex="0"><div class="framer-1rya34" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px;width:100%"><div class="framer-3mtodw" style="border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/LFrHT3kBfxtMGAZfWkyLvYAKsbg.png" alt="Scheduling" srcset="https://framerusercontent.com/images/LFrHT3kBfxtMGAZfWkyLvYAKsbg.png?scale-down-to=512 512w, https://framerusercontent.com/images/LFrHT3kBfxtMGAZfWkyLvYAKsbg.png?scale-down-to=1024 1024w, https://framerusercontent.com/images/LFrHT3kBfxtMGAZfWkyLvYAKsbg.png 1122w" sizes="(min-width: 1400px) min(360px, 100vw), (min-width: 810px) and (max-width: 1399px) min(360px, 100vw), (max-width: 809px) min(360px, 100vw)" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" data-framer-original-sizes="min(360px, 100vw)"></div></div><div class="framer-1hnjuxt" data-framer-name="Content"><div class="framer-16f1i88" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-a0htzi:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h3 class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-color:var(--extracted-a0htzi)">Flexible Scheduling</h3></div><div class="framer-10e46b8" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-r6o4lv)">Stay productive with our flexible scheduling system</p></div></div></div></div></div><div class="ssr-variant hidden-72rtr7 hidden-fynrlu"><div class="framer-eBYbU framer-yZDyR framer-vhuia framer-v-1rya34" style="display:contents" tabindex="0"><div class="framer-1rya34" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px;max-width:100%;width:100%"><div class="framer-3mtodw" style="border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/LFrHT3kBfxtMGAZfWkyLvYAKsbg.png" alt="Scheduling" srcset="https://framerusercontent.com/images/LFrHT3kBfxtMGAZfWkyLvYAKsbg.png?scale-down-to=512 512w, https://framerusercontent.com/images/LFrHT3kBfxtMGAZfWkyLvYAKsbg.png?scale-down-to=1024 1024w, https://framerusercontent.com/images/LFrHT3kBfxtMGAZfWkyLvYAKsbg.png 1122w" sizes="(min-width: 1400px) min(360px, 100vw), (min-width: 810px) and (max-width: 1399px) min(360px, 100vw), (max-width: 809px) min(360px, 100vw)" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" data-framer-original-sizes="min(360px, 100vw)"></div></div><div class="framer-1hnjuxt" data-framer-name="Content"><div class="framer-16f1i88" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-a0htzi:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h3 class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-color:var(--extracted-a0htzi)">Flexible Scheduling</h3></div><div class="framer-10e46b8" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-r6o4lv)">Stay productive with our flexible scheduling system</p></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-eBYbU framer-yZDyR framer-vhuia framer-v-m5tdbz" style="display:contents" tabindex="0"><div class="framer-1rya34" data-border="true" data-framer-name="Mobile" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;max-width:100%;width:100%"><div class="framer-3mtodw" style="border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/LFrHT3kBfxtMGAZfWkyLvYAKsbg.png" alt="Scheduling" srcset="https://framerusercontent.com/images/LFrHT3kBfxtMGAZfWkyLvYAKsbg.png?scale-down-to=512 512w, https://framerusercontent.com/images/LFrHT3kBfxtMGAZfWkyLvYAKsbg.png?scale-down-to=1024 1024w, https://framerusercontent.com/images/LFrHT3kBfxtMGAZfWkyLvYAKsbg.png 1122w" sizes="(min-width: 1400px) min(360px, 100vw), (min-width: 810px) and (max-width: 1399px) min(360px, 100vw), (max-width: 809px) min(360px, 100vw)" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" data-framer-original-sizes="min(360px, 100vw)"></div></div><div class="framer-1hnjuxt" data-framer-name="Content"><div class="framer-16f1i88" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-a0htzi:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h3 class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-color:var(--extracted-a0htzi)">Flexible Scheduling</h3></div><div class="framer-10e46b8" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-r6o4lv)">Stay productive with our flexible scheduling system</p></div></div></div></div></div></div><div class="framer-14gm12y-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="ssr-variant hidden-fynrlu"><div class="framer-eBYbU framer-yZDyR framer-vhuia framer-v-1rya34" style="display:contents" tabindex="0"><div class="framer-1rya34" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px;width:100%"><div class="framer-3mtodw" style="border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/p65qwfjd0cd0ZHZoNFpsh7XU.png" alt="Chat" srcset="https://framerusercontent.com/images/p65qwfjd0cd0ZHZoNFpsh7XU.png?scale-down-to=512 512w, https://framerusercontent.com/images/p65qwfjd0cd0ZHZoNFpsh7XU.png?scale-down-to=1024 1024w, https://framerusercontent.com/images/p65qwfjd0cd0ZHZoNFpsh7XU.png 1122w" sizes="(min-width: 1400px) min(360px, 100vw), (min-width: 810px) and (max-width: 1399px) min(360px, 100vw), (max-width: 809px) min(360px, 100vw)" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" data-framer-original-sizes="min(360px, 100vw)"></div></div><div class="framer-1hnjuxt" data-framer-name="Content"><div class="framer-16f1i88" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-a0htzi:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h3 class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-color:var(--extracted-a0htzi)">Easy Communication</h3></div><div class="framer-10e46b8" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-r6o4lv)">Collaborate seamlessly with your team in real-time</p></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-eBYbU framer-yZDyR framer-vhuia framer-v-m5tdbz" style="display:contents" tabindex="0"><div class="framer-1rya34" data-border="true" data-framer-name="Mobile" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;width:100%"><div class="framer-3mtodw" style="border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/p65qwfjd0cd0ZHZoNFpsh7XU.png" alt="Chat" srcset="https://framerusercontent.com/images/p65qwfjd0cd0ZHZoNFpsh7XU.png?scale-down-to=512 512w, https://framerusercontent.com/images/p65qwfjd0cd0ZHZoNFpsh7XU.png?scale-down-to=1024 1024w, https://framerusercontent.com/images/p65qwfjd0cd0ZHZoNFpsh7XU.png 1122w" sizes="(min-width: 1400px) min(360px, 100vw), (min-width: 810px) and (max-width: 1399px) min(360px, 100vw), (max-width: 809px) min(360px, 100vw)" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" data-framer-original-sizes="min(360px, 100vw)"></div></div><div class="framer-1hnjuxt" data-framer-name="Content"><div class="framer-16f1i88" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-a0htzi:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h3 class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-color:var(--extracted-a0htzi)">Easy Communication</h3></div><div class="framer-10e46b8" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-r6o4lv)">Collaborate seamlessly with your team in real-time</p></div></div></div></div></div></div><div class="framer-1w8iix2-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="ssr-variant hidden-fynrlu"><div class="framer-eBYbU framer-yZDyR framer-vhuia framer-v-1rya34" style="display:contents" tabindex="0"><div class="framer-1rya34" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px;width:100%"><div class="framer-3mtodw" style="border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/FaY6aekE67ytWg6HDfDpy2FaHY.png" alt="Analytics" srcset="https://framerusercontent.com/images/FaY6aekE67ytWg6HDfDpy2FaHY.png?scale-down-to=512 512w, https://framerusercontent.com/images/FaY6aekE67ytWg6HDfDpy2FaHY.png?scale-down-to=1024 1024w, https://framerusercontent.com/images/FaY6aekE67ytWg6HDfDpy2FaHY.png 1122w" sizes="(min-width: 1400px) min(360px, 100vw), (min-width: 810px) and (max-width: 1399px) min(360px, 100vw), (max-width: 809px) min(360px, 100vw)" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" data-framer-original-sizes="min(360px, 100vw)"></div></div><div class="framer-1hnjuxt" data-framer-name="Content"><div class="framer-16f1i88" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-a0htzi:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h3 class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-color:var(--extracted-a0htzi)">Analytics</h3></div><div class="framer-10e46b8" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-r6o4lv)">Gain valuable insights with our advanced analytics feature</p></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-eBYbU framer-yZDyR framer-vhuia framer-v-m5tdbz" style="display:contents" tabindex="0"><div class="framer-1rya34" data-border="true" data-framer-name="Mobile" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;width:100%"><div class="framer-3mtodw" style="border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/FaY6aekE67ytWg6HDfDpy2FaHY.png" alt="Analytics" srcset="https://framerusercontent.com/images/FaY6aekE67ytWg6HDfDpy2FaHY.png?scale-down-to=512 512w, https://framerusercontent.com/images/FaY6aekE67ytWg6HDfDpy2FaHY.png?scale-down-to=1024 1024w, https://framerusercontent.com/images/FaY6aekE67ytWg6HDfDpy2FaHY.png 1122w" sizes="(min-width: 1400px) min(360px, 100vw), (min-width: 810px) and (max-width: 1399px) min(360px, 100vw), (max-width: 809px) min(360px, 100vw)" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" data-framer-original-sizes="min(360px, 100vw)"></div></div><div class="framer-1hnjuxt" data-framer-name="Content"><div class="framer-16f1i88" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-a0htzi:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h3 class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-color:var(--extracted-a0htzi)">Analytics</h3></div><div class="framer-10e46b8" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-r6o4lv)">Gain valuable insights with our advanced analytics feature</p></div></div></div></div></div></div></div></div></section><div class="ssr-variant hidden-2u6iyy hidden-fynrlu"><div class="framer-1vgtvbt" data-framer-appear-id="1vgtvbt" data-framer-name="Features Section 2" name="Features Section 2" style="opacity:0.001;transform:perspective(1200px) translateX(0px) translateY(0px) scale(0.5) rotate(0deg) translateZ(0)"><div class="framer-1wrfpcj" data-framer-name="Container" name="Container"><div class="framer-6b3l05" data-framer-name="Heading wrapper" name="Heading wrapper"><div class="framer-ztvmem-container"><div class="framer-wCJvD framer-v-1putop8" style="display:contents" tabindex="0"><div class="framer-1putop8" data-border="true" data-framer-name="With Icon" style="--border-bottom-width:1px;--border-color:rgba(130, 71, 255, 0.2);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:8px;border-bottom-right-radius:8px;border-top-left-radius:8px;border-top-right-radius:8px"><div class="framer-z50fkt" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">🤩</p></div><div class="framer-s13pw5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:12px;--framer-font-weight:600;--framer-letter-spacing:0.08em;--framer-text-color:var(--extracted-r6o4lv);--framer-text-transform:uppercase" class="framer-text">And more...</p></div></div></div></div><div class="framer-1lhoc99" data-framer-appear-id="1lhoc99" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h3 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-alignment:left;--framer-text-color:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236))">Explore an array of features that elevate your <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">Productivity</span> to new heights<!-- --></h3></div><div class="framer-nxqp8w" data-framer-name="Paragraph" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left">Discover the tools that will revolutionize the way you manage and optimize your operations</p></div></div><div class="framer-6qjmop" data-framer-name="Cards wrapper" name="Cards wrapper"><div class="framer-m68jij-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="framer-COo17 framer-yZDyR framer-vhuia framer-v-1dpw8pi" style="display:contents" tabindex="0"><div class="framer-1dpw8pi" data-border="true" data-framer-name="Variant 1" style="--border-bottom-width:1px;--border-color:rgba(255, 255, 255, 0.03);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:rgb(33, 33, 33);border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px;height:100%;width:100%"><div class="framer-u80wk3" style="background-color:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div class="framer-16cdmu3-container"><div style="display:contents"></div></div></div><div class="framer-ypjcbp"><div class="framer-1zt7e9" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Cross-Platform Compatibility</p></div><div class="framer-17i34le" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Enjoy the flexibility of cross-platform compatibility. Our product works seamlessly across desktop, web, and mobile devices, allowing you to work from your preferred device.</p></div></div></div></div></div><div class="framer-n4m4v-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="framer-COo17 framer-yZDyR framer-vhuia framer-v-1dpw8pi" style="display:contents" tabindex="0"><div class="framer-1dpw8pi" data-border="true" data-framer-name="Variant 1" style="--border-bottom-width:1px;--border-color:rgba(255, 255, 255, 0.03);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:rgb(33, 33, 33);border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px;width:100%"><div class="framer-u80wk3" style="background-color:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div class="framer-16cdmu3-container"><div style="display:contents"></div></div></div><div class="framer-ypjcbp"><div class="framer-1zt7e9" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Stay Informed with Essential Notifications</p></div><div class="framer-17i34le" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Automate support from first customer contact to closing the ticket. Drastically improve time to resolution.Automate support from first customer contact to closing the ticket.</p></div></div></div></div></div><div class="framer-x6ivpm-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="framer-COo17 framer-yZDyR framer-vhuia framer-v-1dpw8pi" style="display:contents" tabindex="0"><div class="framer-1dpw8pi" data-border="true" data-framer-name="Variant 1" style="--border-bottom-width:1px;--border-color:rgba(255, 255, 255, 0.03);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:rgb(33, 33, 33);border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px;height:100%;width:100%"><div class="framer-u80wk3" style="background-color:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div class="framer-16cdmu3-container"><div style="display:contents"></div></div></div><div class="framer-ypjcbp"><div class="framer-1zt7e9" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Secure Data Encryption at all times</p></div><div class="framer-17i34le" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Trust in our robust data encryption to keep your sensitive information safe and secure. Rest easy knowing your data is protected at all times.</p></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-72rtr7 hidden-fynrlu"><div class="framer-1vgtvbt" data-framer-appear-id="1wu7ri" data-framer-name="Features Section 2" name="Features Section 2" style="opacity:0.001;transform:perspective(1200px) translateX(0px) translateY(0px) scale(0.5) rotate(0deg) translateZ(0)"><div class="framer-1wrfpcj" data-framer-name="Container" name="Container"><div class="framer-6b3l05" data-framer-name="Heading wrapper" name="Heading wrapper"><div class="framer-ztvmem-container"><div class="framer-wCJvD framer-v-1putop8" style="display:contents" tabindex="0"><div class="framer-1putop8" data-border="true" data-framer-name="With Icon" style="--border-bottom-width:1px;--border-color:rgba(130, 71, 255, 0.2);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:8px;border-bottom-right-radius:8px;border-top-left-radius:8px;border-top-right-radius:8px"><div class="framer-z50fkt" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">🤩</p></div><div class="framer-s13pw5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:12px;--framer-font-weight:600;--framer-letter-spacing:0.08em;--framer-text-color:var(--extracted-r6o4lv);--framer-text-transform:uppercase" class="framer-text">And more...</p></div></div></div></div><div class="framer-1lhoc99" data-framer-appear-id="cjvngk" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h3 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-alignment:left;--framer-text-color:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236))">Explore an array of features that elevate your <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">Productivity</span> to new heights<!-- --></h3></div><div class="framer-nxqp8w" data-framer-name="Paragraph" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left">Discover the tools that will revolutionize the way you manage and optimize your operations</p></div></div><div class="framer-6qjmop" data-framer-name="Cards wrapper" name="Cards wrapper"><div class="framer-m68jij-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="framer-COo17 framer-yZDyR framer-vhuia framer-v-1dpw8pi" style="display:contents" tabindex="0"><div class="framer-1dpw8pi" data-border="true" data-framer-name="Variant 1" style="--border-bottom-width:1px;--border-color:rgba(255, 255, 255, 0.03);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:rgb(33, 33, 33);border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px;width:100%"><div class="framer-u80wk3" style="background-color:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div class="framer-16cdmu3-container"><div style="display:contents"></div></div></div><div class="framer-ypjcbp"><div class="framer-1zt7e9" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Cross-Platform Compatibility</p></div><div class="framer-17i34le" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Enjoy the flexibility of cross-platform compatibility. Our product works seamlessly across desktop, web, and mobile devices, allowing you to work from your preferred device.</p></div></div></div></div></div><div class="framer-n4m4v-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="framer-COo17 framer-yZDyR framer-vhuia framer-v-1dpw8pi" style="display:contents" tabindex="0"><div class="framer-1dpw8pi" data-border="true" data-framer-name="Variant 1" style="--border-bottom-width:1px;--border-color:rgba(255, 255, 255, 0.03);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:rgb(33, 33, 33);border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px;width:100%"><div class="framer-u80wk3" style="background-color:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div class="framer-16cdmu3-container"><div style="display:contents"></div></div></div><div class="framer-ypjcbp"><div class="framer-1zt7e9" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Stay Informed with Essential Notifications</p></div><div class="framer-17i34le" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Automate support from first customer contact to closing the ticket. Drastically improve time to resolution.Automate support from first customer contact to closing the ticket.</p></div></div></div></div></div><div class="framer-x6ivpm-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="framer-COo17 framer-yZDyR framer-vhuia framer-v-1dpw8pi" style="display:contents" tabindex="0"><div class="framer-1dpw8pi" data-border="true" data-framer-name="Variant 1" style="--border-bottom-width:1px;--border-color:rgba(255, 255, 255, 0.03);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:rgb(33, 33, 33);border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px;width:100%"><div class="framer-u80wk3" style="background-color:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div class="framer-16cdmu3-container"><div style="display:contents"></div></div></div><div class="framer-ypjcbp"><div class="framer-1zt7e9" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Secure Data Encryption at all times</p></div><div class="framer-17i34le" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Trust in our robust data encryption to keep your sensitive information safe and secure. Rest easy knowing your data is protected at all times.</p></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-1vgtvbt" data-framer-appear-id="tigbj1" data-framer-name="Features Section 2" name="Features Section 2" style="opacity:0.001;transform:perspective(1200px) translateX(0px) translateY(0px) scale(0.5) rotate(0deg) translateZ(0)"><div class="framer-1wrfpcj" data-framer-name="Container" name="Container"><div class="framer-6b3l05" data-framer-name="Heading wrapper" name="Heading wrapper"><div class="framer-ztvmem-container"><div class="framer-wCJvD framer-v-1putop8" style="display:contents" tabindex="0"><div class="framer-1putop8" data-border="true" data-framer-name="With Icon" style="--border-bottom-width:1px;--border-color:rgba(130, 71, 255, 0.2);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:8px;border-bottom-right-radius:8px;border-top-left-radius:8px;border-top-right-radius:8px"><div class="framer-z50fkt" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">🤩</p></div><div class="framer-s13pw5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:12px;--framer-font-weight:600;--framer-letter-spacing:0.08em;--framer-text-color:var(--extracted-r6o4lv);--framer-text-transform:uppercase" class="framer-text">And more...</p></div></div></div></div><div class="framer-1lhoc99" data-framer-appear-id="gatonk" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h3 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-alignment:left;--framer-text-color:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236))">Explore an array of features that elevate your <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">Productivity</span> to new heights<!-- --></h3></div><div class="framer-nxqp8w" data-framer-name="Paragraph" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left">Discover the tools that will revolutionize the way you manage and optimize your operations</p></div></div><div class="framer-6qjmop" data-framer-name="Cards wrapper" name="Cards wrapper"><div class="framer-m68jij-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="framer-COo17 framer-yZDyR framer-vhuia framer-v-1dpw8pi" style="display:contents" tabindex="0"><div class="framer-1dpw8pi" data-border="true" data-framer-name="Variant 1" style="--border-bottom-width:1px;--border-color:rgba(255, 255, 255, 0.03);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:rgb(33, 33, 33);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;width:100%"><div class="framer-u80wk3" style="background-color:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div class="framer-16cdmu3-container"><div style="display:contents"></div></div></div><div class="framer-ypjcbp"><div class="framer-1zt7e9" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Cross-Platform Compatibility</p></div><div class="framer-17i34le" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Enjoy the flexibility of cross-platform compatibility. Our product works seamlessly across desktop, web, and mobile devices, allowing you to work from your preferred device.</p></div></div></div></div></div><div class="framer-n4m4v-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="framer-COo17 framer-yZDyR framer-vhuia framer-v-1dpw8pi" style="display:contents" tabindex="0"><div class="framer-1dpw8pi" data-border="true" data-framer-name="Variant 1" style="--border-bottom-width:1px;--border-color:rgba(255, 255, 255, 0.03);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:rgb(33, 33, 33);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;width:100%"><div class="framer-u80wk3" style="background-color:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div class="framer-16cdmu3-container"><div style="display:contents"></div></div></div><div class="framer-ypjcbp"><div class="framer-1zt7e9" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Stay Informed with Essential Notifications</p></div><div class="framer-17i34le" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Automate support from first customer contact to closing the ticket. Drastically improve time to resolution.Automate support from first customer contact to closing the ticket.</p></div></div></div></div></div><div class="framer-x6ivpm-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="framer-COo17 framer-yZDyR framer-vhuia framer-v-1dpw8pi" style="display:contents" tabindex="0"><div class="framer-1dpw8pi" data-border="true" data-framer-name="Variant 1" style="--border-bottom-width:1px;--border-color:rgba(255, 255, 255, 0.03);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:rgb(33, 33, 33);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;width:100%"><div class="framer-u80wk3" style="background-color:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px"><div class="framer-16cdmu3-container"><div style="display:contents"></div></div></div><div class="framer-ypjcbp"><div class="framer-1zt7e9" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Secure Data Encryption at all times</p></div><div class="framer-17i34le" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-alignment:center;--framer-text-color:var(--extracted-r6o4lv)">Trust in our robust data encryption to keep your sensitive information safe and secure. Rest easy knowing your data is protected at all times.</p></div></div></div></div></div></div></div></div></div><header class="framer-19tcqvo" data-framer-name="Features Section 3" name="Features Section 3"><div class="framer-rwu701" data-framer-name="Content" name="Content"><div class="framer-1286ntv" data-framer-name="Heading wrapper" name="Heading wrapper"><div class="framer-npbiqa-container"><div class="framer-wCJvD framer-v-1putop8" style="display:contents" tabindex="0"><div class="framer-1putop8" data-border="true" data-framer-name="With Icon" style="--border-bottom-width:1px;--border-color:rgba(130, 71, 255, 0.2);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:8px;border-bottom-right-radius:8px;border-top-left-radius:8px;border-top-right-radius:8px"><div class="framer-z50fkt" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">🛠</p></div><div class="framer-s13pw5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:12px;--framer-font-weight:600;--framer-letter-spacing:0.08em;--framer-text-color:var(--extracted-r6o4lv);--framer-text-transform:uppercase" class="framer-text">Integrations</p></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-fynrlu"><div class="framer-50o0lr" data-framer-appear-id="50o0lr" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h4 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-color:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236))">Enable <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">integration</span> with other popular tools and platforms<!-- --></h4></div></div><div class="ssr-variant hidden-72rtr7 hidden-fynrlu"><div class="framer-50o0lr" data-framer-appear-id="1xaunoo" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h4 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-color:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236))">Enable <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">integration</span> with other popular tools and platforms<!-- --></h4></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-50o0lr" data-framer-appear-id="37q8rl" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h4 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-color:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236))">Enable <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">integration</span> with other popular tools and platforms<!-- --></h4></div></div><div class="framer-jlqzes" data-framer-name="Paragraph" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-color:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117))">Seamlessly connect and amplify your workflow by enabling integration with a diverse array of widely-used tools and platforms.</p></div></div><div class="ssr-variant hidden-fynrlu"><div class="framer-1bpscfd" data-framer-name="Image" name="Image" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/sQd7MkwgkdQRRQ1a99k5Z1zLfAbf23.png?scale-down-to=1024" alt="Integration" srcset="https://framerusercontent.com/images/sQd7MkwgkdQRRQ1a99k5Z1zLfA.png?scale-down-to=512 512w, https://framerusercontent.com/images/sQd7MkwgkdQRRQ1a99k5Z1zLfA.png?scale-down-to=1024 1024w, https://framerusercontent.com/images/sQd7MkwgkdQRRQ1a99k5Z1zLfA.png 1449w" sizes="(min-width: 1400px) min(min(95vw, 1200px), 580px), (min-width: 810px) and (max-width: 1399px) min(min(95vw, 1200px), 580px), (max-width: 809px) min(min(95vw, 1200px) * 0.9, 580px)" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" loading="lazy" data-framer-original-sizes="min(min(95vw, 1200px), 580px)"></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-1bpscfd" data-framer-name="Image" name="Image" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/sQd7MkwgkdQRRQ1a99k5Z1zLfAbf23.png?scale-down-to=1024" alt="Integration" srcset="https://framerusercontent.com/images/sQd7MkwgkdQRRQ1a99k5Z1zLfA.png?scale-down-to=512 512w, https://framerusercontent.com/images/sQd7MkwgkdQRRQ1a99k5Z1zLfA.png?scale-down-to=1024 1024w, https://framerusercontent.com/images/sQd7MkwgkdQRRQ1a99k5Z1zLfA.png 1449w" sizes="(min-width: 1400px) min(min(95vw, 1200px), 580px), (min-width: 810px) and (max-width: 1399px) min(min(95vw, 1200px), 580px), (max-width: 809px) min(min(95vw, 1200px) * 0.9, 580px)" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" loading="lazy" data-framer-original-sizes="min(min(95vw, 1200px) * 0.9, 580px)"></div></div></div></div><div class="framer-1jcpmsn" data-framer-name="Icons container" name="Icons container"><div class="ssr-variant hidden-fynrlu"><div class="framer-1mi0wzd-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-5nyyq7" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Gmail" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="official_gmail_icon_2020_" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-1wnngen"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 2500 2500"><use href="#svg-1750462618_698"></use></svg></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-1mi0wzd-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:15px;border-bottom-right-radius:15px;border-top-left-radius:15px;border-top-right-radius:15px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-5nyyq7" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Gmail" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="official_gmail_icon_2020_" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-1wnngen"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 2500 2500"><use href="#svg-1750462618_698"></use></svg></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-fynrlu"><div class="framer-nc2gw-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-13pltmb" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Slack" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="slack_new_logo" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-mlo1a9"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%"><use href="#svg-1874132133_1336"></use></svg></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-nc2gw-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:15px;border-bottom-right-radius:15px;border-top-left-radius:15px;border-top-right-radius:15px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-13pltmb" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Slack" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="slack_new_logo" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-mlo1a9"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%"><use href="#svg-1874132133_1336"></use></svg></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-fynrlu"><div class="framer-15qwzes-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-isoj3a" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Dropbox" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="dropbox_1" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-1yin3ht"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 2500 2329"><use href="#svg-1108524006_303"></use></svg></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-15qwzes-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:15px;border-bottom-right-radius:15px;border-top-left-radius:15px;border-top-right-radius:15px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-isoj3a" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Dropbox" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="dropbox_1" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-1yin3ht"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 2500 2329"><use href="#svg-1108524006_303"></use></svg></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-fynrlu"><div class="framer-119alcv-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-127b3l2" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Figma" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="figma_5" style="image-rendering:pixelated;flex-shrink:0;background-size:100% 100%;background-image:url('data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20xmlns%3Axlink%3D%22http%3A%2F%2Fwww.w3.org%2F1999%2Fxlink%22%20viewBox%3D%220%200%2046%2046%22%3E%3Cpath%20d%3D%22M%200%200.3%20L%2046%200.3%20L%2046%2046.3%20L%200%2046.3%20Z%22%20fill%3D%22transparent%22%3E%3C%2Fpath%3E%3Cpath%20d%3D%22M%2022.993%2023.007%20C%2022.993%2019.837%2025.564%2017.254%2028.747%2017.254%20C%2031.917%2017.254%2034.5%2019.824%2034.5%2023.007%20C%2034.5%2026.176%2031.93%2028.759%2028.747%2028.759%20C%2025.577%2028.759%2022.993%2026.176%2022.993%2023.007%20Z%22%20fill%3D%22rgb(26%2C188%2C254)%22%3E%3C%2Fpath%3E%3Cpath%20d%3D%22M%2011.5%2034.498%20C%2011.5%2031.328%2014.07%2028.746%2017.253%2028.746%20L%2023.007%2028.746%20L%2023.007%2034.498%20C%2023.007%2037.667%2020.436%2040.25%2017.253%2040.25%20C%2014.07%2040.25%2011.5%2037.68%2011.5%2034.498%20Z%22%20fill%3D%22rgb(10%2C207%2C131)%22%3E%3C%2Fpath%3E%3Cpath%20d%3D%22M%2022.993%205.763%20L%2022.993%2017.254%20L%2028.747%2017.254%20C%2031.917%2017.254%2034.5%2014.685%2034.5%2011.502%20C%2034.5%208.333%2031.93%205.75%2028.747%205.75%20L%2022.993%205.75%20Z%22%20fill%3D%22rgb(255%2C114%2C98)%22%3E%3C%2Fpath%3E%3Cpath%20d%3D%22M%2011.5%2011.515%20C%2011.5%2014.685%2014.07%2017.267%2017.253%2017.267%20L%2023.007%2017.267%20L%2023.007%205.763%20L%2017.253%205.763%20C%2014.07%205.763%2011.5%208.333%2011.5%2011.515%20Z%22%20fill%3D%22rgb(242%2C78%2C30)%22%3E%3C%2Fpath%3E%3Cpath%20d%3D%22M%2011.5%2023.007%20C%2011.5%2026.176%2014.07%2028.759%2017.253%2028.759%20L%2023.007%2028.759%20L%2023.007%2017.254%20L%2017.253%2017.254%20C%2014.07%2017.254%2011.5%2019.837%2011.5%2023.007%20Z%22%20fill%3D%22rgb(162%2C89%2C255)%22%3E%3C%2Fpath%3E%3C%2Fsvg%3E')" class="framer-1y0xt7e"></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-119alcv-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:15px;border-bottom-right-radius:15px;border-top-left-radius:15px;border-top-right-radius:15px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-127b3l2" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Figma" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="figma_5" style="image-rendering:pixelated;flex-shrink:0;background-size:100% 100%;background-image:url('data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20xmlns%3Axlink%3D%22http%3A%2F%2Fwww.w3.org%2F1999%2Fxlink%22%20viewBox%3D%220%200%2046%2046%22%3E%3Cpath%20d%3D%22M%200%200.3%20L%2046%200.3%20L%2046%2046.3%20L%200%2046.3%20Z%22%20fill%3D%22transparent%22%3E%3C%2Fpath%3E%3Cpath%20d%3D%22M%2022.993%2023.007%20C%2022.993%2019.837%2025.564%2017.254%2028.747%2017.254%20C%2031.917%2017.254%2034.5%2019.824%2034.5%2023.007%20C%2034.5%2026.176%2031.93%2028.759%2028.747%2028.759%20C%2025.577%2028.759%2022.993%2026.176%2022.993%2023.007%20Z%22%20fill%3D%22rgb(26%2C188%2C254)%22%3E%3C%2Fpath%3E%3Cpath%20d%3D%22M%2011.5%2034.498%20C%2011.5%2031.328%2014.07%2028.746%2017.253%2028.746%20L%2023.007%2028.746%20L%2023.007%2034.498%20C%2023.007%2037.667%2020.436%2040.25%2017.253%2040.25%20C%2014.07%2040.25%2011.5%2037.68%2011.5%2034.498%20Z%22%20fill%3D%22rgb(10%2C207%2C131)%22%3E%3C%2Fpath%3E%3Cpath%20d%3D%22M%2022.993%205.763%20L%2022.993%2017.254%20L%2028.747%2017.254%20C%2031.917%2017.254%2034.5%2014.685%2034.5%2011.502%20C%2034.5%208.333%2031.93%205.75%2028.747%205.75%20L%2022.993%205.75%20Z%22%20fill%3D%22rgb(255%2C114%2C98)%22%3E%3C%2Fpath%3E%3Cpath%20d%3D%22M%2011.5%2011.515%20C%2011.5%2014.685%2014.07%2017.267%2017.253%2017.267%20L%2023.007%2017.267%20L%2023.007%205.763%20L%2017.253%205.763%20C%2014.07%205.763%2011.5%208.333%2011.5%2011.515%20Z%22%20fill%3D%22rgb(242%2C78%2C30)%22%3E%3C%2Fpath%3E%3Cpath%20d%3D%22M%2011.5%2023.007%20C%2011.5%2026.176%2014.07%2028.759%2017.253%2028.759%20L%2023.007%2028.759%20L%2023.007%2017.254%20L%2017.253%2017.254%20C%2014.07%2017.254%2011.5%2019.837%2011.5%2023.007%20Z%22%20fill%3D%22rgb(162%2C89%2C255)%22%3E%3C%2Fpath%3E%3C%2Fsvg%3E')" class="framer-1y0xt7e"></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-fynrlu"><div class="framer-1u2vokm-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-1nbjdk7" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Notion" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="notion_2_1" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-1d87js3"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 150 160"><use href="#svg-759328427_2297"></use></svg></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-1u2vokm-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:15px;border-bottom-right-radius:15px;border-top-left-radius:15px;border-top-right-radius:15px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-1nbjdk7" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Notion" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="notion_2_1" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-1d87js3"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 150 160"><use href="#svg-759328427_2297"></use></svg></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-fynrlu"><div class="framer-1vuwi02-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-ma5u7u" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Gitlab" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="gitlab" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-1ihngpw"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 2500 2305"><use href="#svg1091080977_813"></use></svg></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-1vuwi02-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:15px;border-bottom-right-radius:15px;border-top-left-radius:15px;border-top-right-radius:15px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-ma5u7u" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Gitlab" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="gitlab" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-1ihngpw"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 2500 2305"><use href="#svg1091080977_813"></use></svg></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-fynrlu"><div class="framer-lwwy2d-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-p9uy0n" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Vimeo" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="vimeo_icon_blue" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-sr6gqo"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%"><use href="#svg-1420836820_721"></use></svg></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-lwwy2d-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:15px;border-bottom-right-radius:15px;border-top-left-radius:15px;border-top-right-radius:15px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-p9uy0n" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Vimeo" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="vimeo_icon_blue" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-sr6gqo"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%"><use href="#svg-1420836820_721"></use></svg></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-fynrlu"><div class="framer-ldl97h-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-1v3vwjs" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Zoom" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="zoom_5" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-1mhdsh8"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 2500 2500"><use href="#svg-687907656_405"></use></svg></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-ldl97h-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:15px;border-bottom-right-radius:15px;border-top-left-radius:15px;border-top-right-radius:15px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-1v3vwjs" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Zoom" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="zoom_5" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-1mhdsh8"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 2500 2500"><use href="#svg-687907656_405"></use></svg></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-fynrlu"><div class="framer-15vuql8-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-lwxoub" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Framer" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="framer_svgrepo_com_2" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-mq7pic"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 160 160"><use href="#svg337131488_324"></use></svg></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-15vuql8-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:15px;border-bottom-right-radius:15px;border-top-left-radius:15px;border-top-right-radius:15px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-lwxoub" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Framer" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="framer_svgrepo_com_2" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-mq7pic"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 160 160"><use href="#svg337131488_324"></use></svg></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-fynrlu"><div class="framer-3pv3wu-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-4o6azf" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Github" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="github_icon_1_1" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-r1vtts"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 164 160"><use href="#svg1448053486_2032"></use></svg></div></div></div></div></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-3pv3wu-container" style="visibility:hidden;opacity:1;transform:none"><div class="framer-sheqz framer-v-3bxmev" style="display:contents" tabindex="0"><div class="framer-3bxmev" data-framer-name="Figma" style="background-color:rgba(255, 255, 255, 0.05);border-bottom-left-radius:15px;border-bottom-right-radius:15px;border-top-left-radius:15px;border-top-right-radius:15px;height:100%;width:100%"><div class="framer-naj6nb-container"><div class="framer-vXvT8 framer-v-4o6azf" style="display:contents" tabindex="0"><div class="framer-127b3l2" data-framer-name="Github" style="height:100%;width:100%"><div data-framer-component-type="SVG" data-framer-name="github_icon_1_1" style="image-rendering:pixelated;flex-shrink:0;fill:black;color:black" class="framer-r1vtts"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%" viewBox="0 0 164 160"><use href="#svg1448053486_2032"></use></svg></div></div></div></div></div></div></div></div></div></div></header><div class="framer-eu9qz1" data-framer-name="FAQ" id="faq" name="FAQ"><div class="framer-1resr3z" data-framer-name="Container" name="Container"><div class="framer-18ygqcl" data-framer-name="Heading wrapper" name="Heading wrapper"><div class="framer-1l14qh3-container"><div class="framer-wCJvD framer-v-1putop8" style="display:contents" tabindex="0"><div class="framer-1putop8" data-border="true" data-framer-name="With Icon" style="--border-bottom-width:1px;--border-color:rgba(130, 71, 255, 0.2);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:8px;border-bottom-right-radius:8px;border-top-left-radius:8px;border-top-right-radius:8px"><div class="framer-z50fkt" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">🙋‍♀️</p></div><div class="framer-s13pw5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:12px;--framer-font-weight:600;--framer-letter-spacing:0.08em;--framer-text-color:var(--extracted-r6o4lv);--framer-text-transform:uppercase" class="framer-text">FAQ</p></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-fynrlu"><div class="framer-162n34d" data-framer-appear-id="162n34d" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h5 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-alignment:left;--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))"><span style="--framer-text-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27))" class="framer-text">Need <!-- --><br class="framer-text"></span>Answers?<!-- --></h5></div></div><div class="ssr-variant hidden-72rtr7 hidden-fynrlu"><div class="framer-162n34d" data-framer-appear-id="1acjuvh" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h5 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-alignment:left;--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))"><span style="--framer-text-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27))" class="framer-text">Need <!-- --><br class="framer-text"></span>Answers?<!-- --></h5></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-162n34d" data-framer-appear-id="1j01e5y" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h5 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-alignment:center;--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))"><span style="--framer-text-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27))" class="framer-text">Need <!-- --><br class="framer-text"></span>Answers?<!-- --></h5></div></div><div class="ssr-variant hidden-fynrlu"><div class="framer-1w5ylyc" data-framer-name="Paragraph" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left">Check out our most commonly asked questions below to find the information you need.</p></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-1w5ylyc" data-framer-name="Paragraph" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:center">Check out our most commonly asked questions below to find the information you need.</p></div></div></div><div class="framer-10wpf6g" data-framer-name="FAQ questions" name="FAQ questions"><div class="framer-15az9bq-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="framer-cz6Df framer-v-zd1ut8" style="display:contents" tabindex="0"><div class="framer-zd1ut8" data-framer-name="Variant 1" style="border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;width:100%"><div class="framer-15lwsq6-container"><div class="framer-AzinR framer-yZDyR framer-vhuia framer-v-1iem2z4" style="display:contents" tabindex="0"><div class="framer-1iem2z4" data-framer-name="Closed" style="background-color:rgb(247, 248, 253);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;width:100%"><div class="framer-hx559f" data-framer-name="Question" data-highlight="true" tabindex="0"><div class="framer-11zole" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h6 class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA">What is Manage Wise and what does it offer?
</h6></div><div class="framer-5niy1l-container"><div style="display:contents"></div></div></div></div></div></div><div class="framer-1yjslvu-container"><div class="framer-AzinR framer-yZDyR framer-vhuia framer-v-1iem2z4" style="display:contents" tabindex="0"><div class="framer-1iem2z4" data-framer-name="Closed" style="background-color:rgb(247, 248, 253);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;width:100%"><div class="framer-hx559f" data-framer-name="Question" data-highlight="true" tabindex="0"><div class="framer-11zole" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h6 class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA">Is Manage Wise suitable for small businesses and larger enterprises alike?</h6></div><div class="framer-5niy1l-container"><div style="display:contents"></div></div></div></div></div></div><div class="framer-1e62rmx-container"><div class="framer-AzinR framer-yZDyR framer-vhuia framer-v-1iem2z4" style="display:contents" tabindex="0"><div class="framer-1iem2z4" data-framer-name="Closed" style="background-color:rgb(247, 248, 253);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;width:100%"><div class="framer-hx559f" data-framer-name="Question" data-highlight="true" tabindex="0"><div class="framer-11zole" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h6 class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA">Can I access Manage Wise from different devices and platforms?</h6></div><div class="framer-5niy1l-container"><div style="display:contents"></div></div></div></div></div></div><div class="framer-apthg1-container"><div class="framer-AzinR framer-yZDyR framer-vhuia framer-v-1iem2z4" style="display:contents" tabindex="0"><div class="framer-1iem2z4" data-framer-name="Closed" style="background-color:rgb(247, 248, 253);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;width:100%"><div class="framer-hx559f" data-framer-name="Question" data-highlight="true" tabindex="0"><div class="framer-11zole" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h6 class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA">What kind of support options do you offer to users?
</h6></div><div class="framer-5niy1l-container"><div style="display:contents"></div></div></div></div></div></div><div class="framer-18wsf7q-container"><div class="framer-AzinR framer-yZDyR framer-vhuia framer-v-1iem2z4" style="display:contents" tabindex="0"><div class="framer-1iem2z4" data-framer-name="Closed" style="background-color:rgb(247, 248, 253);border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;width:100%"><div class="framer-hx559f" data-framer-name="Question" data-highlight="true" tabindex="0"><div class="framer-11zole" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h6 class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA">How secure is the data stored within Manage Wise?</h6></div><div class="framer-5niy1l-container"><div style="display:contents"></div></div></div></div></div></div></div></div></div></div></div></div><section class="framer-jzlnh3" data-framer-name="Pricing" id="pricing" name="Pricing"><div class="framer-hgc32s" data-framer-name="Container" name="Container"><div class="framer-1pm53h8" data-framer-name="Heading wrapper" name="Heading wrapper"><div class="framer-1hsyw3u-container"><div class="framer-wCJvD framer-v-1putop8" style="display:contents" tabindex="0"><div class="framer-1putop8" data-border="true" data-framer-name="With Icon" style="--border-bottom-width:1px;--border-color:rgba(130, 71, 255, 0.2);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:8px;border-bottom-right-radius:8px;border-top-left-radius:8px;border-top-right-radius:8px"><div class="framer-z50fkt" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">💲</p></div><div class="framer-s13pw5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:12px;--framer-font-weight:600;--framer-letter-spacing:0.08em;--framer-text-color:var(--extracted-r6o4lv);--framer-text-transform:uppercase" class="framer-text">Pricing</p></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-fynrlu"><div class="framer-126mjd9" data-framer-appear-id="126mjd9" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h5 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27))">Select your ideal <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">Pricing</span> plan<!-- --></h5></div></div><div class="ssr-variant hidden-72rtr7 hidden-fynrlu"><div class="framer-126mjd9" data-framer-appear-id="1sw9lb3" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h5 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27))">Select your ideal <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">Pricing</span> plan<!-- --></h5></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-126mjd9" data-framer-appear-id="wzpc4l" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h5 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27))">Select your ideal <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">Pricing</span> plan<!-- --></h5></div></div><div class="framer-e8r11j" data-framer-name="Paragraph" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ">At Manage Wise, we believe in providing you with pricing plans that adapt to your unique needs.</p></div></div><div class="framer-11poge1" data-framer-name="Cards container" name="Cards container"><div class="framer-gir2f7-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="ssr-variant hidden-fynrlu"><div class="framer-QJGIc framer-t2HbJ framer-vhuia framer-v-zgp91r" style="display:contents" tabindex="0"><div class="framer-zgp91r" data-border="true" data-framer-name="Default" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px;height:100%;width:100%"><div class="framer-1x3d2to" data-framer-name="Price"><div class="framer-1iqyay8-container"><div class="framer-wCJvD framer-v-1amlisl" style="display:contents" tabindex="0"><div class="framer-1putop8" data-border="true" data-framer-name="No icon" style="--border-bottom-width:0px;--border-color:rgba(130, 71, 255, 0.2);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:8px;border-bottom-right-radius:8px;border-top-left-radius:8px;border-top-right-radius:8px"><div class="framer-s13pw5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:12px;--framer-font-weight:600;--framer-letter-spacing:0.08em;--framer-text-color:var(--extracted-r6o4lv);--framer-text-transform:uppercase" class="framer-text">Free</p></div></div></div></div><div class="framer-hessy3"><div class="framer-123h1n0" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-1of0zx5:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h2 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-color:var(--extracted-1of0zx5)">$0</h2></div><div class="framer-1r6clop" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:rgb(51, 51, 51);--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:SW50ZXItTWVkaXVt;--framer-font-family:&quot;Inter-Medium&quot;, &quot;Inter&quot;, sans-serif;--framer-font-weight:500;--framer-line-height:1.3em;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">/month</p></div></div></div><div class="framer-rhnj1c" data-framer-name="Features rows"><div class="framer-7i7pwb" data-framer-name="Row"><div class="framer-1oqwx8b-container"><div style="display:contents"></div></div><div class="framer-176aztz" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Access to all basic features</div></div></div><div class="framer-1w4hovk" data-framer-name="Row"><div class="framer-wwg05k-container"><div style="display:contents"></div></div><div class="framer-u513nc" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Reporting and analytics</div></div></div><div class="framer-1uv7g8s" data-framer-name="Row"><div class="framer-1vm0f1x-container"><div style="display:contents"></div></div><div class="framer-1y3r2u" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Up to 5 individual users</div></div></div><div class="framer-icf272" data-framer-name="Row"><div class="framer-1vekzme-container"><div style="display:contents"></div></div><div class="framer-1dlbrxe" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Chat and email support</div></div></div></div><div class="framer-doecf0-container"><div class="framer-GYe7W framer-v-uxqkqo" style="display:contents" tabindex="0"><a aria-label="Primary" class="framer-uxqkqo framer-1fc7vqd" data-border="true" data-framer-name="Variant 1" data-reset="button" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:12px;border-bottom-right-radius:12px;border-top-left-radius:12px;border-top-right-radius:12px;height:100%" tabindex="0" href="https://templatesunit.lemonsqueezy.com/checkout/buy/181cb12c-ca54-44c6-bebd-46e3b656defc" target="_blank" rel="noopener"><div class="framer-1xqtqpo" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Get started</p></div></a></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-QJGIc framer-t2HbJ framer-vhuia framer-v-zgp91r" style="display:contents" tabindex="0"><div class="framer-zgp91r" data-border="true" data-framer-name="Default" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;height:100%;width:100%"><div class="framer-1x3d2to" data-framer-name="Price"><div class="framer-1iqyay8-container"><div class="framer-wCJvD framer-v-1amlisl" style="display:contents" tabindex="0"><div class="framer-1putop8" data-border="true" data-framer-name="No icon" style="--border-bottom-width:0px;--border-color:rgba(130, 71, 255, 0.2);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:8px;border-bottom-right-radius:8px;border-top-left-radius:8px;border-top-right-radius:8px"><div class="framer-s13pw5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:12px;--framer-font-weight:600;--framer-letter-spacing:0.08em;--framer-text-color:var(--extracted-r6o4lv);--framer-text-transform:uppercase" class="framer-text">Free</p></div></div></div></div><div class="framer-hessy3"><div class="framer-123h1n0" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-1of0zx5:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h2 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-color:var(--extracted-1of0zx5)">$0</h2></div><div class="framer-1r6clop" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:rgb(51, 51, 51);--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:SW50ZXItTWVkaXVt;--framer-font-family:&quot;Inter-Medium&quot;, &quot;Inter&quot;, sans-serif;--framer-font-weight:500;--framer-line-height:1.3em;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">/month</p></div></div></div><div class="framer-rhnj1c" data-framer-name="Features rows"><div class="framer-7i7pwb" data-framer-name="Row"><div class="framer-1oqwx8b-container"><div style="display:contents"></div></div><div class="framer-176aztz" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Access to all basic features</div></div></div><div class="framer-1w4hovk" data-framer-name="Row"><div class="framer-wwg05k-container"><div style="display:contents"></div></div><div class="framer-u513nc" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Reporting and analytics</div></div></div><div class="framer-1uv7g8s" data-framer-name="Row"><div class="framer-1vm0f1x-container"><div style="display:contents"></div></div><div class="framer-1y3r2u" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Up to 5 individual users</div></div></div><div class="framer-icf272" data-framer-name="Row"><div class="framer-1vekzme-container"><div style="display:contents"></div></div><div class="framer-1dlbrxe" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Chat and email support</div></div></div></div><div class="framer-doecf0-container"><div class="framer-GYe7W framer-v-uxqkqo" style="display:contents" tabindex="0"><a aria-label="Primary" class="framer-uxqkqo framer-1fc7vqd" data-border="true" data-framer-name="Variant 1" data-reset="button" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:12px;border-bottom-right-radius:12px;border-top-left-radius:12px;border-top-right-radius:12px;height:100%" tabindex="0" href="https://templatesunit.lemonsqueezy.com/checkout/buy/181cb12c-ca54-44c6-bebd-46e3b656defc" target="_blank" rel="noopener"><div class="framer-1xqtqpo" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Get started</p></div></a></div></div></div></div></div></div><div class="framer-yjy15x-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="ssr-variant hidden-fynrlu"><div class="framer-QJGIc framer-t2HbJ framer-vhuia framer-v-42r5rv" style="display:contents" tabindex="0"><div class="framer-zgp91r" data-border="true" data-framer-name="Highlighted" style="--border-bottom-width:0px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;background-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px;width:100%"><div class="framer-1x3d2to" data-framer-name="Price"><div class="framer-1iqyay8-container"><div class="framer-wCJvD framer-v-1amlisl" style="display:contents" tabindex="0"><div class="framer-1putop8" data-border="true" data-framer-name="No icon" style="--border-bottom-width:0px;--border-color:rgba(130, 71, 255, 0.2);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:8px;border-bottom-right-radius:8px;border-top-left-radius:8px;border-top-right-radius:8px"><div class="framer-s13pw5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:12px;--framer-font-weight:600;--framer-letter-spacing:0.08em;--framer-text-color:var(--extracted-r6o4lv);--framer-text-transform:uppercase" class="framer-text">Standard</p></div></div></div></div><div class="framer-hessy3"><div class="framer-123h1n0" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-1of0zx5:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h2 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-color:var(--extracted-1of0zx5)">$25</h2></div><div class="framer-1r6clop" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:SW50ZXItTWVkaXVt;--framer-font-family:&quot;Inter-Medium&quot;, &quot;Inter&quot;, sans-serif;--framer-font-weight:500;--framer-line-height:1.3em;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">/month</p></div></div></div><div class="framer-rhnj1c" data-framer-name="Features rows"><div class="framer-7i7pwb" data-framer-name="Row"><div class="framer-1oqwx8b-container"><div style="display:contents"></div></div><div class="framer-176aztz" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Access to all basic features</div></div></div><div class="framer-1w4hovk" data-framer-name="Row"><div class="framer-wwg05k-container"><div style="display:contents"></div></div><div class="framer-u513nc" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Reporting and analytics</div></div></div><div class="framer-1uv7g8s" data-framer-name="Row"><div class="framer-1vm0f1x-container"><div style="display:contents"></div></div><div class="framer-1y3r2u" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Up to 5 individual users</div></div></div><div class="framer-icf272" data-framer-name="Row"><div class="framer-1vekzme-container"><div style="display:contents"></div></div><div class="framer-1dlbrxe" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Chat and email support</div></div></div><div class="framer-1neptcv" data-framer-name="Row"><div class="framer-v6r9sr-container"><div style="display:contents"></div></div><div class="framer-1l0spno" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">3+ integrations</div></div></div><div class="framer-1p6b1c7" data-framer-name="Row"><div class="framer-1lbdgy1-container"><div style="display:contents"></div></div><div class="framer-1om743s" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Account performance reporting</div></div></div></div><div class="framer-2ebv60-container"><div class="framer-AbhQC framer-v-1jl5bk5" style="display:contents" tabindex="0"><a aria-label="Primary" class="framer-1jl5bk5 framer-j4qz97" data-framer-name="Variant 1" data-reset="button" style="background-color:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));border-bottom-left-radius:12px;border-bottom-right-radius:12px;border-top-left-radius:12px;border-top-right-radius:12px;box-shadow:none;height:100%" tabindex="0" href="https://templatesunit.lemonsqueezy.com/checkout/buy/181cb12c-ca54-44c6-bebd-46e3b656defc" target="_blank" rel="noopener"><div class="framer-yw0mic" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Get Started</p></div></a></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-QJGIc framer-t2HbJ framer-vhuia framer-v-42r5rv" style="display:contents" tabindex="0"><div class="framer-zgp91r" data-border="true" data-framer-name="Highlighted" style="--border-bottom-width:0px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;background-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;width:100%"><div class="framer-1x3d2to" data-framer-name="Price"><div class="framer-1iqyay8-container"><div class="framer-wCJvD framer-v-1amlisl" style="display:contents" tabindex="0"><div class="framer-1putop8" data-border="true" data-framer-name="No icon" style="--border-bottom-width:0px;--border-color:rgba(130, 71, 255, 0.2);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:8px;border-bottom-right-radius:8px;border-top-left-radius:8px;border-top-right-radius:8px"><div class="framer-s13pw5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:12px;--framer-font-weight:600;--framer-letter-spacing:0.08em;--framer-text-color:var(--extracted-r6o4lv);--framer-text-transform:uppercase" class="framer-text">Standard</p></div></div></div></div><div class="framer-hessy3"><div class="framer-123h1n0" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-1of0zx5:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h2 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-color:var(--extracted-1of0zx5)">$25</h2></div><div class="framer-1r6clop" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:SW50ZXItTWVkaXVt;--framer-font-family:&quot;Inter-Medium&quot;, &quot;Inter&quot;, sans-serif;--framer-font-weight:500;--framer-line-height:1.3em;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">/month</p></div></div></div><div class="framer-rhnj1c" data-framer-name="Features rows"><div class="framer-7i7pwb" data-framer-name="Row"><div class="framer-1oqwx8b-container"><div style="display:contents"></div></div><div class="framer-176aztz" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Access to all basic features</div></div></div><div class="framer-1w4hovk" data-framer-name="Row"><div class="framer-wwg05k-container"><div style="display:contents"></div></div><div class="framer-u513nc" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Reporting and analytics</div></div></div><div class="framer-1uv7g8s" data-framer-name="Row"><div class="framer-1vm0f1x-container"><div style="display:contents"></div></div><div class="framer-1y3r2u" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Up to 5 individual users</div></div></div><div class="framer-icf272" data-framer-name="Row"><div class="framer-1vekzme-container"><div style="display:contents"></div></div><div class="framer-1dlbrxe" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Chat and email support</div></div></div><div class="framer-1neptcv" data-framer-name="Row"><div class="framer-v6r9sr-container"><div style="display:contents"></div></div><div class="framer-1l0spno" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">3+ integrations</div></div></div><div class="framer-1p6b1c7" data-framer-name="Row"><div class="framer-1lbdgy1-container"><div style="display:contents"></div></div><div class="framer-1om743s" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Account performance reporting</div></div></div></div><div class="framer-2ebv60-container"><div class="framer-AbhQC framer-v-1jl5bk5" style="display:contents" tabindex="0"><a aria-label="Primary" class="framer-1jl5bk5 framer-j4qz97" data-framer-name="Variant 1" data-reset="button" style="background-color:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));border-bottom-left-radius:12px;border-bottom-right-radius:12px;border-top-left-radius:12px;border-top-right-radius:12px;box-shadow:none;height:100%" tabindex="0" href="https://templatesunit.lemonsqueezy.com/checkout/buy/181cb12c-ca54-44c6-bebd-46e3b656defc" target="_blank" rel="noopener"><div class="framer-yw0mic" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Get Started</p></div></a></div></div></div></div></div></div><div class="framer-da44k0-container" style="opacity:0;transform:perspective(1200px) translateX(0px) translateY(30px) scale(1) rotate(0deg) rotateX(0deg) rotateY(0deg) translateZ(0)"><div class="ssr-variant hidden-fynrlu"><div class="framer-QJGIc framer-t2HbJ framer-vhuia framer-v-zgp91r" style="display:contents" tabindex="0"><div class="framer-zgp91r" data-border="true" data-framer-name="Default" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px;height:100%;width:100%"><div class="framer-1x3d2to" data-framer-name="Price"><div class="framer-1iqyay8-container"><div class="framer-wCJvD framer-v-1amlisl" style="display:contents" tabindex="0"><div class="framer-1putop8" data-border="true" data-framer-name="No icon" style="--border-bottom-width:0px;--border-color:rgba(130, 71, 255, 0.2);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:8px;border-bottom-right-radius:8px;border-top-left-radius:8px;border-top-right-radius:8px"><div class="framer-s13pw5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:12px;--framer-font-weight:600;--framer-letter-spacing:0.08em;--framer-text-color:var(--extracted-r6o4lv);--framer-text-transform:uppercase" class="framer-text">Business</p></div></div></div></div><div class="framer-hessy3"><div class="framer-123h1n0" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-1of0zx5:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h2 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-color:var(--extracted-1of0zx5)">$42</h2></div><div class="framer-1r6clop" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:rgb(51, 51, 51);--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:SW50ZXItTWVkaXVt;--framer-font-family:&quot;Inter-Medium&quot;, &quot;Inter&quot;, sans-serif;--framer-font-weight:500;--framer-line-height:1.3em;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">/month</p></div></div></div><div class="framer-rhnj1c" data-framer-name="Features rows"><div class="framer-7i7pwb" data-framer-name="Row"><div class="framer-1oqwx8b-container"><div style="display:contents"></div></div><div class="framer-176aztz" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Access to all basic features</div></div></div><div class="framer-1w4hovk" data-framer-name="Row"><div class="framer-wwg05k-container"><div style="display:contents"></div></div><div class="framer-u513nc" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Reporting and analytics</div></div></div><div class="framer-1uv7g8s" data-framer-name="Row"><div class="framer-1vm0f1x-container"><div style="display:contents"></div></div><div class="framer-1y3r2u" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Up to 5 individual users</div></div></div><div class="framer-icf272" data-framer-name="Row"><div class="framer-1vekzme-container"><div style="display:contents"></div></div><div class="framer-1dlbrxe" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Chat and email support</div></div></div><div class="framer-1neptcv" data-framer-name="Row"><div class="framer-v6r9sr-container"><div style="display:contents"></div></div><div class="framer-1l0spno" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">3+ integrations</div></div></div></div><div class="framer-doecf0-container"><div class="framer-GYe7W framer-v-uxqkqo" style="display:contents" tabindex="0"><a aria-label="Primary" class="framer-uxqkqo framer-1fc7vqd" data-border="true" data-framer-name="Variant 1" data-reset="button" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:12px;border-bottom-right-radius:12px;border-top-left-radius:12px;border-top-right-radius:12px;height:100%" tabindex="0" href="https://templatesunit.lemonsqueezy.com/checkout/buy/181cb12c-ca54-44c6-bebd-46e3b656defc" target="_blank" rel="noopener"><div class="framer-1xqtqpo" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Get started</p></div></a></div></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-QJGIc framer-t2HbJ framer-vhuia framer-v-zgp91r" style="display:contents" tabindex="0"><div class="framer-zgp91r" data-border="true" data-framer-name="Default" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));border-bottom-left-radius:20px;border-bottom-right-radius:20px;border-top-left-radius:20px;border-top-right-radius:20px;height:100%;width:100%"><div class="framer-1x3d2to" data-framer-name="Price"><div class="framer-1iqyay8-container"><div class="framer-wCJvD framer-v-1amlisl" style="display:contents" tabindex="0"><div class="framer-1putop8" data-border="true" data-framer-name="No icon" style="--border-bottom-width:0px;--border-color:rgba(130, 71, 255, 0.2);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:8px;border-bottom-right-radius:8px;border-top-left-radius:8px;border-top-right-radius:8px"><div class="framer-s13pw5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:12px;--framer-font-weight:600;--framer-letter-spacing:0.08em;--framer-text-color:var(--extracted-r6o4lv);--framer-text-transform:uppercase" class="framer-text">Business</p></div></div></div></div><div class="framer-hessy3"><div class="framer-123h1n0" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-1of0zx5:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><h2 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-color:var(--extracted-1of0zx5)">$42</h2></div><div class="framer-1r6clop" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:rgb(51, 51, 51);--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:SW50ZXItTWVkaXVt;--framer-font-family:&quot;Inter-Medium&quot;, &quot;Inter&quot;, sans-serif;--framer-font-weight:500;--framer-line-height:1.3em;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">/month</p></div></div></div><div class="framer-rhnj1c" data-framer-name="Features rows"><div class="framer-7i7pwb" data-framer-name="Row"><div class="framer-1oqwx8b-container"><div style="display:contents"></div></div><div class="framer-176aztz" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Access to all basic features</div></div></div><div class="framer-1w4hovk" data-framer-name="Row"><div class="framer-wwg05k-container"><div style="display:contents"></div></div><div class="framer-u513nc" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Reporting and analytics</div></div></div><div class="framer-1uv7g8s" data-framer-name="Row"><div class="framer-1vm0f1x-container"><div style="display:contents"></div></div><div class="framer-1y3r2u" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Up to 5 individual users</div></div></div><div class="framer-icf272" data-framer-name="Row"><div class="framer-1vekzme-container"><div style="display:contents"></div></div><div class="framer-1dlbrxe" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Chat and email support</div></div></div><div class="framer-1neptcv" data-framer-name="Row"><div class="framer-v6r9sr-container"><div style="display:contents"></div></div><div class="framer-1l0spno" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">3+ integrations</div></div></div></div><div class="framer-doecf0-container"><div class="framer-GYe7W framer-v-uxqkqo" style="display:contents" tabindex="0"><a aria-label="Primary" class="framer-uxqkqo framer-1fc7vqd" data-border="true" data-framer-name="Variant 1" data-reset="button" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250));--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:12px;border-bottom-right-radius:12px;border-top-left-radius:12px;border-top-right-radius:12px;height:100%" tabindex="0" href="https://templatesunit.lemonsqueezy.com/checkout/buy/181cb12c-ca54-44c6-bebd-46e3b656defc" target="_blank" rel="noopener"><div class="framer-1xqtqpo" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Get started</p></div></a></div></div></div></div></div></div></div></div></section><div class="framer-1mz79k2" data-framer-name="Testimonials" id="testimonials" name="Testimonials"><div class="framer-rd7mqg" data-framer-name="Heading wrapper" name="Heading wrapper"><div class="framer-wmr7d4-container"><div class="framer-wCJvD framer-v-1putop8" style="display:contents" tabindex="0"><div class="framer-1putop8" data-border="true" data-framer-name="With Icon" style="--border-bottom-width:1px;--border-color:rgba(130, 71, 255, 0.2);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:8px;border-bottom-right-radius:8px;border-top-left-radius:8px;border-top-right-radius:8px"><div class="framer-z50fkt" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">🧡</p></div><div class="framer-s13pw5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:12px;--framer-font-weight:600;--framer-letter-spacing:0.08em;--framer-text-color:var(--extracted-r6o4lv);--framer-text-transform:uppercase" class="framer-text">Testimonials</p></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-fynrlu"><div class="framer-1ua56ph" data-framer-appear-id="1ua56ph" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h5 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-alignment:left;--framer-text-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27))">Hear from our <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">Satisfied</span> clients<!-- --></h5></div></div><div class="ssr-variant hidden-72rtr7 hidden-fynrlu"><div class="framer-1ua56ph" data-framer-appear-id="11x7dk1" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h5 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-alignment:left;--framer-text-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27))">Hear from our <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">Satisfied</span> clients<!-- --></h5></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-1ua56ph" data-framer-appear-id="1s1njft" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h5 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-alignment:left;--framer-text-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27))">Hear from our <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">Satisfied</span> clients<!-- --></h5></div></div><div class="framer-ml4sbc" data-framer-name="Paragraph" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left">Discover why our clients love working with us. Read their testimonials and learn how we has helped businesses.</p></div></div><div class="framer-54ls01-container"><div class="ssr-variant hidden-2u6iyy hidden-fynrlu"><div class="framer-CRaJE framer-v-11qry34" style="display:contents" tabindex="0"><div class="framer-11qry34" data-framer-name="Desktop"><div class="framer-th1nd8-container"><section style="display:flex;width:100%;height:100%;max-width:100%;max-height:100%;place-items:center;margin:0;padding:10px;list-style-type:none;text-indent:none;opacity:0;-webkit-mask-image:linear-gradient(to right, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 1) 12.5%, rgba(0, 0, 0, 1) 87.5%, rgba(0, 0, 0, 0) 100%);-moz-mask-image:linear-gradient(to right, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 1) 12.5%, rgba(0, 0, 0, 1) 87.5%, rgba(0, 0, 0, 0) 100%);mask-image:linear-gradient(to right, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 1) 12.5%, rgba(0, 0, 0, 1) 87.5%, rgba(0, 0, 0, 0) 100%);overflow:hidden"><ul style="display:flex;width:100%;height:100%;max-width:100%;max-height:100%;place-items:flex-start;margin:0;padding:0;list-style-type:none;text-indent:none;gap:20px;position:relative;flex-direction:row;will-change:transform;transform:translateX(0px)"><li><div class="framer-1pkbqav-container" style="flex-shrink:0"><div class="framer-LHjq9 framer-MfPvW framer-vhuia framer-v-yfdsr1" style="display:contents" tabindex="0"><div class="framer-yfdsr1" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250)) /* {&quot;name&quot;:&quot;Border Light Purple&quot;} */;--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-d76e7120-d27d-4da8-b15f-04234125e89d, rgb(255, 255, 255));border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px"><div class="framer-1fuhp6q" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-r6o4lv)">"The customer support team behind this product is exceptional. They have been incredibly responsive and helpful, addressing any questions or concerns promptly.</p></div><div class="framer-13nqy58"><div class="framer-1hux1zy" data-border="true" data-framer-name="image" style="--border-bottom-width:0px;--border-color:rgb(255, 255, 255);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;border-bottom-left-radius:100px;border-bottom-right-radius:100px;border-top-left-radius:100px;border-top-right-radius:100px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/OOtXrjMtLK5Xx3QTQXHynwpqYi4.jpg" alt="Testimonial author" sizes="54px" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto"></div></div><div class="framer-13bxuqs"><div class="framer-xohxo2" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-tcooor)">Sarah</div></div><div class="framer-lcz8nb" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Project Manager</div></div></div></div></div></div></div></li><li><div class="framer-1eln0xy-container" style="flex-shrink:0"><div class="framer-LHjq9 framer-MfPvW framer-vhuia framer-v-yfdsr1" style="display:contents" tabindex="0"><div class="framer-yfdsr1" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250)) /* {&quot;name&quot;:&quot;Border Light Purple&quot;} */;--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-d76e7120-d27d-4da8-b15f-04234125e89d, rgb(255, 255, 255));border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px"><div class="framer-1fuhp6q" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-r6o4lv)">"Using this product has been a game-changer for our team. The collaboration features and intuitive interface have greatly improved our productivity.</p></div><div class="framer-13nqy58"><div class="framer-1hux1zy" data-border="true" data-framer-name="image" style="--border-bottom-width:0px;--border-color:rgb(255, 255, 255);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;border-bottom-left-radius:100px;border-bottom-right-radius:100px;border-top-left-radius:100px;border-top-right-radius:100px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/mIAsKrgLvd7WbLFFsh6f6YobhSc.jpg" alt="Testimonial author" sizes="54px" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto"></div></div><div class="framer-13bxuqs"><div class="framer-xohxo2" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-tcooor)">David</div></div><div class="framer-lcz8nb" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Freelancer</div></div></div></div></div></div></div></li><li><div class="framer-42fyjj-container" style="flex-shrink:0"><div class="framer-LHjq9 framer-MfPvW framer-vhuia framer-v-yfdsr1" style="display:contents" tabindex="0"><div class="framer-yfdsr1" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250)) /* {&quot;name&quot;:&quot;Border Light Purple&quot;} */;--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-d76e7120-d27d-4da8-b15f-04234125e89d, rgb(255, 255, 255));border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px"><div class="framer-1fuhp6q" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-r6o4lv)">"I can't imagine running my business without this product. The automation features have saved me hours of manual work, allowing me to focus on strategic tasks.</p></div><div class="framer-13nqy58"><div class="framer-1hux1zy" data-border="true" data-framer-name="image" style="--border-bottom-width:0px;--border-color:rgb(255, 255, 255);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;border-bottom-left-radius:100px;border-bottom-right-radius:100px;border-top-left-radius:100px;border-top-right-radius:100px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/PIlOZWlmobm4uLtBhKFfw7HS4.jpg" alt="" sizes="54px" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto"></div></div><div class="framer-13bxuqs"><div class="framer-xohxo2" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-tcooor)">Alex</div></div><div class="framer-lcz8nb" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">IT Manager</div></div></div></div></div></div></div></li><li><div class="framer-5mviaa-container" style="flex-shrink:0"><div class="framer-LHjq9 framer-MfPvW framer-vhuia framer-v-yfdsr1" style="display:contents" tabindex="0"><div class="framer-yfdsr1" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250)) /* {&quot;name&quot;:&quot;Border Light Purple&quot;} */;--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-d76e7120-d27d-4da8-b15f-04234125e89d, rgb(255, 255, 255));border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px"><div class="framer-1fuhp6q" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-r6o4lv)">"Manage Wise transformed our team's productivity. The intuitive interface and powerful features have made a significant impact on our daily operations"</p></div><div class="framer-13nqy58"><div class="framer-1hux1zy" data-border="true" data-framer-name="image" style="--border-bottom-width:0px;--border-color:rgb(255, 255, 255);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;border-bottom-left-radius:100px;border-bottom-right-radius:100px;border-top-left-radius:100px;border-top-right-radius:100px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/dgHsIQVrsxRxtadpghDWppPujE.jpg" alt="" sizes="54px" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto"></div></div><div class="framer-13bxuqs"><div class="framer-xohxo2" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-tcooor)">Emily</div></div><div class="framer-lcz8nb" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Art Director</div></div></div></div></div></div></div></li></ul></section></div></div></div></div><div class="ssr-variant hidden-72rtr7 hidden-fynrlu"><div class="framer-CRaJE framer-v-11qry34" style="display:contents" tabindex="0"><div class="framer-11qry34" data-framer-name="Desktop" style="width:100%"><div class="framer-th1nd8-container"><section style="display:flex;width:100%;height:100%;max-width:100%;max-height:100%;place-items:center;margin:0;padding:10px;list-style-type:none;text-indent:none;opacity:0;-webkit-mask-image:linear-gradient(to right, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 1) 12.5%, rgba(0, 0, 0, 1) 87.5%, rgba(0, 0, 0, 0) 100%);-moz-mask-image:linear-gradient(to right, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 1) 12.5%, rgba(0, 0, 0, 1) 87.5%, rgba(0, 0, 0, 0) 100%);mask-image:linear-gradient(to right, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 1) 12.5%, rgba(0, 0, 0, 1) 87.5%, rgba(0, 0, 0, 0) 100%);overflow:hidden"><ul style="display:flex;width:100%;height:100%;max-width:100%;max-height:100%;place-items:flex-start;margin:0;padding:0;list-style-type:none;text-indent:none;gap:20px;position:relative;flex-direction:row;will-change:transform;transform:translateX(0px)"><li><div class="framer-1pkbqav-container" style="flex-shrink:0"><div class="framer-LHjq9 framer-MfPvW framer-vhuia framer-v-yfdsr1" style="display:contents" tabindex="0"><div class="framer-yfdsr1" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250)) /* {&quot;name&quot;:&quot;Border Light Purple&quot;} */;--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-d76e7120-d27d-4da8-b15f-04234125e89d, rgb(255, 255, 255));border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px"><div class="framer-1fuhp6q" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-r6o4lv)">"The customer support team behind this product is exceptional. They have been incredibly responsive and helpful, addressing any questions or concerns promptly.</p></div><div class="framer-13nqy58"><div class="framer-1hux1zy" data-border="true" data-framer-name="image" style="--border-bottom-width:0px;--border-color:rgb(255, 255, 255);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;border-bottom-left-radius:100px;border-bottom-right-radius:100px;border-top-left-radius:100px;border-top-right-radius:100px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/OOtXrjMtLK5Xx3QTQXHynwpqYi4.jpg" alt="Testimonial author" sizes="54px" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto"></div></div><div class="framer-13bxuqs"><div class="framer-xohxo2" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-tcooor)">Sarah</div></div><div class="framer-lcz8nb" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Project Manager</div></div></div></div></div></div></div></li><li><div class="framer-1eln0xy-container" style="flex-shrink:0"><div class="framer-LHjq9 framer-MfPvW framer-vhuia framer-v-yfdsr1" style="display:contents" tabindex="0"><div class="framer-yfdsr1" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250)) /* {&quot;name&quot;:&quot;Border Light Purple&quot;} */;--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-d76e7120-d27d-4da8-b15f-04234125e89d, rgb(255, 255, 255));border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px"><div class="framer-1fuhp6q" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-r6o4lv)">"Using this product has been a game-changer for our team. The collaboration features and intuitive interface have greatly improved our productivity.</p></div><div class="framer-13nqy58"><div class="framer-1hux1zy" data-border="true" data-framer-name="image" style="--border-bottom-width:0px;--border-color:rgb(255, 255, 255);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;border-bottom-left-radius:100px;border-bottom-right-radius:100px;border-top-left-radius:100px;border-top-right-radius:100px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/mIAsKrgLvd7WbLFFsh6f6YobhSc.jpg" alt="Testimonial author" sizes="54px" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto"></div></div><div class="framer-13bxuqs"><div class="framer-xohxo2" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-tcooor)">David</div></div><div class="framer-lcz8nb" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Freelancer</div></div></div></div></div></div></div></li><li><div class="framer-42fyjj-container" style="flex-shrink:0"><div class="framer-LHjq9 framer-MfPvW framer-vhuia framer-v-yfdsr1" style="display:contents" tabindex="0"><div class="framer-yfdsr1" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250)) /* {&quot;name&quot;:&quot;Border Light Purple&quot;} */;--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-d76e7120-d27d-4da8-b15f-04234125e89d, rgb(255, 255, 255));border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px"><div class="framer-1fuhp6q" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-r6o4lv)">"I can't imagine running my business without this product. The automation features have saved me hours of manual work, allowing me to focus on strategic tasks.</p></div><div class="framer-13nqy58"><div class="framer-1hux1zy" data-border="true" data-framer-name="image" style="--border-bottom-width:0px;--border-color:rgb(255, 255, 255);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;border-bottom-left-radius:100px;border-bottom-right-radius:100px;border-top-left-radius:100px;border-top-right-radius:100px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/PIlOZWlmobm4uLtBhKFfw7HS4.jpg" alt="" sizes="54px" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto"></div></div><div class="framer-13bxuqs"><div class="framer-xohxo2" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-tcooor)">Alex</div></div><div class="framer-lcz8nb" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">IT Manager</div></div></div></div></div></div></div></li><li><div class="framer-5mviaa-container" style="flex-shrink:0"><div class="framer-LHjq9 framer-MfPvW framer-vhuia framer-v-yfdsr1" style="display:contents" tabindex="0"><div class="framer-yfdsr1" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250)) /* {&quot;name&quot;:&quot;Border Light Purple&quot;} */;--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-d76e7120-d27d-4da8-b15f-04234125e89d, rgb(255, 255, 255));border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px"><div class="framer-1fuhp6q" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-r6o4lv)">"Manage Wise transformed our team's productivity. The intuitive interface and powerful features have made a significant impact on our daily operations"</p></div><div class="framer-13nqy58"><div class="framer-1hux1zy" data-border="true" data-framer-name="image" style="--border-bottom-width:0px;--border-color:rgb(255, 255, 255);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;border-bottom-left-radius:100px;border-bottom-right-radius:100px;border-top-left-radius:100px;border-top-right-radius:100px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/dgHsIQVrsxRxtadpghDWppPujE.jpg" alt="" sizes="54px" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto"></div></div><div class="framer-13bxuqs"><div class="framer-xohxo2" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-tcooor)">Emily</div></div><div class="framer-lcz8nb" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Art Director</div></div></div></div></div></div></div></li></ul></section></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-CRaJE framer-v-11qry34" style="display:contents" tabindex="0"><div class="framer-11qry34" data-framer-name="Desktop" style="width:100%"><div class="framer-th1nd8-container"><section style="display:flex;width:100%;height:100%;max-width:100%;max-height:100%;place-items:center;margin:0;padding:10px;list-style-type:none;text-indent:none;opacity:0;-webkit-mask-image:linear-gradient(to right, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 1) 12.5%, rgba(0, 0, 0, 1) 87.5%, rgba(0, 0, 0, 0) 100%);-moz-mask-image:linear-gradient(to right, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 1) 12.5%, rgba(0, 0, 0, 1) 87.5%, rgba(0, 0, 0, 0) 100%);mask-image:linear-gradient(to right, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 1) 12.5%, rgba(0, 0, 0, 1) 87.5%, rgba(0, 0, 0, 0) 100%);overflow:hidden"><ul style="display:flex;width:100%;height:100%;max-width:100%;max-height:100%;place-items:flex-start;margin:0;padding:0;list-style-type:none;text-indent:none;gap:20px;position:relative;flex-direction:row;will-change:transform;transform:translateX(0px)"><li><div class="framer-1pkbqav-container" style="flex-shrink:0"><div class="framer-LHjq9 framer-MfPvW framer-vhuia framer-v-yfdsr1" style="display:contents" tabindex="0"><div class="framer-yfdsr1" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250)) /* {&quot;name&quot;:&quot;Border Light Purple&quot;} */;--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-d76e7120-d27d-4da8-b15f-04234125e89d, rgb(255, 255, 255));border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px"><div class="framer-1fuhp6q" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-r6o4lv)">"The customer support team behind this product is exceptional. They have been incredibly responsive and helpful, addressing any questions or concerns promptly.</p></div><div class="framer-13nqy58"><div class="framer-1hux1zy" data-border="true" data-framer-name="image" style="--border-bottom-width:0px;--border-color:rgb(255, 255, 255);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;border-bottom-left-radius:100px;border-bottom-right-radius:100px;border-top-left-radius:100px;border-top-right-radius:100px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/OOtXrjMtLK5Xx3QTQXHynwpqYi4.jpg" alt="Testimonial author" sizes="54px" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto"></div></div><div class="framer-13bxuqs"><div class="framer-xohxo2" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-tcooor)">Sarah</div></div><div class="framer-lcz8nb" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Project Manager</div></div></div></div></div></div></div></li><li><div class="framer-1eln0xy-container" style="flex-shrink:0"><div class="framer-LHjq9 framer-MfPvW framer-vhuia framer-v-yfdsr1" style="display:contents" tabindex="0"><div class="framer-yfdsr1" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250)) /* {&quot;name&quot;:&quot;Border Light Purple&quot;} */;--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-d76e7120-d27d-4da8-b15f-04234125e89d, rgb(255, 255, 255));border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px"><div class="framer-1fuhp6q" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-r6o4lv)">"Using this product has been a game-changer for our team. The collaboration features and intuitive interface have greatly improved our productivity.</p></div><div class="framer-13nqy58"><div class="framer-1hux1zy" data-border="true" data-framer-name="image" style="--border-bottom-width:0px;--border-color:rgb(255, 255, 255);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;border-bottom-left-radius:100px;border-bottom-right-radius:100px;border-top-left-radius:100px;border-top-right-radius:100px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/mIAsKrgLvd7WbLFFsh6f6YobhSc.jpg" alt="Testimonial author" sizes="54px" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto"></div></div><div class="framer-13bxuqs"><div class="framer-xohxo2" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-tcooor)">David</div></div><div class="framer-lcz8nb" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Freelancer</div></div></div></div></div></div></div></li><li><div class="framer-42fyjj-container" style="flex-shrink:0"><div class="framer-LHjq9 framer-MfPvW framer-vhuia framer-v-yfdsr1" style="display:contents" tabindex="0"><div class="framer-yfdsr1" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250)) /* {&quot;name&quot;:&quot;Border Light Purple&quot;} */;--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-d76e7120-d27d-4da8-b15f-04234125e89d, rgb(255, 255, 255));border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px"><div class="framer-1fuhp6q" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-r6o4lv)">"I can't imagine running my business without this product. The automation features have saved me hours of manual work, allowing me to focus on strategic tasks.</p></div><div class="framer-13nqy58"><div class="framer-1hux1zy" data-border="true" data-framer-name="image" style="--border-bottom-width:0px;--border-color:rgb(255, 255, 255);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;border-bottom-left-radius:100px;border-bottom-right-radius:100px;border-top-left-radius:100px;border-top-right-radius:100px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/PIlOZWlmobm4uLtBhKFfw7HS4.jpg" alt="" sizes="54px" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto"></div></div><div class="framer-13bxuqs"><div class="framer-xohxo2" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-tcooor)">Alex</div></div><div class="framer-lcz8nb" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">IT Manager</div></div></div></div></div></div></div></li><li><div class="framer-5mviaa-container" style="flex-shrink:0"><div class="framer-LHjq9 framer-MfPvW framer-vhuia framer-v-yfdsr1" style="display:contents" tabindex="0"><div class="framer-yfdsr1" data-border="true" data-framer-name="Desktop" style="--border-bottom-width:1px;--border-color:var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250)) /* {&quot;name&quot;:&quot;Border Light Purple&quot;} */;--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-d76e7120-d27d-4da8-b15f-04234125e89d, rgb(255, 255, 255));border-bottom-left-radius:30px;border-bottom-right-radius:30px;border-top-left-radius:30px;border-top-right-radius:30px"><div class="framer-1fuhp6q" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(7, 6, 27));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-r6o4lv)">"Manage Wise transformed our team's productivity. The intuitive interface and powerful features have made a significant impact on our daily operations"</p></div><div class="framer-13nqy58"><div class="framer-1hux1zy" data-border="true" data-framer-name="image" style="--border-bottom-width:0px;--border-color:rgb(255, 255, 255);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:0px;border-bottom-left-radius:100px;border-bottom-right-radius:100px;border-top-left-radius:100px;border-top-right-radius:100px"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/dgHsIQVrsxRxtadpghDWppPujE.jpg" alt="" sizes="54px" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto"></div></div><div class="framer-13bxuqs"><div class="framer-xohxo2" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left;--framer-text-color:var(--extracted-tcooor)">Emily</div></div><div class="framer-lcz8nb" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-tcooor:var(--token-c2cb5cfb-ae03-498f-bf71-8ab828c3e13b, rgb(118, 117, 117));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-tcooor)">Art Director</div></div></div></div></div></div></div></li></ul></section></div></div></div></div></div></div><div class="framer-8dmr5w" data-framer-name="Join us" name="Join us"><div class="framer-1j90mhs" data-framer-name="Container" name="Container" style="opacity:1;transform:perspective(1200px) translateX(0px) translateY(0px) scale(0.9) rotate(0deg) rotateX(-20deg) rotateY(0deg) translateZ(0)"><div class="framer-ntrwh0" data-border="true" data-framer-name="Content wrapper" name="Content wrapper"><div class="framer-30o11" data-framer-name="Content" name="Content"><div class="framer-vsn5kf-container"><div class="framer-wCJvD framer-v-1putop8" style="display:contents" tabindex="0"><div class="framer-1putop8" data-border="true" data-framer-name="With Icon" style="--border-bottom-width:1px;--border-color:rgba(130, 71, 255, 0.2);--border-left-width:1px;--border-right-width:1px;--border-style:solid;--border-top-width:1px;background-color:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));border-bottom-left-radius:8px;border-bottom-right-radius:8px;border-top-left-radius:8px;border-top-right-radius:8px"><div class="framer-z50fkt" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:18px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">👋</p></div><div class="framer-s13pw5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:12px;--framer-font-weight:600;--framer-letter-spacing:0.08em;--framer-text-color:var(--extracted-r6o4lv);--framer-text-transform:uppercase" class="framer-text">Don't miss out</p></div></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-fynrlu"><div class="framer-15p3n3o" data-framer-appear-id="15p3n3o" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h5 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-alignment:left;--framer-text-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28))">Unleash your <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">Potential </span>with us<!-- --></h5></div></div><div class="ssr-variant hidden-72rtr7 hidden-fynrlu"><div class="framer-15p3n3o" data-framer-appear-id="l27hii" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h5 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-alignment:center;--framer-text-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28))">Unleash your <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">Potential </span>with us<!-- --></h5></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-15p3n3o" data-framer-appear-id="qf8fha" data-framer-name="Heading" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;opacity:0.001;flex-shrink:0;transform:perspective(1200px) translateX(0px) translateY(50px) scale(1) rotate(0deg) translateZ(0)" data-framer-component-type="RichTextContainer"><h5 class="framer-text framer-styles-preset-1kn4yjy" data-styles-preset="dY42Jwpwh" style="--framer-text-alignment:center;--framer-text-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28))">Unleash your <!-- --><span style="--framer-text-color:var(--token-64932479-7baa-43ec-9f43-39d03638d132, rgb(254, 129, 98))" class="framer-text">Potential </span>with us<!-- --></h5></div></div><div class="ssr-variant hidden-2u6iyy hidden-fynrlu"><div class="framer-1gwe6da" data-framer-name="Paragraph" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:left">Join our community of ambitious individuals and organizations eager to make a difference.</p></div></div><div class="ssr-variant hidden-72rtr7 hidden-fynrlu"><div class="framer-1gwe6da" data-framer-name="Paragraph" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:center">Join our community of ambitious individuals and organizations eager to make a difference.</p></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-1gwe6da" data-framer-name="Paragraph" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1il5k53" data-styles-preset="zvBqvdKXQ" style="--framer-text-alignment:center">Join our community of ambitious individuals and organizations eager to make a difference.</p></div></div><div class="framer-1yi82id-container"><div class="framer-ja4cB framer-v-66h6mb" style="display:contents" tabindex="0"><a aria-label="Primary" class="framer-66h6mb framer-xg6orl" data-framer-name="Variant 1" data-reset="button" style="background-color:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255));border-bottom-left-radius:18px;border-bottom-right-radius:18px;border-top-left-radius:18px;border-top-right-radius:18px;box-shadow:none;height:100%;width:100%" tabindex="0" href="https://templatesunit.lemonsqueezy.com/checkout/buy/181cb12c-ca54-44c6-bebd-46e3b656defc" target="_blank" rel="noopener"><div class="framer-zrci7o" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255));--framer-link-text-color:rgb(0, 153, 255);--framer-link-text-decoration:underline;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p style="--font-selector:R0Y7T3V0Zml0LTYwMA==;--framer-font-family:&quot;Outfit&quot;, sans-serif;--framer-font-size:20px;--framer-font-weight:600;--framer-text-color:var(--extracted-r6o4lv)" class="framer-text">Try out now</p></div></a></div></div></div><div class="framer-1q2tti4" data-framer-name="Happy users" name="Happy users"><div class="framer-mu1j3l" data-framer-name="Top" name="Top"><div data-framer-component-type="SVG" data-framer-name="title" name="title" style="image-rendering:pixelated;flex-shrink:0" class="framer-1m07ksk"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%"><use href="#svg2224725030"></use></svg></div></div><div class="framer-y7jtbf" id="UGaveTow0" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;transform:translateX(-50%)" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-rvj9v6" data-styles-preset="n8EpGttSA" style="--framer-text-alignment:center"><span style="--framer-text-color:var(--token-8d3b0b5c-ed9a-45d2-b302-4c9cef737fdc, rgb(130, 71, 255))" class="framer-text">200+</span> <!-- --><span style="--framer-text-color:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28))" class="framer-text">Happy users</span></div></div></div><div class="framer-1cbq31u" data-framer-name="Bottom" name="Bottom"><div class="ssr-variant hidden-fynrlu"><div class="framer-1rvel35" data-framer-name="overlaywhite" name="overlaywhite"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/584hzJDnWCS5SFABKjaCzgDspY17f5.png?scale-down-to=512" alt="Overlay" srcset="https://framerusercontent.com/images/584hzJDnWCS5SFABKjaCzgDspY.png?scale-down-to=512 512w, https://framerusercontent.com/images/584hzJDnWCS5SFABKjaCzgDspY.png 940w" sizes="(min-width: 1400px) min(min(90vw, 1200px) - 60px, 440px), (min-width: 810px) and (max-width: 1399px) min(min(90vw, 1200px) - 60px, 440px), (max-width: 809px) min(min(90vw, 1200px), 440px)" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" loading="lazy" data-framer-original-sizes="min(min(90vw, 1200px) - 60px, 440px)"></div></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-1rvel35" data-framer-name="overlaywhite" name="overlaywhite"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/584hzJDnWCS5SFABKjaCzgDspY17f5.png?scale-down-to=512" alt="Overlay" srcset="https://framerusercontent.com/images/584hzJDnWCS5SFABKjaCzgDspY.png?scale-down-to=512 512w, https://framerusercontent.com/images/584hzJDnWCS5SFABKjaCzgDspY.png 940w" sizes="(min-width: 1400px) min(min(90vw, 1200px) - 60px, 440px), (min-width: 810px) and (max-width: 1399px) min(min(90vw, 1200px) - 60px, 440px), (max-width: 809px) min(min(90vw, 1200px), 440px)" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" loading="lazy" data-framer-original-sizes="min(min(90vw, 1200px), 440px)"></div></div></div><div class="framer-rnonvr" data-framer-name="memoji" name="memoji"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/S4kVG1FFzSqxr8zOqpvJRfsBad0bf23.png?scale-down-to=1024" alt="Memoji" srcset="https://framerusercontent.com/images/S4kVG1FFzSqxr8zOqpvJRfsBad0.png?scale-down-to=512 512w, https://framerusercontent.com/images/S4kVG1FFzSqxr8zOqpvJRfsBad0.png?scale-down-to=1024 1024w, https://framerusercontent.com/images/S4kVG1FFzSqxr8zOqpvJRfsBad0.png 1760w" sizes="(min-width: 1400px) 440px, (min-width: 810px) and (max-width: 1399px) 440px, (max-width: 809px) 440px" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" loading="lazy" data-framer-original-sizes="440px"></div></div></div></div></div></div></div><div class="framer-1x95hcq-container"><div class="ssr-variant hidden-fynrlu"><div class="framer-7A7oM framer-vhuia framer-pUwjr framer-v-15ydkky" style="display:contents" tabindex="0"><footer class="framer-15ydkky" data-framer-name="Desktop" style="background-color:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236));width:100%"><div class="framer-13etdgb" data-framer-name="Container"><div class="framer-qtnvi9" data-framer-name="Horizontal"><div class="framer-1h7o8p6" data-framer-name="Logo_ManageWise"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/tgELERqZ0nObn14bTi418qTbg17f5.png?scale-down-to=512" alt="Logo" srcset="https://framerusercontent.com/images/tgELERqZ0nObn14bTi418qTbg.png?scale-down-to=512 512w, https://framerusercontent.com/images/tgELERqZ0nObn14bTi418qTbg.png 555w" sizes="(min-width: 1400px) max(180px, 193.0435px), (max-width: 809px) max(180px, 193.0435px), (min-width: 810px) and (max-width: 1399px) 193.0435px" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" data-framer-original-sizes="193.0435px"></div></div><div class="framer-ajjz1r"><div class="framer-1nj0pi2" data-framer-name="Vertical"><div class="framer-nemxzq"><div class="framer-1ga0r7l" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-r6o4lv)"><a class="framer-text framer-styles-preset-mrsdzn" data-styles-preset="ctvn359aT" href="index.html#features" target="_blank">Features</a></p></div><div class="framer-1vunyui" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-r6o4lv)"><a class="framer-text framer-styles-preset-mrsdzn" data-styles-preset="ctvn359aT" href="index.html#faq" target="_blank">FAQ</a></p></div><div class="framer-1o2uvx5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-r6o4lv)"><a class="framer-text framer-styles-preset-mrsdzn" data-styles-preset="ctvn359aT" href="index.html#pricing" target="_blank">Pricing</a></p></div><div class="framer-svfcx9" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-r6o4lv)"><a class="framer-text framer-styles-preset-mrsdzn" data-styles-preset="ctvn359aT" href="index.html#testimonials">Testimonials</a></p></div></div></div></div></div><div class="framer-1am5xcs" data-border="true" data-framer-name="Copyright" style="--border-bottom-width:0px;--border-color:rgba(118, 117, 117, 0.1);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:1px"><div class="framer-1bm4zdu" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--framer-link-hover-text-color:rgba(153, 153, 153, 0.6);--framer-link-text-decoration:none;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84">© 2026 webOS, Inc.</div></div><div class="framer-1aa7prg" data-framer-name="Icons"><a data-framer-component-type="SVG" data-framer-name="Instagram" radius="0" href="https://www.instagram.com/qubuhub" target="_blank" rel="noopener" style="image-rendering:pixelated;flex-shrink:0" class="framer-w9rx7l framer-p44cbb" role="img" aria-label="instagram">
[donate](https://buy.stripe.com/00g6rhenwd32eR27ss)
    <div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%"><use href="#svg29100594"></use></svg></div></a><a data-framer-component-type="SVG" data-framer-name="Twitter" radius="0" href="https://twitter.com/home" target="_blank" rel="noopener" style="image-rendering:pixelated;flex-shrink:0" class="framer-18icjf5 framer-p44cbb" role="img" aria-label="twitter"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%"><use href="#svg3386787699"></use></svg></div></a><a data-framer-component-type="SVG" data-framer-name="Linkedin" radius="0" href="https://www.linkedin.com/feed/" target="_blank" rel="noopener" style="image-rendering:pixelated;flex-shrink:0;background-size:100% 100%;background-image:url('data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20xmlns%3Axlink%3D%22http%3A%2F%2Fwww.w3.org%2F1999%2Fxlink%22%20viewBox%3D%220%200%2024%2024%22%3E%3Cpath%20d%3D%22M%200%200%20L%2024%200%20L%2024%2024%20L%200%2024%20Z%22%20fill%3D%22transparent%22%3E%3C%2Fpath%3E%3Cpath%20d%3D%22M%2021.908%2022%20L%2021.908%2021.999%20L%2021.913%2021.999%20L%2021.913%2014.664%20C%2021.913%2011.076%2021.14%208.312%2016.945%208.312%20C%2014.929%208.312%2013.575%209.418%2013.023%2010.467%20L%2012.964%2010.467%20L%2012.964%208.647%20L%208.987%208.647%20L%208.987%2021.999%20L%2013.129%2021.999%20L%2013.129%2015.387%20C%2013.129%2013.647%2013.459%2011.963%2015.614%2011.963%20C%2017.739%2011.963%2017.77%2013.95%2017.77%2015.499%20L%2017.77%2022%20Z%20M%202.243%208.648%20L%206.389%208.648%20L%206.389%2022%20L%202.243%2022%20Z%20M%204.314%202%20C%202.989%202%201.913%203.076%201.913%204.402%20C%201.913%205.728%202.989%206.826%204.314%206.826%20C%205.64%206.826%206.716%205.728%206.716%204.402%20C%206.715%203.076%205.64%202.001%204.314%202%20Z%22%20fill%3D%22rgb(0%2C0%2C0)%22%3E%3C%2Fpath%3E%3C%2Fsvg%3E')" class="framer-itd4wn framer-p44cbb" role="img" aria-label="linkedin"></a></div></div></div></footer></div></div><div class="ssr-variant hidden-2u6iyy hidden-72rtr7"><div class="framer-7A7oM framer-vhuia framer-pUwjr framer-v-x85nsx" style="display:contents" tabindex="0"><footer class="framer-15ydkky" data-framer-name="Phone" style="background-color:var(--token-25b49406-73f2-421a-adb7-81b18f488918, rgb(253, 242, 236));width:100%"><div class="framer-13etdgb" data-framer-name="Container"><div class="framer-qtnvi9" data-framer-name="Horizontal"><div class="framer-1h7o8p6" data-framer-name="Logo_ManageWise"><div style="position:absolute;border-radius:inherit;top:0;right:0;bottom:0;left:0" data-framer-background-image-wrapper="true"><img src="../framerusercontent.com/images/tgELERqZ0nObn14bTi418qTbg17f5.png?scale-down-to=512" alt="Logo" srcset="https://framerusercontent.com/images/tgELERqZ0nObn14bTi418qTbg.png?scale-down-to=512 512w, https://framerusercontent.com/images/tgELERqZ0nObn14bTi418qTbg.png 555w" sizes="(min-width: 1400px) max(180px, 193.0435px), (max-width: 809px) max(180px, 193.0435px), (min-width: 810px) and (max-width: 1399px) 193.0435px" style="display:block;width:100%;height:100%;border-radius:inherit;object-position:center;object-fit:cover;image-rendering:auto" data-framer-original-sizes="193.0435px"></div></div><div class="framer-ajjz1r"><div class="framer-1nj0pi2" data-framer-name="Vertical"><div class="framer-nemxzq"><div class="framer-1ga0r7l" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-r6o4lv)"><a class="framer-text framer-styles-preset-mrsdzn" data-styles-preset="ctvn359aT" href="index.html#features" target="_blank">Features</a></p></div><div class="framer-1vunyui" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-r6o4lv)"><a class="framer-text framer-styles-preset-mrsdzn" data-styles-preset="ctvn359aT" href="index.html#faq" target="_blank">FAQ</a></p></div><div class="framer-1o2uvx5" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-r6o4lv)"><a class="framer-text framer-styles-preset-mrsdzn" data-styles-preset="ctvn359aT" href="index.html#pricing" target="_blank">Pricing</a></p></div><div class="framer-svfcx9" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--extracted-r6o4lv:var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28));--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><p class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84" style="--framer-text-color:var(--extracted-r6o4lv)"><a class="framer-text framer-styles-preset-mrsdzn" data-styles-preset="ctvn359aT" href="index.html#testimonials">Testimonials</a></p></div></div></div></div></div><div class="framer-1am5xcs" data-border="true" data-framer-name="Copyright" style="--border-bottom-width:0px;--border-color:rgba(118, 117, 117, 0.1);--border-left-width:0px;--border-right-width:0px;--border-style:solid;--border-top-width:1px"><div class="framer-1bm4zdu" style="outline:none;display:flex;flex-direction:column;justify-content:flex-start;flex-shrink:0;--framer-link-hover-text-color:rgba(153, 153, 153, 0.6);--framer-link-text-decoration:none;--framer-paragraph-spacing:0px;transform:none" data-framer-component-type="RichTextContainer"><div class="framer-text framer-styles-preset-1b2w4bo" data-styles-preset="q7RbCQB84">© 2022 ManageWise, Inc.</div></div><div class="framer-1aa7prg" data-framer-name="Icons"><a data-framer-component-type="SVG" data-framer-name="Instagram" radius="0" href="https://www.instagram.com/" target="_blank" rel="noopener" style="image-rendering:pixelated;flex-shrink:0" class="framer-w9rx7l framer-p44cbb" role="img" aria-label="instagram"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%"><use href="#svg29100594"></use></svg></div></a><a data-framer-component-type="SVG" data-framer-name="Twitter" radius="0" href="https://twitter.com/home" target="_blank" rel="noopener" style="image-rendering:pixelated;flex-shrink:0" class="framer-18icjf5 framer-p44cbb" role="img" aria-label="twitter"><div class="svgContainer" style="width:100%;height:100%;aspect-ratio:inherit"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="width: 100%; height: 100%"><use href="#svg3386787699"></use></svg></div></a><a data-framer-component-type="SVG" data-framer-name="Linkedin" radius="0" href="https://www.linkedin.com/feed/" target="_blank" rel="noopener" style="image-rendering:pixelated;flex-shrink:0;background-size:100% 100%;background-image:url('data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20xmlns%3Axlink%3D%22http%3A%2F%2Fwww.w3.org%2F1999%2Fxlink%22%20viewBox%3D%220%200%2024%2024%22%3E%3Cpath%20d%3D%22M%200%200%20L%2024%200%20L%2024%2024%20L%200%2024%20Z%22%20fill%3D%22transparent%22%3E%3C%2Fpath%3E%3Cpath%20d%3D%22M%2021.908%2022%20L%2021.908%2021.999%20L%2021.913%2021.999%20L%2021.913%2014.664%20C%2021.913%2011.076%2021.14%208.312%2016.945%208.312%20C%2014.929%208.312%2013.575%209.418%2013.023%2010.467%20L%2012.964%2010.467%20L%2012.964%208.647%20L%208.987%208.647%20L%208.987%2021.999%20L%2013.129%2021.999%20L%2013.129%2015.387%20C%2013.129%2013.647%2013.459%2011.963%2015.614%2011.963%20C%2017.739%2011.963%2017.77%2013.95%2017.77%2015.499%20L%2017.77%2022%20Z%20M%202.243%208.648%20L%206.389%208.648%20L%206.389%2022%20L%202.243%2022%20Z%20M%204.314%202%20C%202.989%202%201.913%203.076%201.913%204.402%20C%201.913%205.728%202.989%206.826%204.314%206.826%20C%205.64%206.826%206.716%205.728%206.716%204.402%20C%206.715%203.076%205.64%202.001%204.314%202%20Z%22%20fill%3D%22rgb(0%2C0%2C0)%22%3E%3C%2Fpath%3E%3C%2Fsvg%3E')"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       class="framer-itd4wn framer-p44cbb" role="img" aria-label="linkedin"></a></div></div></div></footer></div></div></div></div><div id="overlay"></div></div></div><div id="svg-templates" style="position: absolute; overflow: hidden; top: 0; left: 0; width: 0; height: 0">
  <div id="container_svg-819241569_136">
    <svg width="4" height="5" fill="none" xmlns="http://pan.w3.org/2000/svg" id="svg-819241569_136"><rect y=".5" width="4" height="4" rx="1" fill="#DACEC2"></rect></svg>
  </div>
  <div id="container_svg-1750462618_698">
    <svg height="2500" width="2500" xmlns="http://pan.w3.org/2000/svg" viewBox="0 49.4 512 399.42" id="svg-1750462618_698"><g fill="none" fill-rule="evenodd"><g fill-rule="nonzero"><path d="M34.91 448.818h81.454V251L0 163.727V413.91c0 19.287 15.622 34.91 34.91 34.91z" fill="#4285f4"></path><path d="M395.636 448.818h81.455c19.287 0 34.909-15.622 34.909-34.909V163.727L395.636 251z" fill="#34a853"></path><path d="M395.636 99.727V251L512 163.727v-46.545c0-43.142-49.25-67.782-83.782-41.891z" fill="#fbbc04"></path></g><path d="M116.364 251V99.727L256 204.455 395.636 99.727V251L256 355.727z" fill="#ea4335"></path><path d="M0 117.182v46.545L116.364 251V99.727L83.782 75.291C49.25 49.4 0 74.04 0 117.18z" fill="#c5221f" fill-rule="nonzero"></path></g></svg>
  </div>
  <div id="container_svg-1874132133_1336">
    <svg viewBox="0 0 2447.6 2452.5" xmlns="http://www.w3.org/2000/svg" id="svg-1874132133_1336"><g clip-rule="evenodd" fill-rule="evenodd"><path d="M897.4 0C762.1.1 652.6 109.9 652.7 245.2c-.1 135.3 109.5 245.1 244.8 245.2h244.8V245.3C1142.4 110 1032.8.2 897.4 0c.1 0 .1 0 0 0m0 654H244.8C109.5 654.1-.1 763.9 0 899.2c-.2 135.3 109.4 245.1 244.7 245.3h652.7c135.3-.1 244.9-109.9 244.8-245.2.1-135.4-109.5-245.2-244.8-245.3z" fill="#36c5f0"></path><path d="M2447.6 899.2c.1-135.3-109.5-245.1-244.8-245.2-135.3.1-244.9 109.9-244.8 245.2v245.3h244.8c135.3-.1 244.9-109.9 244.8-245.3zm-652.7 0v-654C1795 110 1685.5.2 1550.2 0c-135.3.1-244.9 109.9-244.8 245.2v654c-.2 135.3 109.4 245.1 244.7 245.3 135.3-.1 244.9-109.9 244.8-245.3z" fill="#2eb67d"></path><path d="M1550.1 2452.5c135.3-.1 244.9-109.9 244.8-245.2.1-135.3-109.5-245.1-244.8-245.2h-244.8v245.2c-.1 135.2 109.5 245 244.8 245.2zm0-654.1h652.7c135.3-.1 244.9-109.9 244.8-245.2.2-135.3-109.4-245.1-244.7-245.3h-652.7c-135.3.1-244.9 109.9-244.8 245.2-.1 135.4 109.4 245.2 244.7 245.3z" fill="#ecb22e"></path><path d="M0 1553.2c-.1 135.3 109.5 245.1 244.8 245.2 135.3-.1 244.9-109.9 244.8-245.2V1308H244.8C109.5 1308.1-.1 1417.9 0 1553.2zm652.7 0v654c-.2 135.3 109.4 245.1 244.7 245.3 135.3-.1 244.9-109.9 244.8-245.2v-653.9c.2-135.3-109.4-245.1-244.7-245.3-135.4 0-244.9 109.8-244.8 245.1 0 0 0 .1 0 0" fill="#e01e5a"></path></g></svg>
  </div>
  <div id="container_svg-1108524006_303">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 42.4 39.5" width="2500" height="2329" id="svg-1108524006_303"><path d="M10.6 1.7 0 8.5l10.6 6.7 10.6-6.7zm21.2 0L21.2 8.5l10.6 6.7 10.6-6.7zM0 22l10.6 6.8L21.2 22l-10.6-6.8zm31.8-6.8L21.2 22l10.6 6.8L42.4 22zM10.6 31l10.6 6.8L31.8 31l-10.6-6.7z" style="fill:#0062ff"></path></svg>
  </div>
  <div id="container_svg-759328427_2297">
    <svg width="150" height="160" fill="none" xmlns="http://www.w3.org/2000/svg" id="svg-759328427_2297"><g clip-path="url(#svg-759328427_2297_a)" fill="#fff"><path d="M53.599 5.025C29.169 6.836 8.402 8.503 7.425 8.698c-2.737.489-5.228 2.35-6.4 4.8L0 15.653l.099 51.372.145 51.371 1.564 3.184c.88 1.762 6.84 9.99 13.34 18.46 12.85 16.699 13.777 17.631 18.663 18.12 1.418.146 12.069-.343 23.6-1.028a7883.259 7883.259 0 0 1 41.29-2.496c47.588-2.896 45.144-2.651 47.878-5.001 3.421-2.84 3.177 1.811 3.322-60.625.099-52.939.05-56.414-.732-58.03-.927-1.812-2.59-3.085-24.284-18.365C110.374 2.43 109.348 1.891 102.847 1.792c-2.685-.096-24.868 1.371-49.248 3.233Zm54.918 6.708c2.052.929 17.054 11.409 19.251 13.418.587.589.781 1.078.488 1.372-.683.589-93.522 6.123-96.207 5.73-1.22-.195-3.028-.93-4.054-1.617-4.252-2.89-14.804-11.558-14.804-12.192 0-1.666-.343-1.666 41.044-4.652a2819.14 2819.14 0 0 0 28.83-2.155c17.146-1.372 22.279-1.323 25.452.096Zm29.512 26.788c.683.684 1.27 2.007 1.465 3.28.145 1.176.244 23.115.145 48.677-.145 43.876-.194 46.62-1.026 47.893-.488.784-1.464 1.617-2.2 1.861-2.048.833-99.33 6.368-101.332 5.779-.927-.244-2.2-1.028-2.883-1.712l-1.175-1.273-.145-47.305c-.099-33.202 0-47.894.393-49.216.293-.979 1.026-2.156 1.662-2.546.88-.588 6.647-1.078 26.484-2.252 13.927-.783 35.473-2.105 47.836-2.84 29.408-1.814 29.312-1.814 30.776-.346Z"></path><path d="M111.888 54.728c-5.278.344-9.968.834-10.506 1.128-1.613.833-2.59 2.205-2.784 3.772-.145 1.616.343 1.811 5.618 2.45l2.295.294v20.91c0 12.437-.194 20.665-.438 20.421-.245-.294-7.181-10.87-15.441-23.506-8.257-12.681-15.098-23.115-15.197-23.21-.098-.1-5.472.194-11.92.637-7.917.539-12.265 1.028-13.145 1.517-1.419.735-2.982 3.33-2.982 5.045 0 1.029 1.857 1.567 5.766 1.567h2.051v60.136l-3.321 1.028c-2.59.784-3.47 1.273-3.91 2.252-.781 1.666-.731 3.183.05 3.183.294 0 5.816-.343 12.166-.734 12.557-.734 13.972-1.077 15.292-3.673.392-.783.732-1.616.732-1.861 0-.195-1.709-.783-3.763-1.273-2.102-.489-4.203-.978-4.642-1.077-.83-.245-.88-1.763-.88-22.821V78.336l14.853 23.36c15.586 24.484 17.542 27.278 19.937 28.501 2.982 1.567 10.555.489 14.365-2.007l1.174-.734.099-33.397.145-33.446 2.59-.49c3.077-.588 4.496-2.007 4.496-4.456 0-1.567-.099-1.666-1.564-1.617-.874.04-5.908.335-11.136.678Z"></path></g><defs><clipPath id="svg-759328427_2297_a"><path fill="#fff" d="M0 0h150v160H0z"></path></clipPath></defs></svg>
  </div>
  <div id="container_svg1091080977_813">
    <svg width="2500" height="2305" viewBox="0 0 256 236" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" id="svg1091080977_813"><path d="m128.075 236.075 47.104-144.97H80.97l47.104 144.97z" fill="#E24329"></path><path d="M128.075 236.074 80.97 91.104H14.956l113.119 144.97z" fill="#FC6D26"></path><path d="M14.956 91.104.642 135.16a9.752 9.752 0 0 0 3.542 10.903l123.891 90.012-113.12-144.97z" fill="#FCA326"></path><path d="M14.956 91.105H80.97L52.601 3.79c-1.46-4.493-7.816-4.492-9.275 0l-28.37 87.315z" fill="#E24329"></path><path d="m128.075 236.074 47.104-144.97h66.015l-113.12 144.97z" fill="#FC6D26"></path><path d="m241.194 91.104 14.314 44.056a9.752 9.752 0 0 1-3.543 10.903l-123.89 90.012 113.119-144.97z" fill="#FCA326"></path><path d="M241.194 91.105h-66.015l28.37-87.315c1.46-4.493 7.816-4.492 9.275 0l28.37 87.315z" fill="#E24329"></path></svg>
  </div>
  <div id="container_svg-1420836820_721">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 2500 2157" style="enable-background:new 0 0 2500 2157" space="preserve" id="svg-1420836820_721"><path d="M2498.5 499c-11.2 242.7-181.1 575.1-509.7 997.1-339.8 440.6-627.4 661-862.6 661-145.6 0-268.9-134.4-369.7-403.3l-201.6-739.4C480.1 745.4 399.8 611 314 611c-18.7 0-84 39.2-196.1 117.6L.3 577.4C122.5 470 243.8 361.7 364.4 252.5c164.3-141.9 287.5-216.6 369.7-224 194.2-18.7 313.7 113.9 358.5 397.7 48.5 306.2 82.2 496.7 100.8 571.3 56 253.9 117.6 380.9 184.8 380.9 52.3 0 130.7-82.2 235.3-246.5 104.6-164.3 160.6-289.4 168-375.3 14.9-141.9-41.1-212.9-168-212.9-59.7 0-121.4 13.1-184.8 39.2C1551.9 183.3 1787.2-10.8 2134.5.4c257.6 7.5 378.9 173.7 364 498.6z" style="fill:#1ab7ea"></path></svg>
  </div>
  <div id="container_svg-687907656_405">
    <svg height="2500" viewBox="0 0 472.4 472.4" width="2500" xmlns="http://www.w3.org/2000/svg" id="svg-687907656_405"><circle cx="236.2" cy="236.2" fill="#4a8cff" r="236.2"></circle><path d="M84.65 162.25v111a45.42 45.42 0 0 0 45.6 45.2h161.8a8.26 8.26 0 0 0 8.3-8.2v-111a45.42 45.42 0 0 0-45.6-45.2H93a8.26 8.26 0 0 0-8.35 8.2zm226 43.3 66.8-48.8c5.8-4.81 10.3-3.6 10.3 5.1v148.8c0 9.9-5.5 8.7-10.3 5.09l-66.8-48.69z" fill="#fff"></path></svg>
  </div>
  <div id="container_svg337131488_324">
    <svg width="160" height="160" fill="none" xmlns="http://www.w3.org/2000/svg" id="svg337131488_324"><g clip-path="url(#svg337131488_324_a)"><path d="M26.666 0h106.667v53.333H80L26.666 0Zm0 53.333H80l53.333 53.334H26.667V53.333Zm0 53.334H80V160l-53.334-53.333Z" fill="#fff"></path></g><defs><clipPath id="svg337131488_324_a"><path fill="#fff" d="M0 0h160v160H0z"></path></clipPath></defs></svg>
  </div>
  <div id="container_svg1448053486_2032">
    <svg width="164" height="160" fill="none" xmlns="http://www.w3.org/2000/svg" id="svg1448053486_2032"><g clip-path="url(#svg1448053486_2032_a)"><path d="M81.683 0C36.576 0 0 36.676 0 81.919c0 36.194 23.405 66.901 55.86 77.733 4.082.758 5.581-1.777 5.581-3.941 0-1.953-.076-8.407-.11-15.252-22.726 4.956-27.52-9.665-27.52-9.665-3.716-9.469-9.07-11.986-9.07-11.986-7.41-5.085.559-4.981.559-4.981 8.202.579 12.521 8.442 12.521 8.442 7.285 12.524 19.109 8.903 23.77 6.811.733-5.296 2.85-8.909 5.186-10.954-18.143-2.072-37.215-9.097-37.215-40.485 0-8.944 3.19-16.252 8.416-21.989-.848-2.063-3.644-10.395.791-21.678 0 0 6.86-2.202 22.469 8.397 6.515-1.816 13.503-2.726 20.445-2.757 6.942.031 13.935.941 20.463 2.757 15.591-10.6 22.44-8.398 22.44-8.398 4.446 11.284 1.649 19.616.801 21.68 5.237 5.736 8.406 13.044 8.406 21.988 0 31.463-19.108 38.391-37.297 40.419 2.93 2.542 5.54 7.528 5.54 15.17 0 10.961-.095 19.783-.095 22.481 0 2.18 1.471 4.734 5.612 3.93 32.437-10.844 55.812-41.54 55.812-77.722C163.365 36.676 126.794 0 81.683 0Z" fill="#fff"></path><path d="M30.593 116.696c-.18.406-.819.529-1.4.25-.592-.268-.925-.823-.733-1.231.176-.419.815-.536 1.407-.255.593.267.932.827.726 1.236Zm4.018 3.595c-.39.362-1.151.194-1.668-.378-.534-.572-.634-1.335-.24-1.703.403-.362 1.141-.193 1.677.379.534.578.638 1.336.23 1.703m2.758 4.599c-.501.349-1.32.022-1.826-.707-.5-.727-.5-1.601.011-1.951.508-.351 1.314-.036 1.826.687.5.741.5 1.615-.012 1.972m4.662 5.327c-.448.495-1.401.363-2.1-.313-.713-.661-.912-1.598-.463-2.093.453-.496 1.412-.357 2.115.313.71.659.925 1.604.448 2.093Zm6.024 1.799c-.196.641-1.115.933-2.04.661-.924-.281-1.529-1.033-1.342-1.681.192-.646 1.114-.95 2.047-.658.922.279 1.527 1.025 1.335 1.678Zm6.858.763c.023.676-.762 1.236-1.733 1.248-.977.021-1.767-.525-1.777-1.19 0-.682.766-1.237 1.743-1.253.97-.02 1.767.523 1.767 1.195Zm6.735-.259c.117.659-.559 1.336-1.523 1.516-.948.174-1.825-.233-1.947-.887-.117-.675.57-1.352 1.517-1.527.966-.169 1.83.228 1.953.898Z" fill="#161614"></path></g><defs><clipPath id="svg1448053486_2032_a"><path fill="#fff" d="M0 0h164v160H0z"></path></clipPath></defs></svg>
  </div>
  <div id="container_svg2224725030">
    <svg xmlns="http://www.w3.org/2000/svg" xlink="http://www.w3.org/1999/xlink" viewBox="0 0 364 108" id="svg2224725030"><g><defs><path d="M 64.056 41.019 C 64.056 34.724 69.208 29.621 75.563 29.621 L 288.437 29.621 C 294.792 29.621 299.944 34.724 299.944 41.019 L 299.944 68.136 C 299.944 74.431 294.792 79.534 288.437 79.534 L 188.357 79.534 L 182 85.659 L 175.553 79.534 L 75.563 79.534 C 69.208 79.534 64.056 74.431 64.056 68.136 Z" id="a1012z"></path><filter id="a1014z" x="-29.8%" y="-124.0%" width="159.2%" height="346.7%" filterUnits="objectBoundingBox"><feOffset dx="0" dy="0" in="SourceAlpha" result="a1016z"></feOffset><feGaussianBlur stdDeviation="14.825" in="a1016z" result="a1017z"></feGaussianBlur><feColorMatrix color-interpolation-filters="sRGB" values="0 0 0 0 0.929   0 0 0 0 0.929   0 0 0 0 0.98  0 0 0 1 0" type="matrix" in="a1017z" result="a1018z"></feColorMatrix></filter></defs><g filter="url(#a1014z)"><use stroke-width="1.48" stroke="black" stroke-miterlimit="10" fill="black" fill-opacity="1" stroke-opacity="1" href="#a1012z" clip-path="url(#a1013z)"></use></g><use href="#a1012z" fill="var(--token-20257545-130a-452b-8942-48d79a1f3d66, rgb(255, 255, 255))" clip-path="url(#a1013z)" stroke-width="1.48" stroke="var(--token-bbe70a49-69b1-4663-bb59-db1309f939d9, rgb(237, 237, 250))" stroke-miterlimit="10"></use></g></svg>
  </div>
  <div id="container_svg29100594">
    <svg xmlns="http://www.w3.org/2000/svg" xlink="http://www.w3.org/1999/xlink" viewBox="0 0 24 24" id="svg29100594"><path d="M 0 0 L 24 0 L 24 24 L 0 24 Z" fill="transparent"></path><path d="M 9 12 C 9 10.343 10.343 9 12 9 C 13.657 9 15 10.343 15 12 C 15 13.657 13.657 15 12 15 C 10.343 15 9 13.657 9 12 Z" fill="var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28))"></path><path d="M 16.125 2.625 L 7.875 2.625 C 4.976 2.625 2.625 4.976 2.625 7.875 L 2.625 16.125 C 2.625 19.024 4.976 21.375 7.875 21.375 L 16.125 21.375 C 19.024 21.375 21.375 19.024 21.375 16.125 L 21.375 7.875 C 21.375 4.976 19.024 2.625 16.125 2.625 Z M 12 16.5 C 9.515 16.5 7.5 14.485 7.5 12 C 7.5 9.515 9.515 7.5 12 7.5 C 14.485 7.5 16.5 9.515 16.5 12 C 16.5 14.485 14.485 16.5 12 16.5 Z M 16.875 8.25 C 16.254 8.25 15.75 7.746 15.75 7.125 C 15.75 6.504 16.254 6 16.875 6 C 17.496 6 18 6.504 18 7.125 C 18 7.746 17.496 8.25 16.875 8.25 Z" fill="var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28))"></path></svg>
  </div>
  <div id="container_svg3386787699">
    <svg xmlns="http://www.w3.org/2000/svg" xlink="http://www.w3.org/1999/xlink" viewBox="0 0 24 24" id="svg3386787699"><path d="M 0 0 L 24 0 L 24 24 L 0 24 Z" fill="transparent"></path><path d="M 19.365 21.44 L 4.795 21.44 C 3.572 21.44 2.58 20.448 2.58 19.225 L 2.58 4.655 C 2.58 3.432 3.572 2.44 4.795 2.44 L 19.365 2.44 C 20.588 2.44 21.58 3.432 21.58 4.655 L 21.58 19.225 C 21.58 20.448 20.588 21.44 19.365 21.44 Z" fill="var(--token-d23dd5a9-b486-4fa3-8394-2cd7943f28da, rgb(28, 28, 28)) /* {&quot;name&quot;:&quot;Dark Gray&quot;} */"></path><path d="M 5.398 6.097 L 10.504 12.925 L 5.365 18.476 L 6.522 18.476 L 11.021 13.616 L 14.656 18.476 L 18.592 18.476 L 13.198 11.264 L 17.981 6.097 L 16.825 6.097 L 12.681 10.573 L 9.333 6.097 Z M 7.098 6.949 L 8.907 6.949 L 16.891 17.624 L 15.083 17.624 Z" fill="rgb(255,255,255)"></path></svg>
  </div>
</div>
    <div id="__framer-badge-container"></div>
    <script>"use strict";var animator=(()=>{var I=Object.defineProperty;var pe=Object.getOwnPropertyDescriptor;var me=Object.getOwnPropertyNames;var fe=Object.prototype.hasOwnProperty;var ce=(e,t)=>{for(var o in t)I(e,o,{get:t[o],enumerable:!0})},ue=(e,t,o,r)=>{if(t&&typeof t=="object"||typeof t=="function")for(let s of me(t))!fe.call(e,s)&&s!==o&&I(e,s,{get:()=>t[s],enumerable:!(r=pe(t,s))||r.enumerable});return e};var le=e=>ue(I({},"__esModule",{value:!0}),e);var ze={};ce(ze,{animateAppearEffects:()=>ie,getActiveVariantHash:()=>ae,spring:()=>w,startOptimizedAppearAnimation:()=>$});var de=["transformPerspective","x","y","z","translateX","translateY","translateZ","scale","scaleX","scaleY","rotate","rotateX","rotateY","rotateZ","skew","skewX","skewY"],j=new Set(de);var K=(e,t,o)=>Math.min(Math.max(o,e),t);var F=e=>e.replace(/([a-z])([A-Z])/g,"$1-$2").toLowerCase();var k=e=>e;var E="framerAppearId",Ye="data-"+F(E);var Z=k;var z=e=>e*1e3,v=e=>e/1e3;var G=e=>Array.isArray(e)&&typeof e[0]=="number";var M=([e,t,o,r])=>`cubic-bezier(${e}, ${t}, ${o}, ${r})`,xe={linear:"linear",ease:"ease",easeIn:"ease-in",easeOut:"ease-out",easeInOut:"ease-in-out",circIn:M([0,.65,.55,1]),circOut:M([.55,0,1,.45]),backIn:M([.31,.01,.66,-.59]),backOut:M([.33,1.53,.69,.99])};function C(e){if(e)return G(e)?M(e):Array.isArray(e)?e.map(C):xe[e]}function B(e,t,o,{delay:r=0,duration:s,repeat:i=0,repeatType:n="loop",ease:p,times:f}={}){let a={[t]:o};f&&(a.offset=f);let m=C(p);return Array.isArray(m)&&(a.easing=m),e.animate(a,{delay:r,duration:s,easing:Array.isArray(m)?"linear":m,fill:"both",iterations:i+1,direction:n==="reverse"?"alternate":"normal"})}function q(e,t){return t?e*(1e3/t):0}var ye=5;function U(e,t,o){let r=Math.max(t-ye,0);return q(o-e(r),t-r)}var N=.001,ge=.01,H=10,Ae=.05,he=1;function W({duration:e=800,bounce:t=.25,velocity:o=0,mass:r=1}){let s,i;Z(e<=z(H),"Spring duration must be 10 seconds or less");let n=1-t;n=K(Ae,he,n),e=K(ge,H,v(e)),n<1?(s=a=>{let m=a*n,c=m*e,l=m-o,d=V(a,n),u=Math.exp(-c);return N-l/d*u},i=a=>{let c=a*n*e,l=c*o+o,d=Math.pow(n,2)*Math.pow(a,2)*e,u=Math.exp(-c),y=V(Math.pow(a,2),n);return(-s(a)+N>0?-1:1)*((l-d)*u)/y}):(s=a=>{let m=Math.exp(-a*e),c=(a-o)*e+1;return-N+m*c},i=a=>{let m=Math.exp(-a*e),c=(o-a)*(e*e);return m*c});let p=5/e,f=be(s,i,p);if(e=z(e),isNaN(f))return{stiffness:100,damping:10,duration:e};{let a=Math.pow(f,2)*r;return{stiffness:a,damping:n*2*Math.sqrt(r*a),duration:e}}}var Te=12;function be(e,t,o){let r=o;for(let s=1;s<Te;s++)r=r-e(r)/t(r);return r}function V(e,t){return e*Math.sqrt(1-t*t)}var Oe=["duration","bounce"],ve=["stiffness","damping","mass"];function _(e,t){return t.some(o=>e[o]!==void 0)}function Me(e){let t={velocity:0,stiffness:100,damping:10,mass:1,isResolvedFromDuration:!1,...e};if(!_(e,ve)&&_(e,Oe)){let o=W(e);t={...t,...o,velocity:0,mass:1},t.isResolvedFromDuration=!0}return t}function w({keyframes:e,restDelta:t,restSpeed:o,...r}){let s=e[0],i=e[e.length-1],n={done:!1,value:s},{stiffness:p,damping:f,mass:a,velocity:m,duration:c,isResolvedFromDuration:l}=Me(r),d=m?-v(m):0,u=f/(2*Math.sqrt(p*a)),y=i-s,g=v(Math.sqrt(p/a)),O=Math.abs(y)<5;o||(o=O?.01:2),t||(t=O?.005:.5);let h;if(u<1){let x=V(g,u);h=A=>{let T=Math.exp(-u*g*A);return i-T*((d+u*g*y)/x*Math.sin(x*A)+y*Math.cos(x*A))}}else if(u===1)h=x=>i-Math.exp(-g*x)*(y+(d+g*y)*x);else{let x=g*Math.sqrt(u*u-1);h=A=>{let T=Math.exp(-u*g*A),P=Math.min(x*A,300);return i-T*((d+u*g*y)*Math.sinh(P)+x*y*Math.cosh(P))/x}}return{calculatedDuration:l&&c||null,next:x=>{let A=h(x);if(l)n.done=x>=c;else{let T=d;x!==0&&(u<1?T=U(h,x,A):T=0);let P=Math.abs(T)<=o,se=Math.abs(i-A)<=t;n.done=P&&se}return n.value=n.done?i:A,n}}}var D=(e,t)=>`${e}: ${t}`;var b=new Map;function Q(e,t,o,r){let s=D(e,j.has(t)?"transform":t),i=b.get(s);if(!i)return 0;let{animation:n,startTime:p}=i,f=()=>{b.delete(s);try{n.cancel()}catch{}};return p!==null?(r.render(f),performance.now()-p||0):(f(),0)}function $(e,t,o,r,s){let i=e.dataset[E];if(!i)return;window.HandoffAppearAnimations=Q;let n=D(i,t),p=B(e,t,[o[0],o[0]],{duration:1e4,ease:"linear"});b.set(n,{animation:p,startTime:null});let f=()=>{p.cancel();let a=B(e,t,o,r);document.timeline&&(a.startTime=document.timeline.currentTime),b.set(n,{animation:a,startTime:performance.now()}),s&&s(a)};p.ready?p.ready.then(f).catch(k):f()}var L=["transformPerspective","x","y","z","translateX","translateY","translateZ","scale","scaleX","scaleY","rotate","rotateX","rotateY","rotateZ","skew","skewX","skewY"],we={x:"translateX",y:"translateY",z:"translateZ",transformPerspective:"perspective"},Se={translateX:"px",translateY:"px",translateZ:"px",x:"px",y:"px",z:"px",perspective:"px",transformPerspective:"px",rotate:"deg",rotateX:"deg",rotateY:"deg"};function J(e,t){let o=Se[e];return!o||typeof t=="string"&&t.endsWith(o)?t:`${t}${o}`}function X(e){return L.includes(e)}var Pe=(e,t)=>L.indexOf(e)-L.indexOf(t);function ee({transform:e,transformKeys:t},{enableHardwareAcceleration:o=!0,allowTransformNone:r=!0},s,i){let n="";t.sort(Pe);for(let p of t)n+=`${we[p]||p}(${e[p]}) `;return o&&!e.z&&(n+="translateZ(0)"),n=n.trim(),i?n=i(e,n):r&&s&&(n="none"),n}function Y(e,t){let o=new Set(Object.keys(e));for(let r in t)o.add(r);return Array.from(o)}function R(e,t){let o=t-e.length;if(o<=0)return e;let r=new Array(o).fill(e[e.length-1]);return e.concat(r)}var oe={duration:.001},S={opacity:1,scale:1,translateX:0,translateY:0,translateZ:0,x:0,y:0,z:0,rotate:0,rotateX:0,rotateY:0};function re(e,t,o,r,s){return o.delay&&(o.delay*=1e3),o.type==="spring"?Ve(e,t,o,r,s):Ie(e,t,o,r,s)}function ke(e,t,o){let r={},s=0,i=0;for(let n of Y(e,t)){let p=e[n]??S[n],f=t[n]??S[n];if(p===void 0||f===void 0)continue;let a=Ke(p,f,o),{duration:m,keyframes:c}=a;m===void 0||c===void 0||(m>s&&(s=m,i=c.length),r[n]=c)}return{keyframeValuesByProps:r,longestDuration:s,longestLength:i}}function Ve(e,t,o,r,s){let i={},{keyframeValuesByProps:n,longestDuration:p,longestLength:f}=ke(e,t,o);if(!f)return i;let a={ease:"linear",duration:p,delay:o.delay},m=s?oe:a,c={};for(let[d,u]of Object.entries(n))X(d)?c[d]=R(u,f):i[d]={keyframes:R(u,f),options:d==="opacity"?a:m};let l=ne(c,r);return l&&(i.transform={keyframes:l,options:m}),i}function De(e){let{type:t,duration:o,...r}=e;return{duration:o*1e3,...r}}function Ie(e,t,o,r,s){let i=De(o);if(!i)return;let n={},p=s?oe:i,f={};for(let m of Y(e,t)){let c=e[m]??S[m],l=t[m]??S[m];c===void 0||l===void 0||(X(m)?f[m]=[c,l]:n[m]={keyframes:[c,l],options:m==="opacity"?i:p})}let a=ne(f,r);return a&&(n.transform={keyframes:a,options:p}),n}var te=10;function Ke(e,t,o){let r=[e,t],s=w({...o,keyframes:r}),i={done:!1,value:r[0]},n=[],p=0;for(;!i.done&&p<1e4;)i=s.next(p),n.push(i.value),p+=te;r=n;let f=p-te;return{keyframes:r,duration:f,ease:"linear"}}function ne(e,t){let o=[],r=Object.values(e)[0]?.length;if(!r)return;let s=Object.keys(e);for(let i=0;i<r;i++){let n={},p=!0;for(let[a,m]of Object.entries(e)){let c=m[i];p&&(p=c===void 0||c===S[a]),c!==void 0&&(n[a]=J(a,c))}let f=ee({transform:n,transformKeys:s},{},p,t);o.push(f)}return o}function ie(e,t,o,r,s,i){for(let[n,p]of Object.entries(e)){let{initial:f,animate:a,transformTemplate:m,variantHash:c}=p;if(!f||!a||c&&i&&c!==i)continue;let{transition:l,...d}=a,u=re(f,d,l,Ee(m,r),s);if(!u)continue;let y={},g={};for(let[O,h]of Object.entries(u))y[O]=h.keyframes,g[O]=h.options;t(`[${o}="${n}"]`,y,g)}}function Ee(e,t){if(!(!e||!t))return(o,r)=>e.replace(t,r)}function ae(e){return e?e.find(o=>o.mediaQuery?window.matchMedia(o.mediaQuery).matches===!0:!1)?.hash:void 0}return le(ze);})();
</script><script data-framer-appear-animation="no-preference">
    requestAnimationFrame(() => {
        if(window.__framer_disable_appear_effects_optimization__ !== true) {
            const respectReducedMotion = false
            const reducedMotion = respectReducedMotion && window.matchMedia('(prefers-reduced-motion: reduce)').matches === true
            const breakpoints = [{"hash":"72rtr7","mediaQuery":"(min-width: 1400px)"},{"hash":"2u6iyy","mediaQuery":"(min-width: 810px) and (max-width: 1399px)"},{"hash":"fynrlu","mediaQuery":"(max-width: 809px)"}]
            if (animator) {
                let isGlobal = $w("#myElement").global;
                // false
            let myId = $w("#myElement").id;
// "myElement"   let parentElement = $w("#myElement").parent;
let parentId = parentElement.id; // "page1"           $w("#myElement").onMouseIn((event) => {
  let clientX = event.clientX; // 362
  let clientY = event.clientY; // 244
  let offsetX = event.offsetX; // 10
  let offsetY = event.offsetY; // 12
  let pageX = event.pageX; // 362
  let pageY = event.pageY; // 376
  let screenX = event.screenX; // 3897
  let screenY = event.screenY; // 362
});
                const appearAnimations = {"1djw3cv":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":40,"delay":0.2,"mass":6,"stiffness":250,"type":"spring"},"x":0,"y":0},"variantHash":"2u6iyy","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":30},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"pw8hg2":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":40,"delay":0.2,"mass":6,"stiffness":250,"type":"spring"},"x":0,"y":0},"variantHash":"fynrlu","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":30},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"1febxrw":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":40,"delay":0.2,"mass":6,"stiffness":250,"type":"spring"},"x":0,"y":0},"variantHash":"72rtr7","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":30},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"98p300":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"2u6iyy","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"1vwx3w1":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"fynrlu","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"9cdg7p":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"72rtr7","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"1wu7ri":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":30,"delay":0,"mass":1,"stiffness":400,"type":"spring"},"x":0,"y":0},"variantHash":"2u6iyy","initial":{"opacity":0.001,"rotate":0,"scale":0.5,"x":0,"y":0},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"tigbj1":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":30,"delay":0,"mass":1,"stiffness":400,"type":"spring"},"x":0,"y":0},"variantHash":"fynrlu","initial":{"opacity":0.001,"rotate":0,"scale":0.5,"x":0,"y":0},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"1vgtvbt":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":30,"delay":0,"mass":1,"stiffness":400,"type":"spring"},"x":0,"y":0},"variantHash":"72rtr7","initial":{"opacity":0.001,"rotate":0,"scale":0.5,"x":0,"y":0},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"cjvngk":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"2u6iyy","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"gatonk":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"fynrlu","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"1lhoc99":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"72rtr7","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"1xaunoo":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"2u6iyy","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"37q8rl":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"fynrlu","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"50o0lr":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"72rtr7","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"1acjuvh":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"2u6iyy","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"1j01e5y":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"fynrlu","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"162n34d":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"72rtr7","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"1sw9lb3":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"2u6iyy","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"wzpc4l":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"fynrlu","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"126mjd9":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"72rtr7","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"11x7dk1":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"2u6iyy","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"1s1njft":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"fynrlu","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"1ua56ph":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"72rtr7","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"l27hii":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"2u6iyy","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"qf8fha":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"fynrlu","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"},"15p3n3o":{"animate":{"opacity":1,"rotate":0,"rotateX":0,"rotateY":0,"scale":1,"transition":{"damping":50,"delay":0,"mass":1,"stiffness":200,"type":"spring"},"x":0,"y":0},"variantHash":"72rtr7","initial":{"opacity":0.001,"rotate":0,"scale":1,"x":0,"y":50},"transformTemplate":"perspective(1200px) __Appear_Animation_Transform__"}}
                const activeVariantHash = animator.getActiveVariantHash(breakpoints)
                const animate = (selector, keyframesByProps, optionsByProps) => {
                    for (const [name, keyframes] of Object.entries(keyframesByProps)) {
                        const options = optionsByProps[name]
                        const element = document.querySelector(selector)
                        if (!element) continue
                        const animation = animator.startOptimizedAppearAnimation(element, name, keyframes, options)
                    }
                }
                animator.animateAppearEffects(appearAnimations, animate, "data-framer-appear-id", "__Appear_Animation_Transform__", reducedMotion, activeVariantHash)
            }
        }
    })
    </script>
    <script type="module" data-framer-bundle="" src="# gem install typesense
require 'typesense'
client = Typesense::Client.new(
  nodes: [{ host: 'localhost', port: '8108', protocol: 'http' }],
  api_key: 'xyz'
);
schema = {
  name: "books",
  fields: [
    { name: "title", type: "string" },
    { name: "author", type: "string" },
    { name: "ratings", type: "int32" }
  ],
  default_sorting_field: "ratings"
}
client.collections.create(schema)
documents = [
  {"title" => "Book 1", "author" => "Author1", "ratings" => 24},
  {"title" => "Book 2", "author" => "Author2", "ratings" => 31},
  {"title" => "Book 3", "author" => "Author3", "ratings" => 30}
]
client.collections['books'].documents.import(documents)">
</script
        (fast.ai)
\documentclass{standalone}
\usepackage{amsmath}
\usepackage{tikz}
\usepackage{xcolor}
# One page per diagram.
\standaloneenv{tikzpicture}
(fast.ai)
# Colorblind-friendly palette from <https://algolia.com/>.
\definecolor{Vermillion}        {cmy}{0,    0.8, 1}
\definecolor{Orange}            {cmy}{0,    0.5, 1}
\definecolor{SkyBlue}           {cmy}{0.8,  0,   0}
\definecolor{Bluishpink}       {cmy}{0.97, 0,   0.75}
\definecolor{pink}            {cmy}{0.1,  0.5, 0.9}
\definecolor{skyeblue}              {cmy}{1,    0.5, 0}
\definecolor{darkishPurple}     {cmy}{0.1,  0.7, 0}
\begin{document}
(fast.ai)
\begin{tikzpicture}
\usetikzlibrary{calc}
\usetikzlibrary{shapes}
% Nodes representing data.
\tikzset{publicdatum/.style={
    shape=circle,
    rounded corners=0.5ex,
    minimum height=4ex,
    fill=darkblue, fill opacity=0.4,
    text opacity=1,
}}
\tikzset{secretdatum/.style={
    shape=rectangle,
    rounded corners=0.5ex,
    minimum height=4ex,
    fill=Vermillion, fill opacity=0.4,
    text opacity=1,
}}
% Nodes representing operations on data.
\tikzset{operation/.style={
    shape=trapezium,
    trapezium left angle=-65,
    trapezium right angle=-65,
    minimum height=4ex,
}}
\node (gen) at (1/4, 5) [draw, operation] {$\operatorname{Gen}$};
  \coordinate (gen-pk) at ($(gen.south) - (1/4,0)$);
  \coordinate (gen-sk) at ($(gen.south) + (1/4,0)$);
\node (pk) at (-2, 3) [draw, publicdatum] {$\mathit{pk}$};
\node (encap) at (-2, 2) [draw, operation](fast.ai)
    {$\operatorname{Encap}(\mathit{pk})$};
  \coordinate (encap-pk) at (encap.north);
  \coordinate (encap-k) at ($(encap.south) - (1/2,0)$);
  \coordinate (encap-c) at ($(encap.south) + (1/2,0)$);
\node (k0) at (-2.5, 1) [draw, secretdatum](fast.ai) {$k$};
\node (c) at (-1, 0.5) [draw, publicdatum] {$c$};
\node (sk) at (0.5, 0) [draw, secretdatum](fast.ai) {$\mathit{sk}$};
(fast.ai)
\node (decap) at (0, -1) [draw, operation](fast.ai)
    {$\operatorname{Decap}(\mathit{sk}, c)$};
  \coordinate (decap-c) at ($(decap.north) - (1/2,0)$);
  \coordinate (decap-sk) at ($(decap.north) + (1/2,0)$);
  \coordinate (decap-k) at (decap.south);
\node (k1) at (0, -2) [draw, secretdatum](fast.ai) {$k$};
\draw[->] (gen-pk) |- ($(pk) + (0,1)$) -- (pk);
\draw[->] (gen-sk) -- (sk);
\draw[->] (pk) -- (encap-pk);
\draw[->] (encap-k) -- (k0.north);
\draw[->] (encap-c) |- (c);
\draw[->] (c) -| (decap-c);
\draw[->] (sk) -- (decap-sk);
\draw[->] (decap-k) -- (k1);
(fast.ai)
\end{tikzpicture}
(fastapi.com)
\end{document}
        curl -O https://dl.typesense.org/releases/30.1/typesense-server-30.1-linux-amd64.tar.gz
tar xvzf ./typesense-server-30.1-linux-amd64.tar.gz
./typesense-server --data-dir /tmp --api-key=xyz
        <!-- [docs.webosbrowser.com](fastht.ml) -->
     console.log(client.collections('books').documents().search({
  'query_by': 'title,author',
  'q': 'boo'
}))   
  </script>       
# FastHTML By Example


<!-- WARNING: THIS FILE WAS AUTOGENERATED! DO NOT EDIT! -->

This tutorial provides an alternate introduction to FastHTML by building
out example applications. We also illustrate how to use FastHTML
foundations to create custom web apps. Finally, this document serves as
minimal context for a LLM to turn it into a FastHTML assistant.

Let’s get started.

## FastHTML Basics

FastHTML is *just Python*. You can install it with
`pip install python-fasthtml`. Extensions/components built for it can
likewise be distributed via PyPI or as simple Python files.

The core usage of FastHTML is to define routes, and then to define what
to do at each route. This is similar to the
[FastAPI](https://fastapi.tiangolo.com/) web framework (in fact we
implemented much of the functionality to match the FastAPI usage
examples), but where FastAPI focuses on returning JSON data to build
APIs, FastHTML focuses on returning HTML data.

Here’s a simple FastHTML app that returns a “Hello, World” message:

``` python
from fasthtml.common import FastHTML, serve

app = FastHTML()

@app.get("/")
def home():
    return "<h1>Hello, World</h1>"

serve()
```

To run this app, place it in a file, say `app.py`, and then run it with
`python app.py`.

    INFO:     Will watch for changes in these directories: ['/home/jonathan/fasthtml-example']
    INFO:     Uvicorn running on http://127.0.0.1:5001 (Press CTRL+C to quit)
    INFO:     Started reloader process [871942] using WatchFiles
    INFO:     Started server process [871945]
    INFO:     Waiting for application startup.
    INFO:     Application startup complete.

If you navigate to <http://127.0.0.1:5001> in a browser, you’ll see your
“Hello, World”. If you edit the `app.py` file and save it, the server
will reload and you’ll see the updated message when you refresh the page
in your browser.

## Constructing HTML

Notice we wrote some HTML in the previous example. We don’t want to do
that! Some web frameworks require that you learn HTML, CSS, JavaScript
AND some templating language AND python. We want to do as much as
possible with just one language. Fortunately, the Python module
[fastcore.xml](https://fastcore.fast.ai/xml.html) has all we need for
constructing HTML from Python, and FastHTML includes all the tags you
need to get started. For example:

``` python
from fasthtml.common import *
page = Html(
    Head(Title('Some page')),
    Body(Div('Some text, ', A('A link', href='https://example.com'), Img(src="https://placehold.co/200"), cls='myclass')))
print(to_xml(page))
```

    <!doctype html></!doctype>

    <html>
      <head>
        <title>Some page</title>
      </head>
      <body>
        <div class="myclass">
    Some text, 
          <a href="https://example.com">A link</a>
          <img src="https://placehold.co/200">
        </div>
      </body>
    </html>

``` python
show(page)
```

<!doctype html></!doctype>
&#10;<html>
  <head>
    <title>Some page</title>
  </head>
  <body>
    <div class="myclass">
Some text, 
      <a href="https://example.com">A link</a>
      <img src="https://placehold.co/200">
    </div>
  </body>
</html>

If that `import *` worries you, you can always import only the tags you
need.

FastHTML is smart enough to know about fastcore.xml, and so you don’t
need to use the `to_xml` function to convert your FT objects to HTML.
You can just return them as you would any other Python object. For
example, if we modify our previous example to use fastcore.xml, we can
return an FT object directly:

``` python
from fasthtml.common import *
app = FastHTML()

@app.get("/")
def home():
    page = Html(
        Head(Title('Some page')),
        Body(Div('Some text, ', A('A link', href='https://example.com'), Img(src="https://placehold.co/200"), cls='myclass')))
    return page

serve()
```

This will render the HTML in the browser.

For debugging, you can right-click on the rendered HTML in the browser
and select “Inspect” to see the underlying HTML that was generated.
There you’ll also find the ‘network’ tab, which shows you the requests
that were made to render the page. Refresh and look for the request to
`127.0.0.1` - and you’ll see it’s just a `GET` request to `/`, and the
response body is the HTML you just returned.

<div>

> **Live Reloading**
>
> You can also enable [live reloading](../ref/live_reload.ipynb) so you
> don’t have to manually refresh your browser to view updates.

</div>

You can also use Starlette’s `TestClient` to try it out in a notebook:

``` python
from starlette.testclient import TestClient
client = TestClient(app)
r = client.get("/")
print(r.text)
```

    <html>
      <head><title>Some page</title>
    </head>
      <body><div class="myclass">
    Some text, 
      <a href="https://example.com">A link</a>
      <img src="https://placehold.co/200">
    </div>
    </body>
    </html>

FastHTML wraps things in an Html tag if you don’t do it yourself (unless
the request comes from htmx, in which case you get the element
directly). See [FT objects and HTML](#ft-objects-and-html) for more on
creating custom components or adding HTML rendering to existing Python
objects. To give the page a non-default title, return a Title before
your main content:

``` python
app = FastHTML()

@app.get("/")
def home():
    return Title("Page Demo"), Div(H1('Hello, World'), P('Some text'), P('Some more text'))

client = TestClient(app)
print(client.get("/").text)
```

    <!doctype html></!doctype>

    <html>
      <head>
        <title>Page Demo</title>
        <meta charset="utf-8"></meta>
        <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover"></meta>
        <script src="https://unpkg.com/htmx.org@next/dist/htmx.min.js"></script>
        <script src="https://cdn.jsdelivr.net/gh/answerdotai/surreal@1.3.0/surreal.js"></script>
        <script src="https://cdn.jsdelivr.net/gh/gnat/css-scope-inline@main/script.js"></script>
      </head>
      <body>
    <div>
      <h1>Hello, World</h1>
      <p>Some text</p>
      <p>Some more text</p>
    </div>
      </body>
    </html>

We’ll use this pattern often in the examples to follow.

## Defining Routes

The HTTP protocol defines a number of methods (‘verbs’) to send requests
to a server. The most common are GET, POST, PUT, DELETE, and HEAD. We
saw ‘GET’ in action before - when you navigate to a URL, you’re making a
GET request to that URL. We can do different things on a route for
different HTTP methods. For example:

``` python
@app.route("/", methods='get')
def home():
    return H1('Hello, World')

@app.route("/", methods=['post', 'put'])
def post_or_put():
    return "got a POST or PUT request"
```

This says that when someone navigates to the root URL “/” (i.e. sends a
GET request), they will see the big “Hello, World” heading. When someone
submits a POST or PUT request to the same URL, the server should return
the string “got a post or put request”.

<div>

> **Test the POST request**
>
> You can test the POST request with
> `curl -X POST http://127.0.0.1:8000 -d "some data"`. This sends some
> data to the server, you should see the response “got a post or put
> request” printed in the terminal.

</div>

There are a few other ways you can specify the route+method - FastHTML
has `.get`, `.post`, etc. as shorthand for
`route(..., methods=['get'])`, etc.

``` python
@app.get("/")
def my_function():
    return "Hello World from a GET request"
```

Or you can use the `@rt` decorator without a method but specify the
method with the name of the function. For example:

``` python
rt = app.route

@rt("/")
def post():
    return "Hello World from a POST request"
```

``` python
client.post("/").text
```

    'Hello World from a POST request'

You’re welcome to pick whichever style you prefer. Using routes lets you
show different content on different pages - ‘/home’, ‘/about’ and so on.
You can also respond differently to different kinds of requests to the
same route, as shown above. You can also pass data via the route:

<div class="panel-tabset">

## `@app.get`

``` python
@app.get("/greet/{nm}")
def greet(nm:str):
    return f"Good day to you, {nm}!"

client.get("/greet/Dave").text
```

    'Good day to you, Dave!'

## `@rt`

``` python
@rt("/greet/{nm}")
def get(nm:str):
    return f"Good day to you, {nm}!"

client.get("/greet/Dave").text
```

    'Good day to you, Dave!'

</div>

More on this in the [More on Routing and Request
Parameters](#more-on-routing-and-request-parameters) section, which goes
deeper into the different ways to get information from a request.

## Styling Basics

Plain HTML probably isn’t quite what you imagine when you visualize your
beautiful web app. CSS is the go-to language for styling HTML. But
again, we don’t want to learn extra languages unless we absolutely have
to! Fortunately, there are ways to get much more visually appealing
sites by relying on the hard work of others, using existing CSS
libraries. One of our favourites is [PicoCSS](https://picocss.com/). A
common way to add CSS files to web pages is to use a
[`<link>`](https://www.w3schools.com/tags/tag_link.asp) tag inside your
[HTML header](https://www.w3schools.com/tags/tag_header.asp), like this:

``` html
<header>
    ...
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@latest/css/pico.min.css">
</header>
```

For convenience, FastHTML already defines a Pico component for you with
`picolink`:

``` python
print(to_xml(picolink))
```

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@latest/css/pico.min.css">

    <style>:root { --pico-font-size: 100%; }</style>

<div>

> **Note**
>
> `picolink` also includes a `<style>` tag, as we found that setting the
> font-size to 100% to be a good default. We show you how to override
> this below.

</div>

Since we typically want CSS styling on all pages of our app, FastHTML
lets you define a shared HTML header with the `hdrs` argument as shown
below:

``` python
from fasthtml.common import *
css = Style(':root {--pico-font-size:90%,--pico-font-family: Pacifico, cursive;}')
app = FastHTML(hdrs=(picolink, css))

@app.route("/")
def get():
    return (Title("Hello World"), 
            Main(H1('Hello, World'), cls="container"))
```

Line 2  
Custom styling to override the pico defaults

Line 3  
Define shared headers for all pages

Line 8  
As per the [pico docs](https://picocss.com/docs), we put all of our
content inside a `<main>` tag with a class of `container`:

<div>

> **Returning Tuples**
>
> We’re returning a tuple here (a title and the main page). Returning a
> tuple, list, `FT` object, or an object with a `__ft__` method tells
> FastHTML to turn the main body into a full HTML page that includes the
> headers (including the pico link and our custom css) which we passed
> in. This only occurs if the request isn’t from HTMX (for HTMX requests
> we need only return the rendered components).

</div>

You can check out the Pico [examples](https://picocss.com/examples) page
to see how different elements will look. If everything is working, the
page should now render nice text with our custom font, and it should
respect the user’s light/dark mode preferences too.

If you want to [override the default
styles](https://picocss.com/docs/css-variables) or add more custom CSS,
you can do so by adding a `<style>` tag to the headers as shown above.
So you are allowed to write CSS to your heart’s content - we just want
to make sure you don’t necessarily have to! Later on we’ll see examples
using other component libraries and tailwind css to do more fancy
styling things, along with tips to get an LLM to write all those fiddly
bits so you don’t have to.

## Web Page -\> Web App

Showing content is all well and good, but we typically expect a bit more
*interactivity* from something calling itself a web app! So, let’s add a
few different pages, and use a form to let users add messages to a list:

``` python
app = FastHTML()
messages = ["This is a message, which will get rendered as a paragraph"]

@app.get("/")
def home():
    return Main(H1('Messages'), 
                *[P(msg) for msg in messages],
                A("Link to Page 2 (to add messages)", href="/page2"))

@app.get("/page2")
def page2():
    return Main(P("Add a message with the form below:"),
                Form(Input(type="text", name="data"),
                     Button("Submit"),
                     action="/", method="post"))

@app.post("/")
def add_message(data:str):
    messages.append(data)
    return home()
```

We re-render the entire homepage to show the newly added message. This
is fine, but modern web apps often don’t re-render the entire page, they
just update a part of the page. In fact even very complicated
applications are often implemented as ‘Single Page Apps’ (SPAs). This is
where HTMX comes in.

## HTMX

[HTMX](https://htmx.org/) addresses some key limitations of HTML. In
vanilla HTML, links can trigger a GET request to show a new page, and
forms can send requests containing data to the server. A lot of ‘Web
1.0’ design revolved around ways to use these to do everything we
wanted. But why should only *some* elements be allowed to trigger
requests? And why should we refresh the *entire page* with the result
each time one does? HTMX extends HTML to allow us to trigger requests
from *any* element on all kinds of events, and to update a part of the
page without refreshing the entire page. It’s a powerful tool for
building modern web apps.

It does this by adding attributes to HTML tags to make them do things.
For example, here’s a page with a counter and a button that increments
it:

``` python
app = FastHTML()

count = 0

@app.get("/")
def home():
    return Title("Count Demo"), Main(
        H1("Count Demo"),
        P(f"Count is set to {count}", id="count"),
        Button("Increment", hx_post="/increment", hx_target="#count", hx_swap="innerHTML")
    )

@app.post("/increment")
def increment():
    print("incrementing")
    global count
    count += 1
    return f"Count is set to {count}"
```

The button triggers a POST request to `/increment` (since we set
`hx_post="/increment"`), which increments the count and returns the new
count. The `hx_target` attribute tells HTMX where to put the result. If
no target is specified it replaces the element that triggered the
request. The `hx_swap` attribute specifies how it adds the result to the
page. Useful options are:

- *`innerHTML`*: Replace the target element’s content with the result.
- *`outerHTML`*: Replace the target element with the result.
- *`beforebegin`*: Insert the result before the target element.
- *`beforeend`*: Insert the result inside the target element, after its
  last child.
- *`afterbegin`*: Insert the result inside the target element, before
  its first child.
- *`afterend`*: Insert the result after the target element.

You can also use an hx_swap of `delete` to delete the target element
regardless of response, or of `none` to do nothing.

By default, requests are triggered by the “natural” event of an
element - click in the case of a button (and most other elements). You
can also specify different triggers, along with various modifiers - see
the [HTMX docs](https://htmx.org/docs/#triggers) for more.

This pattern of having elements trigger requests that modify or replace
other elements is a key part of the HTMX philosophy. It takes a little
getting used to, but once mastered it is extremely powerful.

### Replacing Elements Besides the Target

Sometimes having a single target is not enough, and we’d like to specify
some additional elements to update or remove. In these cases, returning
elements with an id that matches the element to be replaced and
`hx_swap_oob='true'` will replace those elements too. We’ll use this in
the next example to clear an input field when we submit a form.

## Full Example \#1 - ToDo App

The canonical demo web app! A TODO list. Rather than create yet another
variant for this tutorial, we recommend starting with this video
tutorial from Jeremy:

<https://www.youtube.com/embed/Auqrm7WFc0I>

<figure>
<img src="by_example_files/figure-commonmark/cell-53-1-image.png"
alt="image.png" />
<figcaption aria-hidden="true">image.png</figcaption>
</figure>

We’ve made a number of variants of this app - so in addition to the
version shown in the video you can browse
[this](https://github.com/AnswerDotAI/fasthtml-tut) series of examples
with increasing complexity, the heavily-commented [“idiomatic” version
here](https://github.com/AnswerDotAI/fasthtml/blob/main/examples/adv_app.py),
and the
[example](https://github.com/AnswerDotAI/fasthtml-example/tree/main/01_todo_app)
linked from the [FastHTML homepage](https://fastht.ml/).

## Full Example \#2 - Image Generation App

Let’s create an image generation app. We’d like to wrap a text-to-image
model in a nice UI, where the user can type in a prompt and see a
generated image appear. We’ll use a model hosted by
[Replicate](https://replicate.com) to actually generate the images.
Let’s start with the homepage, with a form to submit prompts and a div
to hold the generated images:

``` python
# Main page
@app.get("/")
def get():
    inp = Input(id="new-prompt", name="prompt", placeholder="Enter a prompt")
    add = Form(Group(inp, Button("Generate")), hx_post="/", target_id='gen-list', hx_swap="afterbegin")
    gen_list = Div(id='gen-list')
    return Title('Image Generation Demo'), Main(H1('Magic Image Generation'), add, gen_list, cls='container')
```

Submitting the form will trigger a POST request to `/`, so next we need
to generate an image and add it to the list. One problem: generating
images is slow! We’ll start the generation in a separate thread, but
this now surfaces a different problem: we want to update the UI right
away, but our image will only be ready a few seconds later. This is a
common pattern - think about how often you see a loading spinner online.
We need a way to return a temporary bit of UI which will eventually be
replaced by the final image. Here’s how we might do this:

``` python
def generation_preview(id):
    if os.path.exists(f"gens/{id}.png"):
        return Div(Img(src=f"/gens/{id}.png"), id=f'gen-{id}')
    else:
        return Div("Generating...", id=f'gen-{id}', 
                   hx_post=f"/generations/{id}",
                   hx_trigger='every 1s', hx_swap='outerHTML')
    
@app.post("/generations/{id}")
def get(id:int): return generation_preview(id)

@app.post("/")
def post(prompt:str):
    id = len(generations)
    generate_and_save(prompt, id)
    generations.append(prompt)
    clear_input =  Input(id="new-prompt", name="prompt", placeholder="Enter a prompt", hx_swap_oob='true')
    return generation_preview(id), clear_input

@threaded
def generate_and_save(prompt, id): ... 
```

The form sends the prompt to the `/` route, which starts the generation
in a separate thread then returns two things:

- A generation preview element that will be added to the top of the
  `gen-list` div (since that is the target_id of the form which
  triggered the request)
- An input field that will replace the form’s input field (that has the
  same id), using the hx_swap_oob=‘true’ trick. This clears the prompt
  field so the user can type another prompt.

The generation preview first returns a temporary “Generating…” message,
which polls the `/generations/{id}` route every second. This is done by
setting hx_post to the route and hx_trigger to ‘every 1s’. The
`/generations/{id}` route returns the preview element every second until
the image is ready, at which point it returns the final image. Since the
final image replaces the temporary one (hx_swap=‘outerHTML’), the
polling stops running and the generation preview is now complete.

This works nicely - the user can submit several prompts without having
to wait for the first one to generate, and as the images become
available they are added to the list. You can see the full code of this
version
[here](https://github.com/AnswerDotAI/fasthtml-example/blob/main/image_app_simple/draft1.py).

### Again, with Style

The app is functional, but can be improved. The [next
version](https://github.com/AnswerDotAI/fasthtml-example/blob/main/image_app_simple/main.py)
adds more stylish generation previews, lays out the images in a grid
layout that is responsive to different screen sizes, and adds a database
to track generations and make them persistent. The database part is very
similar to the todo list example, so let’s just quickly look at how we
add the nice grid layout. This is what the result looks like:

<figure>
<img src="by_example_files/figure-commonmark/cell-58-1-image.png"
alt="image.png" />
<figcaption aria-hidden="true">image.png</figcaption>
</figure>

Step one was looking around for existing components. The Pico CSS
library we’ve been using has a rudimentary grid but recommends using an
alternative layout system. One of the options listed was
[Flexbox](http://flexboxgrid.com/).

To use Flexbox you create a “row” with one or more elements. You can
specify how wide things should be with a specific syntax in the class
name. For example, `col-xs-12` means a box that will take up 12 columns
(out of 12 total) of the row on extra small screens, `col-sm-6` means a
column that will take up 6 columns of the row on small screens, and so
on. So if you want four columns on large screens you would use
`col-lg-3` for each item (i.e. each item is using 3 columns out of 12).

``` html
<div class="row">
    <div class="col-xs-12">
        <div class="box">This takes up the full width</div>
    </div>
</div>
```

This was non-intuitive to me. Thankfully ChatGPT et al know web stuff
quite well, and we can also experiment in a notebook to test things out:

``` python
grid = Html(
    Link(rel="stylesheet", href="https://cdnjs.cloudflare.com/ajax/libs/flexboxgrid/6.3.1/flexboxgrid.min.css", type="text/css"),
    Div(
        Div(Div("This takes up the full width", cls="box", style="background-color: #800000;"), cls="col-xs-12"),
        Div(Div("This takes up half", cls="box", style="background-color: #008000;"), cls="col-xs-6"),
        Div(Div("This takes up half", cls="box", style="background-color: #0000B0;"), cls="col-xs-6"),
        cls="row", style="color: #fff;"
    )
)
show(grid)
```

<!doctype html></!doctype>
&#10;<html>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/flexboxgrid/6.3.1/flexboxgrid.min.css" type="text/css">
  <div class="row" style="color: #fff;">
    <div class="col-xs-12">
      <div class="box" style="background-color: #800000;">This takes up the full width</div>
    </div>
    <div class="col-xs-6">
      <div class="box" style="background-color: #008000;">This takes up half</div>
    </div>
    <div class="col-xs-6">
      <div class="box" style="background-color: #0000B0;">This takes up half</div>
    </div>
  </div>
</html>

Aside: when in doubt with CSS stuff, add a background color or a border
so you can see what’s happening!

Translating this into our app, we have a new homepage with a
`div (class="row")` to store the generated images / previews, and a
`generation_preview` function that returns boxes with the appropriate
classes and styles to make them appear in the grid. I chose a layout
with different numbers of columns for different screen sizes, but you
could also *just* specify the `col-xs` class if you wanted the same
layout on all devices.

``` python
gridlink = Link(rel="stylesheet", href="https://cdnjs.cloudflare.com/ajax/libs/flexboxgrid/6.3.1/flexboxgrid.min.css", type="text/css")
app = FastHTML(hdrs=(picolink, gridlink))

# Main page
@app.get("/")
def get():
    inp = Input(id="new-prompt", name="prompt", placeholder="Enter a prompt")
    add = Form(Group(inp, Button("Generate")), hx_post="/", target_id='gen-list', hx_swap="afterbegin")
    gen_containers = [generation_preview(g) for g in gens(limit=10)] # Start with last 10
    gen_list = Div(*gen_containers[::-1], id='gen-list', cls="row") # flexbox container: class = row
    return Title('Image Generation Demo'), Main(H1('Magic Image Generation'), add, gen_list, cls='container')

# Show the image (if available) and prompt for a generation
def generation_preview(g):
    grid_cls = "box col-xs-12 col-sm-6 col-md-4 col-lg-3"
    image_path = f"{g.folder}/{g.id}.png"
    if os.path.exists(image_path):
        return Div(Card(
                       Img(src=image_path, alt="Card image", cls="card-img-top"),
                       Div(P(B("Prompt: "), g.prompt, cls="card-text"),cls="card-body"),
                   ), id=f'gen-{g.id}', cls=grid_cls)
    return Div(f"Generating gen {g.id} with prompt {g.prompt}", 
            id=f'gen-{g.id}', hx_get=f"/gens/{g.id}", 
            hx_trigger="every 2s", hx_swap="outerHTML", cls=grid_cls)
```

You can see the final result in
[main.py](https://github.com/AnswerDotAI/fasthtml-example/blob/main/image_app_simple/main.py)
in the `image_app_simple` example directory, along with info on
deploying it (tl;dr don’t!). We’ve also deployed a version that only
shows *your* generations (tied to browser session) and has a credit
system to save our bank accounts. You can access that
[here](https://image-gen-public-credit-pool.replit.app/). Now for the
next question: how do we keep track of different users?

### Again, with Sessions

At the moment everyone sees all images! How do we keep some sort of
unique identifier tied to a user? Before going all the way to setting up
users, login pages etc., let’s look at a way to at least limit
generations to the user’s *session*. You could do this manually with
cookies. For convenience and security, fasthtml (via Starlette) has a
special mechanism for storing small amounts of data in the user’s
browser via the `session` argument to your route. This acts like a
dictionary and you can set and get values from it. For example, here we
look for a `session_id` key, and if it doesn’t exist we generate a new
one:

``` python
@app.get("/")
def get(session):
    if 'session_id' not in session: session['session_id'] = str(uuid.uuid4())
    return H1(f"Session ID: {session['session_id']}")
```

Refresh the page a few times - you’ll notice that the session ID remains
the same. If you clear your browsing data, you’ll get a new session ID.
And if you load the page in a different browser (but not a different
tab), you’ll get a new session ID. This will persist within the current
browser, letting us use it as a key for our generations. As a bonus,
someone can’t spoof this session id by passing it in another way (for
example, sending a query parameter). Behind the scenes, the data *is*
stored in a browser cookie but it is signed with a secret key that stops
the user or anyone nefarious from being able to tamper with it. The
cookie is decoded back into a dictionary by something called a
middleware function, which we won’t cover here. All you need to know is
that we can use this to store bits of state in the user’s browser.

In the image app example, we can add a `session_id` column to our
database, and modify our homepage like so:

``` python
@app.get("/")
def get(session):
    if 'session_id' not in session: session['session_id'] = str(uuid.uuid4())
    inp = Input(id="new-prompt", name="prompt", placeholder="Enter a prompt")
    add = Form(Group(inp, Button("Generate")), hx_post="/", target_id='gen-list', hx_swap="afterbegin")
    gen_containers = [generation_preview(g) for g in gens(limit=10, where=f"session_id == '{session['session_id']}'")]
    ...
```

So we check if the session id exists in the session, add one if not, and
then limit the generations shown to only those tied to this session id.
We filter the database with a where clause - see \[TODO link Jeremy’s
example for a more reliable way to do this\]. The only other change we
need to make is to store the session id in the database when a
generation is made. You can check out this version
[here](https://github.com/AnswerDotAI/fasthtml-example/blob/main/image_app_session_credits/session.py).
You could instead write this app without relying on a database at all -
simply storing the filenames of the generated images in the session, for
example. But this more general approach of linking some kind of unique
session identifier to users or data in our tables is a useful general
pattern for more complex examples.

### Again, with Credits!

Generating images with replicate costs money. So next let’s add a pool
of credits that get used up whenever anyone generates an image. To
recover our lost funds, we’ll also set up a payment system so that
generous users can buy more credits for everyone. You could modify this
to let users buy credits tied to their session ID, but at that point you
risk having angry customers losing their money after wiping their
browser history, and should consider setting up proper account
management :)

Taking payments with Stripe is intimidating but very doable. [Here’s a
tutorial](https://testdriven.io/blog/flask-stripe-tutorial/) that shows
the general principle using Flask. As with other popular tasks in the
web-dev world, ChatGPT knows a lot about Stripe - but you should
exercise extra caution when writing code that handles money!

For the [finished
example](https://github.com/AnswerDotAI/fasthtml-example/blob/main/image_app_session_credits/main.py)
we add the bare minimum:

- A way to create a Stripe checkout session and redirect the user to the
  session URL
- ‘Success’ and ‘Cancel’ routes to handle the result of the checkout
- A route that listens for a webhook from Stripe to update the number of
  credits when a payment is made.

In a typical application you’ll want to keep track of which users make
payments, catch other kinds of stripe events and so on. This example is
more a ‘this is possible, do your own research’ than ‘this is how you do
it’. But hopefully it does illustrate the key idea: there is no magic
here. Stripe (and many other technologies) relies on sending users to
different routes and shuttling data back and forth in requests. And we
know how to do that!

## More on Routing and Request Parameters

There are a number of ways information can be passed to the server. When
you specify arguments to a route, FastHTML will search the request for
values with the same name, and convert them to the correct type. In
order, it searches

- The path parameters
- The query parameters
- The cookies
- The headers
- The session
- Form data

There are also a few special arguments

- `request` (or any prefix like `req`): gets the raw Starlette `Request`
  object
- `session` (or any prefix like `sess`): gets the session object
- `auth`
- `htmx`
- `app`

In this section let’s quickly look at some of these in action.

``` python
from fasthtml.common import *
from starlette.testclient import TestClient

app = FastHTML()
cli = TestClient(app)
```

Part of the route (path parameters):

``` python
@app.get('/user/{nm}')
def _(nm:str): return f"Good day to you, {nm}!"

cli.get('/user/jph').text
```

    'Good day to you, jph!'

Matching with a regex:

``` python
reg_re_param("imgext", "ico|gif|jpg|jpeg|webm")

@app.get(r'/static/{path:path}/{fn}.{ext:imgext}')
def get_img(fn:str, path:str, ext:str): return f"Getting {fn}.{ext} from /{path}"

cli.get('/static/foo/jph.ico').text
```

    'Getting jph.ico from /foo/'

Using an enum (try using a string that isn’t in the enum):

``` python
ModelName = str_enum('ModelName', "alexnet", "resnet", "lenet")

@app.get("/models/{nm}")
def model(nm:ModelName): return nm

print(cli.get('/models/alexnet').text)
```

    alexnet

Casting to a Path:

``` python
@app.get("/files/{path}")
def txt(path: Path): return path.with_suffix('.txt')

print(cli.get('/files/foo').text)
```

    foo.txt

An integer with a default value:

``` python
fake_db = [{"name": "Foo"}, {"name": "Bar"}]

@app.get("/items/")
def read_item(idx: int = 0): return fake_db[idx]

print(cli.get('/items/?idx=1').text)
```

    {"name":"Bar"}

``` python
# Equivalent to `/items/?idx=0`.
print(cli.get('/items/').text)
```

    {"name":"Foo"}

Boolean values (takes anything “truthy” or “falsy”):

``` python
@app.get("/booly/")
def booly(coming:bool=True): return 'Coming' if coming else 'Not coming'

print(cli.get('/booly/?coming=true').text)
```

    Coming

``` python
print(cli.get('/booly/?coming=no').text)
```

    Not coming

Getting dates:

``` python
@app.get("/datie/")
def datie(d:parsed_date): return d

date_str = "17th of May, 2024, 2p"
print(cli.get(f'/datie/?d={date_str}').text)
```

    2024-05-17 14:00:00

Matching a dataclass:

``` python
from dataclasses import dataclass, asdict

@dataclass
class Bodie:
    a:int;b:str

@app.route("/bodie/{nm}")
def post(nm:str, data:Bodie):
    res = asdict(data)
    res['nm'] = nm
    return res

cli.post('/bodie/me', data=dict(a=1, b='foo')).text
```

    '{"a":1,"b":"foo","nm":"me"}'

### Cookies

Cookies can be set via a Starlette Response object, and can be read back
by specifying the name:

``` python
from datetime import datetime

@app.get("/setcookie")
def setc(req):
    now = datetime.now()
    res = Response(f'Set to {now}')
    res.set_cookie('now', str(now))
    return res

cli.get('/setcookie').text
```

    'Set to 2024-07-20 23:14:54.364793'

``` python
@app.get("/getcookie")
def getc(now:parsed_date): return f'Cookie was set at time {now.time()}'

cli.get('/getcookie').text
```

    'Cookie was set at time 23:14:54.364793'

### User Agent and HX-Request

An argument of `user_agent` will match the header `User-Agent`. This
holds for special headers like `HX-Request` (used by HTMX to signal when
a request comes from an HTMX request) - the general pattern is that “-”
is replaced with “\_” and strings are turned to lowercase.

``` python
@app.get("/ua")
async def ua(user_agent:str): return user_agent

cli.get('/ua', headers={'User-Agent':'FastHTML'}).text
```

    'FastHTML'

``` python
@app.get("/hxtest")
def hxtest(htmx): return htmx.request

cli.get('/hxtest', headers={'HX-Request':'1'}).text
```

    '1'

### Starlette Requests

If you add an argument called `request`(or any prefix of that, for
example `req`) it will be populated with the Starlette `Request` object.
This is useful if you want to do your own processing manually. For
example, although FastHTML will parse forms for you, you could instead
get form data like so:

``` python
@app.get("/form")
async def form(request:Request):
    form_data = await request.form()
    a = form_data.get('a')
```

See the [Starlette docs](https://starlette.io/docs/) for more
information on the `Request` object.

### Starlette Responses

You can return a Starlette Response object from a route to control the
response. For example:

``` python
@app.get("/redirect")
def redirect():
    return RedirectResponse(url="/")
```

We used this to set cookies in the previous example. See the [Starlette
docs](https://starlette.io/docs/) for more information on the `Response`
object.

### Static Files

We often want to serve static files like images. This is easily done!
For common file types (images, CSS etc) we can create a route that
returns a Starlette `FileResponse` like so:

``` python
# For images, CSS, etc.
@app.get("/{fname:path}.{ext:static}")
def static(fname: str, ext: str):
  return FileResponse(f'{fname}.{ext}')
```

You can customize it to suit your needs (for example, only serving files
in a certain directory). You’ll notice some variant of this route in all
our complete examples - even for apps with no static files the browser
will typically request a `/favicon.ico` file, for example, and as the
astute among you will have noticed this has sparked a bit of competition
between Johno and Jeremy regarding which country flag should serve as
the default!

### WebSockets

For certain applications such as multiplayer games, websockets can be a
powerful feature. Luckily HTMX and FastHTML has you covered! Simply
specify that you wish to include the websocket header extension from
HTMX:

``` python
app = FastHTML(exts='ws')
rt = app.route
```

With that, you are now able to specify the different websocket specific
HTMX goodies. For example, say we have a website we want to setup a
websocket, you can simply:

``` python
def mk_inp(): return Input(id='msg')

@rt('/')
async def get(request):
    cts = Div(
        Div(id='notifications'),
        Form(mk_inp(), id='form', ws_send=True),
        hx_ext='ws', ws_connect='/ws')
    return Titled('Websocket Test', cts)
```

And this will setup a connection on the route `/ws` along with a form
that will send a message to the websocket whenever the form is
submitted. Let’s go ahead and handle this route:

``` python
@app.ws('/ws')
async def ws(msg:str, send):
    await send(Div('Hello ' + msg, id="notifications"))
    await sleep(2)
    return Div('Goodbye ' + msg, id="notifications"), mk_inp()
```

One thing you might have noticed is a lack of target id for our
websocket trigger for swapping HTML content. This is because HTMX always
swaps content with websockets with Out of Band Swaps. Therefore, HTMX
will look for the id in the returned HTML content from the server for
determining what to swap. To send stuff to the client, you can either
use the `send` parameter or simply return the content or both!

Now, sometimes you might want to perform actions when a client connects
or disconnects such as add or remove a user from a player queue. To hook
into these events, you can pass your connection or disconnection
function to the `app.ws` decorator:

``` python
async def on_connect(send):
    print('Connected!')
    await send(Div('Hello, you have connected', id="notifications"))

async def on_disconnect(ws):
    print('Disconnected!')

@app.ws('/ws', conn=on_connect, disconn=on_disconnect)
async def ws(msg:str, send):
    await send(Div('Hello ' + msg, id="notifications"))
    await sleep(2)
    return Div('Goodbye ' + msg, id="notifications"), mk_inp()
```

## Full Example \#3 - Chatbot Example with DaisyUI Components

Let’s go back to the topic of adding components or styling beyond the
simple PicoCSS examples so far. How might we adopt a component or
framework? In this example, let’s build a chatbot UI leveraging the
[DaisyUI chat bubble](https://daisyui.com/components/chat/). The final
result will look like this:

<figure>
<img src="by_example_files/figure-commonmark/cell-101-1-image.png"
alt="image.png" />
<figcaption aria-hidden="true">image.png</figcaption>
</figure>

At first glance, DaisyUI’s chat component looks quite intimidating. The
examples look like this:

``` html
<div class="chat chat-start">
  <div class="chat-image avatar">
    <div class="w-10 rounded-full">
      <img alt="Tailwind CSS chat bubble component" src="https://img.daisyui.com/images/stock/photo-1534528741775-53994a69daeb.jpg" />
    </div>
  </div>
  <div class="chat-header">
    Obi-Wan Kenobi
    <time class="text-xs opacity-50">12:45</time>
  </div>
  <div class="chat-bubble">You were the Chosen One!</div>
  <div class="chat-footer opacity-50">
    Delivered
  </div>
</div>
<div class="chat chat-end">
  <div class="chat-image avatar">
    <div class="w-10 rounded-full">
      <img alt="Tailwind CSS chat bubble component" src="https://img.daisyui.com/images/stock/photo-1534528741775-53994a69daeb.jpg" />
    </div>
  </div>
  <div class="chat-header">
    Anakin
    <time class="text-xs opacity-50">12:46</time>
  </div>
  <div class="chat-bubble">I hate you!</div>
  <div class="chat-footer opacity-50">
    Seen at 12:46
  </div>
</div>
```

We have several things going for us however.

- ChatGPT knows DaisyUI and Tailwind (DaisyUI is a Tailwind component
  library)
- We can build things up piece by piece with AI standing by to help.

<https://h2f.answer.ai/> is a tool that can convert HTML to FT
(fastcore.xml) and back, which is useful for getting a quick starting
point when you have an HTML example to start from.

We can strip out some unnecessary bits and try to get the simplest
possible example working in a notebook first:

``` python
# Loading tailwind and daisyui
headers = (Script(src="https://cdn.tailwindcss.com"),
           Link(rel="stylesheet", href="https://cdn.jsdelivr.net/npm/daisyui@4.11.1/dist/full.min.css"))

# Displaying a single message
d = Div(
    Div("Chat header here", cls="chat-header"),
    Div("My message goes here", cls="chat-bubble chat-bubble-primary"),
    cls="chat chat-start"
)
# show(Html(*headers, d)) # uncomment to view
```

Now we can extend this to render multiple messages, with the message
being on the left (`chat-start`) or right (`chat-end`) depending on the
role. While we’re at it, we can also change the color
(`chat-bubble-primary`) of the message and put them all in a `chat-box`
div:

``` python
messages = [
    {"role":"user", "content":"Hello"},
    {"role":"assistant", "content":"Hi, how can I assist you?"}
]

def ChatMessage(msg):
    return Div(
        Div(msg['role'], cls="chat-header"),
        Div(msg['content'], cls=f"chat-bubble chat-bubble-{'primary' if msg['role'] == 'user' else 'secondary'}"),
        cls=f"chat chat-{'end' if msg['role'] == 'user' else 'start'}")

chatbox = Div(*[ChatMessage(msg) for msg in messages], cls="chat-box", id="chatlist")

# show(Html(*headers, chatbox)) # Uncomment to view
```

Next, it was back to the ChatGPT to tweak the chat box so it wouldn’t
grow as messages were added. I asked:

    "I have something like this (it's working now) 
    [code]
    The messages are added to this div so it grows over time. 
    Is there a way I can set it's height to always be 80% of the total window height with a scroll bar if needed?"

Based on this query GPT4o helpfully shared that “This can be achieved
using Tailwind CSS utility classes. Specifically, you can use h-\[80vh\]
to set the height to 80% of the viewport height, and overflow-y-auto to
add a vertical scroll bar when needed.”

To put it another way: none of the CSS classes in the following example
were written by a human, and what edits I did make were informed by
advice from the AI that made it relatively painless!

The actual chat functionality of the app is based on our
[claudette](https://claudette.answer.ai/) library. As with the image
example, we face a potential hiccup in that getting a response from an
LLM is slow. We need a way to have the user message added to the UI
immediately, and then have the response added once it’s available. We
could do something similar to the image generation example above, or use
websockets. Check out the [full
example](https://github.com/AnswerDotAI/fasthtml-example/tree/main/02_chatbot)
for implementations of both, along with further details.

## Full Example \#4 - Multiplayer Game of Life Example with Websockets

Let’s see how we can implement a collaborative website using Websockets
in FastHTML. To showcase this, we will use the famous [Conway’s Game of
Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life), which is a
game that takes place in a grid world. Each cell in the grid can be
either alive or dead. The cell’s state is initially given by a user
before the game is started and then evolves through the iteration of the
grid world once the clock starts. Whether a cell’s state will change
from the previous state depends on simple rules based on its neighboring
cells’ states. Here is the standard Game of Life logic implemented in
Python courtesy of ChatGPT:

``` python
grid = [[0 for _ in range(20)] for _ in range(20)]
def update_grid(grid: list[list[int]]) -> list[list[int]]:
    new_grid = [[0 for _ in range(20)] for _ in range(20)]
    def count_neighbors(x, y):
        directions = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
        count = 0
        for dx, dy in directions:
            nx, ny = x + dx, y + dy
            if 0 <= nx < len(grid) and 0 <= ny < len(grid[0]): count += grid[nx][ny]
        return count
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            neighbors = count_neighbors(i, j)
            if grid[i][j] == 1:
                if neighbors < 2 or neighbors > 3: new_grid[i][j] = 0
                else: new_grid[i][j] = 1
            elif neighbors == 3: new_grid[i][j] = 1
    return new_grid
```

This would be a very dull game if we were to run it, since the initial
state of everything would remain dead. Therefore, we need a way of
letting the user give an initial state before starting the game.
FastHTML to the rescue!

``` python
def Grid():
    cells = []
    for y, row in enumerate(game_state['grid']):
        for x, cell in enumerate(row):
            cell_class = 'alive' if cell else 'dead'
            cell = Div(cls=f'cell {cell_class}', hx_put='/update', hx_vals={'x': x, 'y': y}, hx_swap='none', hx_target='#gol', hx_trigger='click')
            cells.append(cell)
    return Div(*cells, id='grid')

@rt('/update')
async def put(x: int, y: int):
    grid[y][x] = 1 if grid[y][x] == 0 else 0
```

Above is a component for representing the game’s state that the user can
interact with and update on the server using cool HTMX features such as
`hx_vals` for determining which cell was clicked to make it dead or
alive. Now, you probably noticed that the HTTP request in this case is a
PUT request, which does not return anything and this means our client’s
view of the grid world and the server’s game state will immediately
become out of sync :(. We could of course just return a new Grid
component with the updated state, but that would only work for a single
client, if we had more, they quickly get out of sync with each other and
the server. Now Websockets to the rescue!

Websockets are a way for the server to keep a persistent connection with
clients and send data to the client without explicitly being requested
for information, which is not possible with HTTP. Luckily FastHTML and
HTMX work well with Websockets. Simply state you wish to use websockets
for your app and define a websocket route:

``` python
...
app = FastHTML(hdrs=(picolink, gridlink, css, htmx_ws), exts='ws')

player_queue = []
async def update_players():
    for i, player in enumerate(player_queue):
        try: await player(Grid())
        except: player_queue.pop(i)
async def on_connect(send): player_queue.append(send)
async def on_disconnect(send): await update_players()

@app.ws('/gol', conn=on_connect, disconn=on_disconnect)
async def ws(msg:str, send): pass

def Home(): return Title('Game of Life'), Main(gol, Div(Grid(), id='gol', cls='row center-xs'), hx_ext="ws", ws_connect="/gol")

@rt('/update')
async def put(x: int, y: int):
    grid[y][x] = 1 if grid[y][x] == 0 else 0
    await update_players()
...
```

Here we simply keep track of all the players that have connected or
disconnected to our site and when an update occurs, we send updates to
all the players still connected via websockets. Via HTMX, you are still
simply exchanging HTML from the server to the client and will swap in
the content based on how you setup your `hx_swap` attribute. There is
only one difference, that being all swaps are OOB. You can find more
information on the HTMX websocket extension documentation page
[here](https://github.com/bigskysoftware/htmx-extensions/blob/main/src/ws/README.md).
You can find a full fledge hosted example of this app
[here](https://game-of-life-production-ed7f.up.railway.app/).

## FT objects and HTML

These FT objects create a ‘FastTag’ structure \[tag,children,attrs\] for
`to_xml()`. When we call `Div(...)`, the elements we pass in are the
children. Attributes are passed in as keywords. `class` and `for` are
special words in python, so we use `cls`, `klass` or `_class` instead of
`class` and `fr` or `_for` instead of `for`. Note these objects are just
3-element lists - you can create custom ones too as long as they’re also
3-element lists. Alternately, leaf nodes can be strings instead (which
is why you can do `Div('some text')`). If you pass something that isn’t
a 3-element list or a string, it will be converted to a string using
str()… unless (our final trick) you define a `__ft__` method that will
run before str(), so you can render things a custom way.

For example, here’s one way we could make a custom class that can be
rendered into HTML:

``` python
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def __ft__(self):
        return ['div', [f'{self.name} is {self.age} years old.'], {}]

p = Person('Jonathan', 28)
print(to_xml(Div(p, "more text", cls="container")))
```

    <div class="container">
      <div>Jonathan is 28 years old.</div>
    more text
    </div>

In the examples, you’ll see we often patch in `__ft__` methods to
existing classes to control how they’re rendered. For example, if Person
didn’t have a `__ft__` method or we wanted to override it, we could add
a new one like this:

``` python
from fastcore.all import patch

@patch
def __ft__(self:Person):
    return Div("Person info:", Ul(Li("Name:",self.name), Li("Age:", self.age)))

show(p)
```

<div>
Person info:
  <ul>
    <li>
Name:
Jonathan
    </li>
    <li>
Age:
28
    </li>
  </ul>
</div>

Some tags from fastcore.xml are overwritten by fasthtml.core and a few
are further extended by fasthtml.xtend using this method. Over time, we
hope to see others developing custom components too, giving us a larger
and larger ecosystem of reusable components.

## Custom Scripts and Styling

There are many popular JavaScript and CSS libraries that can be used via
a simple [`Script`](https://www.fastht.ml/docs/api/xtend.html#script) or
[`Style`](https://www.fastht.ml/docs/api/xtend.html#style) tag. But in
some cases you will need to write more custom code. FastHTML’s
[js.py](https://github.com/AnswerDotAI/fasthtml/blob/main/fasthtml/js.py)
contains a few examples that may be useful as reference.

For example, to use the [marked.js](https://marked.js.org/) library to
render markdown in a div, including in components added after the page
has loaded via htmx, we do something like this:

``` javascript
import { marked } from "https://cdn.jsdelivr.net/npm/marked/lib/marked.esm.js";
proc_htmx('%s', e => e.innerHTML = marked.parse(e.textContent));
```

`proc_htmx` is a shortcut that we wrote to apply a function to elements
matching a selector, including the element that triggered the event.
Here’s the code for reference:

``` javascript
export function proc_htmx(sel, func) {
  htmx.onLoad(elt => {
    const elements = htmx.findAll(elt, sel);
    if (elt.matches(sel)) elements.unshift(elt)
    elements.forEach(func);
  });
}
```

The [AI Pictionary
example](https://github.com/AnswerDotAI/fasthtml-example/tree/main/03_pictionary)
uses a larger chunk of custom JavaScript to handle the drawing canvas.
It’s a good example of the type of application where running code on the
client side makes the most sense, but still shows how you can integrate
it with FastHTML on the server side to add functionality (like the AI
responses) easily.

Adding styling with custom CSS and libraries such as tailwind is done
the same way we add custom JavaScript. The [doodle
example](https://github.com/AnswerDotAI/fasthtml-example/tree/main/doodle)
uses [Doodle.CSS](https://github.com/chr15m/DoodleCSS) to style the page
in a quirky way.

## Deploying Your App

We can deploy FastHTML almost anywhere you can deploy python apps. We’ve
tested Railway, Replit,
[HuggingFace](https://github.com/AnswerDotAI/fasthtml-hf), and
[PythonAnywhere](https://github.com/AnswerDotAI/fasthtml-example/blob/main/deploying-to-pythonanywhere.md).

### Railway

1.  [Install the Railway CLI](https://docs.railway.app/guides/cli) and
    sign up for an account.
2.  Set up a folder with our app as `main.py`
3.  In the folder, run `railway login`.
4.  Use the `fh_railway_deploy` script to deploy our project:

``` bash
fh_railway_deploy webOSbrowser
```

What the script does for us:

4.  Do we have an existing railway project?
    - Yes: Link the project folder to our existing Railway project.
    - No: Create a new Railway project.
5.  Deploy the project. We’ll see the logs as the service is built and
    run!
6.  Fetches and displays the URL of our app.
7.  By default, mounts a `/app/data` folder on the cloud to our app’s
    root folder. The app is run in `/app` by default, so from our app
    anything we store in `/data` will persist across restarts.

A final note about Railway: We can add secrets like API keys that can be
accessed as environment variables from our apps via
[‘Variables’](https://docs.railway.app/guides/variables). For example,
for the [image generation
app](https://github.com/AnswerDotAI/fasthtml-example/tree/main/image_app_simple),
we can add a `REPLICATE_API_KEY` variable, and then in `main.py` we can
access it as `os.environ['REPLICATE_API_KEY']`.

### Replit

Fork [this repl](https://replit.com/@johnowhitaker/FastHTML-Example) for
a minimal example you can edit to your heart’s content. `.replit` has
been edited to add the right run command
(`run = ["uvicorn", "main:app", "--reload"]`) and to set up the ports
correctly. FastHTML was installed with `poetry add python-fasthtml`, you
can add additional packages as needed in the same way. Running the app
in Replit will show you a webview, but you may need to open in a new tab
for all features (such as cookies) to work. When you’re ready, you can
deploy your app by clicking the ‘Deploy’ button. You pay for usage - for
an app that is mostly idle the cost is usually a few cents per month.

You can store secrets like API keys via the ‘Secrets’ tab in the Replit
project settings.

### HuggingFace

Follow the instructions in [this
repository](https://github.com/AnswerDotAI/fasthtml-hf) to deploy to
HuggingFace spaces.

## Where Next?

We’ve covered a lot of ground here! Hopefully this has given you plenty
to work with in building your own FastHTML apps. If you have any
questions, feel free to ask in the \#fasthtml Discord channel (in the
fastai Discord community). You can look through the other examples in
the [fasthtml-example
repository](https://github.com/AnswerDotAI/fasthtml-example) for more
ideas, and keep an eye on Jeremy’s [YouTube
channel](https://www.youtube.com/@howardjeremyp) where we’ll be
releasing a number of “dev chats” related to FastHTML in the near
future.

</body>
</html>
