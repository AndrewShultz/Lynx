\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ASReport}[2019/16/07 v1.0.0 AS Report Class]

\RequirePackage{ifthen}
\RequirePackage{keyval}
\RequirePackage{setspace}
\RequirePackage{scrtime}

\newboolean{nu@print}
\newboolean{nu@single}
\newboolean{nu@pagedark}
\newboolean{nu@useauthor}

\newcommand{\university}[1]{
  \gdef\nu@university{#1}
}
\newcommand{\nu@university}{University of Nebraska-Lincoln}

\newcommand{\dept}[1]{
  \gdef\nu@dept{#1}
}
\newcommand{\nu@dept}{Physics}

\newcommand{\class}[1]{
  \gdef\nu@class{#1}
}
\newcommand{\nu@class}{PHYS 100 SEC 001}

\newcommand{\classdesc}[1]{
  \gdef\nu@classdesc{#1}
}
\newcommand{\nu@classdesc}{A Physics Class}

\newcommand{\adviser}[1]{
  \gdef\nu@adviser{#1}
}
\newcommand{\nu@adviser}{}

\newcommand{\aauthors}[1]{
  \gdef\nu@author{#1}
  \setboolean{nu@useauthor}{false}
}
\newcommand{\aauthor}[1]{
  \gdef\nu@author{#1}
  \setboolean{nu@useauthor}{true}
}
\newcommand{\nu@author}{}

\newcommand{\duedate}[1]{
  \gdef\nu@duedate{#1}
}
\newcommand{\nu@duedate}{\today}

\newcommand{\HRule}{\rule{\linewidth}{0.5mm}}


\DeclareOption{testing}{%
  \PassOptionsToPackage{showframe}{geometry}
}

\DeclareOption{single}{%
  \setboolean{nu@single}{true}
}

\DeclareOption{double}{%
  \setboolean{nu@single}{false}
}

\DeclareOption{print}{%
  \setboolean{nu@print}{true}
  \PassOptionsToPackage{bindingoffset=0.5in}{geometry}
}

\DeclareOption{dark}{
  \setboolean{nu@pagedark}{true}
  %  \pagecolor{black}
}

\DeclareOption{electronic}{%
  \relax
}

\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{memoir}
}

%\ExecuteOptions{double,electronic,phd}
\ProcessOptions
\LoadClass[]{memoir} % oneside, openany
\RequirePackage[letterpaper,margin=1in]{geometry}
\RequirePackage[]{genericdocument}

\let\@afterindentfalse\@afterindenttrue
\@afterindenttrue

\makepagestyle{nu@pagestyle}
\makeoddfoot{nu@pagestyle}{}{\normalfont\thepage}{}
\makeevenfoot{nu@pagestyle}{}{\normalfont\thepage}{}

\makepagestyle{nu@pagestyleEmpty}

\makepagestyle{nu@pagestyleDraft}
\makeoddfoot{nu@pagestyleDraft}{\textbf{\today}}{\normalfont\thepage}{\textbf{\thistime{}}}
\makeevenfoot{nu@pagestyleDraft}{\textbf{\today}}{\normalfont\thepage}{\textbf{\thistime{}}}

\ifdraftdoc
\aliaspagestyle{plain}{nu@pagestyleDraft}
\aliaspagestyle{empty}{nu@pagestyleEmpty}
\pagestyle{nu@pagestyleDraft}
\else
\aliaspagestyle{plain}{nu@pagestyle}
\aliaspagestyle{empty}{nu@pagestyleEmpty}
\pagestyle{nu@pagestyle}
\fi

%\addtolength{\oddsidemargin}{-0.9in}
%\addtolength{\evensidemargin}{-0.9in}
%\addtolength{\textwidth}{1.8in}
%\addtolength{\topmargin}{-0.7in}
%\addtolength{\bottommargin}{-1.in}
%\addtolength{\textheight}{1.0in}

\captionsetup[figure]{labelfont=bf,textfont={it},width=\textwidth}
\captionsetup[subfigure]{labelfont=bf,textfont={it},width=0.8\textwidth}
\captionsetup[table]{labelfont=bf,textfont={it},width=0.8\textwidth}

\definecolor{numbercolor}{gray}{0.5}
\newif\ifchapternonum
\makechapterstyle{jenor}{
  \renewcommand\printchaptername{}
  \renewcommand\printchapternum{}
  \renewcommand\printchapternonum{\chapternonumtrue}
  \renewcommand\chaptitlefont{\fontsize{18}{35}\selectfont\raggedleft}
  \renewcommand\chapnumfont{\fontsize{0.5in}{0in}\selectfont\color{numbercolor}}
  \renewcommand\printchaptertitle[1]{%
    \vspace{-4em}
    \noindent%
    \ifchapternonum%
    \begin{tabularx}{\textwidth}{X}%
      {\parbox[b]{\textwidth}{\chaptitlefont ##1}%
        \vphantom{\raisebox{-1pt}{\chapnumfont 1}}}
    \end{tabularx}%
    \else
    \begin{tabularx}{\textwidth}{Xl}
      \raisebox{-1pt}{\chapnumfont \thechapter} & {\parbox[b]{0.95\textwidth}{\chaptitlefont ##1}}
    \end{tabularx}%
    \fi
    \par\vskip0mm\hrule
    \vspace{-1em}
  }
}

\chapterstyle{jenor}

\titleformat{\section}[block]
            {\normalfont\bfseries}
            {\thesection.}{0.5em}{}[\hrule]

            %\titleformat{\section}
            %{\normalfont\bfseries}
            %{\thesection.}{0.5em}{}[\hrule]

            %\newlength\outermargin
            %\newlength\innermargin
            %\setlength{\innermargin}{1in}
            %\setlength{\outermargin}{\dimexpr\paperwidth-\textwidth-\innermargin\relax}
            %\titleformat{\section}%
            %{\normalfont\Large\itshape\color{black}\setlength\fboxrule{0.2pt}}% format applied to label+text
            %{\Large\bfseries}
            %{\llap{\colorbox{orange}{\makebox[\outermargin][r]{\raisebox{0pt}[\dimexpr\height+\fboxrule][\dimexpr\depth+\fboxrule]%
            %{\vphantom{lp}\color{black}\bfseries\thesection\enspace}}}}}% label
            %{\thesection}
            %{0pt}% horizontal separation between label and title body
            %{\rlap{\hspace{-\fboxrule}\framebox[\dimexpr\linewidth + 2\fboxrule\relax][l]{\vphantom{lp}}\colorbox{orange}{\makebox[\outermargin][r]{\raisebox{0pt}[\dimexpr\height+\fboxrule][\dimexpr\depth+\fboxrule]%
            % {\vphantom{lp}}}}}\hspace{1cm}}% before the title body
            %{}
            %[\hrule]



            \renewcommand{\maketitle}{%
              {
                \singlespace
                \fontsize{12}{12}\selectfont
                \begin{center}%

                  \textsc{\nu@university}\\
                  \textsc{Department of \nu@dept}\\[0.5cm]
                  \vfill
                  %\textsc{\nu@class}\\
                  %\textsc{\nu@classdesc}\\[3.0cm]
                  \HRule \\
                  \vspace{0.45cm}
                  \textbf{\LARGE{\thetitle}} \\
                  %\vspace{0.15cm}
                  \HRule \\
                  \vfill

                  %Prepared for: \\
                  %\textsc{\nu@adviser} \\
                  %\vfill



                  {\nu@author} \\[0.5cm]

                  {\nu@duedate} \\[0.5cm]
                \end{center}
              }
              \thispagestyle{empty}
              %\cleardoublepage
              %\clearpage
              \let\cleardoublepage\clearpage

            }



            \newcounter{mypagecount}
            \setcounter{mypagecount}{0}
            \newenvironment{interabstract}{
              \setcounter{mypagecount}{\value{page}}
              \cleardoublepage
              \thispagestyle{empty}
              \pagestyle{empty}
              \begin{vplace}[0.75]
                \begin{center}
                  {\Large \textbf{Abstract}}
                \end{center}
            }
                           {
              \end{vplace}
              \cleardoublepage
              \setcounter{page}{\value{mypagecount}}
              \let\cleardoublepage\clearpage
                           }



                           \renewenvironment{abstract}{%
                             \pagestyle{empty}%
                             \begin{doublespacing}%
                               \begin{center}%
                                 \MakeUppercase{\thetitle}\\[.5\baselineskip]
                                 \theauthor, \nu@degreeabbreviation\\
                                 \nu@university, \nu@year%
                               \end{center}%
                               \begin{flushleft}%
                                 Adviser: \nu@adviserAbstract%
                               \end{flushleft}%
                           }{\par\end{doublespacing}\cleardoublepage}

                           \newenvironment{copyrightpage}[1][Copyright]{%
                             \begin{center}%
                               \MakeUppercase{#1}\\
                               \copyright{} \nu@year, \theauthor%
                             \end{center}%
                             \ifthenelse{\boolean{nu@single}}{\begin{singlespacing}}{\begin{doublespacing}}%
                           }{\par%
                             \ifthenelse{\boolean{nu@single}}{\end{singlespacing}}{\end{doublespacing}}%
                             \cleardoublepage
                           }

                           \newenvironment{dedication}[1][Dedication]{%
                             \begin{center}%
                               \MakeUppercase{#1}%
                             \end{center}%
                             \ifthenelse{\boolean{nu@single}}{\begin{singlespacing}}{\begin{doublespacing}}%
                           }{\par%
                             \ifthenelse{\boolean{nu@single}}{\end{singlespacing}}{\end{doublespacing}}%
                             \cleardoublepage
                           }

                           \newenvironment{acknowledgments}[1][Acknowledgments]{%
                             \begin{center}
                               \MakeUppercase{#1}
                             \end{center}
                             \ifthenelse{\boolean{nu@single}}{\begin{singlespacing}}{\begin{doublespacing}}%
                           }{\par%
                             \ifthenelse{\boolean{nu@single}}{\end{singlespacing}}{\end{doublespacing}}%
                             \cleardoublepage
                           }

                           \newenvironment{grantinfo}[1][Grant Information]{%
                             \begin{center}
                               \MakeUppercase{#1}
                             \end{center}
                             \ifthenelse{\boolean{nu@single}}{\begin{singlespacing}}{\begin{doublespacing}}%
                           }{\par%
                             \ifthenelse{\boolean{nu@single}}{\end{singlespacing}}{\end{doublespacing}}%
                             \cleardoublepage
                           }

                           \let\nu@ToC\tableofcontents
                           \renewcommand{\tableofcontents}{\cleardoublepage\nu@ToC}

                           \let\nu@LoF\listoffigures
                           \renewcommand{\listoffigures}{\cleardoublepage\nu@LoF}

                           \let\nu@LoT\listoftables
                           \renewcommand{\listoftables}{\cleardoublepage\nu@LoT}
                           \maxsecnumdepth{subsubsection}
                           \setsecnumdepth{subsubsection}
                           \maxtocdepth{subsubsection}
                           \let\backmatter\relax

                           \AtBeginDocument{
                             \ifthenelse{\boolean{nu@single}}{\singlespacing}{\doublespacing}%
                             \ifthenelse{\boolean{nu@pagedark}}{
                               \color{white}\global\let\default@color\current@color
                               \pagecolor{black}
                             }{}
                           }

                           \endinput

                           %%
                           %% End of file `nuthesis.cls'.
