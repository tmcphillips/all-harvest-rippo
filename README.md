# All-Harvest-Repro
### Alaska Salmon Harvest - All Sectors - 1995-2016

## Overview

The purpose of this repo to enable the analysis associated with the dataset [doi:10.5063/F1BV7DV0](https://knb.ecoinformatics.org/view/doi:10.5063/F1BV7DV0) (*Harvest of Salmon across Commercial, Subsistence, Personal Use, and Sport Fish sectors, Alaska, 1995-2016*; [Jeanette Clark](http://orcid.org/0000-0003-4703-1974) & Alaska Department of Fish and Game) to be re-executed on any computer that has Git, Docker, and GNU Make installed. The versions of R, RStudio Server, and R packages required to run the analysis are preinstalled in a Docker image associated with this repo; the Docker image is used automatically by the targets in the Makefile as needed.

Makefile targets that use the Docker image mount the working directory within the running container. Any changes made to repository contents are reflected in the running container.  Similarly, outputs of the analysis running in the container are immediately accessible outside the container.

The analysis can be run either noninteractively via the *`make run`* command, or interactively in an RStudio instance running in a container started with the command *`make server`*. The *`make clean`* command deletes previously computed outputs.  The command *`git status`* can be used to confirm that previously computed results have been deleted, and again to verify that recomputed outputs are identical to the originals. The Makefile includes targets for building the required Docker image.

## Tutorials

The tutorials below demonstrate how to use the tools and data in this repo to reproduce the original analysis.

### Tutorial 1 - Rerun the analysis at the command line

1. Ensure that Git, Docker, and GNU Make are installed on your MacOS, Linux or Windows computer:

	```
	$ git --version
	git version 2.11.0

	$ docker --version
	Docker version 19.03.5, build 633a0ea838

	$ make --version
	GNU Make 4.1
	Built for x86_64-pc-linux-gnu
	Copyright (C) 1988-2014 Free Software Foundation, Inc.
	License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
	This is free software: you are free to change and redistribute it.
	There is NO WARRANTY, to the extent permitted by law.
	```

2. Clone this Git repo:

	```
	$ git clone https://github.com/tmcphillips/all-harvest-repro.git
	```

	List the contents of the `analysis` subdirectory:

	```
	all-harvest-repro$ ls -l analysis/
	total 2412
	-rw-r--r-- 1 tmcphill tmcphill 2116643 Mar 24 15:49 All_Harvest.html
	-rw-r--r-- 1 tmcphill tmcphill   12338 Mar 24 15:49 All_Harvest.Rmd
	-rwxr-xr-x 1 tmcphill tmcphill     226 Mar 24 15:49 All_Harvest.Rproj
	-rw-r--r-- 1 tmcphill tmcphill  332060 Mar 24 15:49 Harvest_All_Sectors.csv
	-rw-r--r-- 1 tmcphill tmcphill     139 Mar 24 15:49 Makefile
	```

	And use *`git status`* to confirm that the contents of the repo have not changed since it was cloned:

	```
	all-harvest-repro$ git status
	On branch master
	Your branch is up-to-date with 'origin/master'.
	nothing to commit, working tree clean
	```

3. Delete the products of the analysis using *`make clean`*:

	```
	tmcphill@circe:~/GitRepos/all-harvest-repro$ make clean
	docker run -it --rm -p 8787:8787 --volume /mnt/c/Users/tmcphill/OneDrive/GitRepos/all-harvest-repro:/mnt/all-harvest-repro tmcphillips/all-harvest-repro:latest bash -ic 'make -C /mnt/all-har
	vest-repro/analysis clean'
	make: Entering directory '/mnt/all-harvest-repro/analysis'
	rm -rf Harvest_All_Sectors.csv All_Harvest.html
	make: Leaving directory '/mnt/all-harvest-repro/analysis'
	```

	List the `analysis` directory again, noting that the files `All_Harvest.html` and `Harvest_All_Sectors.csv` are no longer present:

	```
	tmcphill@circe:~/GitRepos/all-harvest-repro$ ls -l analysis/
	total 16
	-rw-r--r-- 1 tmcphill tmcphill 12338 Mar 24 15:49 All_Harvest.Rmd
	-rwxr-xr-x 1 tmcphill tmcphill   226 Mar 24 15:49 All_Harvest.Rproj
	-rw-r--r-- 1 tmcphill tmcphill   139 Mar 24 15:49 Makefile
	```

	And note that *`git status`* confirms the two outputs of the analysis have been deleted:

	```
	all-harvest-repro$ git status
	On branch master
	Your branch is up-to-date with 'origin/master'.
	Changes not staged for commit:
	(use "git add/rm <file>..." to update what will be committed)
	(use "git checkout -- <file>..." to discard changes in working directory)

			deleted:    analysis/All_Harvest.html
			deleted:    analysis/Harvest_All_Sectors.csv

	no changes added to commit (use "git add" and/or "git commit -a")
	```

4. Execute the analysis using *`make run`*:

	```
	tmcphill@circe:~/GitRepos/all-harvest-repro$ make run
	docker run -it --rm -p 8787:8787 --volume /mnt/c/Users/tmcphill/OneDrive/GitRepos/all-harvest-repro:/mnt/all-harvest-repro tmcphillips/all-harvest-repro:latest bash -ic 'make -C /mnt/all-harvest-repro/analysis run'
	make: Entering directory '/mnt/all-harvest-repro/analysis'
	R -e "rmarkdown::render('All_Harvest.Rmd',output_file='All_Harvest.html')"
	> rmarkdown::render('All_Harvest.Rmd',output_file='All_Harvest.html')
	processing file: All_Harvest.Rmd
	|...                                                                   |   5%
	ordinary text without R code
	.
	.
	.
	label: unnamed-chunk-9
	|......................................................................| 100%
	ordinary text without R code
	output file: All_Harvest.knit.md
	/usr/local/bin/pandoc +RTS -K512m -RTS All_Harvest.utf8.md --to html4 --from markdown+autolink_bare_uris+tex_math_single_backslash+smart --output All_Harvest.html --email-obfuscation none --self-contained --standalone --section-divs --template /usr/local/lib/R/site-library/rmarkdown/rmd/h/default.html --no-highlight --variable highlightjs=1 --variable 'theme:bootstrap' --include-in-header /tmp/RtmptCD3ex/rmarkdown-str85114df12.html --mathjax --variable 'mathjax-url:https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML' --lua-filter /usr/local/lib/R/site-library/rmarkdown/rmd/lua/pagebreak.lua --lua-filter /usr/local/lib/R/site-library/rmarkdown/rmd/lua/latex-div.lua
	Output created: All_Harvest.html
	>
	make: Leaving directory '/mnt/all-harvest-repro/analysis'
	```

5. Confirm that the files deleted using *`make clean`* have been restored:

	```
	all-harvest-repro$ ls -l analysis/
	total 2412
	-rw-r--r-- 1 tmcphill tmcphill 2116643 Mar 24 15:58 All_Harvest.html
	-rw-r--r-- 1 tmcphill tmcphill   12338 Mar 24 15:49 All_Harvest.Rmd
	-rwxr-xr-x 1 tmcphill tmcphill     226 Mar 24 15:49 All_Harvest.Rproj
	-rw-r--r-- 1 tmcphill tmcphill  332060 Mar 24 15:57 Harvest_All_Sectors.csv
	-rw-r--r-- 1 tmcphill tmcphill     139 Mar 24 15:49 Makefile
	```

	And that the repo has been restored to its initial state:

	```
	all-harvest-repro$ git status
	On branch master
	Your branch is up-to-date with 'origin/master'.
	nothing to commit, working tree clean
	```

### Tutorial 2 - Rerun the analysis in RStudio

1. Start the RStudio server in a Docker container:
	```
	all-harvest-repro$ make server

	--------------------------------------------------------------------------
	The RStudio Server is now running.  Connect to it by navigating in your
	web browser to http://localhost:8787 (Username: repro, Password: repro)

	Exit from this terminal session to shut down RStudio Server.
	--------------------------------------------------------------------------

	repro@c2954130ea22:/mnt/all-harvest-repro$
	```

2.  Connect to the RStudio Server instance running in the container by following this link in your web browser:  http://localhost:8787

	Authenticate with username `repro`, password `repro`:

	<img src="./.images/image002.png" width="300">


3.  Confirm that the RStudio interface appears in your browser with the contents of the analysis folder displayed in the bottom right pane of RStudio:


	<img src="./.images/image003.png" width="800">

4.  At the command prompt use the `make clean` command to delete the products of the data analysis, `Harvest_All_Sectors.csv` and `All_Harvest.html`:

	```
	repro@c2954130ea22:/mnt/all-harvest-repro$ make clean
	bash -ic 'make -C /mnt/all-harvest-repro/analysis clean'
	make[1]: Entering directory '/mnt/all-harvest-repro/analysis'
	rm -rf Harvest_All_Sectors.csv All_Harvest.html
	make[1]: Leaving directory '/mnt/all-harvest-repro/analysis'
	```
	Note in the RStudio interface that these two files no longer appear in the bottom right pane:

	<img src="./.images/image004.png" width="800">

5.  Open the RMarkdown document `All_Harvest.rmd` by clicking on it in the bottom right panel of RStudio:

	<img src="./.images/image005.png" width="800">

6.  Click the `Knit` button in the toolbar immediately above the editor pane.  A new browser window will open displaying the file `All_Harvest.html` that was just rendered:

	<img src="./.images/image006.png" width="800">

7.  Note in the RStudio interface that the two files deleted previously by *`make clean`* have now been restored:

	<img src="./.images/image007.png" width="800">

8.  At the command prompt confirm using *`git status`* that the repository has been restored to its initial state:
	```
	repro@c2954130ea22:/mnt/all-harvest-repro$ git status
	On branch master
	Your branch is up to date with 'origin/master'.

	nothing to commit, working tree clean
	```

9.  Exit the terminal session to shut down the RStudio server and stop the container:

	```
	repro@c2954130ea22:/mnt/all-harvest-repro$ exit
	logout
	all-harvest-repro$
	```

## Licensing

The files in the `analysis` directory of the repo are licensed under the Creative Commons Attribution 4.0 International License, the license under which the data set was originally distributed. To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/

All other contents of this repo are licensed under the MIT license and therefore can be reused in products with more restrictive licenses. See https://mit-license.org/.


