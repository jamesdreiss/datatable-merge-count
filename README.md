## data.table merging and match counting

A few functions to ensure the speedy execution of a fairly common task: the merging of raw lists of names, emails, and addresses with database records and idnumbers, in which duplicate key matches are expected and need to be preserved and counted. They have been written to make use of R's fast `data.table` [package](http://cran.r-project.org/web/packages/data.table/index.html)

These functions favor the more explicit `merge` method for `data.table` over `[.data.table`, even though the latter has been shown to be marginally faster. The equivalent of inner joins are performed on shared table keys.
