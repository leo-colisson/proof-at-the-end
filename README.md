# Proof-at-the-end, or how to move proofs in appendix in LaTeX

This small package aims to provide a way to easily move proofs in the appendix. You can:

- Move proofs in different places/sections by giving different "categories" to the theorems
- Create links from theorem to proof, and from proof to theorem
- Restate the theorem in appendix (or before)
- Keep the proof in the main body like normal theorems by just adding with just one keyword
- Duplicate the proof in appendix and in the current section, practical to use synctex during the proof writting
- Add comments that would appear only in the appendix (or in both body and appendix)
- Move both the theorem and the proof completely in appendix
- Easily change the defaults, and create your own styles
- Change the text of the link, for example to use another language

## Demo

If you just want to see an example of what you can do, you can directly open the file `demo.pdf` to see what is possible, or generate it with

    git clone https://github.com/tobiasBora/proof-at-the-end.git
    pdflatex demo.tex

## Quickstart

To use this package, if it's not yet in your CTAN distribution, first download the `proof-at-the-end.sty` file and insert it in the root of your project with (you can also clone this repository if you prefer):

    cd <your project>
    wget https://raw.githubusercontent.com/tobiasBora/proof-at-the-end/master/proof-at-the-end.sty

Then, load it in your project:

    \usepackage{proof-at-the-end}

Then, you can configure your theorem/lemma environments as usual, by using any counter you like...:

    \usepackage{amssymb, amsthm, amsmath}
    % Theorems
    \newtheorem{thm}{Theorem}[section]
    \newtheorem*{thm*}{Theorem}
    \providecommand*\thmautorefname{Theorem}
    % Lemmata
    \newtheorem{lemma}[thm]{Lemma}
    \newtheorem*{lemma*}{Lemma}
    \providecommand*\lemmaautorefname{Lemma}
    
And inside your document, you can use the following syntax to create a new theorem:

    \theoremProofEnd[OPTIONS]{THEOREM ENVIRONMENT}[OPTIONAL TITLE]{\label{thm:OPTIONAL LABEL}
        YOUR THEOREM
    }{
        YOUR (OPTIONAL) PROOF
    }

For example:

    \theoremProofEnd{thm}[Yes I can have a title]{\label{thm:ilikelabels}
      Creating a new theorem is easy
    }{
      You want a proof? Here is it!
    }

And put in the place where you would like to display the theorem the following code:

    \printProofs

If you would like to display a lemma instead, just change `{thm}` into `{lemma}`, or into any other theorem environment you defined! 

Isn't it simple ?

## Configuration

You can very easily configure this package, and how the theorems/proofs are displayed by providing a value in `OPTIONS`. For example, if you would like to keep the proof of a theorem in the main text, use the `normal` option:

    \theoremProofEnd[normal]{thm}[A title]{
      You can easily turn a theorem back into a normal theorem!
    }{ %% Proof
      And keep the proof with you!
    }

The options are in fact a set of keys/values, thanks to `pgfkeys`. So you can combine them with comma separated list like that (order matters, as the right-most values may change configuration set by left-most values):

    \theoremProofEnd[proof at the end, no link to proof, text proof={Difficult proof}]{thm}[A title]{
      Each theorem can have a custom configuration!
    }{ %% Proof
      Quite practical, isn't it?
    }

You can easily create your own styles like that:

    \pgfkeys{/prAtEnd/my great style/.style={
        proot at the end,
        no link to proof,
        text proof={Difficult proof},
      }
    }

You can also change the default configuration when you load the package by nesting the configuration into a `conf` key:

    \usepackage[conf={normal}]{proof-at-the-end}

## Categories, or how to move proofs in different sections

Let's imagine that you have some proofs that are easy to do, and some proofs that are long but interesting. You may want to put the easy proofs in a different place that the long proofs. It is super easy to do, you just need to give a category name to the option `category` like here:

    \theoremProofEnd[category=mylongproofs]{thm}[A title]{
      You can easily change the place of the proofs
    }{ %% Proof
      Just use a different category name!
    }

and give in the section where you would like to display the proofs the code this category name to `\printProofs`:

    \printProofs[mylongproofs]

## Comments

You can also move some text in the appendix by using:

    \textInAppendix{You text that should go in appendix}
    
You can also give it a category as explained above, and configure it to be displayed in both the main text and at the end of the file with:

    \textInAppendix[both]{I am a comment that is written in both the main text and the appendix}
    
## Restate a theorem

It is easy to restate a theorem in the appendix, to have both the theorem in the main text and in the appendix: just use the option `restate`:

    \theoremProofEnd[end, restate]{thm}[A title]{
      This theorem will be displayed both in main text and appendix.
    }{
      Just use restate option.
    }

You can also use the option `restate command=yourcustomcommand` in order to create a macro `\yourcustomcommand` that will restate the theorem wherever you want (but after the definition).

If you want to (re)state a theorem *before* its definition (say in the introduction), there is also a custom command `\theoremProofEndRestateBefore` that requires a (unique) custom name that you need to provide also later on in place of the real theorem with the option `restated before`:

    \section{Introduction}
    \theoremProofEndRestateBefore{thm}[Title]{anamethatisusedlaterontorestate}{
      It is possible to state the theorem before in the introduction, and restate it later
    }
    
    \section{Real definition}
    \theoremProofEnd[restated before]{thm}{anamethatisusedlaterontorestate}{
      Proof of the theorem, put in place of the theorem the unique name
    }

## List of options:

Here is the list of options supported. Most options have a `no` version, with `no ` written before. Note that you may prefer to use directly the alias/styles (see next paragraph).

- `category`: category of the proof (if you want to put proofs at several places), can be anything
- `proof here`/`no proof here`: put (or not) the proof in the main text
- `proof end`/`no proof end`: display the proof in appendix
- `restate`/`no restate`: restate the theorem in appendix
- `link to proof`/`no link to proof`: Display a link to the proof in the main text
- `all end`/`no all end`: put the theorem and proof only in appendix
- `text link`: text of the link to the proof, defaults to `{See \hyperref[proof:prAtEnd\pratendcountercurrent]{proof} on page~\pageref{proof:prAtEnd\pratendcountercurrent}}`
- `text proof`: text displayed in place of "Proof" in the appendix. Defaults to `{Proof of \string\autoref{thm:prAtEnd\pratendcountercurrent}}`
- `restate command`: name of a unique macro (without backslash) that will be defined as an alias to restate the theorem wherever you want
- `restated before`: if the theorems has been stated before (with `\theoremProofEndRestateBefore`), then we just need to put the restate command in place of the theorem, and enable this option
- `both`/`no both`: only for `\textInAppendix`, specifies that the text must be present in both the main text and the appendix.

Here are all the alias/styles (you can create you own as well), they are practical to quickly define a behaviours, but are made of the basic options listed above:

- `normal`: like a 'normal' theorem, without any proof in the appendix, and with a proof displayed. Shortcut for `proof here, no all end, no proof end, no link to proof, no restate, no both`.
- `proof at the end` (or just `end`): theorems whose proof need to go in the appendix. Shorcut for `no proof here, no all end, proof end, no both`.
- `debug`: make sure the proof is written in the main text as well (alias to `proof here`), it is quite practical to use when you write a proof to be able to use synctex features to move between the pdf and the file.
- `no link to theorem`: Remove the link from the proof to the theorem, alias of `text proof={\proofname}`
- `stared` (or `no number`): when you use the stared version of a theorem you don't have any number, so autoref fails to write a nice link to the theorem. This option changes the text of "Proof", by keeping the link but writting only `Proof`. Defaults to `text proof={\string\mbox{\string\hyperref[thm:prAtEnd\pratendcountercurrent]{\proofname}}}`
- `defaults`: default style that is loaded before anything else that configure by default a link to the proof, put the proof in appendix, use the category `defaultcategory`. It is an alias of `end, link to proof, no restate, category=defaultcategory, text link={See \hyperref[proof:prAtEnd\pratendcountercurrent]{proof} on page~\pageref{proof:prAtEnd\pratendcountercurrent}}, text proof={Proof of \string\autoref{thm:prAtEnd\pratendcountercurrent}}, restate command=pratenddummymacro`.
- `custom defaults`: style that is empty (contains only the option you sent to the package) that is overwritten and loaded right after `defaults`. Useful if you want to overwrite the default.



