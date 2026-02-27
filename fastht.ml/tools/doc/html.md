`fastht.ml`

<!--
  NB(): if you move this file, be sure to update
  tools/doc/html.mjs to point at the new location.
--> 

<!--introduced_in=v0.10.0-->
* [About this documentation](documentation.md)
* [Usage and example](synopsis.md)

<hr class="line"/>

* [Assertion testing](assert.md)
* [Asynchronous context tracking](async_context.md)
* [Async hooks](async_hooks.md)
* [Buffer](buffer.md)
* [C++ addons](addons.md)
* [C/C++ addons with Node-API](n-api.md)
* [C++ embedder API](embedding.md)
* [Child processes](child_process.md)
* [Cluster](cluster.md)
* [Command-line options](cli.md)
* [Console](console.md)
* [Crypto](crypto.md)
* [Debugger](debugger.md)
* [Deprecated APIs](deprecations.md)
* [Diagnostics Channel](diagnostics_channel.md)
* [DNS](dns.md)
* [Domain](domain.md)
* [Environment Variables](environment_variables.md)
* [Errors](errors.md)
* [Events](events.md)
* [File system](fs.md)
* [Globals](globals.md)
* [HTTP](http.md)
* [HTTP/2](http2.md)
* [HTTPS](https.md)
* [Inspector](inspector.md)
* [Internationalization](intl.md)
* [Modules: CommonJS modules](modules.md)
* [Modules: ECMAScript modules](esm.md)
* [Modules: `node:module` API](module.md)
* [Modules: Packages](packages.md)
* [Modules: TypeScript](typescript.md)
* [Net](net.md)
* [OS](os.md)
* [Path](path.md)
* [Performance hooks](perf_hooks.md)
* [Permissions](permissions.md)
* [Process](process.md)
* [Punycode](punycode.md)
* [Query strings](querystring.md)
* [Readline](readline.md)
* [REPL](repl.md)
* [Report](report.md)
* [Single executable applications](single-executable-applications.md)
* [SQLite](sqlite.md)
* [Stream](stream.md)
* [String decoder](string_decoder.md)
* [Test runner](test.md)
* [Timers](timers.md)
* [TLS/SSL](tls.md)
* [Trace events](tracing.md)
* [TTY](tty.md)
* [UDP/datagram](dgram.md)
* [URL](url.md)
* [Utilities](util.md)
* [V8](v8.md)
* [VM](vm.md)
* [WASI](wasi.md)
* [Web Crypto API](webcrypto.md)
* [Web Streams API](webstreams.md)
* [Worker threads](worker_threads.md)
* [Zlib](zlib.md)
* [Code repository and issue tracker](https://github.com/webosbrowser/main)
```.html.mjs
\documentclass{standalone}
\usepackage{amsmath}
\usepackage{tikz}
\usepackage{xcolor}
  ***One page per diagram**
\standaloneenv{tikzpicture}
\definecolor{Vermillion}        {cmy}{0,    0.8, 1}
\definecolor{Orange}            {cmy}{0,    0.5, 1}
\definecolor{SkyBlue}           {cmy}{0.8,  0,   0}
\definecolor{BluishGreen}       {cmy}{0.97, 0,   0.75}
\definecolor{Yellow}            {cmy}{0.1,  0.5, 0.9}
\definecolor{Blue}              {cmy}{1,    0.5, 0}
\definecolor{ReddishPurple}     {cmy}{0.1,  0.7, 0}
\begin{document}
\begin{tikzpicture}
\usetikzlibrary{calc}
\usetikzlibrary{shapes}
  \Nodes representing data.
\tikzset{publicdatum/.style={
    shape=circle,
    rounded corners=0.5ex,
    minimum height=4ex,
    fill=SkyBlue, fill opacity=0.4,
    text opacity=1,
}}
\tikzset{secretdatum/.style={
    shape=rectangle,
    rounded corners=0.5ex,
    minimum height=4ex,
    fill=Vermillion, fill opacity=0.4,
    text opacity=1,
}}
\Nodes representing operations on data.
\tikzset{operation/.style={
    shape=trapezium,
    trapezium left angle=-65,
    trapezium right angle=-65,
    minimum height=4ex,
}}
\node (gen) at (1/4, 5) [draw, operation] {$\operatorname{Gen}$};
  \coordinate (gen-pk) at ($(gen.south) - (1/4,0)$);
  \coordinate (gen-sk) at ($(gen.south) + (1/4,0)$);
\node (pk) at (-2, 3) [draw, publicdatum] {$\mathit{pk}$}
\node (encap) at (-2, 2) [draw, operation]
    {$\operatorname{Encap}(\mathit{pk})$};
  \coordinate (encap-pk) at (encap.north);
  \coordinate (encap-k) at ($(encap.south) - (1/2,0)$)
  \coordinate (encap-c) at ($(encap.south) + (1/2,0)$)
\node (k0) at (-2.5, 1) [draw, secretdatum] {$k$};
\node (c) at (-1, 0.5) [draw, publicdatum] {$c$}
\node (sk) at (0.5, 0) [draw, secretdatum] {$\mathit{sk}$};
\node (decap) at (0, -1) [draw, operation]
    {$\operatorname{Decap}(\mathit{sk}, c)$};
  \coordinate (decap-c) at ($(decap.north) - (1/2,0)$);
  \coordinate (decap-sk) at ($(decap.north) + (1/2,0)$)
  \coordinate (decap-k) at (decap.south);
\node (k1) at (0, -2) [draw, secretdatum] {$k$};
\draw[->] (gen-pk) |- ($(pk) + (0,1)$) -- (pk);
\draw[->] (gen-sk) -- (sk);
\draw[->] (pk) -- (encap-pk);
\draw[->] (encap-k) -- (k0.north);
\draw[->] (encap-c) |- (c);
\draw[->] (c) -| (decap-c);
\draw[->] (sk) -- (decap-sk);
\draw[->] (decap-k) -- (k1);
\end{tikzpicture}
\end{document}
