# Proof-at-the-end, or how to move proofs in appendix in LaTeX

## Introduction

This small package aims to provide a way to easily move proofs in the appendix. You can:

- Move proofs in different places/sections by giving different "categories" to the theorems
- Create links from theorem to proof, and from proof to theorem
- Restate the theorem in appendix (or before)
- Keep the proof in the main body like normal theorems by just adding with just one keyword
- Duplicate the proof in appendix and in the current section, practical to use synctex during the proof writting
- Add comments that would appear only in the appendix (or in both body and appendix)
- Move both the theorem and the proof completely in appendix
- Easily change the defaults, and create your own styles/environments
- Include sketch of proof in the main text, and full proof in appendix
- Change the text of the link, for example to translate into another language
- Have a nice environment-based commands in order to mimic the usual theorem/proof structure.


NB: This project is hosted on github at [https://github.com/leo-colisson/proof-at-the-end](https://github.com/leo-colisson/proof-at-the-end) . Feel free to contribute, report bugs, or read/copy-paste the documentation/examples from there.

Disclaimer: This package is still in beta and not considered as stable.

## Demo ##

If you just want to see an example of what you can do, you can directly open the file `demo.pdf` to see what is possible, or generate it with

```bash
git clone https://github.com/leo-colisson/proof-at-the-end.git
pdflatex demo.tex && pdflatex demo.tex
```

## Quickstart ##

To use this package, if it's not yet in your CTAN distribution, first download the `proof-at-the-end.sty` file and insert it in the root of your project with the following commands (you can also clone this repository if you prefer). It also requires a recent version of xparse, so for simplicity we included the sty file of xparse in this repository as well:

```bash
cd <your project>
repopratend="https://raw.githubusercontent.com/leo-colisson/proof-at-the-end"
wget ${repopratend}/master/proof-at-the-end.sty
wget ${repopratend}/master/xparse.sty
```

Then, load it in your project:

```latex
\usepackage{proof-at-the-end}
```

Then, you can configure your theorem/lemma/... environments as usual, by using any counter you like...:

```latex
\usepackage{amssymb, amsthm, amsmath}
% Theorems
\newtheorem{thm}{Theorem}[section]
\newtheorem*{thm*}{Theorem}
\providecommand*\thmautorefname{Theorem}
% Lemmata
\newtheorem{lemma}[thm]{Lemma}
\newtheorem*{lemma*}{Lemma}
\providecommand*\lemmaautorefname{Lemma}
```

And inside your document, you can use the following syntax to create a new theorem:

```latex
\begin{theoremEnd}[OPTIONS]{THEOREM ENVIRONMENT}[OPTIONAL TITLE]
    YOUR THEOREM, with eventually labels like \label{thm:OPTIONAL LABEL}
\end{theoremEnd}
\begin{proofEnd} %% Optional environment
    YOUR (OPTIONAL) PROOF
\end{proofEnd}
```

For example:

```latex
\begin{theoremEnd}{thm}[Yes I can have a title]
  \label{thm:ilikelabels}
  Creating a new theorem is easy
\end{theoremEnd}
\begin{proofEnd}
  You want a proof? Here is it!
\end{proofEnd}
```

And put in the place where you would like to display the theorem the following code:

```latex
\printProofs
```

If you would like to display a lemma instead, just change `{thm}` into `{lemma}`, or into any other theorem environment you defined! You can now compile safely your document ;)

NB: if you want to make sure all the references are linked correctly, make sure to compile twice the document!


Isn't it simple ?

## Use cases

### Configuration and how to use and create styles ###

You can very easily configure this package, and choose how each theorem/proof must be displayed by providing a value in `OPTIONS`. For example, if you would like to keep the proof of a theorem in the main text like any normal theorem, use the `normal` option:

```latex
\begin{theoremEnd}[normal]{thm}[A title]
  You can easily turn a theorem back into a normal theorem!
\end{theoremEnd}
\begin{proofEnd}
  And keep the proof with you!
\end{proofEnd}
```

The options are in fact a set of keys/values, thanks to `pgfkeys`. So you can combine them with comma separated list like that (order matters, as the right-most values may overwrite configuration set by left-most values):

```latex
\begin{theoremEnd}[proof at the end,
                   no link to proof,
                   text proof={Difficult proof}
                  ]{thm}[A title]
  Each theorem can have a custom configuration!
\end{theoremEnd}
\begin{proofEnd}
  Quite practical, isn't it?
\end{proofEnd}
```

You can easily create your own styles like that:

```latex
\pgfkeys{/prAtEnd/my great style/.style={
    proot at the end,
    no link to proof,
    text proof={Difficult proof},
  }
}
```

You can also change the default configuration when you load the package by nesting the configuration into a `conf` key:

```latex
\usepackage[conf={normal, one big link}]{proof-at-the-end}
```

Note however that for now it is *not* possible to use macros directly inside the options when you load the package, so if you need to use more complicated configuration, you can overwrite the `global custom defaults` style for global configuration, and the `local custom defaults` style for local configuration (useful for example if you want to define a category for a single section):

```latex
\pgfkeys{/prAtEnd/global custom defaults/.style={
    one big link={Go to proof on page~\pageref*{proof:prAtEnd\pratendcountercurrent}}
  }
}
```

and for local configuration:
```latex
\pgfkeys{/prAtEnd/local custom defaults/.style={
    category=greattheorem
  }
}
```

Finally, it can be practical to define custom environments to avoid typing always `theoremEnd`:

```latex
\NewDocumentEnvironment{thmE}{O{}O{}+b}{%
  \begin{theoremEnd}[normal,#2]{thm}[#1]%
    #3%
  \end{theoremEnd}%
}
\NewDocumentEnvironment{proofE}{O{}+b}{%
  \begin{proofEnd}[#1]%
    #2%
  \end{proofEnd}%
}
```
That you could use like that:

```latex
\begin{thmE}[Title]
  Here is a normal theorem with the proof in the main text.
\end{thmE}
\begin{proofE}
  The (optional) proof
\end{proofE}
  
\begin{thmE}[Title][end]
  Here is a theorem whose proof goes to the end.
\end{thmE}
\begin{proofE}
  The proof
\end{proofE}

\begin{thmE}[Title][all end]
  Here is a theorem that goes with the proof at the end.
\end{thmE}
\begin{proofE}
  The proof
\end{proofE}
```

Note also that it is also possible to give options to the `proofEnd` environment, but it is usually useless, as it will automatically pick the parameters from the last `theoremEnd` environment. However, if for some reasons you want to change the options of the proof only, you can do it, but do it as your own risks ;)

### Categories, or how to move proofs in different sections ###

Let's imagine that you have some proofs that are easy to do, and some proofs that are long but interesting. You may want to put the easy proofs in a different place that the long proofs. It is super easy to do, you just need to give a category name to the option `category` like here:

```latex
\begin{theoremEnd}[category=mylongproofs]{thm}[A title]
  You can easily change the place of the proofs
\end{theoremEnd}
\begin{proofEnd}
  Just use a different category name!
\end{proofEnd}
```

and give in the section where you would like to display the proofs the code this category name to `\printProofs`:

```latex
\printProofs[mylongproofs]
```

### Comments ###

You can also move some text in the appendix by using:

```latex
\textEnd{You text that should go in appendix}
```
    
You can also give it a category as explained above, or configure it to be displayed in both the main text and at the end of the file with:

```latex
\textEnd[both]{I am a comment that is written in both the main text
and the appendix}
```

You can also use the environment notation like that:

```latex
\begin{textAtEnd}[options]
  You can also use the environment syntax.
\end{textAtEnd}
```

### Restate a theorem ###

It is easy to restate a theorem in the appendix, to have both the theorem in the main text and in the appendix: just use the option `restate`:

```latex
\begin{theoremEnd}[end, restate]{thm}[A title]
  This theorem will be displayed both in main text and appendix.
\end{theoremEnd}
\begin{proofEnd}
  Just use restate option.
\end{proofEnd}
```

You can also use the option `restate command=yourcustomcommand` in order to create a macro `\yourcustomcommand` that will restate the theorem wherever you want (but after the definition).

If you want to (re)state a theorem *before* its definition (say in the introduction), there is also a special environment `theoremEndRestateBefore` that requires a (unique) custom name that you need to provide also later on in place of the real theorem with the option `restated before`:

```latex
\section{Introduction}
\begin{theoremEndRestateBefore}{thm}[Title]{anamethatisusedtorestate}
  It is possible to state the theorem before
  in the introduction, and restate it later
\end{theoremEndRestateBefore}

\section{Real definition}
\begin{theoremEnd}[restated before]{thm}
  anamethatisusedtorestate
\end{theoremEnd}
\begin{proofEnd}
  Proof of the theorem, put in place of the theorem the unique name
\end{proofEnd}
```

### Translate the links ###

The more powerful way to change the text of the links is to redefine `text link` and `text proof` (see section List of options for more details). However we defined also some easy way to redefine the text using `one big link translated` and `text proof translated`. For example, to create your `french` style you can do:

```latex
\pgfkeys{/prAtEnd/french/.style={
    one big link translated={Voir preuve page},
    text proof translated={Preuve du}
  }
}
```

### Write a sketch of proof in the main text ###

You can include a sketch of proof in the main text by simply adding a proof in between `theoremEnd` and `proofEnd`. An alias option `see full proof` can also be used to change the link into "See full proof on page X":

```latex
\begin{theoremEnd}[see full proof]{thm}
  I can also write a sketch of proof, and put the full proof in appendix.
\end{theoremEnd}
\begin{proof}
  Hint: look at the alias options.
\end{proof}
\begin{proofEnd}
  You just use ``see full proof'' as an option
\end{proofEnd}
```

## List of options ##

Here is the list of fundamental options supported. Most options have a `no` version, with `no ` written before. Note that you may prefer to use directly the alias/styles (see next paragraph) as the options listed here are quite fundamental and atomic.

- `category`: category of the proof (if you want to put proofs at several places), can be anything
- `proof here`/`no proof here`: put (or not) the proof in the main text
- `proof end`/`no proof end`: display the proof in appendix
- `restate`/`no restate`: restate the theorem in appendix
- `link to proof`/`no link to proof`: Display a link to the proof in the main text
- `opt all end`/`no opt all end`: put the theorem and proof only in appendix. You may prefer the alias `all end`, that also makes sure that the proof is indeed displayed in appendix.
- `text link`: text of the link to the proof, defaults to

  `{See \hyperref[proof:prAtEnd\pratendcountercurrent]{proof} on page~\pageref{proof:prAtEnd\pratendcountercurrent}}`
- `text proof`: text displayed in place of "Proof" in the appendix. Defaults to `{Proof of \string\autoref{thm:prAtEnd\pratendcountercurrent}}`
- `restate command`: name of a unique macro (without backslash) that will be defined as an alias to restate the theorem wherever you want
- `restated before`: if the theorems has been stated before (with `\theoremProofEndRestateBefore`), then we just need to put the restate command in place of the theorem, and enable this option
- `both`/`no both`: only for `\textInAppendix`, specifies that the text must be present in both the main text and the appendix.

Here are all the alias/styles (you can create you own as well), they are practical to quickly define a behaviours, but are made of the basic options listed above:

- `normal`: like a 'normal' theorem, without any proof in the appendix, and with a proof displayed in the main text. Shortcut for `proof here, no all end, no proof end, no link to proof, no restate, no both`.
- `end`: theorems whose proof need to go in the appendix. Shorcut for `proof at the end, link to proof`.
- `all end`: makes sure both the theorem and the proof are in appendix. Alias of `end, opt all end`.
- `proof at the end`: theorems whose proof need to go in the appendix contrary to `end` it does not make sure that there is a link to the proof.  Shorcut for `no proof here, no all end, proof end, no both`.
- `debug`: make sure the proof is written in the main text as well (alias of `proof here, no opt all end`), it is quite practical to use when you write a proof to be able to use synctex features to move between the pdf and the file.
- `no link to theorem`: Remove the link from the proof to the theorem, alias of `text proof={\proofname}`
- `stared` (or `no number`): when you use the stared version of a theorem you don't have any number, so autoref fails to write a nice link to the theorem. This option changes the text of "Proof", by keeping the link but writting only `Proof`. Equivalent to `text proof={\string\mbox{\string\hyperref[thm:prAtEnd\pratendcountercurrent]{\proofname}}}`
- `see full proof`: useful when you want to write in the main text only a sketch of proof, this alias writes a link `See full proof on page X`. Equivalent to `text link={See \hyperref[proof:prAtEnd\pratendcountercurrent]{full proof} on page~\pageref{proof:prAtEnd\pratendcountercurrent}}`
- `one big link`: instead of two links, one for page, one for proof, put just one link around everything. It can also accept an optional argument which will be the text of the link, like `one big link=Go to the proof`. The default value is `See proof on page~\pageref*{proof:prAtEnd\pratendcountercurrent}`.
- `one big link translated`: This is like `one big link`, but automatically add the page at the end (and a big link around). Practical to quickly define a translation like `one big link translated=Voir preuve page`. See also `text proof translated`.
- `default text link`: default text for the link to the proof, equivalent of `text link={See \hyperref[proof:prAtEnd\pratendcountercurrent]{proof} on page~\pageref{proof:prAtEnd\pratendcountercurrent}}`
- `default text proof`: default text for the proof in appendix, equivalent of `text proof={Proof of \string\autoref{thm:prAtEnd\pratendcountercurrent}}`
- `text proof translated`: like `default text proof`, but takes one argument and use it instead of `Proof of`. Example: `text proof translated={Preuve du}`
- `bare defaults`: default style that is loaded before anything else that configure by default a link to the proof, put the proof in appendix, use the category `defaultcategory`. It is an alias of `end, link to proof, no restate,category=defaultcategory, default text link,default text proof,restate command=pratenddummymacro`.
- `configuration options`: style that contains the options used to load the package. It is called right after `bare defaults`. Note that you cannot insert macro in the options, overwrite `global custom defaults` instead
- `global custom defaults`: empty style that you can overwrite to change the global defaults
- `local custom defaults`: empty style that you can overwrite to change the "local" defaults, like category
- `all defaults`: all the defaults, equivalent of `bare defaults, configuration options, global custom defaults, local custom defaults`


## Contributions ##

Feel free to contribute, report bugs, and send pull requests on the github repository  [https://github.com/leo-colisson/proof-at-the-end](https://github.com/leo-colisson/proof-at-the-end) !

NB: the documentation is generated from the Markdown file `README.md` thanks to pandoc. These commands may help you:
```bash
%% Compile the demo
make demo
%% Clean the project
make clean
%% Generate the documentation
make doc
%% Generate a package for CTAN
make package
```
