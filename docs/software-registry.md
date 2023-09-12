# Software registry

## Submission

Please submit your method on the [submission](submission.md) page.

## Binary R packages from MRCIEU R-universe

We maintain the MRCIEU R-universe <https://mrcieu.r-universe.dev> which distributes binary R packages for many MR related packages which are currently only available on GitHub. The binaries are available for several operating systems; Windows, macOS with Intel processors, and Ubuntu Linux 22.04 Jammy Jellyfish. 

If you would like a package added please open an issue [here](https://github.com/MRCIEU/mrcieu.r-universe.dev/issues).

### How to use the MRCIEU R-universe

To install binary R packages from the MRCIEU R-universe, include the URL in your `repos` list as follows, e.g., to install the **TwoSampleMR** package we could run in R
```r
install.packages('TwoSampleMR', repos = c('https://mrcieu.r-universe.dev', 'https://cloud.r-project.org'))
```
or
```r
options(repos = c('https://mrcieu.r-universe.dev', 'https://cloud.r-project.org'))
install.packages('TwoSampleMR')
```

## Benchmarking

### Simulations

### Empirical analysis
